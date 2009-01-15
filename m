Return-Path: <linux-kernel-owner+w=401wt.eu-S934244AbZAOUvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934244AbZAOUvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932326AbZAOUCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:02:50 -0500
Received: from kroah.org ([198.145.64.141]:49769 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932319AbZAOUCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:02:48 -0500
Date: Thu, 15 Jan 2009 12:00:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>,
       Wu Fengguang <wfg@linux.intel.com>
Subject: [patch 83/94] nfs: remove redundant tests on reading new pages
Message-ID: <20090115200025.GE14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="nfs-remove-redundant-tests-on-reading-new-pages.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wu Fengguang <fengguang.wu@intel.com>

commit 136221fc3219b3805c48db5da065e8e3467175d4 upstream.

aops->readpages() and its NFS helper readpage_async_filler() will only
be called to do readahead I/O for newly allocated pages. So it's not
necessary to test for the always 0 dirty/uptodate page flags.

The removal of nfs_wb_page() call also fixes a readahead bug: the NFS
readahead has been synchronous since 2.6.23, because that call will
clear PG_readahead, which is the reminder for asynchronous readahead.

More background: the PG_readahead page flag is shared with PG_reclaim,
one for read path and the other for write path. clear_page_dirty_for_io()
unconditionally clears PG_readahead to prevent possible readahead residuals,
assuming itself to be always called in the write path. However, NFS is one
and the only exception in that it _always_ calls clear_page_dirty_for_io()
in the read path, i.e. for readpages()/readpage().

Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Wu Fengguang <wfg@linux.intel.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/read.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -533,12 +533,6 @@ readpage_async_filler(void *data, struct
 	unsigned int len;
 	int error;
 
-	error = nfs_wb_page(inode, page);
-	if (error)
-		goto out_unlock;
-	if (PageUptodate(page))
-		goto out_unlock;
-
 	len = nfs_page_length(page);
 	if (len == 0)
 		return nfs_return_empty_page(page);

