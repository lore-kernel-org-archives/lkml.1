Return-Path: <linux-kernel-owner+w=401wt.eu-S1763502AbXESMOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763502AbXESMOT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 08:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761330AbXESMOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 08:14:00 -0400
Received: from imf16aec.mail.bellsouth.net ([205.152.59.64]:58265 "EHLO
	imf16aec.mail.bellsouth.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760832AbXESMN6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 08:13:58 -0400
Date: Sat, 19 May 2007 07:13:55 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
To: Tejun Heo <htejun@gmail.com>
Cc: Greg K-H <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       =?UTF-8?B?TWF0w63CrWFz?= Alejandro Torres <torresmat@gmail.com>
Subject: Re: [PATCH] pci-quirks: disable MSI on RS400-200 and RS480, take #2
Message-ID: <20070519071355.4a7617e2@osprey.hogchain.net>
In-Reply-To: <4641BD26.1020501@gmail.com>
References: <4641BD26.1020501@gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Can someone (Greg K-H?) tell me the status of the below patch?  Is it
planned for 2.6.22?  It looks like a useful generic "let's disable msi
on board x" that I might want to use for the atl1 network driver.

Thanks,
Jay

On Wed, 09 May 2007 14:23:02 +0200
Tejun Heo <htejun@gmail.com> wrote:

> MSI doesn't work on RS400-200 and RS480 requiring pci=nomsi kernel
> boot parameter for ahci to work.  This patch renames quirk_svw_msi()
> to quirk_disable_all_msi() and use it to disable MSI on those chips.
> 
>   http://thread.gmane.org/gmane.linux.ide/17820
>   http://thread.gmane.org/gmane.linux.ide/17516
>   https://bugzilla.novell.com/show_bug.cgi?id=263893
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: Matí­as Alejandro Torres <torresmat@gmail.com>
> ---
> Okay, this is the fixed version and should probably included in
> -stable too as there have been quite some number of reports which got
> resolved by adding 'pci=nomsi'.  Verified by Matí­as Alejandro Torres.
> 
> Thanks.
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 3411483..1e3070e 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -1624,18 +1624,20 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_N
>  			quirk_nvidia_ck804_pcie_aer_ext_cap);
>  
>  #ifdef CONFIG_PCI_MSI
> -/* The Serverworks PCI-X chipset does not support MSI. We cannot
> easily rely
> - * on setting PCI_BUS_FLAGS_NO_MSI in its bus flags because there
> are actually
> - * some other busses controlled by the chipset even if Linux is not
> aware of it.
> - * Instead of setting the flag on all busses in the machine, simply
> disable MSI
> - * globally.
> +/* Some chipsets do not support MSI. We cannot easily rely on setting
> + * PCI_BUS_FLAGS_NO_MSI in its bus flags because there are actually
> + * some other busses controlled by the chipset even if Linux is not
> + * aware of it.  Instead of setting the flag on all busses in the
> + * machine, simply disable MSI globally.
>   */
> -static void __init quirk_svw_msi(struct pci_dev *dev)
> +static void __init quirk_disable_all_msi(struct pci_dev *dev)
>  {
>  	pci_no_msi();
>  	printk(KERN_WARNING "PCI: MSI quirk detected. MSI
> deactivated.\n"); }
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS,
> PCI_DEVICE_ID_SERVERWORKS_GCNB_LE, quirk_svw_msi);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS,
> PCI_DEVICE_ID_SERVERWORKS_GCNB_LE, quirk_disable_all_msi);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI,
> PCI_DEVICE_ID_ATI_RS400_200, quirk_disable_all_msi);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480,
> quirk_disable_all_msi); /* Disable MSI on chipsets that are known to
> not support it */ static void __devinit quirk_disable_msi(struct
> pci_dev *dev) - To unsubscribe from this list: send the line
> "unsubscribe linux-kernel" in the body of a message to
> majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html Please read the FAQ at
> http://www.tux.org/lkml/
