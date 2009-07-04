Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbZGDPu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbZGDPu1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 11:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbZGDPuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 11:50:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33584 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbZGDPuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 11:50:13 -0400
Date: Sat, 4 Jul 2009 18:50:02 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "avi@redhat.com" <avi@redhat.com>
Subject: Re: [PATCH v5] enable x2APIC without interrupt remapping under KVM
Message-ID: <20090704155002.GC24641@redhat.com>
References: <20090701133007.GC27539@redhat.com> <1246482017.27006.10670.camel@localhost.localdomain> <20090703082905.GF21833@elte.hu> <m1r5wwbxjx.fsf@fess.ebiederm.org> <20090704095556.GB24641@redhat.com> <m1r5wwa56k.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1r5wwa56k.fsf@fess.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 04, 2009 at 07:33:39AM -0700, Eric W. Biederman wrote:
> Gleb Natapov <gleb@redhat.com> writes:
> 
> > On Sat, Jul 04, 2009 at 02:35:30AM -0700, Eric W. Biederman wrote:
> >> Ingo Molnar <mingo@elte.hu> writes:
> >> 
> >> > * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> >> >
> >> >> On Wed, 2009-07-01 at 06:30 -0700, Gleb Natapov wrote:
> >> >> > KVM would like to provide x2APIC interface to a guest without emulating
> >> >> > interrupt remapping device. The reason KVM prefers guest to use x2APIC
> >> >> > is that x2APIC interface is better virtualizable and provides better
> >> >> > performance than mmio xAPIC interface:
> >> >> >     
> >> >> > - msr exits are faster than mmio (no page table walk, emulation)
> >> >> > - no need to read back ICR to look at the busy bit
> >> >> > - one 64 bit ICR write instead of two 32 bit writes
> >> >> > - shared code with the Hyper-V paravirt interface
> >> >> >     
> >> >> > Included patch changes x2APIC enabling logic to enable it even if IR
> >> >> > initialization failed, but kernel runs under KVM and no apic id is
> >> >> > greater than 255 (if there is one spec requires BIOS to move to x2apic
> >> >> > mode before starting an OS).
> >> >> > 
> >> >> > Signed-off-by: Gleb Natapov <gleb@redhat.com>
> >> >> 
> >> >> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
> >> >
> >> > Now, since this affects core x86 APIC code non-trivially so should 
> >> > submitted to and go via the x86 tree. (Can prepare a special branch 
> >> > with just this change if KVM tree wants/needs to pull it before 
> >> > v2.6.32.)
> >> 
> >> Please don't separate the x2apic code from the dmar code for this
> >> reason.
> >> 
> >> Supporting hotplug cpus with ioapics is torture.
> >> 
> > What is the connection between this patch and cpu hotplug?
> 
> When I asked if cpu hotplug was a supported and more or
> less common feature of kvm I was told it was.
> 
It is supported in a sense that cpus can be created dynamically
and DSDT has objects to inform OS that a cpu state changed. I don't
know how common it is. I surely don't use it daily. But 99% of the real
work is done by a guest.

> Good cpu hotplug today means supporting interrupt remapping.
> (The code you are disabling for kvm).
>From you previous mails I understand that the problem is no with cpu
hotplug, but with cpu offlining and this is the guest feature that
cannot be controlled by KVM in any way. If you think that Linux should
not support cpu offlining with ioapics fine, send a patch to disable it
and cpu hot-unplug will not be supported by KVM with Linux guests, but
note that KVM ioapic has no problems that you've mentioned and HW
makers that provide x86 hardware may be using more sophisticated
ioapics that you've tested (I don't know never saw such hardware).

> 
> Therefore I don't see the point of supporting one without the other.
x2apic provide us with other benefits as commit message explains, and
doesn't add any problems that we don't have now already.

> Especially if we don't have a case where on real hardware we need to
> split the support.
> 

--
			Gleb.
