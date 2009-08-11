Return-Path: <linux-kernel-owner+w=401wt.eu-S1752635AbZHKMCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbZHKMCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbZHKMCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:02:33 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:35541 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbZHKMCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:02:32 -0400
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Aug 2009 08:02:32 EDT
Date: Tue, 11 Aug 2009 09:32:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: kmemleak: Protect the seq start/next/stop sequence by
	rcu_read_lock()
Message-ID: <20090811073205.GA17476@elte.hu>
References: <20090729152101.1878.71159.stgit@pc1117.cambridge.arm.com> <20090802111453.GA24927@elte.hu> <1249919718.10848.55.camel@pc1117.cambridge.arm.com> <20090810184527.GA9601@elte.hu> <1249945003.26205.23.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249945003.26205.23.camel@pc1117.cambridge.arm.com>
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


* Catalin Marinas <catalin.marinas@arm.com> wrote:

> On Mon, 2009-08-10 at 20:45 +0200, Ingo Molnar wrote:
> > * Catalin Marinas <catalin.marinas@arm.com> wrote:
> > 
> > > On Sun, 2009-08-02 at 13:14 +0200, Ingo Molnar wrote:
> > > > hm, some recent kmemleak patch is causing frequent hard and 
> > > > soft lockups in -tip testing (-rc5 based).
> > > 
> > > Thanks for reporting this. It shouldn't be caused by the patch 
> > > mentioned in the subject as this only deals with reading the seq 
> > > file which doesn't seem to be the case here.
> > 
> > Since i turned off kmemleak in -tip completely via the patch below i 
> > havent had a single such lockup.
> > 
> > Have you tried the config i sent - does it work fine for you? For me 
> > it locks up on various boxes within a couple of minutes - without 
> > doing anything particular beyond building a kernel or so.
> 
> I couldn't tried your config as I don't have an x86_64 machine (I 
> only rely on an x86_32 laptop at home and several ARM machines at 
> work for testing).
> 
> I tried similar config and with the mainline kernel I get some 
> lockups (several seconds) with CONFIG_PREEMPT disabled on ARM 
> machines or x86 during a scanning episode but it eventually 
> completes the scanning. With the kmemleak patches for the next 
> merging window, I don't get any lockups as it has more 
> cond_resched() calls.

How big are those patches? Kmemleak is new in .31 so if it fixes a 
real problem it might still be acceptable.

> Maybe on your x86_64 box you get some bigger objects allocated 
> (alloc_bootmem, per-cpu, data/bss, NODE_DATA, task stacks) which 
> are scanned without cond_resched() calls and CONFIG_PREEMPT 
> disabled. Scanning the memory can even take several minutes 
> especially with CONFIG_PROVE_LOCKING enabled and maybe that's why 
> you see the lockups. Enabling CONFIG_PREEMPT reduces the lockup 
> period.
> 
> I'll try tomorrow with x86_32 allyesconfig on my laptop and see 
> how it goes.

It could be a livelock not a true deadlock - but a pretty severe one 
at that.

	Ingo
