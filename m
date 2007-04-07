Return-Path: <linux-kernel-owner+w=401wt.eu-S965691AbXDGKBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965691AbXDGKBJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 06:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965711AbXDGKBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 06:01:09 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:7678 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965691AbXDGKBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 06:01:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=fbz03PHCgv0S8DkSKDpU9USJLHDwtgSsSE5JFrkO+yUr7s4iwG7T7Jj5FkrCOo4MzkuD4FnYdQFKuO/1X/swGyJ31t4PPw9pTwUPhticu5KWZhI4sM2GpQrcW0CRwBGLXzqzpFnne7/Qo+w0bfdIpiOIBbgAMtZtSUu/mEF+4EM=
Date: Sat, 7 Apr 2007 18:56:08 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chris Pallotta <chris@allmedia.com>, Jim Van Zandt <jrv@vanzandt.mv.com>
Subject: [PATCH] dtlk: fix error checks in module_init()
Message-ID: <20070407095608.GB4660@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Chris Pallotta <chris@allmedia.com>,
	Jim Van Zandt <jrv@vanzandt.mv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes two things in module_init.

- fix register_chrdev() error check

  Currently dtlk doesn't check register_chrdev() failure correctly.
  register_chrdev() returns a errno on failure.

- check probe failure

  dtlk ignores probe failure and allows the module loading without
  such device. I got "Trying to free nonexistent resource" message
  by release_region() when unloading module without device.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Chris Pallotta <chris@allmedia.com>
Cc: Jim Van Zandt <jrv@vanzandt.mv.com>

---
 drivers/char/dtlk.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: 2.6-mm/drivers/char/dtlk.c
===================================================================
--- 2.6-mm.orig/drivers/char/dtlk.c
+++ 2.6-mm/drivers/char/dtlk.c
@@ -324,16 +324,22 @@ static int dtlk_release(struct inode *in
 
 static int __init dtlk_init(void)
 {
+	int err;
+
 	dtlk_port_lpc = 0;
 	dtlk_port_tts = 0;
 	dtlk_busy = 0;
 	dtlk_major = register_chrdev(0, "dtlk", &dtlk_fops);
-	if (dtlk_major == 0) {
+	if (dtlk_major < 0) {
 		printk(KERN_ERR "DoubleTalk PC - cannot register device\n");
-		return 0;
+		return -EBUSY;
+	}
+	err = dtlk_dev_probe();
+	if (err) {
+		unregister_chrdev(dtlk_major, "dtlk");
+		return err;
 	}
-	if (dtlk_dev_probe() == 0)
-		printk(", MAJOR %d\n", dtlk_major);
+	printk(", MAJOR %d\n", dtlk_major);
 
 	init_waitqueue_head(&dtlk_process_list);
 
