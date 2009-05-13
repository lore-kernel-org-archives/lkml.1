Return-Path: <linux-kernel-owner+w=401wt.eu-S1761415AbZEMT04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761415AbZEMT04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 15:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759162AbZEMT0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 15:26:47 -0400
Received: from waste.org ([66.93.16.53]:54479 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452AbZEMT0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 15:26:47 -0400
Date: Wed, 13 May 2009 14:26:15 -0500
From: Matt Mackall <mpm@selenic.com>
To: Konstantin Baydarov <kbaidarov@ru.mvista.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Late Re Initialization Of Strong RNG (random.c)
Message-ID: <20090513192614.GI31071@waste.org>
References: <4A0AF0E1.2000200@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0AF0E1.2000200@ru.mvista.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 08:10:09PM +0400, Konstantin Baydarov wrote:
>   Hello,
>   Recently I've faced following issue:
>     When I'm using "jiffies" clocksource ("clock=jiffies" in kernel 
> boot line) and NFS rootfs I'm getting following errors before bash login 
> prompt appears:
>   NFS: server 10.150.41.21 error: fileid changed
>   fsid 0:e: expected fileid 0x6cc16f, got 0x9255de
>   or
>   NFS: readdir reply truncated!
> 
>   Errors appears when 2-3 reboots.
> 
>   Root Case:
>     Turned out that during every boot, when kernel NFS client 
> initializes XID field of NFS RPC request by calling random32(), 
> random32() returns pseudo random numbers instead of strong random. So 
> every boot Kernel NFS client starts to send RPC requests to NFS 
> server(Linux NFSD) with the same XID value. After couple board reboots, 
> NFS server fills up the requests cache with the pseudorandom XIDs and 
> false NFSD cache hits star to occur, and following errors appear:
> fsid 0:e: expected fileid 0x6cc16f, got 0x9255de
> 
>   My board has an RTC, so values retuned by random32() during NFS XID 
> initialization should unique for every boot, because strong 
> RNG(drivers/char/random.c) uses getnstimeofday() (getnstimeofday called 
> from ktime_get_real) for pool initialization,  see init_std_data(). So 
> RNG pools should be initialized with the different "timeofday" values, 
> provided by RTC hw.
>   It turned out that RTC driver, compilled in kernel, starts later then 
> strong rng(drivers/char/random.c) initializes it's pools. So 
> getnstimeofday(), called in init_std_data(), returns the same "uptime" 
> values instead of the monotonous "timeofday" values(the date in seconds 
> or something like that).
> 
>   How Solved:
>   To fix this I've added late reinitialization of strong RND (into 
> late_initcall_sync subsection), to make sure that RNG pools 
> initialization occurs after any of board specific RTC driver 
> initialization. Also I've added random32 reseed after strong RND 
> reinitialization.
> 
>   I'm using PPC board, and I can't reproduce this issue with "timebase" 
> clocksource, the default clocksource for my board. I believe it's 
> because it has more resolution than "timebase". But I believe that there 
> is a possibility that errors "NFS: readdir reply truncated!" can appear 
> on other board with default clocksource.
>   Anyway it's safer to initialize RNG with "timeofday" values instead 
> of "uptime" value. IIUC, even with the high resolution clocksource, 
> "uptime" value can be the same for 2 sequential boots.

This is a bit convoluted. I'm working on an alternate approach that
looks like the below. This lets every device provide input at boot,
without any particular special points at which the RNG isn't 'ready'.
Not sure how best to trigger reseeds of the (horrid, insecure) random32
interface though. Perhaps your late initcall for random32 is sufficient.

random: introduce add_system_randomness

diff -r f0e58585e7d3 -r 72baa688f705 drivers/char/random.c
--- a/drivers/char/random.c	     Fri Apr 17 20:28:21 2009 -0500
+++ b/drivers/char/random.c	     Fri Apr 17 20:47:53 2009 -0500
@@ -670,6 +670,23 @@
   preempt_enable();
 }
 
+/*
+ * add_system_randomness - add system and boot-sensitive data
+ *
+ * @buf: data source
+ * @bytes: size of data
+ *
+ * This function is used to help give our RNG an early boot seed that
+ * is unique from system to system and boot to boot. Sources include
+ * MAC addresses, DMI info, serial numbers, boot wall times, and the
+ * like.
+ */
+void add_system_randomness(const void *buf, int bytes)
+{
+	mix_pool_bytes(&input_pool, buf, bytes);
+}
+EXPORT_SYMBOL(add_system_randomness);
+
 void add_input_randomness(unsigned int type, unsigned int code,
					       unsigned int value)
 {
diff -r f0e58585e7d3 -r 72baa688f705 include/linux/random.h
--- a/include/linux/random.h	     Fri Apr 17 20:28:21 2009 -0500
+++ b/include/linux/random.h	     Fri Apr 17 20:47:53 2009 -0500
@@ -46,6 +46,8 @@
 
 extern void rand_initialize_irq(int irq);
 
+void add_system_randomness(const void *buf, int bytes)
+
 extern void add_input_randomness(unsigned int type, unsigned int
 code,
				 unsigned int value);
 extern void add_interrupt_randomness(int irq);


-- 
Mathematics is the supreme nostalgia of our time.
