Return-Path: <linux-kernel-owner+w=401wt.eu-S1753057AbZHJJHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbZHJJHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 05:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbZHJJHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 05:07:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:50094 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbZHJJHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 05:07:20 -0400
Date: Mon, 10 Aug 2009 09:06:40 GMT
From: tip-bot for Linus Torvalds <torvalds@linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, wei.chong.tan@intel.com, hpa@zytor.com,
       mingo@redhat.com, torvalds@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, wei.chong.tan@intel.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <B28277FD4E0F9247A3D55704C440A140D5D683F3@pgsmsx504.gar.corp.intel.com>
References: <B28277FD4E0F9247A3D55704C440A140D5D683F3@pgsmsx504.gar.corp.intel.com>
Subject: [tip:x86/urgent] x86: Fix serialization in pit_expect_msb()
Message-ID: <tip-672f3c902d13ba6d4a8bc4bb92fb187ccd906908@git.kernel.org>
Git-Commit-ID: 672f3c902d13ba6d4a8bc4bb92fb187ccd906908
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 10 Aug 2009 09:06:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  672f3c902d13ba6d4a8bc4bb92fb187ccd906908
Gitweb:     http://git.kernel.org/tip/672f3c902d13ba6d4a8bc4bb92fb187ccd906908
Author:     Linus Torvalds <torvalds@linux-foundation.org>
AuthorDate: Fri, 31 Jul 2009 12:45:41 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 10 Aug 2009 11:03:51 +0200

x86: Fix serialization in pit_expect_msb()

Wei Chong Tan reported a fast-PIT-calibration corner-case:

| pit_expect_msb() is vulnerable to SMI disturbance corner case
| in some platforms which causes /proc/cpuinfo to show wrong
| CPU MHz value when quick_pit_calibrate() jumps to success
| section.

I think that the real issue isn't even an SMI - but the fact
that in the very last iteration of the loop, there's no
serializing instruction _after_ the last 'rdtsc'. So even in
the absense of SMI's, we do have a situation where the cycle
counter was read without proper serialization.

The last check should be done outside the outer loop, since
_inside_ the outer loop, we'll be testing that the PIT has
the right MSB value has the right value in the next iteration.

So only the _last_ iteration is special, because that's the one
that will not check the PIT MSB value any more, and because the
final 'get_cycles()' isn't serialized.

In other words:

 - I'd like to move the PIT MSB check to after the last
   iteration, rather than in every iteration

 - I think we should comment on the fact that it's also a
   serializing instruction and so 'fences in' the TSC read.

Here's a suggested replacement.

Reported-by: "Tan, Wei Chong" <wei.chong.tan@intel.com>
Tested-by: "Tan, Wei Chong" <wei.chong.tan@intel.com>
LKML-Reference: <B28277FD4E0F9247A3D55704C440A140D5D683F3@pgsmsx504.gar.corp.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/tsc.c |   29 ++++++++++++++++++++++-------
 1 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 6e1a368..71f4368 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -275,15 +275,20 @@ static unsigned long pit_calibrate_tsc(u32 latch, unsigned long ms, int loopmin)
  * use the TSC value at the transitions to calculate a pretty
  * good value for the TSC frequencty.
  */
+static inline int pit_verify_msb(unsigned char val)
+{
+	/* Ignore LSB */
+	inb(0x42);
+	return inb(0x42) == val;
+}
+
 static inline int pit_expect_msb(unsigned char val, u64 *tscp, unsigned long *deltap)
 {
 	int count;
 	u64 tsc = 0;
 
 	for (count = 0; count < 50000; count++) {
-		/* Ignore LSB */
-		inb(0x42);
-		if (inb(0x42) != val)
+		if (!pit_verify_msb(val))
 			break;
 		tsc = get_cycles();
 	}
@@ -336,8 +341,7 @@ static unsigned long quick_pit_calibrate(void)
 	 * to do that is to just read back the 16-bit counter
 	 * once from the PIT.
 	 */
-	inb(0x42);
-	inb(0x42);
+	pit_verify_msb(0);
 
 	if (pit_expect_msb(0xff, &tsc, &d1)) {
 		for (i = 1; i <= MAX_QUICK_PIT_ITERATIONS; i++) {
@@ -348,8 +352,19 @@ static unsigned long quick_pit_calibrate(void)
 			 * Iterate until the error is less than 500 ppm
 			 */
 			delta -= tsc;
-			if (d1+d2 < delta >> 11)
-				goto success;
+			if (d1+d2 >= delta >> 11)
+				continue;
+
+			/*
+			 * Check the PIT one more time to verify that
+			 * all TSC reads were stable wrt the PIT.
+			 *
+			 * This also guarantees serialization of the
+			 * last cycle read ('d2') in pit_expect_msb.
+			 */
+			if (!pit_verify_msb(0xfe - i))
+				break;
+			goto success;
 		}
 	}
 	printk("Fast TSC calibration failed\n");
