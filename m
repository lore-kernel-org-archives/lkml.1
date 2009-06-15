Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbZFOOHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbZFOOHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbZFOOG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:06:59 -0400
Received: from www.tglx.de ([62.245.132.106]:50183 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbZFOOG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:06:58 -0400
Date: Mon, 15 Jun 2009 16:06:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] ntp updates for 2.6.31
Message-ID: <alpine.LFD.2.00.0906151452000.2800@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-for-linus-ntp git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-for-linus-ntp

Thanks,

	tglx

------------------>
John Stultz (2):
      ntp: adjust SHIFT_PLL to improve NTP convergence
      ntp: fix comment typos


 include/linux/timex.h |   42 +++++++++++++++++++++++++++++++-----------
 1 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/include/linux/timex.h b/include/linux/timex.h
index aa3475f..9910e3b 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -170,17 +170,37 @@ struct timex {
 #include <asm/timex.h>
 
 /*
- * SHIFT_KG and SHIFT_KF establish the damping of the PLL and are chosen
- * for a slightly underdamped convergence characteristic. SHIFT_KH
- * establishes the damping of the FLL and is chosen by wisdom and black
- * art.
+ * SHIFT_PLL is used as a dampening factor to define how much we
+ * adjust the frequency correction for a given offset in PLL mode.
+ * It also used in dampening the offset correction, to define how
+ * much of the current value in time_offset we correct for each
+ * second. Changing this value changes the stiffness of the ntp
+ * adjustment code. A lower value makes it more flexible, reducing
+ * NTP convergence time. A higher value makes it stiffer, increasing
+ * convergence time, but making the clock more stable.
  *
- * MAXTC establishes the maximum time constant of the PLL. With the
- * SHIFT_KG and SHIFT_KF values given and a time constant range from
- * zero to MAXTC, the PLL will converge in 15 minutes to 16 hours,
- * respectively.
+ * In David Mills' nanokernel reference implementation SHIFT_PLL is 4.
+ * However this seems to increase convergence time much too long.
+ *
+ * https://lists.ntp.org/pipermail/hackers/2008-January/003487.html
+ *
+ * In the above mailing list discussion, it seems the value of 4
+ * was appropriate for other Unix systems with HZ=100, and that
+ * SHIFT_PLL should be decreased as HZ increases. However, Linux's
+ * clock steering implementation is HZ independent.
+ *
+ * Through experimentation, a SHIFT_PLL value of 2 was found to allow
+ * for fast convergence (very similar to the NTPv3 code used prior to
+ * v2.6.19), with good clock stability.
+ *
+ *
+ * SHIFT_FLL is used as a dampening factor to define how much we
+ * adjust the frequency correction for a given offset in FLL mode.
+ * In David Mills' nanokernel reference implementation SHIFT_FLL is 2.
+ *
+ * MAXTC establishes the maximum time constant of the PLL.
  */
-#define SHIFT_PLL	4	/* PLL frequency factor (shift) */
+#define SHIFT_PLL	2	/* PLL frequency factor (shift) */
 #define SHIFT_FLL	2	/* FLL frequency factor (shift) */
 #define MAXTC		10	/* maximum time constant (shift) */
 
@@ -192,10 +212,10 @@ struct timex {
 #define SHIFT_USEC 16		/* frequency offset scale (shift) */
 #define PPM_SCALE ((s64)NSEC_PER_USEC << (NTP_SCALE_SHIFT - SHIFT_USEC))
 #define PPM_SCALE_INV_SHIFT 19
-#define PPM_SCALE_INV ((1ll << (PPM_SCALE_INV_SHIFT + NTP_SCALE_SHIFT)) / \
+#define PPM_SCALE_INV ((1LL << (PPM_SCALE_INV_SHIFT + NTP_SCALE_SHIFT)) / \
 		       PPM_SCALE + 1)
 
-#define MAXPHASE 500000000l	/* max phase error (ns) */
+#define MAXPHASE 500000000L	/* max phase error (ns) */
 #define MAXFREQ 500000		/* max frequency error (ns/s) */
 #define MAXFREQ_SCALED ((s64)MAXFREQ << NTP_SCALE_SHIFT)
 #define MINSEC 256		/* min interval between updates (s) */
