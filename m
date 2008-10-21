Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbYJUQQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbYJUQQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 12:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYJUQQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 12:16:20 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:55670 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277AbYJUQQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 12:16:20 -0400
Subject: Re: [PATCH 2/3] x86: Get TSC frequency from VMware hypervisor.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>
In-Reply-To: <48FD35CC.10904@zytor.com>
References: <1224552952.2640.93.camel@alok-dev1>  <48FD35CC.10904@zytor.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 21 Oct 2008 09:16:19 -0700
Message-Id: <1224605779.6161.9.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-20 at 18:52 -0700, H. Peter Anvin wrote:
> Alok Kataria wrote:
> > x86: Get TSC frequency from VMware hypervisor.
> >
> > From: Alok N Kataria <akataria@vmware.com>
> >
> > This patch adds functions to detect if we are running under VMware.
> > The current way to check if we are on VMware is following,
> > #  check if "hypervisor present bit" is set, if so read the 0x40000000
> >    cpuid leaf and check for "VMwareVMware" signature.
> > #  if the above fails, check the DMI vendors name for "VMware" string
> >    if we find one we query the VMware backdoor port to check if we are
> >    under VMware.
> >
> > The DMI + Backdoor check is needed for older VMware products, which
> > don't implement the hypervisor signature cpuid leaf.
> > Also note that since we are checking for the DMI signature the backdoor
> > port would never be accessed on native hardware.
> >
> > This patch also adds a hypervisor_get_tsc_freq function, instead of
> > calibrating the frequency which can be error prone in virtualized
> > environment, we ask the hypervisor for it. We get the frequency from
> > the hypervisor by accessing the backdoor port if we are running on VMware.
> > Other hypervisors too can add code to get frequency on their platform
> > to this routine.
> >
> 
> I would like to see, instead of calling vmware_platform() directly in
> places like tsc.c, a hypervisor field in the CPU structure that is set
> with the rest of the CPU identification stuff.

Hi hpa,

Do you mean we should have a x86_hyper_vendor field in cpuinfo_x86 ? 
Even with that, i think we will have to differentiate between each of
the hypervisors, as each of the hypervisor implementation differs in how
they provide the TSC frequency. 

So we would end up with code like,
	if (boot_cpu.x86_hyper_vendor == VMWARE)
		get_frequency_vmware_way();
	if (boot_cpu.x86_hyper_vendor == XXX)
		get_frequency_XXX_way();

I agree that having a field in the cpu structure will make sure that we
don't end up calling vmware_platform multiple times, but does it help in
this particular situation ?

Let me know if you meant something else.

Thanks,
Alok

>   That way we avoid ending
> up with garbage like:
> 
> if (vmware_platform() || xen_platform() || kvm_platform() ...)
> 
>         -hpa

