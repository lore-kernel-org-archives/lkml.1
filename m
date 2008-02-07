Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630AbYBGGuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbYBGGuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 01:50:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbYBGGty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 01:49:54 -0500
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:41711 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbYBGGtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:49:53 -0500
Date: Thu, 7 Feb 2008 17:47:50 +1100
To: Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       LinuxPPC-dev <linuxppc-dev@ozlabs.org>
Subject: [PATCH] Fix powerpc vdso clock_getres().
Message-ID: <20080207064750.GG6887@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since implementing highres timers on powerpc the clock_getres syscall
has reported different resolutions due to the vdso using the a low res
value.  In the patch d7f71674ad7c3c4467e48f6ab9e85516dae2720 
([POWERPC] Use a sensible default for clock_getres() in the VDSO), the
powerpc vdso was updated to use the correct value.

This fix doesn't work on older compilers.  Below is a fix for powerpc,
that introduces a new (generic) #define MONOTONIC_RES_NSEC which is
equal to the 64 value stored in KTIME_MONOTONIC_RES.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>

---

Thomas, If this is okay with you can it go through Paul's tree?

 arch/powerpc/kernel/asm-offsets.c |    2 +-
 include/linux/hrtimer.h           |    5 ++++-
 include/linux/ktime.h             |    3 ++-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index e6e4928..4b749c4 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -313,7 +313,7 @@ int main(void)
 	DEFINE(CLOCK_REALTIME, CLOCK_REALTIME);
 	DEFINE(CLOCK_MONOTONIC, CLOCK_MONOTONIC);
 	DEFINE(NSEC_PER_SEC, NSEC_PER_SEC);
-	DEFINE(CLOCK_REALTIME_RES, (KTIME_MONOTONIC_RES).tv64);
+	DEFINE(CLOCK_REALTIME_RES, MONOTONIC_RES_NSEC);
 
 #ifdef CONFIG_BUG
 	DEFINE(BUG_ENTRY_SIZE, sizeof(struct bug_entry));
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 7a9398e..8dba081 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -223,11 +223,14 @@ static inline ktime_t hrtimer_cb_get_time(struct hrtimer *timer)
  * idea of the (in)accuracy of timers. Timer values are rounded up to
  * this resolution values.
  */
-# define KTIME_HIGH_RES		(ktime_t) { .tv64 = 1 }
+# define HIGH_RES_NSEC		1
+# define KTIME_HIGH_RES		(ktime_t) { .tv64 = HIGH_RES_NSEC }
+# define MONOTONIC_RES_NSEC	HIGH_RES_NSEC
 # define KTIME_MONOTONIC_RES	KTIME_HIGH_RES
 
 #else
 
+# define MONOTONIC_RES_NSEC	LOW_RES_NSEC
 # define KTIME_MONOTONIC_RES	KTIME_LOW_RES
 
 /*
diff --git a/include/linux/ktime.h b/include/linux/ktime.h
index a6ddec1..36c542b 100644
--- a/include/linux/ktime.h
+++ b/include/linux/ktime.h
@@ -316,7 +316,8 @@ static inline ktime_t ktime_sub_us(const ktime_t kt, const u64 usec)
  * idea of the (in)accuracy of timers. Timer values are rounded up to
  * this resolution values.
  */
-#define KTIME_LOW_RES		(ktime_t){ .tv64 = TICK_NSEC }
+#define LOW_RES_NSEC		TICK_NSEC
+#define KTIME_LOW_RES		(ktime_t){ .tv64 = LOW_RES_NSEC }
 
 /* Get the monotonic time in timespec format: */
 extern void ktime_get_ts(struct timespec *ts);


Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!

