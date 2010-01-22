Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907Ab0AVPlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab0AVPlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 10:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642Ab0AVPlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 10:41:42 -0500
Received: from relay1.sgi.com ([192.48.179.29]:55832 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029Ab0AVPll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 10:41:41 -0500
Date: Fri, 22 Jan 2010 09:41:40 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jack Steiner <steiner@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de
Subject: Re: [PATCH] x86, UV: Fix RTC latency bug by reading replicated
	cachelines
Message-ID: <20100122154140.GB4975@sgi.com>
References: <20100112210904.GA24546@sgi.com> <20100113092433.GB6739@elte.hu> <20100114183422.GA12152@sgi.com> <20100119144137.GB22276@sgi.com> <20100120081020.GG20621@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100120081020.GG20621@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For SGI UV node controllers (HUB) rev 2.0 or greater, use replicated
cachelines to read the RTC timer.  This optimization allows faster
simulataneous reads from a given socket.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

 arch/x86/kernel/uv_time.c |   13 ++++++++++++-
 drivers/char/uv_mmtimer.c |   18 +++++++++++-------
 2 files changed, 23 insertions(+), 8 deletions(-)

Index: linux/arch/x86/kernel/uv_time.c
===================================================================
--- linux.orig/arch/x86/kernel/uv_time.c	2010-01-22 08:09:37.000000000 -0600
+++ linux/arch/x86/kernel/uv_time.c	2010-01-22 09:14:45.000000000 -0600
@@ -282,10 +282,21 @@ static int uv_rtc_unset_timer(int cpu, i
 
 /*
  * Read the RTC.
+ *
+ * Starting with HUB rev 2.0, the UV RTC register is replicated across all
+ * cachelines of it's own page.  This allows faster simultaneous reads
+ * from a given socket.
  */
 static cycle_t uv_read_rtc(struct clocksource *cs)
 {
-	return (cycle_t)uv_read_local_mmr(UVH_RTC);
+	unsigned long offset;
+
+	if (uv_get_min_hub_revision_id() == 1)
+		offset = 0;
+	else
+		offset = (uv_blade_processor_id() * L1_CACHE_BYTES) % PAGE_SIZE;
+
+	return (cycle_t)uv_read_local_mmr(UVH_RTC | offset);
 }
 
 /*
Index: linux/drivers/char/uv_mmtimer.c
===================================================================
--- linux.orig/drivers/char/uv_mmtimer.c	2010-01-22 08:09:38.000000000 -0600
+++ linux/drivers/char/uv_mmtimer.c	2010-01-22 09:23:34.000000000 -0600
@@ -89,13 +89,17 @@ static long uv_mmtimer_ioctl(struct file
 	switch (cmd) {
 	case MMTIMER_GETOFFSET:	/* offset of the counter */
 		/*
-		 * UV RTC register is on its own page
+		 * Starting with HUB rev 2.0, the UV RTC register is
+		 * replicated across all cachelines of it's own page.
+		 * This allows faster simultaneous reads from a given socket.
+		 *
+		 * The offset returned is in 64 bit units.
 		 */
-		if (PAGE_SIZE <= (1 << 16))
-			ret = ((UV_LOCAL_MMR_BASE | UVH_RTC) & (PAGE_SIZE-1))
-				/ 8;
+		if (uv_get_min_hub_revision_id() == 1)
+			ret = 0;
 		else
-			ret = -ENOSYS;
+			ret = ((uv_blade_processor_id() * L1_CACHE_BYTES) %
+					PAGE_SIZE) / 8;
 		break;
 
 	case MMTIMER_GETRES: /* resolution of the clock in 10^-15 s */
@@ -115,8 +119,8 @@ static long uv_mmtimer_ioctl(struct file
 		ret = hweight64(UVH_RTC_REAL_TIME_CLOCK_MASK);
 		break;
 
-	case MMTIMER_MMAPAVAIL: /* can we mmap the clock into userspace? */
-		ret = (PAGE_SIZE <= (1 << 16)) ? 1 : 0;
+	case MMTIMER_MMAPAVAIL:
+		ret = 1;
 		break;
 
 	case MMTIMER_GETCOUNTER:
