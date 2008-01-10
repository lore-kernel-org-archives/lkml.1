Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbYAJKo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbYAJKo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 05:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbYAJKoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 05:44:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42478 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbYAJKoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 05:44:17 -0500
Date: Thu, 10 Jan 2008 11:43:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       suresh.b.siddha@intel.com, Arjan van de Ven <arjan@infradead.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: CPA patchset
Message-ID: <20080110104351.GC28209@elte.hu>
References: <20080103424.989432000@suse.de> <20080110093126.GA360@elte.hu> <20080110095337.GK25945@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110095337.GK25945@bingen.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andi Kleen <ak@suse.de> wrote:

> There's also unfortunately still one outstanding bug (triggeredb y 
> some recent changes) on 32bit that makes the self test suite not pass 
> currently.

ok. I'd expect there to be a whole lot of bugs triggered in this area. 
We have to shape it in a way that puts the most useful bits to the head 
and the riskiest bits to the end, so that we can do reverts in a 
sensible and least destructive way - if the need arises.

> > - firstly, there's no rationale given. So we'll change ioremap()/etc.
> >   from doing a cflush-range instruction instead of a WBINVD. But why?
> 
> - WBINVD is a very nasty operation. I was talking to some CPU people 
> and they really recommended to get rid of it as far as possible. 
> Stopping the CPU for msecs is just wrong and there are apparently even 
> some theoretical live lock situations. - It is not interruptible in 
> earlier VT versions and messes up real time in the hypervisor. Some 
> people were doing KVM on rt kernels and had latency spikes from that.

ok, i thought you might have had some higher rationale too. Frankly, 
WBINVD wont ever go away from the x86 instruction set, and while i am 
very symphathetic to rt and latency issues, it's still a risky change in 
a historically fragile area of code.

What is very real though are the hard limitations of MTRRs. So i'd 
rather first like to see a clean PAT approach (which all other modern 
OSs have already migrated to in the past 10 years), with all the 
structural cleanups and bugfixes you did as well, which would allow us 
to phase out MTRR use (of the DRM drivers, etc.), and _then_ layer an 
(optional) cflush approach basically as the final step. Right now cflush 
is mixed inextractably into the CPA patchset. WBINVD latency is really 
the last of our problems here.

> >   WBINVD isnt particular fast (takes a few msecs), but why is that a 
> >   problem? Drivers dont do high-frequency ioremap-ing. It's 
> >   typically
> 
> Actually graphics drivers can do higher frequency allocation of WC 
> memory (with PAT) support.

but that is plain stupid. If it can be WC mapped, why not map it WB and 
use cflush when updating memory? That gives cache-coherency on demand 
_and_ true read side caching - so it's faster as well. Modern GX cards 
can take that just fine. The best of both worlds. Unconditional WC is 
way overrated.

> > - secondly, obviously doing a 'flush some' instead of a 'flush all'
> >   operation is risky. There's not many ways we can get the 'flush 
> >   all'
> 
> Yes, that is why it took so long. But it's eventually needed to make 
> PAT actually useful for once.

as i see it, the utility of PAT comes from going away from MTRRs, and 
the resulting flexibility it gives system designers to shape memory and 
IO BARs.

> >   WBINVD instruction wrong (as long as we do it on all cpus, etc.). 
> >   But with this specific range flush we've got all the risks of 
> >   accidentally not flushing _enough_. Especially if some boundary of 
> >   a mapped area is imprecisely.
> 
> Not sure what you mean here? If someone doesn't pass in the correct 
> area then not everything will be uncached in the first place. Using 
> something as cached that should be uncached is usually noticed because 
> it tends to be quite slow or corrupt data.

yes, 'quite slow or corrupt data' is what i meant:

> >   asking for trouble as it's very hard to debug and the operations 
                                 ^^^^^^^^^^^^^^^^^^
> >   here (ioremap) are typically done only once per system bootup. 
> >   [...]
> 
> change_page_attr() is used for more than just ioremap (e.g. a common 
> case is mapping memory into AGP apertures which still happens in many 
> graphics drivers). I also expect it will be used even more in the 
> future when PAT usage will become more wide spread.

i expect usage to not change in pattern. ioremap()ping on the fly is not 
too smart.

[ quoting this from the top: ]

> > finally managed to get the time to review your CPA patchset, and i 
> > fundamentally agree with most of the detail changes done in it. But 
> > here are a few structural high-level observations:
> 
> I have a few changes and will post a updated version shortly.

thanks. I've test-merged the PAT patchset from Venki/Suresh to have a 
look, and to me the most logical way to layer these changes would be:

 - PAT
 - non-cflush bits of CPA
 - cflush bits of CPA
 - GBPAGES

hm?

	Ingo
