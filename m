Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab0BSRNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:13:13 -0500
Received: from kroah.org ([198.145.64.141]:57514 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab0BSRAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:33 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:40 2010
Message-Id: <20100219163240.351599545@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [35/93] NFS: Fix an Oops when truncating a file
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 9f557cd8073104b39528794d44e129331ded649f upstream.

The VM/VFS does not allow mapping->a_ops->invalidatepage() to fail.
Unfortunately, nfs_wb_page_cancel() may fail if a fatal signal occurs.
Since the NFS code assumes that the page stays mapped for as long as the
writeback is active, we can end up Oopsing (among other things).

The only safe fix here is to convert nfs_wait_on_request(), so as to make
it uninterruptible (as is already the case with wait_on_page_writeback()).


Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -176,6 +176,12 @@ void nfs_release_request(struct nfs_page *req)
 	kref_put(&req->wb_kref, nfs_free_request);
 }
 
+static int nfs_wait_bit_uninterruptible(void *word)
+{
+	io_schedule();
+	return 0;
+}
+
 /**
  * nfs_wait_on_request - Wait for a request to complete.
  * @req: request to wait upon.
@@ -186,14 +192,9 @@ void nfs_release_request(struct nfs_page *req)
 int
 nfs_wait_on_request(struct nfs_page *req)
 {
-	int ret = 0;
-
-	if (!test_bit(PG_BUSY, &req->wb_flags))
-		goto out;
-	ret = out_of_line_wait_on_bit(&req->wb_flags, PG_BUSY,
-			nfs_wait_bit_killable, TASK_KILLABLE);
-out:
-	return ret;
+	return wait_on_bit(&req->wb_flags, PG_BUSY,
+			nfs_wait_bit_uninterruptible,
+			TASK_UNINTERRUPTIBLE);
 }
 
 /**


