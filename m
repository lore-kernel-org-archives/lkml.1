Return-Path: <linux-kernel-owner+w=401wt.eu-S1751814AbZGaT50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbZGaT50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 15:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbZGaT5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 15:57:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37475 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbZGaT5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 15:57:24 -0400
Date: Fri, 31 Jul 2009 21:57:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       John Stultz <johnstul@us.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Wei Chong Tan <wei.chong.tan@intel.com>
Subject: Re: [GIT PULL] Additional x86 fixes for 2.6.31-rc5
Message-ID: <20090731195705.GA12270@elte.hu>
References: <200907311813.n6VIDe9S023442@voreg.hos.anvin.org> <alpine.LFD.2.01.0907311218080.3161@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0907311218080.3161@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 31 Jul 2009, H. Peter Anvin wrote:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus
> > 
> > Tan, Wei Chong (1):
> >       x86: SMI workaround for pit_expect_msb
> 
> I really think that last one (commit fb34a8ee86) is 
> incorrect.
> 
> We do _not_ want to do that SMI workaround in the loop, 
> and the logic of that patch is broken anyway.
> 
> If an SMI kicks in, then it's true that tscp will be off, 
> but that's what the error term is there for. If the error 
> term is sufficiently small, then we don't care.
> 
> Sure, we might want the error term to be even smaller, but 
> in no way does it actually invalidate any of the logic - 
> the 'tsc' reading is just a guess anyway. Also, I think 
> that the real issue isn't even an SMI - but the fact that 
> in the very last iteration of the loop, there's no 
> serializing instruction _after_ the last 'rdtsc'. So even 
> in the absense of SMI's, we do have a situation where the 
> cycle counter was read without proper serialization.
> 
> So I think the patch does fix something, I just think it's 
> done the wrong way.
> 
> The last check shouldn't be done the way that commit does 
> it. It should be done outside the outer loop, since 
> _inside_ the outer loop, we'll be testing that the PIT has 
> the right MSB value has the right value in the next 
> iteration.
> 
> So only the _last_ iteration is special, because that's 
> the one that will not check the PIT MSB value any more, 
> and because the final 'get_cycles()' isn't serialized.
> 
> In other words:
>  - I'd like to move the PIT MSB check to after the last 
>  iteration, rather
>    than in every iteration
> 
>  - I think we should comment on the fact that it's also a 
>  serializing
>    instruction and so 'fences in' the TSC read.
> 
> Here's a suggested replacement - BUT NOTE THAT IT'S 
> ENTIRELY UNTESTED!
> 
> (Ok, so the patch is bigger than it strictly needs to be - 
> I hate repeating code, so I made that 'read PIT counter 
> twice and compare MSB' be a new helper routine)
> 
> Hmm? What do you guys think?
> 
> 		Linus
> 
> ---
>  arch/x86/kernel/tsc.c |   29 ++++++++++++++++++++++-------
>  1 files changed, 22 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 6e1a368..71f4368 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -275,15 +275,20 @@ static unsigned long pit_calibrate_tsc(u32 latch, unsigned long ms, int loopmin)
>   * use the TSC value at the transitions to calculate a pretty
>   * good value for the TSC frequencty.
>   */
> +static inline int pit_verify_msb(unsigned char val)
> +{
> +	/* Ignore LSB */
> +	inb(0x42);
> +	return inb(0x42) == val;
> +}
> +
>  static inline int pit_expect_msb(unsigned char val, u64 *tscp, unsigned long *deltap)
>  {
>  	int count;
>  	u64 tsc = 0;
>  
>  	for (count = 0; count < 50000; count++) {
> -		/* Ignore LSB */
> -		inb(0x42);
> -		if (inb(0x42) != val)
> +		if (!pit_verify_msb(val))
>  			break;
>  		tsc = get_cycles();
>  	}
> @@ -336,8 +341,7 @@ static unsigned long quick_pit_calibrate(void)
>  	 * to do that is to just read back the 16-bit counter
>  	 * once from the PIT.
>  	 */
> -	inb(0x42);
> -	inb(0x42);
> +	pit_verify_msb(0);
>  
>  	if (pit_expect_msb(0xff, &tsc, &d1)) {
>  		for (i = 1; i <= MAX_QUICK_PIT_ITERATIONS; i++) {
> @@ -348,8 +352,19 @@ static unsigned long quick_pit_calibrate(void)
>  			 * Iterate until the error is less than 500 ppm
>  			 */
>  			delta -= tsc;
> -			if (d1+d2 < delta >> 11)
> -				goto success;
> +			if (d1+d2 >= delta >> 11)
> +				continue;
> +
> +			/*
> +			 * Check the PIT one more time to verify that
> +			 * all TSC reads were stable wrt the PIT.
> +			 *
> +			 * This also guarantees serialization of the
> +			 * last cycle read ('d2') in pit_expect_msb.
> +			 */
> +			if (!pit_verify_msb(0xfe - i))
> +				break;
> +			goto success;

Oh, this reminds me of a patch i saw from John(?) a couple 
of months ago that added a magic final pit_verify_msb() 
call, which solved PIT calibration instabilities.

(Or maybe i did that hack when i tried to write an 
auto-error-boundary calibrator?)

I dont think we committed it because it was a 'black magic' 
hack as per observation and nobody realized the side-effect 
of the TSC synchronization which you mention above.

My memories are sketchy but i think the symptom was one 
failed PIT loop every 10 bootups, and it was solved by a 
patch very similar to yours.

So with a proper changlog and testing i'd very much go for 
this on those grounds ago - and if it also solves the 
problem observed by Wei Chong Tan that would be perfect.

[ Unfortunately Thomas (who too saw some PIT calibration
  weirdnesses IIRC) wont be back for some time. ]

	Ingo
