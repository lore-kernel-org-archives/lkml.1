Return-Path: <linux-kernel-owner+w=401wt.eu-S1763488AbYCUWt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763488AbYCUWt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762735AbYCUWq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:46:26 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:34755 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762725AbYCUWqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:46:24 -0400
Message-Id: <20080321224456.021882563@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:44:06 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jens Axboe <jens.axboe@oracle.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 76/76] relay: fix subbuf_splice_actor() adding too many pages
Content-Disposition: inline; filename=relay-fix-subbuf_splice_actor-adding-too-many-pages.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jens Axboe <jens.axboe@oracle.com>

If subbuf_pages was larger than the max number of pages the pipe
buffer will hold, subbuf_splice_actor() would happily go beyond
the array size.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 kernel/relay.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -1072,7 +1072,7 @@ static int subbuf_splice_actor(struct fi
 			       unsigned int flags,
 			       int *nonpad_ret)
 {
-	unsigned int pidx, poff, total_len, subbuf_pages, ret;
+	unsigned int pidx, poff, total_len, subbuf_pages, nr_pages, ret;
 	struct rchan_buf *rbuf = in->private_data;
 	unsigned int subbuf_size = rbuf->chan->subbuf_size;
 	uint64_t pos = (uint64_t) *ppos;
@@ -1103,8 +1103,9 @@ static int subbuf_splice_actor(struct fi
 	subbuf_pages = rbuf->chan->alloc_size >> PAGE_SHIFT;
 	pidx = (read_start / PAGE_SIZE) % subbuf_pages;
 	poff = read_start & ~PAGE_MASK;
+	nr_pages = min_t(unsigned int, subbuf_pages, PIPE_BUFFERS);
 
-	for (total_len = 0; spd.nr_pages < subbuf_pages; spd.nr_pages++) {
+	for (total_len = 0; spd.nr_pages < nr_pages; spd.nr_pages++) {
 		unsigned int this_len, this_end, private;
 		unsigned int cur_pos = read_start + total_len;
 

-- 
