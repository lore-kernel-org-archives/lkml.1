Return-Path: <linux-kernel-owner+w=401wt.eu-S1751730AbZHJSIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730AbZHJSIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 14:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbZHJSIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 14:08:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52199 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbZHJSIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 14:08:20 -0400
Date: Mon, 10 Aug 2009 20:08:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] x86 fix
Message-ID: <20090810180809.GA26073@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Linus Torvalds (1):
      x86: Fix serialization in pit_expect_msb()


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
