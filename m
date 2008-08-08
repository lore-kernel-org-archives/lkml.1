Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbYHHPk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbYHHPk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 11:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbYHHPks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 11:40:48 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:33394 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbYHHPkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 11:40:47 -0400
Date: Fri, 8 Aug 2008 18:39:11 +0300
From: Adrian Bunk <bunk@stusta.de>
To: Alan Cox <alan@redhat.com>, Wim Van Sebroeck <wim@iguana.be>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] fix watchdog/shwdt.c compilation
Message-ID: <20080808153911.GC14495@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile errors caused by
commit 70b814ec1a484279a51bf9f7193551b996627247
([WATCHDOG 45/57] shwdt: coding style, cleanup, switch to unlocked_io):

<--  snip  -->

...
  CC      drivers/watchdog/shwdt.o
shwdt.c:64: error: 'WTCSR_CKS_4096' undeclared here (not in a function)
shwdt.c: In function 'sh_wdt_start':
shwdt.c:92: error: 'wdt_lock' undeclared (first use in this function)
shwdt.c:92: error: (Each undeclared identifier is reported only once
shwdt.c:92: error: for each function it appears in.)
shwdt.c:97: error: implicit declaration of function 'sh_wdt_read_csr'
shwdt.c:98: error: 'WTCSR_WT' undeclared (first use in this function)
shwdt.c:99: error: implicit declaration of function 'sh_wdt_write_csr'
shwdt.c:101: error: implicit declaration of function 'sh_wdt_write_cnt'
shwdt.c:112: error: 'WTCSR_TME' undeclared (first use in this function)
shwdt.c:113: error: 'WTCSR_RSTS' undeclared (first use in this function)
shwdt.c: In function 'sh_wdt_stop':
shwdt.c:142: error: 'wdt_lock' undeclared (first use in this function)
shwdt.c:147: error: 'WTCSR_TME' undeclared (first use in this function)
shwdt.c: In function 'sh_wdt_keepalive':
shwdt.c:160: error: 'wdt_lock' undeclared (first use in this function)
shwdt.c: In function 'sh_wdt_set_heartbeat':
shwdt.c:176: error: 'wdt_lock' undeclared (first use in this function)
shwdt.c: In function 'sh_wdt_ping':
shwdt.c:192: error: 'wdt_lock' undeclared (first use in this function)
shwdt.c:197: error: 'WTCSR_IOVF' undeclared (first use in this function)
shwdt.c: At top level:
shwdt.c:417: error: conflicting type qualifiers for 'sh_wdt_info'
shwdt.c:71: error: previous declaration of 'sh_wdt_info' was here
make[3]: *** [drivers/watchdog/shwdt.o] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/watchdog/shwdt.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

ea098979faf0b600824510a18675e47cdab23aca 
diff --git a/drivers/watchdog/shwdt.c b/drivers/watchdog/shwdt.c
index 824125a..9c81aff 100644
--- a/drivers/watchdog/shwdt.c
+++ b/drivers/watchdog/shwdt.c
@@ -31,6 +31,7 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 #include <linux/watchdog.h>
+#include <asm/watchdog.h>
 
 #define PFX "shwdt: "
 
@@ -68,7 +69,7 @@ static int clock_division_ratio = WTCSR_CKS_4096;
 static void sh_wdt_ping(unsigned long data);
 
 static unsigned long shwdt_is_open;
-static struct watchdog_info sh_wdt_info;
+static const struct watchdog_info sh_wdt_info;
 static char shwdt_expect_close;
 static DEFINE_TIMER(timer, sh_wdt_ping, 0, 0);
 static unsigned long next_heartbeat;
@@ -89,7 +90,7 @@ static void sh_wdt_start(void)
 	__u8 csr;
 	unsigned long flags;
 
-	spin_lock_irqsave(&wdt_lock, flags);
+	spin_lock_irqsave(&shwdt_lock, flags);
 
 	next_heartbeat = jiffies + (heartbeat * HZ);
 	mod_timer(&timer, next_ping_period(clock_division_ratio));
@@ -127,7 +128,7 @@ static void sh_wdt_start(void)
 	csr &= ~RSTCSR_RSTS;
 	sh_wdt_write_rstcsr(csr);
 #endif
-	spin_unlock_irqrestore(&wdt_lock, flags);
+	spin_unlock_irqrestore(&shwdt_lock, flags);
 }
 
 /**
@@ -139,14 +140,14 @@ static void sh_wdt_stop(void)
 	__u8 csr;
 	unsigned long flags;
 
-	spin_lock_irqsave(&wdt_lock, flags);
+	spin_lock_irqsave(&shwdt_lock, flags);
 
 	del_timer(&timer);
 
 	csr = sh_wdt_read_csr();
 	csr &= ~WTCSR_TME;
 	sh_wdt_write_csr(csr);
-	spin_unlock_irqrestore(&wdt_lock, flags);
+	spin_unlock_irqrestore(&shwdt_lock, flags);
 }
 
 /**
@@ -157,9 +158,9 @@ static inline void sh_wdt_keepalive(void)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&wdt_lock, flags);
+	spin_lock_irqsave(&shwdt_lock, flags);
 	next_heartbeat = jiffies + (heartbeat * HZ);
-	spin_unlock_irqrestore(&wdt_lock, flags);
+	spin_unlock_irqrestore(&shwdt_lock, flags);
 }
 
 /**
@@ -173,9 +174,9 @@ static int sh_wdt_set_heartbeat(int t)
 	if (unlikely(t < 1 || t > 3600)) /* arbitrary upper limit */
 		return -EINVAL;
 
-	spin_lock_irqsave(&wdt_lock, flags);
+	spin_lock_irqsave(&shwdt_lock, flags);
 	heartbeat = t;
-	spin_unlock_irqrestore(&wdt_lock, flags);
+	spin_unlock_irqrestore(&shwdt_lock, flags);
 	return 0;
 }
 
@@ -189,7 +190,7 @@ static void sh_wdt_ping(unsigned long data)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&wdt_lock, flags);
+	spin_lock_irqsave(&shwdt_lock, flags);
 	if (time_before(jiffies, next_heartbeat)) {
 		__u8 csr;
 
@@ -203,7 +204,7 @@ static void sh_wdt_ping(unsigned long data)
 	} else
 		printk(KERN_WARNING PFX "Heartbeat lost! Will not ping "
 		       "the watchdog\n");
-	spin_unlock_irqrestore(&wdt_lock, flags);
+	spin_unlock_irqrestore(&shwdt_lock, flags);
 }
 
 /**

