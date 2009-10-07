Return-Path: <linux-kernel-owner+w=401wt.eu-S1759915AbZJGUwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915AbZJGUwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 16:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758154AbZJGUwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 16:52:22 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:19747 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757840AbZJGUwV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 16:52:21 -0400
MIME-Version: 1.0
Message-ID: <c0b89573-bec7-45dc-b21d-a51f498c2e0c@default>
Date: Wed, 7 Oct 2009 13:48:19 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Avi Kivity <avi@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>, zach.brown@oracle.com,
       chris.mason@oracle.com
Subject: RE: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall
 implementation
In-Reply-To: <4ACC6C9C.7080707@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.4  (308245) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4ACCFF0A.000E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We can support them by falling back to the kernel.  I'm a bit worried 
> about the kernel playing with the hypervisor's version field.  It's 
> better to introduce yet a new version for the kernel, and check both.

On Nehalem, apps that need timestamp information at a high
frequency will likely use rdtsc/rdtscp directly.

I very much support Jeremy's efforts to make vsyscall+pvclock
work fast on processors other than the very newest ones.

Dan

> -----Original Message-----
> From: Avi Kivity [mailto:avi@redhat.com]
> Sent: Wednesday, October 07, 2009 4:26 AM
> To: Jeremy Fitzhardinge
> Cc: Jeremy Fitzhardinge; Dan Magenheimer; Xen-devel; Kurt Hackel; the
> arch/x86 maintainers; Linux Kernel Mailing List; Glauber de Oliveira
> Costa; Keir Fraser; Zach Brown; Chris Mason
> Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall
> implementation
> 
> 
> On 10/06/2009 08:46 PM, Jeremy Fitzhardinge wrote:
> >
> >> Instead of using vgetcpu() and rdtsc() independently, you can use
> >> rdtscp to read both atomically.  This removes the need for 
> the preempt
> >> notifier.
> >>      
> > rdtscp first appeared on Intel with Nehalem, so we need to 
> support older
> > Intel chips.
> >    
> 
> We can support them by falling back to the kernel.  I'm a bit worried 
> about the kernel playing with the hypervisor's version field.  It's 
> better to introduce yet a new version for the kernel, and check both.
> 
> > You could use rdscp to get (tsc,cpu) atomically, but that's not
> > sufficient to be able to get a consistent snapshot of (tsc, 
> time_info)
> > because it doesn't give you the pvclock_vcpu_time_info 
> version number.
> > If TSC_AUX contained that too, it might be possible.  
> Alternatively you
> > could compare the tsc with pvclock.tsc_timestamp, but 
> unfortunately the
> > ABI doesn't specify that tsc_timestamp is updated in any particular
> > order compared to the rest of the fields, so you still 
> can't use that to
> > get a consistent snapshot (we can revise the ABI, of course).
> >
> > So either way it doesn't avoid the need to iterate.  
> vgetcpu will use
> > rdtscp if available, but I agree it is unfortunate we need to do a
> > redundant rdtsc in that case.
> >
> >    
> 
> def try_pvclock_vtime():
>    tsc, p0 = rdtscp()
>    v0 = pvclock[p0].version
>    tsc, p = rdtscp()
>    t = pvclock_time(pvclock[p], tsc)
>    if p != p0 or pvclock[p].version != v0:
>       raise Exception("Processor or timebased change under our feet")
>    return t
> 
> def pvclock_time():
>    while True:
>      try:
>         return try_pvlock_time()
>      except:
>         pass
> 
> So, two rdtscps and two compares.
> 
> >>> +    for (cpu = 0; cpu<   nr_cpu_ids; cpu++)
> >>> +        pvclock_vsyscall_time_info[cpu].version = ~0;
> >>> +
> >>> +    __set_fixmap(FIX_PVCLOCK_TIME_INFO,
> >>> __pa(pvclock_vsyscall_time_info),
> >>> +             PAGE_KERNEL_VSYSCALL);
> >>> +
> >>> +    preempt_notifier_init(&pvclock_vsyscall_notifier,
> >>> +&pvclock_vsyscall_preempt_ops);
> >>> +    preempt_notifier_register(&pvclock_vsyscall_notifier);
> >>> +
> >>>        
> >> preempt notifiers are per-thread, not global, and will 
> upset the cycle
> >> counters.
> >>      
> > Ah, so I need to register it on every new thread?  That's a 
> bit awkward.
> >    
> 
> It's used to manage processor registers, much like the fpu.  
> If a thread 
> uses a register that's not saved and restored by the normal context 
> switch code, it can register a preempt notifier to do that instead.
> 
> > This is intended to satisfy the cycle-counters who want to do
> > gettimeofday a million times a second, where I guess the tradeoff of
> > avoiding a pile of syscalls is worth a bit of 
> context-switch overhead.
> >    
> 
> It's sufficient to increment a version counter on thread 
> migration, no 
> need to do it on context switch.
> 
> -- 
> Do not meddle in the internals of kernels, for they are 
> subtle and quick to panic.
> 
> 
>
