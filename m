Return-Path: <linux-kernel-owner+w=401wt.eu-S932227AbXCYSCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227AbXCYSCw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 14:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932230AbXCYSCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 14:02:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:44815 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227AbXCYSCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 14:02:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=MY0etew/BU8VswQqW3QDDlyvJqf/rJ/hfosuMlJ4x+Zau2CRIQcgaY2jcog/n8VyKUGl71GCyjxDw8b56ZLNsoHg+z8AESclp8VvFVsFGIGKjYSDNtqqspsNM+tS+d4F+wlrrBafPaWTbzhSrahb3RIFKSsfdRK+LrkbuCIaaow=
Date: Sun, 25 Mar 2007 23:02:21 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: ecashin@coraid.com, linux-kernel@vger.kernel.org,
       kernel-janitors@lists.osdl.org
Subject: [PATCH] aoe, tb0219: fix late spin_lock_init() and friends
Message-ID: <20070325190221.GA5308@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers do register_chrdev() before lock or semaphore used in
corresponding file_operations is initialized.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/block/aoe/aoechr.c |    4 ++--
 drivers/char/tb0219.c      |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -246,13 +246,13 @@ aoechr_init(void)
 {
 	int n, i;
 
+	sema_init(&emsgs_sema, 0);
+	spin_lock_init(&emsgs_lock);
 	n = register_chrdev(AOE_MAJOR, "aoechr", &aoe_fops);
 	if (n < 0) { 
 		printk(KERN_ERR "aoe: can't register char device\n");
 		return n;
 	}
-	sema_init(&emsgs_sema, 0);
-	spin_lock_init(&emsgs_lock);
 	aoe_class = class_create(THIS_MODULE, "aoe");
 	if (IS_ERR(aoe_class)) {
 		unregister_chrdev(AOE_MAJOR, "aoechr");
--- a/drivers/char/tb0219.c
+++ b/drivers/char/tb0219.c
@@ -287,6 +287,8 @@ static int __devinit tb0219_probe(struct
 {
 	int retval;
 
+	spin_lock_init(&tb0219_lock);
+
 	if (request_mem_region(TB0219_START, TB0219_SIZE, "TB0219") == NULL)
 		return -EBUSY;
 
@@ -304,8 +306,6 @@ static int __devinit tb0219_probe(struct
 		return retval;
 	}
 
-	spin_lock_init(&tb0219_lock);
-
 	old_machine_restart = _machine_restart;
 	_machine_restart = tb0219_restart;
 

