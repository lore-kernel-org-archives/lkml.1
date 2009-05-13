Return-Path: <linux-kernel-owner+w=401wt.eu-S1761291AbZEMQRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761291AbZEMQRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 12:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761332AbZEMQQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 12:16:52 -0400
Received: from dev.rtsoft.ru ([213.79.90.226]:54066 "HELO mail.dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761324AbZEMQQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 12:16:50 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 May 2009 12:16:50 EDT
Message-ID: <4A0AF0E1.2000200@ru.mvista.com>
Date: Wed, 13 May 2009 20:10:09 +0400
From: Konstantin Baydarov <kbaidarov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mpm@selenic.com
Subject: [PATCH] Late Re Initialization Of Strong RNG (random.c)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   Hello,
   Recently I've faced following issue:
     When I'm using "jiffies" clocksource ("clock=jiffies" in kernel 
boot line) and NFS rootfs I'm getting following errors before bash login 
prompt appears:
   NFS: server 10.150.41.21 error: fileid changed
   fsid 0:e: expected fileid 0x6cc16f, got 0x9255de
   or
   NFS: readdir reply truncated!

   Errors appears when 2-3 reboots.

   Root Case:
     Turned out that during every boot, when kernel NFS client 
initializes XID field of NFS RPC request by calling random32(), 
random32() returns pseudo random numbers instead of strong random. So 
every boot Kernel NFS client starts to send RPC requests to NFS 
server(Linux NFSD) with the same XID value. After couple board reboots, 
NFS server fills up the requests cache with the pseudorandom XIDs and 
false NFSD cache hits star to occur, and following errors appear:
fsid 0:e: expected fileid 0x6cc16f, got 0x9255de

   My board has an RTC, so values retuned by random32() during NFS XID 
initialization should unique for every boot, because strong 
RNG(drivers/char/random.c) uses getnstimeofday() (getnstimeofday called 
from ktime_get_real) for pool initialization,  see init_std_data(). So 
RNG pools should be initialized with the different "timeofday" values, 
provided by RTC hw.
   It turned out that RTC driver, compilled in kernel, starts later then 
strong rng(drivers/char/random.c) initializes it's pools. So 
getnstimeofday(), called in init_std_data(), returns the same "uptime" 
values instead of the monotonous "timeofday" values(the date in seconds 
or something like that).

   How Solved:
   To fix this I've added late reinitialization of strong RND (into 
late_initcall_sync subsection), to make sure that RNG pools 
initialization occurs after any of board specific RTC driver 
initialization. Also I've added random32 reseed after strong RND 
reinitialization.

   I'm using PPC board, and I can't reproduce this issue with "timebase" 
clocksource, the default clocksource for my board. I believe it's 
because it has more resolution than "timebase". But I believe that there 
is a possibility that errors "NFS: readdir reply truncated!" can appear 
on other board with default clocksource.
   Anyway it's safer to initialize RNG with "timeofday" values instead 
of "uptime" value. IIUC, even with the high resolution clocksource, 
"uptime" value can be the same for 2 sequential boots.

Patch against linux-2.6.29.3 .

Signed-off-by: Konstantin Baydarov <kbaidarov@ru.mvista.com>

Index: linux-2.6.29.3/drivers/char/random.c
===================================================================
--- linux-2.6.29.3.orig/drivers/char/random.c
+++ linux-2.6.29.3/drivers/char/random.c
@@ -947,6 +947,15 @@ static int rand_initialize(void)
  }
  module_init(rand_initialize);

+static int __init rand_late_initialize(void)
+{
+	rand_initialize();
+	random32_reseed();
+
+	return 0;
+}
+late_initcall_sync(rand_late_initialize);
+
  void rand_initialize_irq(int irq)
  {
  	struct timer_rand_state *state;
Index: linux-2.6.29.3/include/linux/random.h
===================================================================
--- linux-2.6.29.3.orig/include/linux/random.h
+++ linux-2.6.29.3/include/linux/random.h
@@ -73,6 +73,7 @@ unsigned long randomize_range(unsigned l

  u32 random32(void);
  void srandom32(u32 seed);
+int random32_reseed(void);

  #endif /* __KERNEL___ */

Index: linux-2.6.29.3/lib/random32.c
===================================================================
--- linux-2.6.29.3.orig/lib/random32.c
+++ linux-2.6.29.3/lib/random32.c
@@ -133,7 +133,7 @@ core_initcall(random32_init);
   *	Generate better values after random number generator
   *	is fully initalized.
   */
-static int __init random32_reseed(void)
+int random32_reseed(void)
  {
  	int i;

@@ -151,4 +151,5 @@ static int __init random32_reseed(void)
  	}
  	return 0;
  }
+EXPORT_SYMBOL(random32_reseed);
  late_initcall(random32_reseed);
