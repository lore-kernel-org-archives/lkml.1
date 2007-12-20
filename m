Return-Path: <linux-kernel-owner+w=401wt.eu-S1762147AbXLTM0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762147AbXLTM0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759946AbXLTM0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:26:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719AbXLTM0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:26:23 -0500
Message-ID: <476A5F69.2030501@redhat.com>
Date: Thu, 20 Dec 2007 07:26:17 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: [Fwd: Re: [PATCH 4/5]PCI: x86 MMCONFIG: introduce pcibios_fix_bus_scan()]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-------- Original Message --------
Subject: Re: [PATCH 4/5]PCI: x86 MMCONFIG: introduce pcibios_fix_bus_scan()
Date: Wed, 19 Dec 2007 19:17:42 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
To: Greg KH <gregkh@suse.de>
References: 
<20071219221746.20362.39243.sendpatchset@dhcp83-188.boston.redhat.com> 
<20071219221806.20362.25964.sendpatchset@dhcp83-188.boston.redhat.com> 
<20071219231032.GC24219@suse.de>

Greg,

First, let me thank you for your prompt replies!

Greg KH wrote:
> On Wed, Dec 19, 2007 at 05:18:06PM -0500, tcamuso@redhat.com wrote:
>> commit ab28e1157e970f711c8451b66b3f940ec092db9d
>> Author: Tony Camuso <tony.camuso@hp.com>
>> Date:   Wed Dec 19 15:51:48 2007 -0500
>>
>>     Introduces the x86 arch-specific routine that will determine whether
>>     a device responds correctly to MMCONFIG accesses. This routine is
>>     given the generic name pcibios_fix_bus_scan_quirk()
>>     
>>     The comment at the top of the routine explains its logic.
>>     
>>     Signed-off-by: Tony Camuso tony.camuso@hp.com
>>
>> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
>> index 8627463..9b1742d 100644
>> --- a/arch/x86/pci/common.c
>> +++ b/arch/x86/pci/common.c
>> @@ -525,3 +525,64 @@ struct pci_bus *pci_scan_bus_with_sysdata(int busno)
>>  
>>  	return bus;
>>  }
>> +
>> +/**
>> + * This routine traps devices not correctly responding to MMCONFIG access.
>> + * For each device on the current bus, compare a mmconf read of the
>> + * vendor/device dword with a legacy PCI config read. If they're not the same,
>> + * the bus serving this device must use legacy PCI config accesses instead of
>> + * mmconf, as must all buses descending from this bus.
>> + */
>> +
>> +#define CHECK_MMCFG_STR_1 \
>> +	"PCI: Device at %04x:%02x.%02x.%x is not MMCONFIG compliant.\n"
>> +#define CHECK_MMCFG_STR_2 \
>> +	"PCI: Bus %04x:%02x and its descendents cannot use MMCONFIG.\n"
> 
> Why define these if they are only used in one place?

If you object, I will be happy to move them into the routine body
without the defines. I agree that It does look inconsistent to have
these strings defined and other strings embedded in the routine body.

> 
> Also, as you use dev_info(), I think you are duplicating some of the
> information in the resulting printk(), right?
> 
Actually, no. The strings do not contain redundant info. The pr_info
routine is just a macro for printk(KERN_INFO ...)

>> +
>> +void __devinit pcibios_fix_bus_scan_quirk(struct pci_bus *bus)
>> +{
>> +	int devfn;
>> +	int fail;
>> +	int found_nommconf_dev = 0;
>> +	static int advised;
>> +	u32 mcfg_vendev;
>> +	u32 arch_vendev;
>> +	struct pci_ops *save_ops = bus->ops;
>> +
>> +	if (bus->parent != NULL)
>> +		if (bus->parent->ops == &pci_legacy_ops)
>> +			return;
>> +
>> +	if (!advised) {
>> +		pr_info("PCI: If a device isn't working, try \"pci=nommconf\". "
>> +			"If that helps, please post a report.\n");
> 
> Post a report where?  Who is going to handle these reports?
> 
> The last time someone put a line like this in the kernel, I got a ton of
> email and didn't know what to do with it.  If you really are trusting of
> this patch, please put your email address in this printk(), so that you
> can properly handle the resulting reports.  I sure don't want to :)

Hmmm! Good point! I was actually copying that other message. I will
remove the string that advises posting a report. I sure don't want 'em,
and I can see that you don't, either.
:)

> 
>> +		advised = 1;
>> +	}
>> +	pr_debug("PCI: Checking bus %04x:%02x for MMCONFIG compliance.\n",
>> +		 pci_domain_nr(bus), bus->number);
>> +
>> +	for (devfn = 0; devfn < 256; devfn++) {
>> +		bus->ops = &pci_legacy_ops;
>> +		fail = (pci_bus_read_config_dword(bus, devfn, PCI_VENDOR_ID,
>> +						  &arch_vendev));
> 
> What's with the extra () around the function?

The function call used to be contained in an if statement.
I changed the logic, but forgot to remove the extra parens.
It's tough getting old.
:}

> 
>> +		if ((arch_vendev == 0xFFFFFFFF) || (arch_vendev == 0) || fail)
>> +			continue;
>> +
>> +		bus->ops = save_ops;	/* Restore to original value */
>> +		pci_bus_read_config_dword(bus, devfn, PCI_VENDOR_ID,
>> +					  &mcfg_vendev);
>> +		if (mcfg_vendev != arch_vendev) {
>> +			found_nommconf_dev = 1;
>> +			break;
>> +		}
>> +	}
>> +
>> +	if (found_nommconf_dev) {
>> +		pr_info(CHECK_MMCFG_STR_1, pci_domain_nr(bus), bus->number,
>> +			PCI_SLOT(devfn), PCI_FUNC(devfn));
>> +		pr_info(CHECK_MMCFG_STR_2, pci_domain_nr(bus), bus->number);
>> +		bus->ops = &pci_legacy_ops;	/* Use Legace PCI Config */
> 
> Spelling check for your comments :)
> 
> thanks,
> 
> greg k-h

Oops Legace ... too much language confusion in my life ... portugues ...
italian ... oi ...


