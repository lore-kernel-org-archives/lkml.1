Return-Path: <linux-kernel-owner+w=401wt.eu-S932121AbXGQAyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121AbXGQAyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 20:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765570AbXGQAyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 20:54:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:4946 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892AbXGQAyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 20:54:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=HeX1VZc9IdWo3Hlc2GK2GTuFPH+GjbPWDb9KDCJeN6cyS50wUuqVSv/d6TT8DrhdH4W7RRbv+jmnnMga36OF7q8mIpdasc7S8IZYI8dhBNQHz0LMda2ybNiC3bwNFXC8NkG2hP2hIgQekIrhXwHN75GQD0pbvUZZ7kKwlakMT7M=
Date: Tue, 17 Jul 2007 08:54:51 +0000
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH] zisofs use mutex instead of semaphore
Message-ID: <20070717085451.GA4179@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Use mutex instead of semaphore in fs/isofs/compress.c, and remove a
unnecessary variable.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
fs/isofs/compress.c |   25 +++++--------------------
1 file changed, 5 insertions(+), 20 deletions(-)

diff -upr linux/fs/isofs/compress.c linux.new/fs/isofs/compress.c
--- linux/fs/isofs/compress.c	2007-07-17 08:39:05.000000000 +0000
+++ linux.new/fs/isofs/compress.c	2007-07-17 08:37:42.000000000 +0000
@@ -33,7 +33,7 @@ static char zisofs_sink_page[PAGE_CACHE_
  * allocation; this avoids failures at block-decompression time.
  */
 static void *zisofs_zlib_workspace;
-static struct semaphore zisofs_zlib_semaphore;
+static DEFINE_MUTEX(zisofs_zlib_lock);
 
 /*
  * When decompressing, we typically obtain more than one page
@@ -180,9 +180,9 @@ static int zisofs_readpage(struct file *
 
 		/* First block is special since it may be fractional.
 		   We also wait for it before grabbing the zlib
-		   semaphore; odds are that the subsequent blocks are
+		   mutex; odds are that the subsequent blocks are
 		   going to come in in short order so we don't hold
-		   the zlib semaphore longer than necessary. */
+		   the zlib mutex longer than necessary. */
 
 		if ( !bh || (wait_on_buffer(bh), !buffer_uptodate(bh)) ) {
 			printk(KERN_DEBUG "zisofs: Hit null buffer, fpage = %d, xpage = %d, csize = %ld\n",
@@ -194,7 +194,7 @@ static int zisofs_readpage(struct file *
 		csize -= stream.avail_in;
 
 		stream.workspace = zisofs_zlib_workspace;
-		down(&zisofs_zlib_semaphore);
+		mutex_lock(&zisofs_zlib_lock);
 		
 		zerr = zlib_inflateInit(&stream);
 		if ( zerr != Z_OK ) {
@@ -281,7 +281,7 @@ static int zisofs_readpage(struct file *
 		zlib_inflateEnd(&stream);
 
 	z_eio:
-		up(&zisofs_zlib_semaphore);
+		mutex_unlock(&zisofs_zlib_lock);
 
 	b_eio:
 		for ( i = 0 ; i < haveblocks ; i++ ) {
@@ -317,31 +317,16 @@ const struct address_space_operations zi
 	/* No bmap operation supported */
 };
 
-static int initialized;
-
 int __init zisofs_init(void)
 {
-	if ( initialized ) {
-		printk("zisofs_init: called more than once\n");
-		return 0;
-	}
-
 	zisofs_zlib_workspace = vmalloc(zlib_inflate_workspacesize());
 	if ( !zisofs_zlib_workspace )
 		return -ENOMEM;
-	init_MUTEX(&zisofs_zlib_semaphore);
 
-	initialized = 1;
 	return 0;
 }
 
 void zisofs_cleanup(void)
 {
-	if ( !initialized ) {
-		printk("zisofs_cleanup: called without initialization\n");
-		return;
-	}
-
 	vfree(zisofs_zlib_workspace);
-	initialized = 0;
 }
