Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbXLKGb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbXLKGb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 01:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbXLKGbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 01:31:22 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:24027 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbXLKGbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 01:31:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CPG2S8JEOZX4gOPunA8jdSrAAgv1j9zASVuRk+aReVYqvK5KUbA4H4ud4cjQ9DuaF3Hr9mPpMjlatbyOgSKj7s1PnqtuvUmqM393wQ+QyhuCOl2IEG7+z8UqCfLX51PSGjqgvduCRLI76X10VSN9qguAHPaBxEmdFQfwV3q7cSk=
Message-ID: <86802c440712102231v230fc96eqe5144f6c3b36a924@mail.gmail.com>
Date: Mon, 10 Dec 2007 22:31:19 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
Cc: "Neil Horman" <nhorman@tuxdriver.com>, "Neil Horman" <nhorman@redhat.com>,
       "Ben Woodard" <woodard@redhat.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>,
       hbabu@us.ibm.com, "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <m1ejdt25x0.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071130144250.GC23810@redhat.com>
	 <20071206221143.GC2863@redhat.com>
	 <m1bq93s5r8.fsf@ebiederm.dsl.xmission.com>
	 <86802c440712070050s3c5017a4w8e747a7035d10d3a@mail.gmail.com>
	 <86802c440712070122q6e5824bcp12e1c3f560e2ab53@mail.gmail.com>
	 <20071207142144.GA10389@hmsendeavour.rdu.redhat.com>
	 <20071207175832.GA18485@hmsreliant.think-freely.org>
	 <m1k5nm2g3w.fsf@ebiederm.dsl.xmission.com>
	 <20071211034349.GA3635@localhost.localdomain>
	 <m1ejdt25x0.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 10, 2007 8:48 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Neil Horman <nhorman@tuxdriver.com> writes:
>
> Almost there.
>
>
>
> > On Mon, Dec 10, 2007 at 06:08:03PM -0700, Eric W. Biederman wrote:
> >> Neil Horman <nhorman@tuxdriver.com> writes:
> >>
> > <snip>
> >>
> >> Ok.  This test is broken.  Please remove the == 1.  You are looking
> >> for == (1 << 18).  So just saying: "if (htcfg & (1 << 18))" should be clearer.
> >>
> > Fixed.  Thanks!
> >
> >> > + printk(KERN_INFO "Detected use of extended apic ids on hypertransport
> > bus\n");
> >> > +          if ((htcfg & (1 << 17)) == 0) {
> >> > + printk(KERN_INFO "Enabling hypertransport extended apic interrupt
> >> > broadcast\n");
> >> > +                  htcfg |= (1 << 17);
> >> > +                  write_pci_config(num, slot, func, 0x68, htcfg);
> >> > +          }
> >> > +  }
> >> > +
> >> > +}
> >>
> >> The rest of this quirk looks fine, include the fact it is only intended
> >> to be applied to PCI_VENDOR_ID_AMD PCI_DEVICE_ID_AMD_K8_NB.
> >>
> > Copy that.
> >
> >>
> >> For what is below I don't like the way the infrastructure has been
> >> extended as what you are doing quickly devolves into a big mess.
> >>
> >> Please extend struct chipset to be something like:
> >> struct chipset {
> >>      u16 vendor;
> >>      u16 device;
> >>         u32 class, class_mask;
> >>      void (*f)(void);
> >> };
> >>
> >> And then the test for matching the chipset can be something like:
> >>      if ((id->vendor == PCI_ANY_ID || id->vendor == dev->vendor) &&
> >>          (id->device == PCI_ANY_ID || id->device == dev->device) &&
> >>          !((id->class ^ dev->class) & id->class_mask))
> >>
> >> Essentially a subset of pci_match_one_device from drivers/pci/pci.h
> >>
> >> That way you don't need to increase the number of tables or the
> >> number of passes through the pci busses, just update the early_qrk
> >> table with a few more bits of information.
> >>
> > copy that.  Fixed.  Thanks!
> >
> >> The extended form should be much more maintainable in the long
> >> run.  Given that we may want this before we enable the timer
> >> which is very early doing this in the pci early quirks seems
> >> to make sense.
> >>
> >> Eric
> >
> >
> > New patch attached, with suggestions incorporated.
> >
> > Thanks & regards
> > Neil
> >
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> >
> >
> >  early-quirks.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++-------
> >  1 file changed, 73 insertions(+), 9 deletions(-)
> >
> >
> >
> > diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
> > index 88bb83e..4b0cee1 100644
> > --- a/arch/x86/kernel/early-quirks.c
> > +++ b/arch/x86/kernel/early-quirks.c
> > @@ -44,6 +44,50 @@ static int __init nvidia_hpet_check(struct acpi_table_header
> > *header)
> >  #endif /* CONFIG_X86_IO_APIC */
> >  #endif /* CONFIG_ACPI */
> >
> > +static void __init fix_hypertransport_config(int num, int slot, int func)
> > +{
> > +     u32 htcfg;
> > +     /*
> > +      *we found a hypertransport bus
> > +      *make sure that are broadcasting
> > +      *interrupts to all cpus on the ht bus
> > +      *if we're using extended apic ids
> > +      */
> > +     htcfg = read_pci_config(num, slot, func, 0x68);
> > +     if (htcfg & (1 << 18)) {
> > + printk(KERN_INFO "Detected use of extended apic ids on hypertransport bus\n");
> > +             if ((htcfg & (1 << 17)) == 0) {
> > + printk(KERN_INFO "Enabling hypertransport extended apic interrupt
> > broadcast\n");
> > +                     htcfg |= (1 << 17);
> > +                     write_pci_config(num, slot, func, 0x68, htcfg);
> > +             }
> > +     }
> > +
> > +}
> > +
> > +static void __init check_hypertransport_config()
> > +{
> > +     int num, slot, func;
> > +     u32 device, vendor;
> > +     func = 0;
> > +     for (num = 0; num < 32; num++) {
> > +             for (slot = 0; slot < 32; slot++) {
> > +                     vendor = read_pci_config(num,slot,func,
> > +                                             PCI_VENDOR_ID);
> > +                     device = read_pci_config(num,slot,func,
> > +                                             PCI_DEVICE_ID);
> > +                     vendor &= 0x0000ffff;
> > +                     device >>= 16;
> > +                     if ((vendor == PCI_VENDOR_ID_AMD) &&
> > +                         (device == PCI_DEVICE_ID_AMD_K8_NB))
> > +                             fix_hypertransport_config(num,slot,func);
> > +             }
> > +     }
> > +
> > +     return;
> > +
> > +}
>
> We should not need check_hypertransport_config as the generic loop
> now does the work for us.
> > +
> >  static void __init nvidia_bugs(void)
> >  {
> >  #ifdef CONFIG_ACPI
> > @@ -83,15 +127,25 @@ static void __init ati_bugs(void)
> >  #endif
> >  }
> >
> > +static void __init amd_host_bugs(void)
> > +{
> > +     printk(KERN_CRIT "IN AMD_HOST_BUGS\n");
> > +     check_hypertransport_config();
> > +}
>
> Likewise this function is unneeded and the printk is likely confusing
> for users.
>
> >  struct chipset {
> >       u16 vendor;
> > +     u16 device;
> > +     u32 class;
> > +     u32 class_mask;
> >       void (*f)(void);
> >  };
> >
> >  static struct chipset early_qrk[] __initdata = {
> > -     { PCI_VENDOR_ID_NVIDIA, nvidia_bugs },
> > -     { PCI_VENDOR_ID_VIA, via_bugs },
> > -     { PCI_VENDOR_ID_ATI, ati_bugs },
> > + { PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID, PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID,
> > nvidia_bugs },
> > + { PCI_VENDOR_ID_VIA, PCI_ANY_ID, PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, via_bugs },
> > + { PCI_VENDOR_ID_ATI, PCI_ANY_ID, PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, ati_bugs },
> > + { PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB, PCI_CLASS_BRIDGE_HOST,
> > PCI_ANY_ID, amd_host_bugs },
> >       {}
> So make that fix_hypertransport_config and we should be good.

Agreed.

struct chipset {
     u16 vendor;
    u16 device;
    u32 class;
+     u32 class_mask;
      void (*f)(void); ============> int (*f) (int num, int slot, int func);
 };

> >  };
> >
> > @@ -108,25 +162,35 @@ void __init early_quirks(void)
> >                       for (func = 0; func < 8; func++) {
> >                               u32 class;
> >                               u32 vendor;
> > +                             u32 device;
> >                               u8 type;
> >                               int i;
> > +
> >                               class = read_pci_config(num,slot,func,
> >                                                       PCI_CLASS_REVISION);
> >                               if (class == 0xffffffff)
> >                                       break;
> >
> > -                             if ((class >> 16) != PCI_CLASS_BRIDGE_PCI)
> > -                                     continue;
> > +                             class >>= 16;
>
> >
> >                               vendor = read_pci_config(num, slot, func,
> >                                                        PCI_VENDOR_ID);
> >                               vendor &= 0xffff;
> >
> > -                             for (i = 0; early_qrk[i].f; i++)
> > -                                     if (early_qrk[i].vendor == vendor) {
> > -                                             early_qrk[i].f();
> > -                                             return;
> > +                             device = read_pci_config(num, slot, func,
> > +                                                     PCI_DEVICE_ID);
> > +                             device >>= 16;
>
> We don't need to shift device.  Although we can do:
> device_vendor = read_pci_config(num, slot, func, PCI_VENDOR_ID);
> device = device_vendor >> 16;
> vendor = device_vendor & 0xffff;
>
> Assuming the early read_pci_config is limited to 32bit reads.
>
>
> > +                             for(i=0;early_qrk[i].f != NULL;i++) {
> > + if (((early_qrk[i].vendor == PCI_ANY_ID) ||
> > +                                         (early_qrk[i].vendor == vendor)) &&
> > + ((early_qrk[i].device == PCI_ANY_ID) ||
> > +                                         (early_qrk[i].device == device)) &&
> > +                                        ((early_qrk[i].class ^ class) &
> > +                                          early_qrk[i].class_mask)) {
> > +                                             early_qrk[i].f();
> >                                       }

> > +                                             early_qrk[i].f();
===>
int status;
status = early_qrk[i].f(num, slot, bus);
if (status == 1)
       break;
else if (status == 2)
       return;


YH
