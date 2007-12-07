Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbXLGUS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbXLGUS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 15:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbXLGUSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 15:18:18 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:2307 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbXLGUSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 15:18:17 -0500
Date: Fri, 7 Dec 2007 15:13:33 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: yhlu <yinghailu@gmail.com>
Cc: Ben Woodard <woodard@redhat.com>, Neil Horman <nhorman@redhat.com>,
       kexec@lists.infradead.org, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       Andi Kleen <andi@firstfloor.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Vivek Goyal <vgoyal@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on
	boot cpu
Message-ID: <20071207201333.GC18485@hmsreliant.think-freely.org>
References: <20071130144250.GC23810@redhat.com> <20071130145131.GB5822@hmsendeavour.rdu.redhat.com> <20071206213951.GB28898@hmsreliant.think-freely.org> <20071206221143.GC2863@redhat.com> <m1bq93s5r8.fsf@ebiederm.dsl.xmission.com> <86802c440712070050s3c5017a4w8e747a7035d10d3a@mail.gmail.com> <86802c440712070122q6e5824bcp12e1c3f560e2ab53@mail.gmail.com> <20071207142144.GA10389@hmsendeavour.rdu.redhat.com> <20071207175832.GA18485@hmsreliant.think-freely.org> <2ea3fae10712071119h7c169b6egd9a7046eab1f136b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ea3fae10712071119h7c169b6egd9a7046eab1f136b@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2007 at 11:19:10AM -0800, yhlu wrote:
> On Dec 7, 2007 9:58 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
> > On Fri, Dec 07, 2007 at 09:21:44AM -0500, Neil Horman wrote:
> > > On Fri, Dec 07, 2007 at 01:22:04AM -0800, Yinghai Lu wrote:
> > > > On Dec 7, 2007 12:50 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > > > >
> > > > > On Dec 6, 2007 4:33 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> > > > ...
> > > > > >
> > > > > > My feel is that if it is for legacy interrupts only it should not be a problem.
> > > > > > Let's investigate and see if we can unconditionally enable this quirk
> > > > > > for all opteron systems.
> > > > >
> > > > > i checked that bit
> > > > >
> > > > > http://www.openbios.org/viewvc/trunk/LinuxBIOSv2/src/northbridge/amd/amdk8/coherent_ht.c?revision=2596&view=markup
> > <snip>
> > > >
> > > > it should be bit 18 (HTTC_APIC_EXT_ID)
> > > >
> > > >
> > > > YH
> > >
> > > this seems reasonable, I can reroll the patch for this.  As I think about it I'm
> > > also going to update the patch to make this check occur for any pci class 0600
> > > device from vendor AMD, since its possible that more than just nvidia chipsets
> > > can be affected.
> > >
> > > I'll repost as soon as I've tested, thanks!
> > > Neil
> >
> >
> > Ok, New patch attached.  It preforms the same function as previously described,
> > but is more restricted in its application.  As Yinghai pointed out, the
> > broadcast mask bit (bit 17 in the htcfg register) should only be enabled, if the
> > extened apic id bit (bit 18 in the same register) is also set.  So this patch
> > now check for that bit to be turned on first.  Also, this patch now adds an
> > independent quirk check for all AMD hypertransport host controllers, since its
> > possible for this misconfiguration to be present in systems other than nvidias.
> > The net effect of these changes is, that its now applicable to all AMD systems
> > containing hypertransport busses, and is only activated if extended apic ids are
> > in use, meaning that this quirk guarantees that all processors in a system are
> > elligible to receive interrupts from the ioapic, even if their apicid extends
> > beyond the nominal 4 bit limitation.  Tested successfully by me.
> >
> > Thanks & Regards
> > Neil
> >
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> >
> >
> >  early-quirks.c |   83 ++++++++++++++++++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 76 insertions(+), 7 deletions(-)
> >
> >
> >
> > diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
> > index 88bb83e..d5a7b30 100644
> > --- a/arch/x86/kernel/early-quirks.c
> > +++ b/arch/x86/kernel/early-quirks.c
> > @@ -44,6 +44,50 @@ static int __init nvidia_hpet_check(struct acpi_table_header *header)
> >  #endif /* CONFIG_X86_IO_APIC */
> >  #endif /* CONFIG_ACPI */
> >
> > +static void __init fix_hypertransport_config(int num, int slot, int func)
> > +{
> > +       u32 htcfg;
> > +       /*
> > +        *we found a hypertransport bus
> > +        *make sure that are broadcasting
> > +        *interrupts to all cpus on the ht bus
> > +        *if we're using extended apic ids
> > +        */
> > +       htcfg = read_pci_config(num, slot, func, 0x68);
> > +       if ((htcfg & (1 << 18)) == 1) {
> > +               printk(KERN_INFO "Detected use of extended apic ids on hypertransport bus\n");
> > +               if ((htcfg & (1 << 17)) == 0) {
> > +                       printk(KERN_INFO "Enabling hypertransport extended apic interrupt broadcast\n");
> > +                       htcfg |= (1 << 17);
> > +                       write_pci_config(num, slot, func, 0x68, htcfg);
> > +               }
> > +       }
> > +
> > +}
> > +
> > +static void __init check_hypertransport_config()
> > +{
> > +       int num, slot, func;
> > +       u32 device, vendor;
> > +       func = 0;
> > +       for (num = 0; num < 32; num++) {
> > +               for (slot = 0; slot < 32; slot++) {
> > +                       vendor = read_pci_config(num,slot,func,
> > +                                               PCI_VENDOR_ID);
> > +                       device = read_pci_config(num,slot,func,
> > +                                               PCI_DEVICE_ID);
> > +                       vendor &= 0x0000ffff;
> > +                       device >>= 16;
> > +                       if ((vendor == PCI_VENDOR_ID_AMD) &&
> > +                           (device == PCI_DEVICE_ID_AMD_K8_NB))
> > +                               fix_hypertransport_config(num,slot,func);
> > +               }
> > +       }
> > +
> > +       return;
> > +
> > +}
> > +
> >  static void __init nvidia_bugs(void)
> >  {
> >  #ifdef CONFIG_ACPI
> > @@ -83,6 +127,12 @@ static void __init ati_bugs(void)
> >  #endif
> >  }
> >
> > +static void __init amd_host_bugs(void)
> > +{
> > +       printk(KERN_CRIT "IN AMD_HOST_BUGS\n");
> > +       check_hypertransport_config();
> > +}
> > +
> >  struct chipset {
> >         u16 vendor;
> >         void (*f)(void);
> > @@ -95,9 +145,16 @@ static struct chipset early_qrk[] __initdata = {
> >         {}
> >  };
> >
> > +static struct chipset early_host_qrk[] __initdata = {
> > +       { PCI_VENDOR_ID_AMD, amd_host_bugs},
> > +       {}
> > +};
> > +
> >  void __init early_quirks(void)
> >  {
> >         int num, slot, func;
> > +       u8 found_bridge = 0;
> > +       u8 found_host = 0;
> >
> >         if (!early_pci_allowed())
> >                 return;
> > @@ -115,18 +172,30 @@ void __init early_quirks(void)
> >                                 if (class == 0xffffffff)
> >                                         break;
> >
> > -                               if ((class >> 16) != PCI_CLASS_BRIDGE_PCI)
> > +                               class >>= 16;
> > +                               if ((class != PCI_CLASS_BRIDGE_PCI) &&
> > +                                   (class != PCI_CLASS_BRIDGE_HOST))
> >                                         continue;
> >
> >                                 vendor = read_pci_config(num, slot, func,
> >                                                          PCI_VENDOR_ID);
> >                                 vendor &= 0xffff;
> > -
> > -                               for (i = 0; early_qrk[i].f; i++)
> > -                                       if (early_qrk[i].vendor == vendor) {
> > -                                               early_qrk[i].f();
> > -                                               return;
> > -                                       }
> > +                               if ((class == PCI_CLASS_BRIDGE_PCI) && (!found_bridge)) {
> > +                                       for (i = 0; early_qrk[i].f; i++)
> > +                                               if (early_qrk[i].vendor == vendor) {
> > +                                                       early_qrk[i].f();
> > +                                                       found_bridge = 1;;
> > +                                               }
> > +                               } else if (!found_host) {
> > +                                       for (i = 0; early_host_qrk[i].f; i++)
> > +                                               if (early_host_qrk[i].vendor == vendor) {
> > +                                                       early_host_qrk[i].f();
> > +                                                       found_host = 1;
> > +                                               }
> > +                               }
> > +
> > +                               if (found_bridge && found_host)
> > +                                       return;
> >
> >                                 type = read_pci_config_byte(num, slot, func,
> >                                                             PCI_HEADER_TYPE);
> >
> >
> 
> 1. k8 northbridge always on bus 00, and dev0x18~dev0x1f, some time
> later it could be on bus 0xff
> 2. need to check for first node (BSP) bit 18 and bit 17 is already
> set, then don't need to go wild to check and set all over the bus.
> 
Not really sure what you're saying here.  I understand that the k8 northbridge
will for the forseeable future be on bus 00, but why not look for all ht hosts?
If we find an ht host, and bit 18 is set while bit 17 is not, we can safely
correct it.

Neil

> YH
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
