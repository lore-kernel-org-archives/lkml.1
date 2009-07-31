Return-Path: <linux-kernel-owner+w=401wt.eu-S1751655AbZGaTqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbZGaTqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 15:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbZGaTqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 15:46:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751436AbZGaTqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 15:46:05 -0400
Date: Fri, 31 Jul 2009 12:45:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Wei Chong Tan <wei.chong.tan@intel.com>
Subject: Re: [GIT PULL] Additional x86 fixes for 2.6.31-rc5
In-Reply-To: <200907311813.n6VIDe9S023442@voreg.hos.anvin.org>
Message-ID: <alpine.LFD.2.01.0907311218080.3161@localhost.localdomain>
References: <200907311813.n6VIDe9S023442@voreg.hos.anvin.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 31 Jul 2009, H. Peter Anvin wrote:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus
> 
> Tan, Wei Chong (1):
>       x86: SMI workaround for pit_expect_msb

I really think that last one (commit fb34a8ee86) is incorrect.

We do _not_ want to do that SMI workaround in the loop, and the logic of 
that patch is broken anyway.

If an SMI kicks in, then it's true that tscp will be off, but that's what 
the error term is there for. If the error term is sufficiently small, then 
we don't care.

Sure, we might want the error term to be even smaller, but in no way does 
it actually invalidate any of the logic - the 'tsc' reading is just a 
guess anyway.

Also, I think that the real issue isn't even an SMI - but the fact that in 
the very last iteration of the loop, there's no serializing instruction 
_after_ the last 'rdtsc'. So even in the absense of SMI's, we do have a 
situation where the cycle counter was read without proper serialization.

So I think the patch does fix something, I just think it's done the wrong 
way.

The last check shouldn't be done the way that commit does it. It should be 
done outside the outer loop, since _inside_ the outer loop, we'll be 
testing that the PIT has the right MSB value has the right value in the 
next iteration. 

So only the _last_ iteration is special, because that's the one that 
will not check the PIT MSB value any more, and because the final 
'get_cycles()' isn't serialized.

In other words: 
 - I'd like to move the PIT MSB check to after the last iteration, rather 
   than in every iteration

 - I think we should comment on the fact that it's also a serializing 
   instruction and so 'fences in' the TSC read.

Here's a suggested replacement - BUT NOTE THAT IT'S ENTIRELY UNTESTED!

(Ok, so the patch is bigger than it strictly needs to be - I hate 
repeating code, so I made that 'read PIT counter twice and compare MSB' be 
a new helper routine)

Hmm? What do you guys think?

		Linus

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
