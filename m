Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbYI2Tid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbYI2Tid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 15:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbYI2TiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 15:38:07 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:37904 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753527AbYI2TiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 15:38:06 -0400
Subject: Re: Use CPUID to communicate with the hypervisor.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Zach Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>,
       "Jun.Nakajima@Intel.Com" <Jun.Nakajima@Intel.Com>
In-Reply-To: <48E1227B.9040809@redhat.com>
References: <1222472815.29886.43.camel@alok-dev1>
	 <48E090B6.2080809@redhat.com> <1222710924.30247.21.camel@alok-dev1>
	 <48E1227B.9040809@redhat.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 29 Sep 2008 12:38:05 -0700
Message-Id: <1222717085.30247.44.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-29 at 11:46 -0700, Gerd Hoffmann wrote:
> Alok Kataria wrote:
> > Hi Gerd,
> >
> >> Shouldn't you check the hypervisor signature here?
> >
> > Nope the whole idea of not checking the hypervisor signature is that we
> > should keep this interface generic.
> 
> Nice idea.  Problem with that is that approach is that we don't have
> full control here.  It probably isn't that a hard to have vmware, xen
> and kvm agree here, given vmware proposes this and for xen+kvm one can
> send patches.  

Yep.
And please note that this does allow either Xen/KVM to propose a new
leaf and the rest of the hypervisor players can decide to export that
leaf or return a zero value. 

> But even that you can't take for granted, see the
> discussion of the "tsc-may-change-on-migration" problem.

I may have been unclear in my first attempt to this question, let me try
again. 
If the frequency of tsc changes during migration, it should be the task
of hypervisor to handle it. There could be multiple ways to solve that
problem, either the hypervisor emulates the old frequency (by whatever
way) or there are cpufreq drivers in the guest which detect changes in
frequency, and ask the hypervisor for the new frequency. The interface
still allows you to query the cpuid leaf and get the new frequency.
right ? 

> 
> The real big problem are other closed-source hypervisors (VirtualPC /
> Hyper-V / Parallels / ...).  How can we be sure they don't define that
> leaf to something different?

How does that matter, if we are able to standardize all this then,
hypervisors which want to run a Linux guest should effectively play by
the standards over here or else they would never work properly on Linux.
What we are trying to do here is try to standardize things for Linux so
that the Linux kernel implementation for Virtualization is that much
more easier. If this goes well other closed source hypervisors too can
effectively follow these standards. 
If the other closed source hypervisors define their own cpuid leafs they
will still have to make Linux kernel side changes to make use of these
new leafs. Which allows them to add to these pool of cpuid interface's
too.

> 
> > Also one thing to remember is, that a hypervisor can decide to not
> > implement this level and just return "0" the kernel can then just ignore
> > that value. That's what we do currently in native_calibrate_tsc.
> 
> The fudamental issue outlined above aside:  Even the "ignore 0" part
> isn't in the patch right now.

Hmm, I am confused, from the patch i posted above, in
native_calibrate_tsc

+       tsc_khz = hypervisor_tsc_freq();
+       if (tsc_khz)
+               return tsc_khz;

We do ignore zero values over here.

> 
> >> Right now both kvm and xen use the first one or two leafes (after info),
> >> but in incompatible ways, so for these the signature *must* be checked
> >> before using the info found there.
> >
> > Hmm that's unfortunate, but we can have exceptions for these one of
> > cases and AFAIK these are only checked in the kvm/xen code path and not
> > in any generic code as of now, right ?
> 
> Yes.
> 
> > btw, i could only find the semantics for 0x40000001 leaf in KVM's header
> > file but don't see Xen using that leaf, can you please point me which
> > leafs are you referring to here.
> 
> pv drivers in hvm guests use that (and query very xen-specific stuff
> which wouldn't make much sense in other hypervisors).  It isn't in the
> kernel source tree, look here instead:
> 
> http://xenbits.xensource.com/xen-3.3-testing.hg?file/19201eebab16/unmodified_drivers/linux-2.6/platform-pci/platform-pci.c

Thanks for the pointer. This would fall in the exception too.

Thanks,
Alok

> 
> cheers,
>   Gerd
> 
> 

