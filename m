Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbYIPKbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbYIPKbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 06:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYIPKbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 06:31:05 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:58055 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751745AbYIPKbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 06:31:03 -0400
Subject: wdt285: fix sparse warnings
Message-Id: <20080916103101.092074533@fluff.org.uk>
User-Agent: quilt/0.46-1
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org, wim@iguana.be
Cc: Ben Dooks <ben-linux@fluff.org>
Content-Disposition: inline; filename=simtec/simtec-cats-sparse-wdt285.patch
Date: Tue, 16 Sep 2008 11:31:01 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wdt285.c watchdog driver is producing a number of
sparse errors due to missing __user attributes to calls
to put_user and copy_to_user, as well as in the prototype
of watchdog_write.

wdt285.c:144:21: warning: incorrect type in argument 1 (different address spaces)
wdt285.c:144:21:    expected void [noderef] <asn:1>*to
wdt285.c:144:21:    got void *<noident>
wdt285.c:150:9: warning: incorrect type in initializer (different address spaces)
wdt285.c:150:9:    expected int const [noderef] <asn:1>*register __p
wdt285.c:150:9:    got int *<noident>
wdt285.c:159:9: warning: incorrect type in initializer (different address spaces)
wdt285.c:159:9:    expected int const [noderef] <asn:1>*register __p
wdt285.c:159:9:    got int *<noident>
wdt285.c:174:9: warning: incorrect type in initializer (different address spaces)
wdt285.c:174:9:    expected int const [noderef] <asn:1>*register __p
wdt285.c:174:9:    got int *<noident>
wdt285.c:183:12: warning: incorrect type in initializer (incompatible argument 2 (different address spaces))
wdt285.c:183:12:    expected int ( *write )( ... )
wdt285.c:183:12:    got int ( static [toplevel] *<noident> )( ... )

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.27-rc6-quilt3/drivers/watchdog/wdt285.c
===================================================================
--- linux-2.6.27-rc6-quilt3.orig/drivers/watchdog/wdt285.c	2008-09-15 00:00:51.000000000 +0100
+++ linux-2.6.27-rc6-quilt3/drivers/watchdog/wdt285.c	2008-09-16 10:37:38.000000000 +0100
@@ -115,8 +115,8 @@ static int watchdog_release(struct inode
 	return 0;
 }
 
-static ssize_t watchdog_write(struct file *file, const char *data,
-						size_t len, loff_t *ppos)
+static ssize_t watchdog_write(struct file *file, const char __user *data,
+			      size_t len, loff_t *ppos)
 {
 	/*
 	 *	Refresh the timer.
@@ -133,21 +133,22 @@ static const struct watchdog_info ident 
 };
 
 static long watchdog_ioctl(struct file *file, unsigned int cmd,
-							unsigned long arg)
+			   unsigned long arg)
 {
 	unsigned int new_margin;
+	int __user *int_arg = (int __user *)arg;
 	int ret = -ENOTTY;
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		ret = 0;
-		if (copy_to_user((void *)arg, &ident, sizeof(ident)))
+		if (copy_to_user((void __user *)arg, &ident, sizeof(ident)))
 			ret = -EFAULT;
 		break;
 
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
-		ret = put_user(0, (int *)arg);
+		ret = put_user(0, int_arg);
 		break;
 
 	case WDIOC_KEEPALIVE:
@@ -156,7 +157,7 @@ static long watchdog_ioctl(struct file *
 		break;
 
 	case WDIOC_SETTIMEOUT:
-		ret = get_user(new_margin, (int *)arg);
+		ret = get_user(new_margin, int_arg);
 		if (ret)
 			break;
 
@@ -171,7 +172,7 @@ static long watchdog_ioctl(struct file *
 		watchdog_ping();
 		/* Fall */
 	case WDIOC_GETTIMEOUT:
-		ret = put_user(soft_margin, (int *)arg);
+		ret = put_user(soft_margin, int_arg);
 		break;
 	}
 	return ret;

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
