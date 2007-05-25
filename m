Return-Path: <linux-kernel-owner+w=401wt.eu-S932207AbXEYVrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207AbXEYVrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 17:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932155AbXEYVrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 17:47:01 -0400
Received: from iona.labri.fr ([147.210.8.143]:43754 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932145AbXEYVq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 17:46:59 -0400
Message-ID: <46575957.8080905@ens-lyon.org>
Date: Fri, 25 May 2007 23:47:03 +0200
From: Brice Goglin <Brice.Goglin@ens-lyon.org>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Jay Cliburn <jacliburn@bellsouth.net>,
       Grzegorz Krzystek <ninex@NineX.eu.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       ninex@o2.pl, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Michael Ellerman <michael@ellerman.id.au>,
       David Miller <davem@davemloft.net>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 1/2] msi: Invert the sense of the MSI enables.
References: <200705122146.l4CLkH6q012322@fire-2.osdl.org>	<m1mz09p1t7.fsf@ebiederm.dsl.xmission.com>	<20070513014622.c5702928.akpm@linux-foundation.org>	<46470209.9000502@bellsouth.net> <46470515.50000@NineX.eu.org>	<464707F7.6080600@bellsouth.net>	<m1irawpwy2.fsf@ebiederm.dsl.xmission.com>	<20070513204407.7ba35010@osprey.hogchain.net>	<4647FA38.3090108@NineX.eu.org> <46480EA5.40400@NineX.eu.org>	<20070514053406.478bf93f@osprey.hogchain.net>	<m1d513oddj.fsf@ebiederm.dsl.xmission.com>	<20070514093829.377e04bc@osprey.hogchain.net>	<m18xbrnyxi.fsf@ebiederm.dsl.xmission.com>	<20070514160005.627435e3@osprey.hogchain.net>	<m1odkmmft4.fsf@ebiederm.dsl.xmission.com>	<20070515212200.517fcba2@osprey.hogchain.net>	<m14pmcmz8r.fsf@ebiederm.dsl.xmission.com>	<20070516185225.3f3ac082@osprey.hogchain.net>	<m1sl9wl28m.fsf@ebiederm.dsl.xmission.com>	<20070522204103.134bf5a2@osprey.hogchain.net> <m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com>
In-Reply-To: <m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> @@ -1677,43 +1650,16 @@ static int __devinit msi_ht_cap_enabled(struct pci_dev *dev)
>  	return 0;
>  }
>  
> -/* Check the hypertransport MSI mapping to know whether MSI is enabled or not */
> +/* Enable MSI on hypertransport chipsets supporting MSI */
>  static void __devinit quirk_msi_ht_cap(struct pci_dev *dev)
>  {
> -	if (dev->subordinate && !msi_ht_cap_enabled(dev)) {
> -		printk(KERN_WARNING "PCI: MSI quirk detected. "
> -		       "MSI disabled on chipset %s.\n",
> -		       pci_name(dev));
> -		dev->subordinate->bus_flags |= PCI_BUS_FLAGS_NO_MSI;
> +	if (dev->subordinate && msi_ht_cap_enabled(dev)) {
> +		printk(KERN_INFO "PCI: Enabled MSI on chipset %s.\n",
> +			pci_name(dev));
> +		dev->subordinate->bus_flags |= PCI_BUS_FLAGS_MSI;
>  	}
>  }
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_HT2000_PCIE,
> -			quirk_msi_ht_cap);
> +DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, quirk_msi_ht_cap);
>  
> -/* The nVidia CK804 chipset may have 2 HT MSI mappings.
> - * MSI are supported if the MSI capability set in any of these mappings.
> - */
> -static void __devinit quirk_nvidia_ck804_msi_ht_cap(struct pci_dev *dev)
> -{
> -	struct pci_dev *pdev;
> -
> -	if (!dev->subordinate)
> -		return;
>  
> -	/* check HT MSI cap on this chipset and the root one.
> -	 * a single one having MSI is enough to be sure that MSI are supported.
> -	 */
> -	pdev = pci_get_slot(dev->bus, 0);
> -	if (!pdev)
> -		return;
> -	if (!msi_ht_cap_enabled(dev) && !msi_ht_cap_enabled(pdev)) {
> -		printk(KERN_WARNING "PCI: MSI quirk detected. "
> -		       "MSI disabled on chipset %s.\n",
> -		       pci_name(dev));
> -		dev->subordinate->bus_flags |= PCI_BUS_FLAGS_NO_MSI;
> -	}
> -	pci_dev_put(pdev);
> -}
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_CK804_PCIE,
> -			quirk_nvidia_ck804_msi_ht_cap);
>   

Are you sure that calling quirk_msi_ht_cap() on all devices will really
replace my nVidia CK804 specific quirk above?

I haven't looked at all this for a while, but if I remember correctly,
the PCI hierarchy with an AMD8131 and a CK804 looks like the following.

-+-[08]-+-0a.0-[09]--
 \-[00]-+-00.0
        +-0e.0-[02]--


The HT MSI mapping of the CK804 may be either on device 00.0 (10de:005e)
and 0e.0 (10de:005d). The devices that are physically behind the CK804
chipset are on bus 02.

To get MSI enabled for these devices, the MSI flag should be set either
on bus 00 (looks impossible here) or on bus 02 (if the HT MSI mapping is
found on 0e.0). However, if the MSI mapping is found on device 00.0, I
don't see your code could enable MSI behind on bus 02.

Brice

