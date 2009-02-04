Return-Path: <linux-kernel-owner+w=401wt.eu-S1764300AbZBDTIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764300AbZBDTIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:08:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761249AbZBDS4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:56:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34652 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761242AbZBDS4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:56:44 -0500
Date: Wed, 4 Feb 2009 19:56:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Norbert Preining <preining@logic.at>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: Re: 2.6.29-rc3-git6: Reported regressions from 2.6.28
Message-ID: <20090204185606.GA12991@elte.hu>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <alpine.LFD.2.00.0902040759420.3247@localhost.localdomain> <20090204181109.GR21085@gamma.logic.tuwien.ac.at> <alpine.LFD.2.00.0902041012440.3247@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902041012440.3247@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 4 Feb 2009, Norbert Preining wrote:
> > 
> > The problem is that if you have a configuration under 2.6.28 without 
> > CONFIG_FB and just call make oldconfig, or even make config and don't 
> > know that you loose the DRM. And I was using make oldconfig (there is a 
> > graphical config?? ;-))
> 
> Sure. It's inconvenient, no question about that. I asked the i915 people 
> to look into not requiring CONFIG_FB, and I hope they will, but my point 
> is that I don't think we can consider "small one-time inconvenience" to be 
> a "regression".

if you mean that as a general principle, there's four very real downsides in 
my opinion.

Firstly, we could have done better (and still can do better), via various 
easy and non-intrusive measures:

   - We could add a runtime warning:

      for example a WARN_ONCE("please enable CONFIG_DRM_I915 and CONFIG_FB") 
      that there's no DRM because CONFIG_FB is not selected and oldconfig 
      loses the I915 setting silently - placed in a key DRM ioctl, would 
      have gone a long way addressing the issue. Testers do notice kernel 
      warnings that pop up when their X gets slow. (This approach might also 
      have the added bonus of warning folks who enable the wrong driver for 
      the hardware.)

   - Or we could add a more thoughtful Kconfig migration:

      Rename DRM_I915 to DRM_I915_FB [which it really is now], and keep
      DRM_I915 as a non-interactive migration helper: if set, it 
      auto-selects both FB and DRM_I915_FB.

      While CONFIG_FB is an interactive Kconfig option so a select can be 
      dangerous to a correct dependency tree, it seems safe to do in this 
      specific case because it seems to be a rather leaf entry with no 
      dependencies.

Sure, upgrading systems and following development is never easy and well 
structured brains are in heavy demand in any case - but we should really 
engineer things so that people spend time on reporting _real_ regressions - 
and not waste their time and energy on self-inflicted wounds.

The four very real downsides are:

1) I dont think it's honest to make an artificial distinction between a 
   user-visible bug that can be fixed via a one-time tweak to a .config, and 
   a user-visible bug that can be fixed via a one-time upgrade to a fixed 
   kernel.

   As far as the tester is involved the two are largely the same, and both 
   were caused by this shiny new 'upstream kernel' thing they just tested.

   Yes, to us developers there's a fundamental difference because one is a
   fix in the code the other is a change in the environment - but the user
   really doesnt make that distinction - both are largely black boxes to
   them.

   Also, it can actually get _worse_ than a regression: if it gets declared
   a feature/annoyance and no action is taken - then it's an unfixed bug and
   that's far worse than even the painful memory of a fixed bug.

2) Furthermore, many testers dont touch early -rcs because they know they
   have rough edges. So it's a linearly ongoing cost beyond -rc1.

3) It's not the individual small annoyances that matter but the sheer sum of 
   of such annoyances when migrating from one kernel to another. I still
   struggle with some of such issues myself when testing back to some old 
   kernel and keep wasting time on it - again and again. Keeping oldconfig 
   compatibility is really a prime-type quality of Linux kernel testing i 
   think.

   Especially a casual tester will be discouraged by such an experience:
   and more so if it's clearly avoidable via a few trivial tweaks - and the 
   tester senses this 'ease of fix' intuitively and gets a "not a bug" 
   pushback.

4) Also, some maintainers are using every excuse they can find to not have 
   to keep 'make oldconfig' compatibility. That is not because they
   are lazy, embarrased and defensive or evil, but it is a natural reaction: 
   they only see the small trivial annoyance they intruduce themselves - 
   which is in a code area and usecase they are prominently familiar with, 
   so they cannot personally relate to the trouble that users go through if 
   they hit such issues.

   But the thing is, we've got dozens and dozens of critical subsystems, and 
   if each one does just a single such stupid looking tiny thing in a kernel 
   cycle it mounts up to a real force. The sheer size of Linux is a real 
   multiplicator factor here IMO. The moment Linus condones it the precedent 
   is set and everyone will just say "others do it too every now and then 
   and Linus doesnt mind so buzz off".

In my experience the sum of such small stupid careless migration annoyances 
during upgrades snowballs way too much in practice, and it has become the 
main vector along which we lose good testers - so i am never shy to flame 
folks if they introduce such issues ;-) YMMV.

</soapbox ;) >

	Ingo
