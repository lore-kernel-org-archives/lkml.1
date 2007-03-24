Return-Path: <linux-kernel-owner+w=401wt.eu-S1751553AbXCXM6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbXCXM6h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 08:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbXCXM6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 08:58:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:37454 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbXCXM6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 08:58:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=mRFJ12qppwWLxHUJ1BO+gquJ8dvB7NwB/29cNB0l5RBzFstXNnvQCJXjEA5RYkHS2z6pPAGdyyg2ojeoy5+z5SXB2XFDGk86+fUn5UcsVAgcqwuoTQ8A5DojkXEpCvytUrjoc1DQNd0vSQONKBm9yYQCxWtc5wpW2zO7WxzgJN8=
Date: Sat, 24 Mar 2007 15:58:12 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: wim@iguana.be
Cc: linux-kernel@vger.kernel.org
Subject: Semi-typical watchdog bug re early misc_register()
Message-ID: <20070324125811.GA30017@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Wim.

It seems that some watchdog drivers are doing following mistake:

	rv = misc_register();
	if (rv < 0)
		return rv;
	rv = request_region();
	if (rv < 0) {
		misc_deregister();
		return rv;
	}

But, right after misc_register() returns, misc device can be opened and
ioctls interacting with hardware issued, and driver can do outb() to
port it doesn't own yet, because request_region() is still pending.

Also, is there similar ordering between register_reboot_notifier() and
misc_register() ? Some drivers do misc_register() last, some register
reboot notifiers.


Here is my patch, compile-tested only.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/char/watchdog/cpu5wdt.c     |   14 +++++++-------
 drivers/char/watchdog/eurotechwdt.c |   22 +++++++++++-----------
 drivers/char/watchdog/ibmasr.c      |   11 +++++------
 drivers/char/watchdog/machzwd.c     |   18 +++++++++---------
 drivers/char/watchdog/sbc8360.c     |   28 ++++++++++++++--------------
 5 files changed, 46 insertions(+), 47 deletions(-)

--- a/drivers/char/watchdog/cpu5wdt.c
+++ b/drivers/char/watchdog/cpu5wdt.c
@@ -220,17 +220,17 @@ static int __devinit cpu5wdt_init(void)
 	if ( verbose )
 		printk(KERN_DEBUG PFX "port=0x%x, verbose=%i\n", port, verbose);
 
-	if ( (err = misc_register(&cpu5wdt_misc)) < 0 ) {
-		printk(KERN_ERR PFX "misc_register failed\n");
-		goto no_misc;
-	}
-
 	if ( !request_region(port, CPU5WDT_EXTENT, PFX) ) {
 		printk(KERN_ERR PFX "request_region failed\n");
 		err = -EBUSY;
 		goto no_port;
 	}
 
+	if ( (err = misc_register(&cpu5wdt_misc)) < 0 ) {
+		printk(KERN_ERR PFX "misc_register failed\n");
+		goto no_misc;
+	}
+
 	/* watchdog reboot? */
 	val = inb(port + CPU5WDT_STATUS_REG);
 	val = (val >> 2) & 1;
@@ -250,9 +250,9 @@ static int __devinit cpu5wdt_init(void)
 
 	return 0;
 
-no_port:
-	misc_deregister(&cpu5wdt_misc);
 no_misc:
+	release_region(port, CPU5WDT_EXTENT);
+no_port:
 	return err;
 }
 
--- a/drivers/char/watchdog/eurotechwdt.c
+++ b/drivers/char/watchdog/eurotechwdt.c
@@ -413,17 +413,10 @@ static int __init eurwdt_init(void)
 {
 	int ret;
 
-	ret = misc_register(&eurwdt_miscdev);
-	if (ret) {
-		printk(KERN_ERR "eurwdt: can't misc_register on minor=%d\n",
-		WATCHDOG_MINOR);
-		goto out;
-	}
-
 	ret = request_irq(irq, eurwdt_interrupt, IRQF_DISABLED, "eurwdt", NULL);
 	if(ret) {
 		printk(KERN_ERR "eurwdt: IRQ %d is not free.\n", irq);
-		goto outmisc;
+		goto out;
 	}
 
 	if (!request_region(io, 2, "eurwdt")) {
@@ -438,6 +431,13 @@ static int __init eurwdt_init(void)
 		goto outreg;
 	}
 
+	ret = misc_register(&eurwdt_miscdev);
+	if (ret) {
+		printk(KERN_ERR "eurwdt: can't misc_register on minor=%d\n",
+		WATCHDOG_MINOR);
+		goto outreboot;
+	}
+
 	eurwdt_unlock_chip();
 
 	ret = 0;
@@ -448,14 +448,14 @@ static int __init eurwdt_init(void)
 out:
 	return ret;
 
+outreboot:
+	unregister_reboot_notifier(&eurwdt_notifier);
+
 outreg:
 	release_region(io, 2);
 
 outirq:
 	free_irq(irq, NULL);
-
-outmisc:
-	misc_deregister(&eurwdt_miscdev);
 	goto out;
 }
 
--- a/drivers/char/watchdog/ibmasr.c
+++ b/drivers/char/watchdog/ibmasr.c
@@ -367,18 +367,17 @@ static int __init ibmasr_init(void)
 	if (!asr_type)
 		return -ENODEV;
 
+	rc = asr_get_base_address();
+	if (rc)
+		return rc;
+
 	rc = misc_register(&asr_miscdev);
 	if (rc < 0) {
+		release_region(asr_base, asr_length);
 		printk(KERN_ERR PFX "failed to register misc device\n");
 		return rc;
 	}
 
-	rc = asr_get_base_address();
-	if (rc) {
-		misc_deregister(&asr_miscdev);
-		return rc;
-	}
-
 	return 0;
 }
 
--- a/drivers/char/watchdog/machzwd.c
+++ b/drivers/char/watchdog/machzwd.c
@@ -440,13 +440,6 @@ static int __init zf_init(void)
 	spin_lock_init(&zf_lock);
 	spin_lock_init(&zf_port_lock);
 
-	ret = misc_register(&zf_miscdev);
-	if (ret){
-		printk(KERN_ERR "can't misc_register on minor=%d\n",
-							WATCHDOG_MINOR);
-		goto out;
-	}
-
 	if(!request_region(ZF_IOBASE, 3, "MachZ ZFL WDT")){
 		printk(KERN_ERR "cannot reserve I/O ports at %d\n",
 							ZF_IOBASE);
@@ -461,16 +454,23 @@ static int __init zf_init(void)
 		goto no_reboot;
 	}
 
+	ret = misc_register(&zf_miscdev);
+	if (ret){
+		printk(KERN_ERR "can't misc_register on minor=%d\n",
+							WATCHDOG_MINOR);
+		goto no_misc;
+	}
+
 	zf_set_status(0);
 	zf_set_control(0);
 
 	return 0;
 
+no_misc:
+	unregister_reboot_notifier(&zf_notifier);
 no_reboot:
 	release_region(ZF_IOBASE, 3);
 no_region:
-	misc_deregister(&zf_miscdev);
-out:
 	return ret;
 }
 
--- a/drivers/char/watchdog/sbc8360.c
+++ b/drivers/char/watchdog/sbc8360.c
@@ -333,18 +333,17 @@ static int __init sbc8360_init(void)
 	int res;
 	unsigned long int mseconds = 60000;
 
-	spin_lock_init(&sbc8360_lock);
-	res = misc_register(&sbc8360_miscdev);
-	if (res) {
-		printk(KERN_ERR PFX "failed to register misc device\n");
-		goto out_nomisc;
+	if (timeout < 0 || timeout > 63) {
+		printk(KERN_ERR PFX "Invalid timeout index (must be 0-63).\n");
+		res = -EINVAL;
+		goto out;
 	}
 
 	if (!request_region(SBC8360_ENABLE, 1, "SBC8360")) {
 		printk(KERN_ERR PFX "ENABLE method I/O %X is not available.\n",
 		       SBC8360_ENABLE);
 		res = -EIO;
-		goto out_noenablereg;
+		goto out;
 	}
 	if (!request_region(SBC8360_BASETIME, 1, "SBC8360")) {
 		printk(KERN_ERR PFX
@@ -360,10 +359,11 @@ static int __init sbc8360_init(void)
 		goto out_noreboot;
 	}
 
-	if (timeout < 0 || timeout > 63) {
-		printk(KERN_ERR PFX "Invalid timeout index (must be 0-63).\n");
-		res = -EINVAL;
-		goto out_noreboot;
+	spin_lock_init(&sbc8360_lock);
+	res = misc_register(&sbc8360_miscdev);
+	if (res) {
+		printk(KERN_ERR PFX "failed to register misc device\n");
+		goto out_nomisc;
 	}
 
 	wd_margin = wd_times[timeout][0];
@@ -383,13 +383,13 @@ static int __init sbc8360_init(void)
 
 	return 0;
 
+      out_nomisc:
+	unregister_reboot_notifier(&sbc8360_notifier);
       out_noreboot:
-	release_region(SBC8360_ENABLE, 1);
 	release_region(SBC8360_BASETIME, 1);
-      out_noenablereg:
       out_nobasetimereg:
-	misc_deregister(&sbc8360_miscdev);
-      out_nomisc:
+	release_region(SBC8360_ENABLE, 1);
+      out:
 	return res;
 }
 

