Return-Path: <linux-kernel-owner+w=401wt.eu-S1752390AbZGaMhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbZGaMhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 08:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbZGaMhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 08:37:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41883 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbZGaMhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 08:37:22 -0400
Date: Fri, 31 Jul 2009 14:37:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] timers fixes for 2.6.31
Message-ID: <20090731123711.GA5421@elte.hu>
References: <alpine.LFD.2.00.0907302158180.2936@localhost.localdomain> <alpine.LFD.2.01.0907301648540.3161@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0907301648540.3161@localhost.localdomain>
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

> 
> 
> On Thu, 30 Jul 2009, Thomas Gleixner wrote:
> > 
> > Please pull the latest timers-fixes-for-linus git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus
> > 
> > Thanks,
> > 
> > 	tglx
> > 
> > ------------------>
> > Magnus Damm (1):
> >       clocksource: save mult_orig in clocksource_disable()
> > 
> >  include/linux/clocksource.h |   12 +++++++++++-
> >  1 files changed, 11 insertions(+), 1 deletions(-)
> 
> Hmm. You seem to have forgotten to push this out. I realize you're 
> off to vacation, do you have time to check that?

I've pushed out the fix. I did two minor (non-functional) edits to 
the commit: fixed the comment style to match that of the rest of 
clocksource.h and improved the commit log a tiny bit. Find the 
updated pull request below.

[ Markus, John: the fix looks right for .31 but i think there's two
  small structural problems with this code, which might have
  contributed to the bug to happen to begin with:

  Firstly, ->mult_orig is a slight misnomer - if it was named 
  properly we wouldnt even need the comments to explain how to use 
  and update it. It's the unadjusted multiplicator while _orig 
  patterns in the kernel generally suggest some sort of save/restore 
  pattern (which this is not).

  I'd suggest to rename it to ->mult_unadjusted, ->mult_raw or 
  ->mult_static instead. This field has not gotten into many 
  clocksource drivers yet so it's easy to do. For .32 obviously.

  Secondly, the broader design question is: why are clocksource
  drivers mucking around with NTP details? Whether NTP is running 
  should be a transparent detail to drivers and if such details are 
  visible in low level driver (which they are in 
  arch/arm/plat-omap/common.c et al) that's sign of uncleanliness. 
  Mind improving that? (for .32 too)

  Also, a commit message quality nit: the commit description lacks 
  details about precisely what bug was hit in practice. While this 
  fix is eligible even without that info, it's not good to omit it. 
]

Linus, please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

 Thanks,

	Ingo

------------------>
Magnus Damm (1):
      clocksource: Save mult_orig in clocksource_disable()


 include/linux/clocksource.h |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index c56457c..1219be4 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -293,7 +293,12 @@ static inline int clocksource_enable(struct clocksource *cs)
 	if (cs->enable)
 		ret = cs->enable(cs);
 
-	/* save mult_orig on enable */
+	/*
+	 * The frequency may have changed while the clocksource
+	 * was disabled. If so the code in ->enable() must update
+	 * the mult value to reflect the new frequency. Make sure
+	 * mult_orig follows this change.
+	 */
 	cs->mult_orig = cs->mult;
 
 	return ret;
@@ -309,6 +314,13 @@ static inline int clocksource_enable(struct clocksource *cs)
  */
 static inline void clocksource_disable(struct clocksource *cs)
 {
+	/*
+	 * Save mult_orig in mult so clocksource_enable() can
+	 * restore the value regardless if ->enable() updates
+	 * the value of mult or not.
+	 */
+	cs->mult = cs->mult_orig;
+
 	if (cs->disable)
 		cs->disable(cs);
 }
