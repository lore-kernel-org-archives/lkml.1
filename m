Return-Path: <linux-kernel-owner+w=401wt.eu-S1754150AbXLKBL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbXLKBL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 20:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbXLKBLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 20:11:49 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37853 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbXLKBLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 20:11:47 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Neil Horman <nhorman@redhat.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ben Woodard <woodard@redhat.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>, hbabu@us.ibm.com,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
References: <20071128190525.GD3192@redhat.com> <474F7177.7050306@redhat.com>
	<20071130144250.GC23810@redhat.com>
	<20071130145131.GB5822@hmsendeavour.rdu.redhat.com>
	<20071206213951.GB28898@hmsreliant.think-freely.org>
	<20071206221143.GC2863@redhat.com>
	<m1bq93s5r8.fsf@ebiederm.dsl.xmission.com>
	<86802c440712070050s3c5017a4w8e747a7035d10d3a@mail.gmail.com>
	<86802c440712070122q6e5824bcp12e1c3f560e2ab53@mail.gmail.com>
	<20071207142144.GA10389@hmsendeavour.rdu.redhat.com>
	<20071207175832.GA18485@hmsreliant.think-freely.org>
Date: Mon, 10 Dec 2007 18:08:03 -0700
In-Reply-To: <20071207175832.GA18485@hmsreliant.think-freely.org> (Neil
	Horman's message of "Fri, 7 Dec 2007 12:58:32 -0500")
Message-ID: <m1k5nm2g3w.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman <nhorman@tuxdriver.com> writes:

> On Fri, Dec 07, 2007 at 09:21:44AM -0500, Neil Horman wrote:
>> On Fri, Dec 07, 2007 at 01:22:04AM -0800, Yinghai Lu wrote:
>> > On Dec 7, 2007 12:50 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> > >
>> > > On Dec 6, 2007 4:33 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> > ...
>> > > >
>> > > > My feel is that if it is for legacy interrupts only it should not be a
> problem.
>> > > > Let's investigate and see if we can unconditionally enable this quirk
>> > > > for all opteron systems.
>> > >
>> > > i checked that bit
>> > >
>> > >
> http://www.openbios.org/viewvc/trunk/LinuxBIOSv2/src/northbridge/amd/amdk8/coherent_ht.c?revision=2596&view=markup
> <snip>
>> > 
>> > it should be bit 18 (HTTC_APIC_EXT_ID)
>> > 
>> > 
>> > YH
>> 
>> this seems reasonable, I can reroll the patch for this.  As I think about it
> I'm
>> also going to update the patch to make this check occur for any pci class 0600
>> device from vendor AMD, since its possible that more than just nvidia chipsets
>> can be affected.
>> 
>> I'll repost as soon as I've tested, thanks!
>> Neil
>
>
> Ok, New patch attached.  It preforms the same function as previously described,
> but is more restricted in its application.  As Yinghai pointed out, the
> broadcast mask bit (bit 17 in the htcfg register) should only be enabled, if the
> extened apic id bit (bit 18 in the same register) is also set.  So this patch
> now check for that bit to be turned on first.  Also, this patch now adds an
> independent quirk check for all AMD hypertransport host controllers, since its
> possible for this misconfiguration to be present in systems other than nvidias.
> The net effect of these changes is, that its now applicable to all AMD systems
> containing hypertransport busses, and is only activated if extended apic ids are
> in use, meaning that this quirk guarantees that all processors in a system are
> elligible to receive interrupts from the ioapic, even if their apicid extends
> beyond the nominal 4 bit limitation.  Tested successfully by me.
>
> Thanks & Regards
> Neil
>
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
>
>
>  early-quirks.c | 83 ++++++++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 76 insertions(+), 7 deletions(-)
>
>
>
> diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
> index 88bb83e..d5a7b30 100644
> --- a/arch/x86/kernel/early-quirks.c
> +++ b/arch/x86/kernel/early-quirks.c
> @@ -44,6 +44,50 @@ static int __init nvidia_hpet_check(struct acpi_table_header
> *header)
>  #endif /* CONFIG_X86_IO_APIC */
>  #endif /* CONFIG_ACPI */
>  
> +static void __init fix_hypertransport_config(int num, int slot, int func)
> +{
> +	u32 htcfg;
> +	/*
> +	 *we found a hypertransport bus
> +	 *make sure that are broadcasting
> +	 *interrupts to all cpus on the ht bus
> +	 *if we're using extended apic ids
> +	 */
> +	htcfg = read_pci_config(num, slot, func, 0x68);
> +	if ((htcfg & (1 << 18)) == 1) {	

Ok.  This test is broken.  Please remove the == 1.  You are looking
for == (1 << 18).  So just saying: "if (htcfg & (1 << 18))" should be clearer.

> + printk(KERN_INFO "Detected use of extended apic ids on hypertransport bus\n");
> +		if ((htcfg & (1 << 17)) == 0) {
> + printk(KERN_INFO "Enabling hypertransport extended apic interrupt
> broadcast\n");
> +			htcfg |= (1 << 17);
> +			write_pci_config(num, slot, func, 0x68, htcfg);
> +		}
> +	}
> +	
> +}

The rest of this quirk looks fine, include the fact it is only intended
to be applied to PCI_VENDOR_ID_AMD PCI_DEVICE_ID_AMD_K8_NB.


For what is below I don't like the way the infrastructure has been
extended as what you are doing quickly devolves into a big mess.

Please extend struct chipset to be something like:
struct chipset {
	u16 vendor;
	u16 device;
        u32 class, class_mask;
	void (*f)(void);
};

And then the test for matching the chipset can be something like:
	if ((id->vendor == PCI_ANY_ID || id->vendor == dev->vendor) &&
	    (id->device == PCI_ANY_ID || id->device == dev->device) &&
	    !((id->class ^ dev->class) & id->class_mask))

Essentially a subset of pci_match_one_device from drivers/pci/pci.h

That way you don't need to increase the number of tables or the
number of passes through the pci busses, just update the early_qrk
table with a few more bits of information.

The extended form should be much more maintainable in the long
run.  Given that we may want this before we enable the timer
which is very early doing this in the pci early quirks seems
to make sense.

Eric
