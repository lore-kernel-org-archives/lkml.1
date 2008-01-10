Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbYAJLHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbYAJLHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 06:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYAJLHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 06:07:10 -0500
Received: from ns2.suse.de ([195.135.220.15]:39691 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbYAJLHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 06:07:07 -0500
Date: Thu, 10 Jan 2008 12:07:05 +0100
From: Andi Kleen <ak@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       suresh.b.siddha@intel.com, Arjan van de Ven <arjan@infradead.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: CPA patchset
Message-ID: <20080110110704.GQ25945@bingen.suse.de>
References: <20080103424.989432000@suse.de> <20080110093126.GA360@elte.hu> <20080110095337.GK25945@bingen.suse.de> <20080110104351.GC28209@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110104351.GC28209@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 11:43:51AM +0100, Ingo Molnar wrote:
> > > - firstly, there's no rationale given. So we'll change ioremap()/etc.
> > >   from doing a cflush-range instruction instead of a WBINVD. But why?
> > 
> > - WBINVD is a very nasty operation. I was talking to some CPU people 
> > and they really recommended to get rid of it as far as possible. 
> > Stopping the CPU for msecs is just wrong and there are apparently even 
> > some theoretical live lock situations. - It is not interruptible in 
> > earlier VT versions and messes up real time in the hypervisor. Some 
> > people were doing KVM on rt kernels and had latency spikes from that.
> 
> ok, i thought you might have had some higher rationale too. Frankly, 
> WBINVD wont ever go away from the x86 instruction set, and while i am 

We can (and should) eliminate it from normal operation at least. The one during
reboot has to be kept unfortunately.

> very symphathetic to rt and latency issues, it's still a risky change in 
> a historically fragile area of code.

It is, but the resulting code is significantly more efficient and does
various other things in better ways (the explicit list allows various
other optimizations). It's how c_p_a should have been written from day one. 


> What is very real though are the hard limitations of MTRRs. So i'd 
> rather first like to see a clean PAT approach (which all other modern 

That's mostly orthogonal. Don't know why you bring it up now?

Anyways more efficient c_p_a() makes PAT usage easier.

> structural cleanups and bugfixes you did as well, which would allow us 
> to phase out MTRR use (of the DRM drivers, etc.), and _then_ layer an 
> (optional) cflush approach basically as the final step. Right now cflush 
> is mixed inextractably into the CPA patchset. WBINVD latency is really 

You could always disable it. Just set full_flush = 1.
Anyways it would be possible to disable it more fully, but at least
the individual flush infrastructure is used by other code too and useful
for it.


> the last of our problems here.

I disagree on that.

> 
> > >   WBINVD isnt particular fast (takes a few msecs), but why is that a 
> > >   problem? Drivers dont do high-frequency ioremap-ing. It's 
> > >   typically
> > 
> > Actually graphics drivers can do higher frequency allocation of WC 
> > memory (with PAT) support.
> 
> but that is plain stupid. If it can be WC mapped, why not map it WB and 
> use cflush when updating memory? 

Not reliable due to the speculative out of order nature of x86 CPUs. 

See my other mail to Dave explaining one scenario where it can go 
wrong.

> > >   all'
> > 
> > Yes, that is why it took so long. But it's eventually needed to make 
> > PAT actually useful for once.
> 
> as i see it, the utility of PAT comes from going away from MTRRs, and 
> the resulting flexibility it gives system designers to shape memory and 
> IO BARs.

MTRRs will not go away, just used less.

One advantage of PAT is that you can set any page in memory efficiently
to WC or UC without requiring hacks like an hardware aperture. But to
make good use of that this operation needs to be reasonably efficient.
> 
> > >   WBINVD instruction wrong (as long as we do it on all cpus, etc.). 
> > >   But with this specific range flush we've got all the risks of 
> > >   accidentally not flushing _enough_. Especially if some boundary of 
> > >   a mapped area is imprecisely.
> > 
> > Not sure what you mean here? If someone doesn't pass in the correct 
> > area then not everything will be uncached in the first place. Using 
> > something as cached that should be uncached is usually noticed because 
> > it tends to be quite slow or corrupt data.
> 
> yes, 'quite slow or corrupt data' is what i meant:

That will already happen without my patchkit.  No change to the positive
or the negative.

> 
> > >   asking for trouble as it's very hard to debug and the operations 
>                                  ^^^^^^^^^^^^^^^^^^
> > >   here (ioremap) are typically done only once per system bootup. 
> > >   [...]
> > 
> > change_page_attr() is used for more than just ioremap (e.g. a common 
> > case is mapping memory into AGP apertures which still happens in many 
> > graphics drivers). I also expect it will be used even more in the 
> > future when PAT usage will become more wide spread.
> 
> i expect usage to not change in pattern. ioremap()ping on the fly is not 
> too smart.

Once PAT is in people will use it more I expect. And contrary to your
claims it is already used for more than just ioremap. Please grep
for it.

Actually in DEBUG_PAGEALLOC kernels it is currently heavily used,
but I eliminated that.

> 
> [ quoting this from the top: ]
> 
> > > finally managed to get the time to review your CPA patchset, and i 
> > > fundamentally agree with most of the detail changes done in it. But 
> > > here are a few structural high-level observations:
> > 
> > I have a few changes and will post a updated version shortly.
> 
> thanks. I've test-merged the PAT patchset from Venki/Suresh to have a 
> look, and to me the most logical way to layer these changes would be:
> 
>  - PAT
>  - non-cflush bits of CPA
>  - cflush bits of CPA

I would prefer to not reorder it significantly inside itself.

I took pains to make it all in small bisectable steps but redoing
all that would be very painful and time consuming for me. Also currently 
it is relatively logical in the way it builds on each other and dumb separation
in clflush vs no clflush wouldn't help with that.

A merge after PAT is fine for me if PAT happens soon (iirc there were
only minor changes to cpa anyways), although it's a pity to delay
some of the fixes for so long. But I haven't seen an PAT update recently
and at least the original patch needed much more work. So I think
you should only delay it for PAT if that happens soon.
I had actually hoped that CPA would be ready for .25, but I have my doubts
for PAT with that.

One possibility if you're worried about CLFLUSH so much would be to
merge the whole series but keep CLFLUSH disabled.  Don't think it would
improve things much though and the only way to get it shaked out is wider
testing anyways.


-Andi
