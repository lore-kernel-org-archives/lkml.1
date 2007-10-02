Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbXJBSAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbXJBSAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 14:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbXJBSA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 14:00:28 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45515 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbXJBSA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 14:00:27 -0400
Date: Tue, 2 Oct 2007 20:00:26 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH] isofs: add +w bit for non-RR discs
Message-ID: <Pine.LNX.4.64.0710021958230.7130@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Add %S_IWUGO bit for files on ISO-9660 filesystems without RockRidge
extensions. This allows one to modify the files right after copying,
without having to do an extra recursive chmod if `cp -p` or
`rsync -p` is used.

References: http://lkml.org/lkml/2007/4/1/164
Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 fs/isofs/inode.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

Index: linux-2.6.23/fs/isofs/inode.c
===================================================================
--- linux-2.6.23.orig/fs/isofs/inode.c
+++ linux-2.6.23/fs/isofs/inode.c
@@ -360,12 +360,11 @@ static int parse_options(char *options, 
 	popt->check = 'u';		/* unset */
 	popt->nocompress = 0;
 	popt->blocksize = 1024;
-	popt->mode = S_IRUGO | S_IXUGO; /*
-					 * r-x for all.  The disc could
-					 * be shared with DOS machines so
-					 * virtually anything could be
-					 * a valid executable.
-					 */
+	/*
+	 * +x bit for all. The disc could be shared with DOS machine, so
+	 * virtually anything could be a valid executable.
+	 */
+	popt->mode = S_IRUGO | S_IWUSR | S_IXUGO;
 	popt->gid = 0;
 	popt->uid = 0;
 	popt->iocharset = NULL;
@@ -1235,7 +1234,7 @@ static void isofs_read_inode(struct inod
 	ei->i_file_format = isofs_file_normal;
 
 	if (de->flags[-high_sierra] & 2) {
-		inode->i_mode = S_IRUGO | S_IXUGO | S_IFDIR;
+		inode->i_mode = S_IRUGO | S_IWUSR | S_IXUGO | S_IFDIR;
 		inode->i_nlink = 1;	/*
 					 * Set to 1.  We know there are 2, but
 					 * the find utility tries to optimize
