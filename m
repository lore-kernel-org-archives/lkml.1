Return-Path: <linux-kernel-owner+w=401wt.eu-S1755747Ab0ASVSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab0ASVSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:18:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397Ab0ASVSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:18:12 -0500
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:53956 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751711Ab0ASVSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:18:04 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAGevVUtbssBB/2dsb2JhbADNZ4wUCoIjggYE
Date: Tue, 19 Jan 2010 22:17:59 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Florian Fainelli <florian@openwrt.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Joe Perches <joe@perches.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       uclinux-dist-devel@blackfin.uclinux.org, linux-omap@vger.kernel.org
Subject: [RFC] [PATCH] watchdog_info separation and constify
Message-ID: <20100119211759.GE3804@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

please comment on following patch.

Kind regards,
Wim.

commit 88d0b1a9c071d26e7b4831320067c84b04ea04a8
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sat Dec 26 18:55:22 2009 +0000

    [WATCHDOG] watchdog_info separation and constify
    
    make sure that the watchdog_info struct is seperated from the ioctl code.
    Also make the struct const where possible.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

diff --git a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
index 6f8ebe1..072b948 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
@@ -553,7 +553,7 @@ static ssize_t mpc52xx_wdt_write(struct file *file, const char __user *data,
 	return 0;
 }
 
-static struct watchdog_info mpc5200_wdt_info = {
+static const struct watchdog_info mpc5200_wdt_info = {
 	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 	.identity	= WDT_IDENTITY,
 };
diff --git a/drivers/hwmon/fschmd.c b/drivers/hwmon/fschmd.c
index bd0fc67..878284b 100644
--- a/drivers/hwmon/fschmd.c
+++ b/drivers/hwmon/fschmd.c
@@ -845,14 +845,15 @@ static ssize_t watchdog_write(struct file *filp, const char __user *buf,
 	return count;
 }
 
+static struct watchdog_info ident = {
+	.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
+			WDIOF_CARDRESET,
+	.identity = "FSC watchdog"
+};
+
 static int watchdog_ioctl(struct inode *inode, struct file *filp,
 	unsigned int cmd, unsigned long arg)
 {
-	static struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
-				WDIOF_CARDRESET,
-		.identity = "FSC watchdog"
-	};
 	int i, ret = 0;
 	struct fschmd_data *data = filp->private_data;
 
diff --git a/drivers/watchdog/acquirewdt.c b/drivers/watchdog/acquirewdt.c
index 4d18c87..f0c956f 100644
--- a/drivers/watchdog/acquirewdt.c
+++ b/drivers/watchdog/acquirewdt.c
@@ -145,16 +145,17 @@ static ssize_t acq_write(struct file *file, const char __user *buf,
 	return count;
 }
 
+static const struct watchdog_info ident = {
+	.options = WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
+	.firmware_version = 1,
+	.identity = WATCHDOG_NAME,
+};
+
 static long acq_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int options, retval = -EINVAL;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
-		.firmware_version = 1,
-		.identity = WATCHDOG_NAME,
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/advantechwdt.c b/drivers/watchdog/advantechwdt.c
index 824d076..3a9f1df 100644
--- a/drivers/watchdog/advantechwdt.c
+++ b/drivers/watchdog/advantechwdt.c
@@ -132,18 +132,19 @@ static ssize_t advwdt_write(struct file *file, const char __user *buf,
 	return count;
 }
 
+static const struct watchdog_info ident = {
+	.options = WDIOF_KEEPALIVEPING |
+		   WDIOF_SETTIMEOUT |
+		   WDIOF_MAGICCLOSE,
+	.firmware_version = 1,
+	.identity = WATCHDOG_NAME,
+};
+
 static long advwdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int new_timeout;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING |
-			   WDIOF_SETTIMEOUT |
-			   WDIOF_MAGICCLOSE,
-		.firmware_version = 1,
-		.identity = WATCHDOG_NAME,
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/adx_wdt.c b/drivers/watchdog/adx_wdt.c
index 9d7d155..a5ca7a6 100644
--- a/drivers/watchdog/adx_wdt.c
+++ b/drivers/watchdog/adx_wdt.c
@@ -37,7 +37,7 @@ struct adx_wdt {
 	spinlock_t lock;
 };
 
-static struct watchdog_info adx_wdt_info = {
+static const struct watchdog_info adx_wdt_info = {
 	.identity = "Avionic Design Xanthos Watchdog",
 	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 };
diff --git a/drivers/watchdog/alim1535_wdt.c b/drivers/watchdog/alim1535_wdt.c
index 937a80f..d5225ad 100644
--- a/drivers/watchdog/alim1535_wdt.c
+++ b/drivers/watchdog/alim1535_wdt.c
@@ -176,17 +176,18 @@ static ssize_t ali_write(struct file *file, const char __user *data,
  *	we want an extension to enable irq ack monitoring and the like
  */
 
+static const struct watchdog_info ident = {
+	.options =		WDIOF_KEEPALIVEPING |
+				WDIOF_SETTIMEOUT |
+				WDIOF_MAGICCLOSE,
+	.firmware_version =	0,
+	.identity =		"ALi M1535 WatchDog Timer",
+};
+
 static long ali_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
-		.options =		WDIOF_KEEPALIVEPING |
-					WDIOF_SETTIMEOUT |
-					WDIOF_MAGICCLOSE,
-		.firmware_version =	0,
-		.identity =		"ALi M1535 WatchDog Timer",
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/alim7101_wdt.c b/drivers/watchdog/alim7101_wdt.c
index f90afdb..def02ee 100644
--- a/drivers/watchdog/alim7101_wdt.c
+++ b/drivers/watchdog/alim7101_wdt.c
@@ -234,16 +234,16 @@ static int fop_close(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static const struct watchdog_info ident = {
+	.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+	.firmware_version = 1,
+	.identity = "ALiM7101",
+};
+
 static long fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
-							| WDIOF_MAGICCLOSE,
-		.firmware_version = 1,
-		.identity = "ALiM7101",
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
index 2e94b71..2798c6f 100644
--- a/drivers/watchdog/ar7_wdt.c
+++ b/drivers/watchdog/ar7_wdt.c
@@ -211,15 +211,15 @@ static ssize_t ar7_wdt_write(struct file *file, const char *data,
 	return len;
 }
 
+static const struct watchdog_info ident = {
+	.identity = LONGNAME,
+	.firmware_version = 1,
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
+};
+
 static long ar7_wdt_ioctl(struct file *file,
 					unsigned int cmd, unsigned long arg)
 {
-	static struct watchdog_info ident = {
-		.identity = LONGNAME,
-		.firmware_version = 1,
-		.options = (WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
-						WDIOF_MAGICCLOSE),
-	};
 	int new_margin;
 
 	switch (cmd) {
diff --git a/drivers/watchdog/at32ap700x_wdt.c b/drivers/watchdog/at32ap700x_wdt.c
index 0378479..6873376 100644
--- a/drivers/watchdog/at32ap700x_wdt.c
+++ b/drivers/watchdog/at32ap700x_wdt.c
@@ -202,7 +202,7 @@ static int at32_wdt_get_status(void)
 	return status;
 }
 
-static struct watchdog_info at32_wdt_info = {
+static const struct watchdog_info at32_wdt_info = {
 	.identity	= "at32ap700x watchdog",
 	.options	= WDIOF_SETTIMEOUT |
 			  WDIOF_KEEPALIVEPING |
diff --git a/drivers/watchdog/at91rm9200_wdt.c b/drivers/watchdog/at91rm9200_wdt.c
index b185daf..b3046dc 100644
--- a/drivers/watchdog/at91rm9200_wdt.c
+++ b/drivers/watchdog/at91rm9200_wdt.c
@@ -121,7 +121,7 @@ static int at91_wdt_settimeout(int new_time)
 	return 0;
 }
 
-static struct watchdog_info at91_wdt_info = {
+static const struct watchdog_info at91_wdt_info = {
 	.identity	= "at91 watchdog",
 	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 };
diff --git a/drivers/watchdog/bcm47xx_wdt.c b/drivers/watchdog/bcm47xx_wdt.c
index 751c003..5f24552 100644
--- a/drivers/watchdog/bcm47xx_wdt.c
+++ b/drivers/watchdog/bcm47xx_wdt.c
@@ -149,7 +149,7 @@ static ssize_t bcm47xx_wdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static struct watchdog_info bcm47xx_wdt_info = {
+static const struct watchdog_info bcm47xx_wdt_info = {
 	.identity 	= DRV_NAME,
 	.options 	= WDIOF_SETTIMEOUT |
 				WDIOF_KEEPALIVEPING |
diff --git a/drivers/watchdog/bfin_wdt.c b/drivers/watchdog/bfin_wdt.c
index c7b3f9d..6ce2022 100644
--- a/drivers/watchdog/bfin_wdt.c
+++ b/drivers/watchdog/bfin_wdt.c
@@ -75,7 +75,7 @@
 
 static unsigned int timeout = WATCHDOG_TIMEOUT;
 static int nowayout = WATCHDOG_NOWAYOUT;
-static struct watchdog_info bfin_wdt_info;
+static const struct watchdog_info bfin_wdt_info;
 static unsigned long open_check;
 static char expect_close;
 static DEFINE_SPINLOCK(bfin_wdt_spinlock);
@@ -387,7 +387,7 @@ static struct miscdevice bfin_wdt_miscdev = {
 	.fops     = &bfin_wdt_fops,
 };
 
-static struct watchdog_info bfin_wdt_info = {
+static const struct watchdog_info bfin_wdt_info = {
 	.identity = "Blackfin Watchdog",
 	.options  = WDIOF_SETTIMEOUT |
 		    WDIOF_KEEPALIVEPING |
diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index e8380ef..8b724aa 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -121,7 +121,7 @@ static ssize_t booke_wdt_write(struct file *file, const char __user *buf,
 	return count;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 	.identity = "PowerPC Book-E Watchdog",
 };
diff --git a/drivers/watchdog/coh901327_wdt.c b/drivers/watchdog/coh901327_wdt.c
index 923cc68..91efe96 100644
--- a/drivers/watchdog/coh901327_wdt.c
+++ b/drivers/watchdog/coh901327_wdt.c
@@ -246,6 +246,14 @@ static ssize_t coh901327_write(struct file *file, const char __user *data,
 	return len;
 }
 
+static const struct watchdog_info ident = {
+	.options		= WDIOF_CARDRESET |
+				  WDIOF_SETTIMEOUT |
+				  WDIOF_KEEPALIVEPING,
+	.identity		= "COH 901 327 Watchdog",
+	.firmware_version	= 1,
+};
+
 static long coh901327_ioctl(struct file *file, unsigned int cmd,
 			    unsigned long arg)
 {
@@ -257,13 +265,6 @@ static long coh901327_ioctl(struct file *file, unsigned int cmd,
 		struct watchdog_info __user *ident;
 		int __user *i;
 	} uarg;
-	static struct watchdog_info ident = {
-		.options		= WDIOF_CARDRESET |
-					  WDIOF_SETTIMEOUT |
-					  WDIOF_KEEPALIVEPING,
-		.identity		= "COH 901 327 Watchdog",
-		.firmware_version	= 1,
-	};
 	uarg.i = (int __user *)arg;
 
 	switch (cmd) {
diff --git a/drivers/watchdog/cpu5wdt.c b/drivers/watchdog/cpu5wdt.c
index 71f6d7e..23d5fe7 100644
--- a/drivers/watchdog/cpu5wdt.c
+++ b/drivers/watchdog/cpu5wdt.c
@@ -148,16 +148,17 @@ static int cpu5wdt_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static const struct watchdog_info ident = {
+	.options = WDIOF_CARDRESET,
+	.identity = "CPU5 WDT",
+};
+
 static long cpu5wdt_ioctl(struct file *file, unsigned int cmd,
 						unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	unsigned int value;
-	static struct watchdog_info ident = {
-		.options = WDIOF_CARDRESET,
-		.identity = "CPU5 WDT",
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/cpwd.c b/drivers/watchdog/cpwd.c
index 081f295..57ad320 100644
--- a/drivers/watchdog/cpwd.c
+++ b/drivers/watchdog/cpwd.c
@@ -401,13 +401,14 @@ static int cpwd_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static const struct watchdog_info info = {
+	.options		= WDIOF_SETTIMEOUT,
+	.firmware_version	= 1,
+	.identity		= DRIVER_NAME,
+};
+
 static long cpwd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	static struct watchdog_info info = {
-		.options		= WDIOF_SETTIMEOUT,
-		.firmware_version	= 1,
-		.identity		= DRIVER_NAME,
-	};
 	void __user *argp = (void __user *)arg;
 	struct inode *inode = file->f_path.dentry->d_inode;
 	int index = iminor(inode) - WD0_MINOR;
diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index 887136d..56162c8 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -142,7 +142,7 @@ davinci_wdt_write(struct file *file, const char *data, size_t len,
 	return len;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_KEEPALIVEPING,
 	.identity = "DaVinci Watchdog",
 };
diff --git a/drivers/watchdog/ep93xx_wdt.c b/drivers/watchdog/ep93xx_wdt.c
index cdd55e0..88ed54e 100644
--- a/drivers/watchdog/ep93xx_wdt.c
+++ b/drivers/watchdog/ep93xx_wdt.c
@@ -131,7 +131,7 @@ ep93xx_wdt_write(struct file *file, const char __user *data, size_t len,
 	return len;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_CARDRESET | WDIOF_MAGICCLOSE,
 	.identity = "EP93xx Watchdog",
 };
diff --git a/drivers/watchdog/eurotechwdt.c b/drivers/watchdog/eurotechwdt.c
index 9add354..4edaccc 100644
--- a/drivers/watchdog/eurotechwdt.c
+++ b/drivers/watchdog/eurotechwdt.c
@@ -233,17 +233,18 @@ size_t count, loff_t *ppos)
  * according to their available features.
  */
 
+static const struct watchdog_info ident = {
+	.options	  = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
+						| WDIOF_MAGICCLOSE,
+	.firmware_version = 1,
+	.identity	  = "WDT Eurotech CPU-1220/1410",
+};
+
 static long eurwdt_ioctl(struct file *file,
 					unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
-		.options	  = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
-							| WDIOF_MAGICCLOSE,
-		.firmware_version = 1,
-		.identity	  = "WDT Eurotech CPU-1220/1410",
-	};
 
 	int time;
 	int options, retval = -EINVAL;
diff --git a/drivers/watchdog/gef_wdt.c b/drivers/watchdog/gef_wdt.c
index 734d980..195087d 100644
--- a/drivers/watchdog/gef_wdt.c
+++ b/drivers/watchdog/gef_wdt.c
@@ -155,18 +155,19 @@ static ssize_t gef_wdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
+static const struct watchdog_info info = {
+	.options =	WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE |
+			WDIOF_KEEPALIVEPING,
+	.firmware_version = 0,
+	.identity = "GE Fanuc watchdog",
+};
+
 static long gef_wdt_ioctl(struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	int timeout;
 	int options;
 	void __user *argp = (void __user *)arg;
-	static struct watchdog_info info = {
-		.options =	WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE |
-				WDIOF_KEEPALIVEPING,
-		.firmware_version = 0,
-		.identity = "GE Fanuc watchdog",
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/geodewdt.c b/drivers/watchdog/geodewdt.c
index 38252ff..00862e2 100644
--- a/drivers/watchdog/geodewdt.c
+++ b/drivers/watchdog/geodewdt.c
@@ -135,6 +135,12 @@ static ssize_t geodewdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
+static const struct watchdog_info ident = {
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
+	.firmware_version =     1,
+	.identity =             WATCHDOG_NAME,
+};
+
 static long geodewdt_ioctl(struct file *file, unsigned int cmd,
 				unsigned long arg)
 {
@@ -142,13 +148,6 @@ static long geodewdt_ioctl(struct file *file, unsigned int cmd,
 	int __user *p = argp;
 	int interval;
 
-	static struct watchdog_info ident = {
-		.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING
-		| WDIOF_MAGICCLOSE,
-		.firmware_version =     1,
-		.identity =             WATCHDOG_NAME,
-	};
-
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		return copy_to_user(argp, &ident,
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index a6c5674..70c2c24 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -554,7 +554,7 @@ static ssize_t hpwdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_SETTIMEOUT |
 		   WDIOF_KEEPALIVEPING |
 		   WDIOF_MAGICCLOSE,
diff --git a/drivers/watchdog/i6300esb.c b/drivers/watchdog/i6300esb.c
index 7ba0b11..7572648 100644
--- a/drivers/watchdog/i6300esb.c
+++ b/drivers/watchdog/i6300esb.c
@@ -250,19 +250,20 @@ static ssize_t esb_write(struct file *file, const char __user *data,
 	return len;
 }
 
+static const struct watchdog_info ident = {
+	.options =		WDIOF_SETTIMEOUT |
+				WDIOF_KEEPALIVEPING |
+				WDIOF_MAGICCLOSE,
+	.firmware_version =	0,
+	.identity =		ESB_MODULE_NAME,
+};
+
 static long esb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int new_options, retval = -EINVAL;
 	int new_heartbeat;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
-		.options =		WDIOF_SETTIMEOUT |
-					WDIOF_KEEPALIVEPING |
-					WDIOF_MAGICCLOSE,
-		.firmware_version =	0,
-		.identity =		ESB_MODULE_NAME,
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index c8a3bec..8d791bd 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -534,6 +534,14 @@ static ssize_t iTCO_wdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
+static const struct watchdog_info ident = {
+	.options =		WDIOF_SETTIMEOUT |
+				WDIOF_KEEPALIVEPING |
+				WDIOF_MAGICCLOSE,
+	.firmware_version =	0,
+	.identity =		DRV_NAME,
+};
+
 static long iTCO_wdt_ioctl(struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
@@ -541,13 +549,6 @@ static long iTCO_wdt_ioctl(struct file *file, unsigned int cmd,
 	int new_heartbeat;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
-		.options =		WDIOF_SETTIMEOUT |
-					WDIOF_KEEPALIVEPING |
-					WDIOF_MAGICCLOSE,
-		.firmware_version =	0,
-		.identity =		DRV_NAME,
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/ib700wdt.c b/drivers/watchdog/ib700wdt.c
index 4bef3dd..8b1a5aa 100644
--- a/drivers/watchdog/ib700wdt.c
+++ b/drivers/watchdog/ib700wdt.c
@@ -168,19 +168,18 @@ static ssize_t ibwdt_write(struct file *file, const char __user *buf,
 	return count;
 }
 
+static const struct watchdog_info ident = {
+	.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+	.firmware_version = 1,
+	.identity = "IB700 WDT",
+};
+
 static long ibwdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int new_margin;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 
-	static struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
-							| WDIOF_MAGICCLOSE,
-		.firmware_version = 1,
-		.identity = "IB700 WDT",
-	};
-
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		if (copy_to_user(argp, &ident, sizeof(ident)))
diff --git a/drivers/watchdog/ibmasr.c b/drivers/watchdog/ibmasr.c
index 89fcefc..f0d438d 100644
--- a/drivers/watchdog/ibmasr.c
+++ b/drivers/watchdog/ibmasr.c
@@ -269,13 +269,14 @@ static ssize_t asr_write(struct file *file, const char __user *buf,
 	return count;
 }
 
+static const struct watchdog_info ident = {
+	.options =	WDIOF_KEEPALIVEPING |
+			WDIOF_MAGICCLOSE,
+	.identity =	"IBM ASR",
+};
+
 static long asr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	static const struct watchdog_info ident = {
-		.options =	WDIOF_KEEPALIVEPING |
-				WDIOF_MAGICCLOSE,
-		.identity =	"IBM ASR",
-	};
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int heartbeat;
diff --git a/drivers/watchdog/indydog.c b/drivers/watchdog/indydog.c
index bea8a12..bafeca2 100644
--- a/drivers/watchdog/indydog.c
+++ b/drivers/watchdog/indydog.c
@@ -107,15 +107,16 @@ static ssize_t indydog_write(struct file *file, const char *data,
 	return len;
 }
 
+static const struct watchdog_info ident = {
+	.options		= WDIOF_KEEPALIVEPING,
+	.firmware_version	= 0,
+	.identity		= "Hardware Watchdog for SGI IP22",
+};
+
 static long indydog_ioctl(struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	int options, retval = -EINVAL;
-	static struct watchdog_info ident = {
-		.options		= WDIOF_KEEPALIVEPING,
-		.firmware_version	= 0,
-		.identity		= "Hardware Watchdog for SGI IP22",
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
index daed48d..d5d9f15 100644
--- a/drivers/watchdog/it8712f_wdt.c
+++ b/drivers/watchdog/it8712f_wdt.c
@@ -231,17 +231,18 @@ static ssize_t it8712f_wdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
+static const struct watchdog_info ident = {
+	.identity = "IT8712F Watchdog",
+	.firmware_version = 1,
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
+					WDIOF_MAGICCLOSE,
+};
+
 static long it8712f_wdt_ioctl(struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
-		.identity = "IT8712F Watchdog",
-		.firmware_version = 1,
-		.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
-						WDIOF_MAGICCLOSE,
-	};
 	int value;
 
 	switch (cmd) {
diff --git a/drivers/watchdog/it87_wdt.c b/drivers/watchdog/it87_wdt.c
index cc133c5..b709b3b 100644
--- a/drivers/watchdog/it87_wdt.c
+++ b/drivers/watchdog/it87_wdt.c
@@ -421,7 +421,7 @@ static ssize_t wdt_write(struct file *file, const char __user *buf,
 	return count;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE | WDIOF_KEEPALIVEPING,
 	.firmware_version =	1,
 	.identity = WATCHDOG_NAME,
diff --git a/drivers/watchdog/ixp2000_wdt.c b/drivers/watchdog/ixp2000_wdt.c
index 4f4b35a..0f504cd 100644
--- a/drivers/watchdog/ixp2000_wdt.c
+++ b/drivers/watchdog/ixp2000_wdt.c
@@ -99,7 +99,7 @@ static ssize_t ixp2000_wdt_write(struct file *file, const char *data,
 }
 
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options	= WDIOF_MAGICCLOSE | WDIOF_SETTIMEOUT |
 				WDIOF_KEEPALIVEPING,
 	.identity	= "IXP2000 Watchdog",
diff --git a/drivers/watchdog/ixp4xx_wdt.c b/drivers/watchdog/ixp4xx_wdt.c
index 147b4d5..e02c0ec 100644
--- a/drivers/watchdog/ixp4xx_wdt.c
+++ b/drivers/watchdog/ixp4xx_wdt.c
@@ -89,7 +89,7 @@ ixp4xx_wdt_write(struct file *file, const char *data, size_t len, loff_t *ppos)
 	return len;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options	= WDIOF_CARDRESET | WDIOF_MAGICCLOSE |
 			  WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 	.identity	= "IXP4xx Watchdog",
diff --git a/drivers/watchdog/ks8695_wdt.c b/drivers/watchdog/ks8695_wdt.c
index e1c8276..2852bb2 100644
--- a/drivers/watchdog/ks8695_wdt.c
+++ b/drivers/watchdog/ks8695_wdt.c
@@ -145,7 +145,7 @@ static int ks8695_wdt_close(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static struct watchdog_info ks8695_wdt_info = {
+static const struct watchdog_info ks8695_wdt_info = {
 	.identity	= "ks8695 watchdog",
 	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 };
diff --git a/drivers/watchdog/machzwd.c b/drivers/watchdog/machzwd.c
index 47d7197..2d118cf 100644
--- a/drivers/watchdog/machzwd.c
+++ b/drivers/watchdog/machzwd.c
@@ -101,7 +101,7 @@ MODULE_PARM_DESC(nowayout,
 
 #define PFX "machzwd"
 
-static struct watchdog_info zf_info = {
+static const struct watchdog_info zf_info = {
 	.options		= WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
 	.firmware_version	= 1,
 	.identity		= "ZF-Logic watchdog",
diff --git a/drivers/watchdog/mixcomwd.c b/drivers/watchdog/mixcomwd.c
index 407b025..9fd61a9 100644
--- a/drivers/watchdog/mixcomwd.c
+++ b/drivers/watchdog/mixcomwd.c
@@ -195,17 +195,18 @@ static ssize_t mixcomwd_write(struct file *file, const char __user *data,
 	return len;
 }
 
+static const struct watchdog_info ident = {
+	.options = WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
+	.firmware_version = 1,
+	.identity = "MixCOM watchdog",
+};
+
 static long mixcomwd_ioctl(struct file *file,
 				unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int status;
-	static struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
-		.firmware_version = 1,
-		.identity = "MixCOM watchdog",
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/mpc8xxx_wdt.c b/drivers/watchdog/mpc8xxx_wdt.c
index 38c588e..04a2042 100644
--- a/drivers/watchdog/mpc8xxx_wdt.c
+++ b/drivers/watchdog/mpc8xxx_wdt.c
@@ -143,16 +143,17 @@ static int mpc8xxx_wdt_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static const struct watchdog_info ident = {
+	.options = WDIOF_KEEPALIVEPING,
+	.firmware_version = 1,
+	.identity = "MPC8xxx",
+};
+
 static long mpc8xxx_wdt_ioctl(struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING,
-		.firmware_version = 1,
-		.identity = "MPC8xxx",
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index a2dc07c..b0646da 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -213,7 +213,7 @@ static ssize_t mpcore_wdt_write(struct file *file, const char *data,
 	return len;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options		= WDIOF_SETTIMEOUT |
 				  WDIOF_KEEPALIVEPING |
 				  WDIOF_MAGICCLOSE,
diff --git a/drivers/watchdog/mtx-1_wdt.c b/drivers/watchdog/mtx-1_wdt.c
index 08e8a6a..ba2503c 100644
--- a/drivers/watchdog/mtx-1_wdt.c
+++ b/drivers/watchdog/mtx-1_wdt.c
@@ -140,16 +140,17 @@ static int mtx1_wdt_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static const struct watchdog_info ident = {
+	.options = WDIOF_CARDRESET,
+	.identity = "MTX-1 WDT",
+};
+
 static long mtx1_wdt_ioctl(struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = (int __user *)argp;
 	unsigned int value;
-	static const struct watchdog_info ident = {
-		.options = WDIOF_CARDRESET,
-		.identity = "MTX-1 WDT",
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/mv64x60_wdt.c b/drivers/watchdog/mv64x60_wdt.c
index a51dbe4..2a56998 100644
--- a/drivers/watchdog/mv64x60_wdt.c
+++ b/drivers/watchdog/mv64x60_wdt.c
@@ -173,19 +173,20 @@ static ssize_t mv64x60_wdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
+static const struct watchdog_info info = {
+	.options =	WDIOF_SETTIMEOUT	|
+			WDIOF_MAGICCLOSE	|
+			WDIOF_KEEPALIVEPING,
+	.firmware_version = 0,
+	.identity = "MV64x60 watchdog",
+};
+
 static long mv64x60_wdt_ioctl(struct file *file,
 					unsigned int cmd, unsigned long arg)
 {
 	int timeout;
 	int options;
 	void __user *argp = (void __user *)arg;
-	static struct watchdog_info info = {
-		.options =	WDIOF_SETTIMEOUT	|
-				WDIOF_MAGICCLOSE	|
-				WDIOF_KEEPALIVEPING,
-		.firmware_version = 0,
-		.identity = "MV64x60 watchdog",
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index c6aaf28..3dbd835 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -200,16 +200,17 @@ static ssize_t omap_wdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
+static const struct watchdog_info ident = {
+	.identity = "OMAP Watchdog",
+	.options = WDIOF_SETTIMEOUT,
+	.firmware_version = 0,
+};
+
 static long omap_wdt_ioctl(struct file *file, unsigned int cmd,
 						unsigned long arg)
 {
 	struct omap_wdt_dev *wdev;
 	int new_margin;
-	static const struct watchdog_info ident = {
-		.identity = "OMAP Watchdog",
-		.options = WDIOF_SETTIMEOUT,
-		.firmware_version = 0,
-	};
 
 	wdev = file->private_data;
 
diff --git a/drivers/watchdog/pc87413_wdt.c b/drivers/watchdog/pc87413_wdt.c
index 1a2b916..6399b4c 100644
--- a/drivers/watchdog/pc87413_wdt.c
+++ b/drivers/watchdog/pc87413_wdt.c
@@ -397,6 +397,14 @@ static ssize_t pc87413_write(struct file *file, const char __user *data,
  *	querying capabilities and current status.
  */
 
+static const struct watchdog_info ident = {
+	.options          = WDIOF_KEEPALIVEPING |
+			    WDIOF_SETTIMEOUT |
+			    WDIOF_MAGICCLOSE,
+	.firmware_version = 1,
+	.identity         = "PC87413(HF/F) watchdog",
+};
+
 static long pc87413_ioctl(struct file *file, unsigned int cmd,
 						unsigned long arg)
 {
@@ -407,14 +415,6 @@ static long pc87413_ioctl(struct file *file, unsigned int cmd,
 		int __user *i;
 	} uarg;
 
-	static struct watchdog_info ident = {
-		.options          = WDIOF_KEEPALIVEPING |
-				    WDIOF_SETTIMEOUT |
-				    WDIOF_MAGICCLOSE,
-		.firmware_version = 1,
-		.identity         = "PC87413(HF/F) watchdog",
-	};
-
 	uarg.i = (int __user *)arg;
 
 	switch (cmd) {
diff --git a/drivers/watchdog/pcwd.c b/drivers/watchdog/pcwd.c
index aa95123..7205f8c 100644
--- a/drivers/watchdog/pcwd.c
+++ b/drivers/watchdog/pcwd.c
@@ -599,6 +599,16 @@ static int pcwd_get_temperature(int *temperature)
  *	/dev/watchdog handling
  */
 
+static const struct watchdog_info ident = {
+	.options =		WDIOF_OVERHEAT |
+				WDIOF_CARDRESET |
+				WDIOF_KEEPALIVEPING |
+				WDIOF_SETTIMEOUT |
+				WDIOF_MAGICCLOSE,
+	.firmware_version =	1,
+	.identity =		"PCWD",
+};
+
 static long pcwd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int rv;
@@ -606,15 +616,6 @@ static long pcwd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	int temperature;
 	int new_heartbeat;
 	int __user *argp = (int __user *)arg;
-	static struct watchdog_info ident = {
-		.options =		WDIOF_OVERHEAT |
-					WDIOF_CARDRESET |
-					WDIOF_KEEPALIVEPING |
-					WDIOF_SETTIMEOUT |
-					WDIOF_MAGICCLOSE,
-		.firmware_version =	1,
-		.identity =		"PCWD",
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/pcwd_pci.c b/drivers/watchdog/pcwd_pci.c
index 698f51b..7bbe72e 100644
--- a/drivers/watchdog/pcwd_pci.c
+++ b/drivers/watchdog/pcwd_pci.c
@@ -476,20 +476,21 @@ static ssize_t pcipcwd_write(struct file *file, const char __user *data,
 	return len;
 }
 
+static const struct watchdog_info ident = {
+	.options =		WDIOF_OVERHEAT |
+				WDIOF_CARDRESET |
+				WDIOF_KEEPALIVEPING |
+				WDIOF_SETTIMEOUT |
+				WDIOF_MAGICCLOSE,
+	.firmware_version =	1,
+	.identity =		WATCHDOG_DRIVER_NAME,
+};
+
 static long pcipcwd_ioctl(struct file *file, unsigned int cmd,
 						unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
-		.options =		WDIOF_OVERHEAT |
-					WDIOF_CARDRESET |
-					WDIOF_KEEPALIVEPING |
-					WDIOF_SETTIMEOUT |
-					WDIOF_MAGICCLOSE,
-		.firmware_version =	1,
-		.identity =		WATCHDOG_DRIVER_NAME,
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/pcwd_usb.c b/drivers/watchdog/pcwd_usb.c
index 052fe45..3e1f151 100644
--- a/drivers/watchdog/pcwd_usb.c
+++ b/drivers/watchdog/pcwd_usb.c
@@ -399,18 +399,19 @@ static ssize_t usb_pcwd_write(struct file *file, const char __user *data,
 	return len;
 }
 
+static const struct watchdog_info ident = {
+	.options =		WDIOF_KEEPALIVEPING |
+				WDIOF_SETTIMEOUT |
+				WDIOF_MAGICCLOSE,
+	.firmware_version =	1,
+	.identity =		DRIVER_NAME,
+};
+
 static long usb_pcwd_ioctl(struct file *file, unsigned int cmd,
 						unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
-		.options =		WDIOF_KEEPALIVEPING |
-					WDIOF_SETTIMEOUT |
-					WDIOF_MAGICCLOSE,
-		.firmware_version =	1,
-		.identity =		DRIVER_NAME,
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/pika_wdt.c b/drivers/watchdog/pika_wdt.c
index 2d22e99..435ec2a 100644
--- a/drivers/watchdog/pika_wdt.c
+++ b/drivers/watchdog/pika_wdt.c
@@ -52,7 +52,7 @@ static struct {
 	struct timer_list timer;	/* The timer that pings the watchdog */
 } pikawdt_private;
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.identity	= DRV_NAME,
 	.options	= WDIOF_CARDRESET |
 			  WDIOF_SETTIMEOUT |
diff --git a/drivers/watchdog/pnx833x_wdt.c b/drivers/watchdog/pnx833x_wdt.c
index 538ec2c..0a2499b 100644
--- a/drivers/watchdog/pnx833x_wdt.c
+++ b/drivers/watchdog/pnx833x_wdt.c
@@ -135,18 +135,18 @@ static ssize_t pnx833x_wdt_write(struct file *file, const char *data, size_t len
 	return len;
 }
 
+static const struct watchdog_info ident = {
+	.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT,
+	.firmware_version = 0,
+	.identity = "Hardware Watchdog for PNX833x",
+};
+
 static long pnx833x_wdt_ioctl(struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	int options, new_timeout = 0;
 	uint32_t timeout, timeout_left = 0;
 
-	static struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT,
-		.firmware_version = 0,
-		.identity = "Hardware Watchdog for PNX833x",
-	};
-
 	switch (cmd) {
 	default:
 		return -ENOTTY;
diff --git a/drivers/watchdog/rc32434_wdt.c b/drivers/watchdog/rc32434_wdt.c
index bf12d06..976914f 100644
--- a/drivers/watchdog/rc32434_wdt.c
+++ b/drivers/watchdog/rc32434_wdt.c
@@ -192,18 +192,19 @@ static ssize_t rc32434_wdt_write(struct file *file, const char *data,
 	return 0;
 }
 
+static const struct watchdog_info ident = {
+	.options =		WDIOF_SETTIMEOUT |
+				WDIOF_KEEPALIVEPING |
+				WDIOF_MAGICCLOSE,
+	.identity =		"RC32434_WDT Watchdog",
+};
+
 static long rc32434_wdt_ioctl(struct file *file, unsigned int cmd,
 				unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int new_timeout;
 	unsigned int value;
-	static struct watchdog_info ident = {
-		.options =		WDIOF_SETTIMEOUT |
-					WDIOF_KEEPALIVEPING |
-					WDIOF_MAGICCLOSE,
-		.identity =		"RC32434_WDT Watchdog",
-	};
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		if (copy_to_user(argp, &ident, sizeof(ident)))
diff --git a/drivers/watchdog/rdc321x_wdt.c b/drivers/watchdog/rdc321x_wdt.c
index 4976bfd..4bbdf92 100644
--- a/drivers/watchdog/rdc321x_wdt.c
+++ b/drivers/watchdog/rdc321x_wdt.c
@@ -144,15 +144,16 @@ static int rdc321x_wdt_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static const struct watchdog_info ident = {
+	.options = WDIOF_CARDRESET,
+	.identity = "RDC321x WDT",
+};
+
 static long rdc321x_wdt_ioctl(struct file *file, unsigned int cmd,
 				unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	unsigned int value;
-	static struct watchdog_info ident = {
-		.options = WDIOF_CARDRESET,
-		.identity = "RDC321x WDT",
-	};
 	unsigned long flags;
 
 	switch (cmd) {
diff --git a/drivers/watchdog/riowd.c b/drivers/watchdog/riowd.c
index c14ae86..dfe089b 100644
--- a/drivers/watchdog/riowd.c
+++ b/drivers/watchdog/riowd.c
@@ -83,13 +83,14 @@ static int riowd_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+static const struct watchdog_info info = {
+	.options		= WDIOF_SETTIMEOUT,
+	.firmware_version	= 1,
+	.identity		= DRIVER_NAME,
+};
+
 static long riowd_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
-	static struct watchdog_info info = {
-		.options		= WDIOF_SETTIMEOUT,
-		.firmware_version	= 1,
-		.identity		= DRIVER_NAME,
-	};
 	void __user *argp = (void __user *)arg;
 	struct riowd *p = riowd_device;
 	unsigned int options;
diff --git a/drivers/watchdog/sbc60xxwdt.c b/drivers/watchdog/sbc60xxwdt.c
index 626d0e8..9cb78cb 100644
--- a/drivers/watchdog/sbc60xxwdt.c
+++ b/drivers/watchdog/sbc60xxwdt.c
@@ -225,16 +225,17 @@ static int fop_close(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static const struct watchdog_info ident = {
+	.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
+						WDIOF_MAGICCLOSE,
+	.firmware_version = 1,
+	.identity = "SBC60xx",
+};
+
 static long fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static const struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
-							WDIOF_MAGICCLOSE,
-		.firmware_version = 1,
-		.identity = "SBC60xx",
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/sbc_epx_c3.c b/drivers/watchdog/sbc_epx_c3.c
index 28f1214..4a1a663 100644
--- a/drivers/watchdog/sbc_epx_c3.c
+++ b/drivers/watchdog/sbc_epx_c3.c
@@ -101,16 +101,17 @@ static ssize_t epx_c3_write(struct file *file, const char __user *data,
 	return len;
 }
 
+static const struct watchdog_info ident = {
+	.options		= WDIOF_KEEPALIVEPING,
+	.firmware_version	= 0,
+	.identity		= "Winsystems EPX-C3 H/W Watchdog",
+};
+
 static long epx_c3_ioctl(struct file *file, unsigned int cmd,
 						unsigned long arg)
 {
 	int options, retval = -EINVAL;
 	int __user *argp = (void __user *)arg;
-	static const struct watchdog_info ident = {
-		.options		= WDIOF_KEEPALIVEPING,
-		.firmware_version	= 0,
-		.identity		= "Winsystems EPX-C3 H/W Watchdog",
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/sbc_fitpc2_wdt.c b/drivers/watchdog/sbc_fitpc2_wdt.c
index 91430a8..a5638be 100644
--- a/drivers/watchdog/sbc_fitpc2_wdt.c
+++ b/drivers/watchdog/sbc_fitpc2_wdt.c
@@ -111,7 +111,7 @@ out:
 }
 
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options	= WDIOF_MAGICCLOSE | WDIOF_SETTIMEOUT |
 				WDIOF_KEEPALIVEPING,
 	.identity	= WATCHDOG_NAME,
diff --git a/drivers/watchdog/sc1200wdt.c b/drivers/watchdog/sc1200wdt.c
index c01daca..2bdf101 100644
--- a/drivers/watchdog/sc1200wdt.c
+++ b/drivers/watchdog/sc1200wdt.c
@@ -181,6 +181,12 @@ static int sc1200wdt_open(struct inode *inode, struct file *file)
 	return nonseekable_open(inode, file);
 }
 
+static const struct watchdog_info ident = {
+	.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
+						WDIOF_MAGICCLOSE,
+	.firmware_version = 0,
+	.identity = "PC87307/PC97307",
+};
 
 static long sc1200wdt_ioctl(struct file *file, unsigned int cmd,
 						unsigned long arg)
@@ -188,12 +194,6 @@ static long sc1200wdt_ioctl(struct file *file, unsigned int cmd,
 	int new_timeout;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static const struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
-							WDIOF_MAGICCLOSE,
-		.firmware_version = 0,
-		.identity = "PC87307/PC97307",
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/sc520_wdt.c b/drivers/watchdog/sc520_wdt.c
index 52b63f2..ae9ffd0 100644
--- a/drivers/watchdog/sc520_wdt.c
+++ b/drivers/watchdog/sc520_wdt.c
@@ -279,16 +279,17 @@ static int fop_close(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static const struct watchdog_info ident = {
+	.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
+						| WDIOF_MAGICCLOSE,
+	.firmware_version = 1,
+	.identity = "SC520",
+};
+
 static long fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static const struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
-							| WDIOF_MAGICCLOSE,
-		.firmware_version = 1,
-		.identity = "SC520",
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/sch311x_wdt.c b/drivers/watchdog/sch311x_wdt.c
index 569eb29..a96c8c4 100644
--- a/drivers/watchdog/sch311x_wdt.c
+++ b/drivers/watchdog/sch311x_wdt.c
@@ -243,6 +243,14 @@ static ssize_t sch311x_wdt_write(struct file *file, const char __user *buf,
 	return count;
 }
 
+static const struct watchdog_info ident = {
+	.options		= WDIOF_KEEPALIVEPING |
+				  WDIOF_SETTIMEOUT |
+				  WDIOF_MAGICCLOSE,
+	.firmware_version	= 1,
+	.identity		= DRV_NAME,
+};
+
 static long sch311x_wdt_ioctl(struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
@@ -250,13 +258,6 @@ static long sch311x_wdt_ioctl(struct file *file, unsigned int cmd,
 	int new_timeout;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
-		.options		= WDIOF_KEEPALIVEPING |
-					  WDIOF_SETTIMEOUT |
-					  WDIOF_MAGICCLOSE,
-		.firmware_version	= 1,
-		.identity		= DRV_NAME,
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/scx200_wdt.c b/drivers/watchdog/scx200_wdt.c
index e67b76c..ddc84ab 100644
--- a/drivers/watchdog/scx200_wdt.c
+++ b/drivers/watchdog/scx200_wdt.c
@@ -157,17 +157,18 @@ static ssize_t scx200_wdt_write(struct file *file, const char __user *data,
 	return 0;
 }
 
+static const struct watchdog_info ident = {
+	.identity = "NatSemi SCx200 Watchdog",
+	.firmware_version = 1,
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
+					WDIOF_MAGICCLOSE,
+};
+
 static long scx200_wdt_ioctl(struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static const struct watchdog_info ident = {
-		.identity = "NatSemi SCx200 Watchdog",
-		.firmware_version = 1,
-		.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
-						WDIOF_MAGICCLOSE,
-	};
 	int new_margin;
 
 	switch (cmd) {
diff --git a/drivers/watchdog/smsc37b787_wdt.c b/drivers/watchdog/smsc37b787_wdt.c
index 8a1f0bc..8f4a094 100644
--- a/drivers/watchdog/smsc37b787_wdt.c
+++ b/drivers/watchdog/smsc37b787_wdt.c
@@ -423,6 +423,14 @@ static ssize_t wb_smsc_wdt_write(struct file *file, const char __user *data,
 
 /* ioctl => control interface */
 
+static const struct watchdog_info ident = {
+	.options = 		WDIOF_KEEPALIVEPING |
+				WDIOF_SETTIMEOUT |
+				WDIOF_MAGICCLOSE,
+	.firmware_version =	0,
+	.identity = 		"SMsC 37B787 Watchdog",
+};
+
 static long wb_smsc_wdt_ioctl(struct file *file,
 					unsigned int cmd, unsigned long arg)
 {
@@ -433,14 +441,6 @@ static long wb_smsc_wdt_ioctl(struct file *file,
 		int __user *i;
 	} uarg;
 
-	static const struct watchdog_info ident = {
-		.options = 		WDIOF_KEEPALIVEPING |
-					WDIOF_SETTIMEOUT |
-					WDIOF_MAGICCLOSE,
-		.firmware_version =	0,
-		.identity = 		"SMsC 37B787 Watchdog",
-	};
-
 	uarg.i = (int __user *)arg;
 
 	switch (cmd) {
diff --git a/drivers/watchdog/softdog.c b/drivers/watchdog/softdog.c
index 833f49f..77cba08 100644
--- a/drivers/watchdog/softdog.c
+++ b/drivers/watchdog/softdog.c
@@ -194,19 +194,20 @@ static ssize_t softdog_write(struct file *file, const char __user *data,
 	return len;
 }
 
+static const struct watchdog_info ident = {
+	.options =		WDIOF_SETTIMEOUT |
+				WDIOF_KEEPALIVEPING |
+				WDIOF_MAGICCLOSE,
+	.firmware_version =	0,
+	.identity =		"Software Watchdog",
+};
+
 static long softdog_ioctl(struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int new_margin;
-	static const struct watchdog_info ident = {
-		.options =		WDIOF_SETTIMEOUT |
-					WDIOF_KEEPALIVEPING |
-					WDIOF_MAGICCLOSE,
-		.firmware_version =	0,
-		.identity =		"Software Watchdog",
-	};
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
diff --git a/drivers/watchdog/stmp3xxx_wdt.c b/drivers/watchdog/stmp3xxx_wdt.c
index 5dd9526..b3421fd 100644
--- a/drivers/watchdog/stmp3xxx_wdt.c
+++ b/drivers/watchdog/stmp3xxx_wdt.c
@@ -94,7 +94,7 @@ static ssize_t stmp3xxx_wdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options	= WDIOF_CARDRESET |
 			  WDIOF_MAGICCLOSE |
 			  WDIOF_SETTIMEOUT |
diff --git a/drivers/watchdog/twl4030_wdt.c b/drivers/watchdog/twl4030_wdt.c
index 8162a40..c455163 100644
--- a/drivers/watchdog/twl4030_wdt.c
+++ b/drivers/watchdog/twl4030_wdt.c
@@ -84,6 +84,12 @@ static ssize_t twl4030_wdt_write_fop(struct file *file,
 	return len;
 }
 
+static const struct watchdog_info twl4030_wd_ident = {
+	.identity = "TWL4030 Watchdog",
+	.options = WDIOF_SETTIMEOUT,
+	.firmware_version = 0,
+};
+
 static long twl4030_wdt_ioctl(struct file *file,
 		unsigned int cmd, unsigned long arg)
 {
@@ -92,12 +98,6 @@ static long twl4030_wdt_ioctl(struct file *file,
 	int new_margin;
 	struct twl4030_wdt *wdt = file->private_data;
 
-	static const struct watchdog_info twl4030_wd_ident = {
-		.identity = "TWL4030 Watchdog",
-		.options = WDIOF_SETTIMEOUT,
-		.firmware_version = 0,
-	};
-
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		return copy_to_user(argp, &twl4030_wd_ident,
diff --git a/drivers/watchdog/txx9wdt.c b/drivers/watchdog/txx9wdt.c
index d635566..364cfee 100644
--- a/drivers/watchdog/txx9wdt.c
+++ b/drivers/watchdog/txx9wdt.c
@@ -127,19 +127,20 @@ static ssize_t txx9wdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
+static const struct watchdog_info ident = {
+	.options =		WDIOF_SETTIMEOUT |
+				WDIOF_KEEPALIVEPING |
+				WDIOF_MAGICCLOSE,
+		.firmware_version =	0,
+	.identity =		"Hardware Watchdog for TXx9",
+};
+
 static long txx9wdt_ioctl(struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int new_timeout;
-	static const struct watchdog_info ident = {
-		.options =		WDIOF_SETTIMEOUT |
-					WDIOF_KEEPALIVEPING |
-					WDIOF_MAGICCLOSE,
-		.firmware_version =	0,
-		.identity =		"Hardware Watchdog for TXx9",
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index f201acc..d9b299c 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -196,17 +196,18 @@ static ssize_t wdt_write(struct file *file, const char __user *buf,
 	return count;
 }
 
+static const struct watchdog_info ident = {
+	.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
+						WDIOF_MAGICCLOSE,
+	.firmware_version = 1,
+	.identity = "W83627HF WDT",
+};
+
 static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int new_timeout;
-	static struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
-							WDIOF_MAGICCLOSE,
-		.firmware_version = 1,
-		.identity = "W83627HF WDT",
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/w83697hf_wdt.c b/drivers/watchdog/w83697hf_wdt.c
index af08972..10c7452 100644
--- a/drivers/watchdog/w83697hf_wdt.c
+++ b/drivers/watchdog/w83697hf_wdt.c
@@ -229,17 +229,18 @@ static ssize_t wdt_write(struct file *file, const char __user *buf,
 	return count;
 }
 
+static const struct watchdog_info ident = {
+	.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
+						| WDIOF_MAGICCLOSE,
+	.firmware_version = 1,
+	.identity = "W83697HF WDT",
+};
+
 static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int new_timeout;
-	static const struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
-							| WDIOF_MAGICCLOSE,
-		.firmware_version = 1,
-		.identity = "W83697HF WDT",
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/w83697ug_wdt.c b/drivers/watchdog/w83697ug_wdt.c
index a6c12de..55244bb 100644
--- a/drivers/watchdog/w83697ug_wdt.c
+++ b/drivers/watchdog/w83697ug_wdt.c
@@ -205,18 +205,19 @@ static ssize_t wdt_write(struct file *file, const char __user *buf,
 	return count;
 }
 
+static const struct watchdog_info ident = {
+	.options =		WDIOF_KEEPALIVEPING |
+				WDIOF_SETTIMEOUT |
+				WDIOF_MAGICCLOSE,
+	.firmware_version =	1,
+	.identity =		"W83697UG WDT",
+};
+
 static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int new_timeout;
-	static const struct watchdog_info ident = {
-		.options =		WDIOF_KEEPALIVEPING |
-					WDIOF_SETTIMEOUT |
-					WDIOF_MAGICCLOSE,
-		.firmware_version =	1,
-		.identity =		"W83697UG WDT",
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/w83877f_wdt.c b/drivers/watchdog/w83877f_wdt.c
index 24587d2..0d242d0 100644
--- a/drivers/watchdog/w83877f_wdt.c
+++ b/drivers/watchdog/w83877f_wdt.c
@@ -242,16 +242,17 @@ static int fop_close(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static const struct watchdog_info ident = {
+	.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
+						| WDIOF_MAGICCLOSE,
+	.firmware_version = 1,
+	.identity = "W83877F",
+};
+
 static long fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static const struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
-							| WDIOF_MAGICCLOSE,
-		.firmware_version = 1,
-		.identity = "W83877F",
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/w83977f_wdt.c b/drivers/watchdog/w83977f_wdt.c
index 0560182..6e6743d 100644
--- a/drivers/watchdog/w83977f_wdt.c
+++ b/drivers/watchdog/w83977f_wdt.c
@@ -371,7 +371,7 @@ static ssize_t wdt_write(struct file *file, const char __user *buf,
  *      according to their available features.
  */
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE | WDIOF_KEEPALIVEPING,
 	.firmware_version =	1,
 	.identity = WATCHDOG_NAME,
diff --git a/drivers/watchdog/wafer5823wdt.c b/drivers/watchdog/wafer5823wdt.c
index 42e940c..4c0368c 100644
--- a/drivers/watchdog/wafer5823wdt.c
+++ b/drivers/watchdog/wafer5823wdt.c
@@ -121,18 +121,19 @@ static ssize_t wafwdt_write(struct file *file, const char __user *buf,
 	return count;
 }
 
+static const struct watchdog_info ident = {
+	.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
+						WDIOF_MAGICCLOSE,
+	.firmware_version = 1,
+	.identity = "Wafer 5823 WDT",
+};
+
 static long wafwdt_ioctl(struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	int new_timeout;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static const struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
-							WDIOF_MAGICCLOSE,
-		.firmware_version = 1,
-		.identity = "Wafer 5823 WDT",
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/wdrtas.c b/drivers/watchdog/wdrtas.c
index 5bfb1f2..4700f41 100644
--- a/drivers/watchdog/wdrtas.c
+++ b/drivers/watchdog/wdrtas.c
@@ -307,16 +307,17 @@ out:
  * wdrtas_ioctl implements the watchdog API ioctls
  */
 
+static const struct watchdog_info wdinfo = {
+	.options = WDRTAS_SUPPORTED_MASK,
+	.firmware_version = 0,
+	.identity = "wdrtas",
+};
+
 static long wdrtas_ioctl(struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	int __user *argp = (void __user *)arg;
 	int i;
-	static struct watchdog_info wdinfo = {
-		.options = WDRTAS_SUPPORTED_MASK,
-		.firmware_version = 0,
-		.identity = "wdrtas",
-	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/wdt.c b/drivers/watchdog/wdt.c
index 3bbefe9..b320fea 100644
--- a/drivers/watchdog/wdt.c
+++ b/drivers/watchdog/wdt.c
@@ -351,6 +351,14 @@ static ssize_t wdt_write(struct file *file, const char __user *buf,
  *	querying capabilities and current status.
  */
 
+static const struct watchdog_info ident = {
+	.options =		WDIOF_SETTIMEOUT|
+				WDIOF_MAGICCLOSE|
+				WDIOF_KEEPALIVEPING,
+	.firmware_version =	1,
+	.identity =		"WDT500/501",
+};
+
 static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
@@ -358,14 +366,6 @@ static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	int new_heartbeat;
 	int status;
 
-	static struct watchdog_info ident = {
-		.options =		WDIOF_SETTIMEOUT|
-					WDIOF_MAGICCLOSE|
-					WDIOF_KEEPALIVEPING,
-		.firmware_version =	1,
-		.identity =		"WDT500/501",
-	};
-
 	/* Add options according to the card we have */
 	ident.options |= (WDIOF_EXTERN1|WDIOF_EXTERN2);
 	if (type == 501) {
diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index f368dd8..ea2eb08 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -404,6 +404,14 @@ static ssize_t wdtpci_write(struct file *file, const char __user *buf,
  *	querying capabilities and current status.
  */
 
+static struct watchdog_info ident = {
+	.options =		WDIOF_SETTIMEOUT|
+				WDIOF_MAGICCLOSE|
+				WDIOF_KEEPALIVEPING,
+	.firmware_version =	1,
+	.identity =		"PCI-WDT500/501",
+};
+
 static long wdtpci_ioctl(struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
@@ -412,14 +420,6 @@ static long wdtpci_ioctl(struct file *file, unsigned int cmd,
 	int new_heartbeat;
 	int status;
 
-	static struct watchdog_info ident = {
-		.options =		WDIOF_SETTIMEOUT|
-					WDIOF_MAGICCLOSE|
-					WDIOF_KEEPALIVEPING,
-		.firmware_version =	1,
-		.identity =		"PCI-WDT500/501",
-	};
-
 	/* Add options according to the card we have */
 	ident.options |= (WDIOF_EXTERN1|WDIOF_EXTERN2);
 	if (type == 501) {
diff --git a/drivers/watchdog/wm831x_wdt.c b/drivers/watchdog/wm831x_wdt.c
index 775bcd8..8c4b2d5 100644
--- a/drivers/watchdog/wm831x_wdt.c
+++ b/drivers/watchdog/wm831x_wdt.c
@@ -213,7 +213,7 @@ static ssize_t wm831x_wdt_write(struct file *file,
 	return count;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
 	.identity = "WM831x Watchdog",
 };
diff --git a/drivers/watchdog/wm8350_wdt.c b/drivers/watchdog/wm8350_wdt.c
index a2d2e8e..89dd7b0 100644
--- a/drivers/watchdog/wm8350_wdt.c
+++ b/drivers/watchdog/wm8350_wdt.c
@@ -177,7 +177,7 @@ static ssize_t wm8350_wdt_write(struct file *file,
 	return count;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
 	.identity = "WM8350 Watchdog",
 };
