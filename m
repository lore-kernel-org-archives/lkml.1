Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbZFAJXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbZFAJXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 05:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbZFAJXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 05:23:17 -0400
Received: from bu3sch.de ([62.75.166.246]:58480 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755501AbZFAJXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 05:23:16 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: ppdev: Reduce kernel log spam
Date: Mon, 1 Jun 2009 11:23:10 +0200
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906011123.10225.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts all KERN_DEBUG to pr_debug to reduce the log spamming.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

One of my programs frequently grabs the parport, does something with it
and then drops it again. This results in spamming of the kernel log with
"... registered pardevice"
"... unregistered pardevice"
These messages are completely useless, except for debugging ppdev, probably.
So put them under DEBUG (or dynamic debug).


Index: wireless-testing/drivers/char/ppdev.c
===================================================================
--- wireless-testing.orig/drivers/char/ppdev.c	2008-10-26 10:47:26.000000000 +0100
+++ wireless-testing/drivers/char/ppdev.c	2009-06-01 10:31:16.000000000 +0200
@@ -111,14 +111,13 @@ static ssize_t pp_read (struct file * fi
 	ssize_t bytes_read = 0;
 	struct parport *pport;
 	int mode;
 
 	if (!(pp->flags & PP_CLAIMED)) {
 		/* Don't have the port claimed */
-		printk (KERN_DEBUG CHRDEV "%x: claim the port first\n",
-			minor);
+		pr_debug(CHRDEV "%x: claim the port first\n", minor);
 		return -EINVAL;
 	}
 
 	/* Trivial case. */
 	if (count == 0)
 		return 0;
@@ -195,14 +194,13 @@ static ssize_t pp_write (struct file * f
 	ssize_t wrote;
 	int mode;
 	struct parport *pport;
 
 	if (!(pp->flags & PP_CLAIMED)) {
 		/* Don't have the port claimed */
-		printk (KERN_DEBUG CHRDEV "%x: claim the port first\n",
-			minor);
+		pr_debug(CHRDEV "%x: claim the port first\n", minor);
 		return -EINVAL;
 	}
 
 	kbuffer = kmalloc(min_t(size_t, count, PP_BUFFER_SIZE), GFP_KERNEL);
 	if (!kbuffer) {
 		return -ENOMEM;
@@ -310,13 +308,13 @@ static int register_device (int minor, s
 		printk (KERN_WARNING "%s: failed to register device!\n", name);
 		kfree (name);
 		return -ENXIO;
 	}
 
 	pp->pdev = pdev;
-	printk (KERN_DEBUG "%s: registered pardevice\n", name);
+	pr_debug("%s: registered pardevice\n", name);
 	return 0;
 }
 
 static enum ieee1284_phase init_phase (int mode)
 {
 	switch (mode & ~(IEEE1284_DEVICEID
@@ -340,14 +338,13 @@ static int pp_do_ioctl(struct file *file
 	case PPCLAIM:
 	    {
 		struct ieee1284_info *info;
 		int ret;
 
 		if (pp->flags & PP_CLAIMED) {
-			printk (KERN_DEBUG CHRDEV
-				"%x: you've already got it!\n", minor);
+			pr_debug(CHRDEV "%x: you've already got it!\n", minor);
 			return -EINVAL;
 		}
 
 		/* Deferred device registration. */
 		if (!pp->pdev) {
 			int err = register_device (minor, pp);
@@ -376,13 +373,13 @@ static int pp_do_ioctl(struct file *file
 		parport_set_timeout (pp->pdev, pp->default_inactivity);
 
 		return 0;
 	    }
 	case PPEXCL:
 		if (pp->pdev) {
-			printk (KERN_DEBUG CHRDEV "%x: too late for PPEXCL; "
+			pr_debug(CHRDEV "%x: too late for PPEXCL; "
 				"already registered\n", minor);
 			if (pp->flags & PP_EXCL)
 				/* But it's not really an error. */
 				return 0;
 			/* There's no chance of making the driver happy. */
 			return -EINVAL;
@@ -488,14 +485,13 @@ static int pp_do_ioctl(struct file *file
 	    }
 	}	/* end switch() */
 
 	/* Everything else requires the port to be claimed, so check
 	 * that now. */
 	if ((pp->flags & PP_CLAIMED) == 0) {
-		printk (KERN_DEBUG CHRDEV "%x: claim the port first\n",
-			minor);
+		pr_debug(CHRDEV "%x: claim the port first\n", minor);
 		return -EINVAL;
 	}
 
 	port = pp->pdev->port;
 	switch (cmd) {
 		struct ieee1284_info *info;
@@ -621,14 +617,13 @@ static int pp_do_ioctl(struct file *file
 		par_timeout.tv_usec = (to_jiffies % (long)HZ) * (1000000/HZ);
 		if (copy_to_user (argp, &par_timeout, sizeof(struct timeval)))
 			return -EFAULT;
 		return 0;
 
 	default:
-		printk (KERN_DEBUG CHRDEV "%x: What? (cmd=0x%x)\n", minor,
-			cmd);
+		pr_debug(CHRDEV "%x: What? (cmd=0x%x)\n", minor, cmd);
 		return -EINVAL;
 	}
 
 	/* Keep the compiler happy */
 	return 0;
 }
@@ -695,39 +690,37 @@ static int pp_release (struct inode * in
 	} else if ((pp->flags & PP_CLAIMED) && pp->pdev &&
 	    (pp->pdev->port->ieee1284.mode != IEEE1284_MODE_COMPAT)) {
 		compat_negot = 2;
 	}
 	if (compat_negot) {
 		parport_negotiate (pp->pdev->port, IEEE1284_MODE_COMPAT);
-		printk (KERN_DEBUG CHRDEV
-			"%x: negotiated back to compatibility mode because "
-			"user-space forgot\n", minor);
+		pr_debug(CHRDEV "%x: negotiated back to compatibility "
+			"mode because user-space forgot\n", minor);
 	}
 
 	if (pp->flags & PP_CLAIMED) {
 		struct ieee1284_info *info;
 
 		info = &pp->pdev->port->ieee1284;
 		pp->state.mode = info->mode;
 		pp->state.phase = info->phase;
 		info->mode = pp->saved_state.mode;
 		info->phase = pp->saved_state.phase;
 		parport_release (pp->pdev);
 		if (compat_negot != 1) {
-			printk (KERN_DEBUG CHRDEV "%x: released pardevice "
+			pr_debug(CHRDEV "%x: released pardevice "
 				"because user-space forgot\n", minor);
 		}
 	}
 
 	if (pp->pdev) {
 		const char *name = pp->pdev->name;
 		parport_unregister_device (pp->pdev);
 		kfree (name);
 		pp->pdev = NULL;
-		printk (KERN_DEBUG CHRDEV "%x: unregistered pardevice\n",
-			minor);
+		pr_debug(CHRDEV "%x: unregistered pardevice\n", minor);
 	}
 
 	kfree (pp);
 
 	return 0;
 }

-- 
Greetings, Michael.
