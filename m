Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbYIWIRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbYIWIRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 04:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbYIWIRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 04:17:34 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:45292 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753825AbYIWIR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 04:17:28 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugEAOtB2EhR9cQt/2dsb2JhbACBXbU2gWY
Date: Tue, 23 Sep 2008 10:17:25 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [WATCHDOG] v2.6.27-rc7 fixes
Message-ID: <20080923081725.GR22550@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/geodewdt.c    |    6 +++---
 drivers/watchdog/ibmasr.c      |    1 -
 drivers/watchdog/pnx4008_wdt.c |    4 ++--
 drivers/watchdog/rc32434_wdt.c |    6 +++---
 drivers/watchdog/rdc321x_wdt.c |    6 +++---
 drivers/watchdog/wdt285.c      |   15 ++++++++-------
 6 files changed, 19 insertions(+), 19 deletions(-)

with these Changes:

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Thu Sep 18 12:26:15 2008 +0000

    [WATCHDOG] unlocked_ioctl changes
    
    Fix some drivers so that they use the unlocked_ioctl call.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Ben Dooks <ben-linux@fluff.org>
Date:   Tue Sep 16 11:31:01 2008 +0100

    [WATCHDOG] wdt285: fix sparse warnings
    
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
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Akinobu Mita <akinobu.mita@gmail.com>
Date:   Sat Sep 13 18:47:19 2008 +0900

    [WATCHDOG] ibmasr: remove unnecessary spin_unlock()
    
    __asr_toggle() is always called with asr_lock held.
    But there is unnecessary spin_unlock() call in __asr_toggle().
    
    Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Acked-by: Andrey Panin <pazke@donpac.ru>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/geodewdt.c b/drivers/watchdog/geodewdt.c
index 614a5c7..6799a6d 100644
--- a/drivers/watchdog/geodewdt.c
+++ b/drivers/watchdog/geodewdt.c
@@ -130,8 +130,8 @@ static ssize_t geodewdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static int geodewdt_ioctl(struct inode *inode, struct file *file,
-				unsigned int cmd, unsigned long arg)
+static long geodewdt_ioctl(struct file *file, unsigned int cmd,
+				unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
@@ -198,7 +198,7 @@ static const struct file_operations geodewdt_fops = {
 	.owner          = THIS_MODULE,
 	.llseek         = no_llseek,
 	.write          = geodewdt_write,
-	.ioctl          = geodewdt_ioctl,
+	.unlocked_ioctl = geodewdt_ioctl,
 	.open           = geodewdt_open,
 	.release        = geodewdt_release,
 };
diff --git a/drivers/watchdog/ibmasr.c b/drivers/watchdog/ibmasr.c
index b82405c..89fcefc 100644
--- a/drivers/watchdog/ibmasr.c
+++ b/drivers/watchdog/ibmasr.c
@@ -85,7 +85,6 @@ static void __asr_toggle(void)
 
 	outb(reg & ~asr_toggle_mask, asr_write_addr);
 	reg = inb(asr_read_addr);
-	spin_unlock(&asr_lock);
 }
 
 static void asr_toggle(void)
diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index 0ed8416..6d9f3d4 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -173,8 +173,8 @@ static const struct watchdog_info ident = {
 	.identity = "PNX4008 Watchdog",
 };
 
-static long pnx4008_wdt_ioctl(struct inode *inode, struct file *file,
-					unsigned int cmd, unsigned long arg)
+static long pnx4008_wdt_ioctl(struct file *file, unsigned int cmd,
+				unsigned long arg)
 {
 	int ret = -ENOTTY;
 	int time;
diff --git a/drivers/watchdog/rc32434_wdt.c b/drivers/watchdog/rc32434_wdt.c
index 6756bcb..c9c73b6 100644
--- a/drivers/watchdog/rc32434_wdt.c
+++ b/drivers/watchdog/rc32434_wdt.c
@@ -182,8 +182,8 @@ static ssize_t rc32434_wdt_write(struct file *file, const char *data,
 	return 0;
 }
 
-static int rc32434_wdt_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long rc32434_wdt_ioctl(struct file *file, unsigned int cmd,
+				unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int new_timeout;
@@ -242,7 +242,7 @@ static struct file_operations rc32434_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= rc32434_wdt_write,
-	.ioctl		= rc32434_wdt_ioctl,
+	.unlocked_ioctl	= rc32434_wdt_ioctl,
 	.open		= rc32434_wdt_open,
 	.release	= rc32434_wdt_release,
 };
diff --git a/drivers/watchdog/rdc321x_wdt.c b/drivers/watchdog/rdc321x_wdt.c
index 9108efa..bf92802 100644
--- a/drivers/watchdog/rdc321x_wdt.c
+++ b/drivers/watchdog/rdc321x_wdt.c
@@ -144,8 +144,8 @@ static int rdc321x_wdt_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int rdc321x_wdt_ioctl(struct inode *inode, struct file *file,
-				unsigned int cmd, unsigned long arg)
+static long rdc321x_wdt_ioctl(struct file *file, unsigned int cmd,
+				unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	unsigned int value;
@@ -204,7 +204,7 @@ static ssize_t rdc321x_wdt_write(struct file *file, const char __user *buf,
 static const struct file_operations rdc321x_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
-	.ioctl		= rdc321x_wdt_ioctl,
+	.unlocked_ioctl	= rdc321x_wdt_ioctl,
 	.open		= rdc321x_wdt_open,
 	.write		= rdc321x_wdt_write,
 	.release	= rdc321x_wdt_release,
diff --git a/drivers/watchdog/wdt285.c b/drivers/watchdog/wdt285.c
index db362c3..191ea63 100644
--- a/drivers/watchdog/wdt285.c
+++ b/drivers/watchdog/wdt285.c
@@ -115,8 +115,8 @@ static int watchdog_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static ssize_t watchdog_write(struct file *file, const char *data,
-						size_t len, loff_t *ppos)
+static ssize_t watchdog_write(struct file *file, const char __user *data,
+			      size_t len, loff_t *ppos)
 {
 	/*
 	 *	Refresh the timer.
@@ -133,21 +133,22 @@ static const struct watchdog_info ident = {
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
@@ -156,7 +157,7 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
 		break;
 
 	case WDIOC_SETTIMEOUT:
-		ret = get_user(new_margin, (int *)arg);
+		ret = get_user(new_margin, int_arg);
 		if (ret)
 			break;
 
@@ -171,7 +172,7 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
 		watchdog_ping();
 		/* Fall */
 	case WDIOC_GETTIMEOUT:
-		ret = put_user(soft_margin, (int *)arg);
+		ret = put_user(soft_margin, int_arg);
 		break;
 	}
 	return ret;
