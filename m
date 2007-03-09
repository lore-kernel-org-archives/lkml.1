Return-Path: <linux-kernel-owner+w=401wt.eu-S2993130AbXCIVFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993130AbXCIVFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:05:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993133AbXCIVFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:05:43 -0500
Received: from gw.goop.org ([64.81.55.164]:41981 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993130AbXCIVFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:05:41 -0500
Message-ID: <45F1CC22.6030106@goop.org>
Date: Fri, 09 Mar 2007 13:05:38 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Zachary Amsden <zach@vmware.com>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, akpm@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
References: <20070309180230.GA17988@elte.hu> <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org> <20070309192420.GA27747@elte.hu> <Pine.LNX.4.64.0703091137340.10832@woody.linux-foundation.org> <20070309201257.GA5761@elte.hu>
In-Reply-To: <20070309201257.GA5761@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Once this thing is released upstream, it creates a new compatibility 
> rule:
>
>   _new kernel must not break on an older hypervisor_
>   

Yes, that's important.  (It's perhaps more important that a new
hypervisor not break an old kernel, but that's 100% the hypervisor's
responsibility.)

But yes, the various pv_ops implementations will need to work to make
sure that they can maintain support for old hypervisors as the pv_ops
interface evolves.  That's the basic nature of such API-ABI couplings. 
The only way to deal with it is to make sure the API is high-enough
level to leave abstraction wiggle-room to adapt the pv_ops interface to
the hypervisor interface.

But I'm pretty sure that's your point, and one we've been aware of from
the start.

> due to a new paravirt_ops design. Ever. It's really that simple. (I 
> think i never said this explicitly because this requirement of backwards 
> compatibility was so obvious to me.)
>   

You're right.  Very important.

> And it doesnt matter whether we think that it was VMWare who messed up. 
> Users/customers _will_ blame us: "v2.6.25 regresses, it wont run under 
> ESX v1.12 anymore". Distro will yield and will undo whatever change 
> breaks backwards compatibility with older hypervisors. (most likely it 
> will be undone upstream already) Backwards compatibility acts as a very 
> heavy barrier against certain types of paravirt_ops design changes.
>   

Well, yes.  If there's a huge disconnect between the pv_ops interface
and the hypervisor interface which can't be bridged, then that might be
a problem.  But one would hope that would get sorted out way before
people start complaining about regressions.  If the regression is just a
bug, well, its just a bug.

pv_ops has to walk a delicate balance.  On the one hand, its entrypoints
can't be 1:1 with any given ABI, because that would make it very
brittle.  On the other hand, it can't be so high-level that any back-end
implementation has to have masses of code mapping the high-level
interface to the ABI.

This is not something you can do with capital-A Architecture up front. 
Its something that you need to work towards incrementally as real design
problems come up.  You know, like the rest of the kernel.

The current pv_ops development has been helped by the fact that Xen and
VMI (and lguest and kvm) have all quite distinct virtualization
approaches, because it prevents the interface from being overly fawning
to one particular design.  But that doesn't mean it should be a grab-bag
union of all the interfaces; we need to find the right level of
abstraction which can deal with everyone's requirements (both the
hypervisors and the kernel overall).  And we'll need to keep rebalancing
those tradeoffs as the requirements change (as new hypervisors get
added, existing ones change, obsolete ones get dropped and as the kernel
itself changes).

> Once v2.6.21 is released, and a bigger distro releases a kernel with 
> CONFIG_PARAVIRT+CONFIG_VMI enabled: backwards compatibility in future 
> versions becomes mainly /that/ distro's problem (and upstream's 
> problem), _NOT_ WMware's problem.
>   

pv_ops went into mainline in 2.6.20, more or less as a placeholder. 
2.6.21 will change it a bit, and the vmi binding will work a bit better,
I guess.  I'm hoping the patches I've been posting will make it into
2.6.22, and they'll make further changes to the interface.  This is a
new, highly dynamic interface, and nobody is claiming or (I hope)
expecting anything else.

If VMWare is indeed actually releasing a product in a couple of weeks
based on 2.6.21, well that's going to be their support problem.  I
really hope no distro is going to decide to ship a release based on a
current or near future kernel with CONFIG_PARAVIRT enabled, at least not
without realizing they're shipping something very new and raw.  pv_ops
is going to change a lot in the next few months.

> That's why i mentioned CONFIG_COMPAT_VDSO as an example. One major 
> distro (SuSE 9.0) came out with that particular glibc version that had a 
> bug that depended on a particular and totally unintentional ABI detail 
> in the vDSO. As a result we had to do several iterations of 
> CONFIG_COMPAT_VDSO to keep backwards compatibility. And glibc is perhaps 
> _the_ most kernel-friendly external software project in existence. 
> Still, the ABI dependency was there, and we cannot break users who run 
> old userspace. The same rule holds here: we cannot break users who run 
> an old hypervisor.
>   

Well, the glibc folks were pretty annoyed about that too, since it
wasn't even a release glibc with the problem; it was just some random
CVS snapshot that got shipped.  The distros screwed up, and we have to
deal with it.  It would be nice to turn off COMPAT_VDSO, but since we
can't, we're going to make it work with CONFIG_PARAVIRT.

    J
