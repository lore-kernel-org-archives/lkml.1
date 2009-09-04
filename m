Return-Path: <linux-kernel-owner+w=401wt.eu-S933806AbZIDRP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933806AbZIDRP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 13:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933777AbZIDRPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 13:15:22 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:60839 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933769AbZIDRPU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 13:15:20 -0400
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Sep 2009 13:15:20 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IwkFl3wl4c6OGMJwbn2j+WK5QJv7jfAF7ySl+3TOQpf6GDR2+FQCXRJl3inrKzpBW3
         4BrLGIuxxhuYLtSQ3bXqgAfs/EnhpF2Ye+oMxs7z6Q0lPQ5qCm3O8NFlDSY14vATxdCS
         /eKefHWrm+r6FSk46OSSF7EwxN4V1NV7MZihY=
MIME-Version: 1.0
In-Reply-To: <20090904165535.26294.95511.sendpatchset@t500>
References: <20090904165525.26294.31112.sendpatchset@t500>
	 <20090904165535.26294.95511.sendpatchset@t500>
Date: Fri, 4 Sep 2009 10:07:45 -0700
Message-ID: <86802c440909041007w9fee1edg49d755dc3fe627e5@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] show Intel QuickPath Interconnect Routing and 
	Protocol Layer Registers in PCI config space
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Stefan Assmann <sassmann@redhat.com>
Cc: linux-kernel@vger.kernel.org, jcm@redhat.com, sdietrich@novell.com,
       linux-acpi@vger.kernel.org, andi@firstfloor.org, hpa@zytor.com,
       mingo@elte.hu, lenb@kernel.org, ktokunag@redhat.com, tglx@linutronix.de,
       Olaf.Dabrunz@gmx.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 4, 2009 at 9:55 AM, Stefan Assmann<sassmann@redhat.com> wrote:
> On some machines with Intel X58 or Intel 55x0 chipset the Intel QuickPath
> Interconnect Routing and Protocol Layer Registers or not exposed to PCI config
> space. Access to these is necessary to disable boot interrupts in the QPI
> Protocol Interrupt Control Register.
> DEVHIDE1 provides a method to (un)hide the PCI config space of devices inside
> the IOH and is altered to guarantee that PCI config space is accessible.
> See Intel document #320838-003, sections 17.6.5.10 and 17.11.2.21.
>
> Signed-off-by: Stefan Assmann <sassmann@redhat.com>
> ---
>  drivers/pci/quirks.c    |   24 ++++++++++++++++++++++++
>  include/linux/pci_ids.h |    1 +
>  2 files changed, 25 insertions(+)
>
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -1612,6 +1612,30 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
>  DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_ESB_10,    quirk_disable_intel_boot_interrupt);
>
>  /*
> + * Show Intel QuickPath Interconnect Routing and Protocol Layer Registers
> + * in PCI config space (ensures access to QPIPINTRC).
> + * See Intel document #320838-003, sections 17.6.5.10 and 17.11.2.21.
> + */
> +#define INTEL_X58_55x0_DEVHIDE1_REG    0xf2
> +#define INTEL_X58_55x0_HIDE_DEV17_FUN0 (1<<12)
> +#define INTEL_X58_55x0_HIDE_DEV17_FUN1 (1<<13)
> +
> +static void quirk_show_intel_qpi_conf_register(struct pci_dev *dev)
> +{
> +       u16 pci_config_word;
> +
> +       pci_read_config_word(dev, INTEL_X58_55x0_DEVHIDE1_REG, &pci_config_word);
> +       pci_config_word &= ~(INTEL_X58_55x0_HIDE_DEV17_FUN0 |
> +                            INTEL_X58_55x0_HIDE_DEV17_FUN1);
> +       pci_write_config_word(dev, INTEL_X58_55x0_DEVHIDE1_REG, pci_config_word);
> +
> +       /* need to rescan the bus for changes to take effect */
> +       pci_rescan_bus(dev->bus);

better to check if those bits are set already...

can you move the quirk to EARLY to avoid rescan bus?

YH

> +}
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_IOAT_TBG9,  quirk_show_intel_qpi_conf_register);
> +DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,  PCI_DEVICE_ID_INTEL_IOAT_TBG9,  quirk_show_intel_qpi_conf_register);
> +
> +/*
>  * disable boot interrupts on HT-1000
>  */
>  #define BC_HT1000_FEATURE_REG          0x64
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2508,6 +2508,7 @@
>  #define PCI_DEVICE_ID_INTEL_IOAT_TBG5  0x342a
>  #define PCI_DEVICE_ID_INTEL_IOAT_TBG6  0x342b
>  #define PCI_DEVICE_ID_INTEL_IOAT_TBG7  0x342c
> +#define PCI_DEVICE_ID_INTEL_IOAT_TBG9  0x342e
>  #define PCI_DEVICE_ID_INTEL_IOAT_TBG0  0x3430
>  #define PCI_DEVICE_ID_INTEL_IOAT_TBG1  0x3431
>  #define PCI_DEVICE_ID_INTEL_IOAT_TBG2  0x3432
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
