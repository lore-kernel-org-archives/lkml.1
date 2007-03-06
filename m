Return-Path: <linux-kernel-owner+w=401wt.eu-S966000AbXCFSmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966000AbXCFSmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966010AbXCFSl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:41:59 -0500
Received: from [198.99.130.12] ([198.99.130.12]:53057 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S966000AbXCFSlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:41:31 -0500
Message-Id: <200703061832.l26IW9J6006559@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 3/5] UML - handle block device hotplug errors
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 06 Mar 2007 13:32:09 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If a disk fails to open, i.e. its host file doesn't exist, it won't
be removable because the hot-unplug code checks the existence of its
gendisk.  This won't exist because it is only allocated for
successfully opened disks.  Thus, a typo on the command line can
result in a unusable and unfixable disk.

This is fixed by freeing the gendisk if it's there, but not letting
that affect the removal.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/ubd_kern.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: test/arch/um/drivers/ubd_kern.c
===================================================================
--- test.orig/arch/um/drivers/ubd_kern.c	2007-03-05 13:14:50.000000000 -0500
+++ test/arch/um/drivers/ubd_kern.c	2007-03-05 13:40:13.000000000 -0500
@@ -790,14 +790,12 @@ static int ubd_id(char **str, int *start
 
 static int ubd_remove(int n, char **error_out)
 {
+	struct gendisk *disk;
 	struct ubd *ubd_dev;
 	int err = -ENODEV;
 
 	mutex_lock(&ubd_lock);
 
-	if(ubd_gendisk[n] == NULL)
-		goto out;
-
 	ubd_dev = &ubd_devs[n];
 
 	if(ubd_dev->file == NULL)
@@ -808,9 +806,12 @@ static int ubd_remove(int n, char **erro
 	if(ubd_dev->count > 0)
 		goto out;
 
-	del_gendisk(ubd_gendisk[n]);
-	put_disk(ubd_gendisk[n]);
-	ubd_gendisk[n] = NULL;
+ 	disk = ubd_gendisk[n];
+ 	ubd_gendisk[n] = NULL;
+	if(disk != NULL){
+		del_gendisk(disk);
+		put_disk(disk);
+	}
 
 	if(fake_gendisk[n] != NULL){
 		del_gendisk(fake_gendisk[n]);

