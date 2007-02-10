Return-Path: <linux-kernel-owner+w=401wt.eu-S1752626AbXBJBja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbXBJBja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 20:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbXBJBja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 20:39:30 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:51266 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752626AbXBJBj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 20:39:29 -0500
Message-ID: <371071566.30389@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sat, 10 Feb 2007 09:40:49 +0800
From: Fengguang Wu <fengguang.wu@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>, John Tran <jbtran@ca.ibm.com>,
       Mike Sullivan <mksully@us.ibm.com>, Chris Mason <mason@suse.com>,
       Steven Pratt <slpratt@austin.ibm.com>, Ram Pai <linuxram@us.ibm.com>,
       Badari Pulavarty <badari@us.ibm.com>, Mingming Cao <mcao@us.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm] readahead: partial sendfile fix
Message-ID: <20070210014049.GA11269@mail.ustc.edu.cn>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Suparna Bhattacharya <suparna@in.ibm.com>,
	John Tran <jbtran@ca.ibm.com>, Mike Sullivan <mksully@us.ibm.com>,
	Chris Mason <mason@suse.com>, Steven Pratt <slpratt@austin.ibm.com>,
	Ram Pai <linuxram@us.ibm.com>, Badari Pulavarty <badari@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Enable readahead to handle partially done read requests, e.g.

        sendfile(188, 1921, [1478592], 19553028) = 37440
        sendfile(188, 1921, [1516032], 19515588) = 28800
        sendfile(188, 1921, [1544832], 19486788) = 37440
        sendfile(188, 1921, [1582272], 19449348) = 14400
        sendfile(188, 1921, [1596672], 19434948) = 37440
        sendfile(188, 1921, [1634112], 19397508) = 37440

In the above strace log,
        - some lighttpd is doing _sequential_ reading
        - every sendfile() returns with only _partial_ work done

page_cache_readahead() expects that if it returns @next_index, it will be
called exactly at @next_index next time. That's not true here. So the pattern
will be falsely recognized as a random read trace.

Also documented in "Linux AIO Performance and Robustness for Enterprise
Workloads" section 3.5:

	  sendfile(fd, 0, 2GB, fd2) = 8192,
	    tells readahead about up to 128KB of the read
	  sendfile(fd, 8192, 2GB - 8192, fd2) = 8192,
	    tells readahead about 8KB - 132KB of the read
	  sendfile(fd, 16384, 2GB - 16384, fd2) = 8192,
	    tells readahead about 16KB-140KB of the read
	       ...
	This confuses the readahead logic about the I/O pattern which appears
	to be 0-128K, 8K-132K, 16K-140K instead of clear sequentiality from
	0-2GB that is really appropriate.

Retry based AIO shares the same read pattern and readahead problem.
In this case, simply disabling readahead on restarted aio is not a good option:
we still need to call into readahead in the rare case of (req_size > ra_max).

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/filemap.c   |    3 ---
 mm/readahead.c |    9 +++++++++
 2 files changed, 9 insertions(+), 3 deletions(-)

--- linux-2.6.20-rc6-mm3.orig/mm/readahead.c
+++ linux-2.6.20-rc6-mm3/mm/readahead.c
@@ -581,6 +581,15 @@ page_cache_readahead(struct address_spac
 	int sequential;
 
 	/*
+	 * A previous read request is partially completed,
+	 * causing the retried/continued read calls into us prematurely.
+	 */
+	if (ra->start < offset &&
+			offset < ra->prev_page &&
+				 ra->prev_page < ra->ahead_start + ra->ahead_size)
+		goto out;
+
+	/*
 	 * We avoid doing extra work and bogusly perturbing the readahead
 	 * window expansion logic.
 	 */
--- linux-2.6.20-rc6-mm3.orig/mm/filemap.c
+++ linux-2.6.20-rc6-mm3/mm/filemap.c
@@ -915,9 +915,6 @@ void do_generic_mapping_read(struct addr
 	if (!isize)
 		goto out;
 
-	if (unlikely(aio_restarted()))
-		next_index = last_index; /* Avoid repeat readahead */
-
 	end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
 	for (;;) {
 		struct page *page;
