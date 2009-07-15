Return-Path: <linux-kernel-owner+w=401wt.eu-S1751746AbZGOEnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbZGOEnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 00:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbZGOEnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 00:43:40 -0400
Received: from mail-yw0-f203.google.com ([209.85.211.203]:37499 "EHLO
	mail-yw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbZGOEnk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 00:43:40 -0400
X-Greylist: delayed 19091 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Jul 2009 00:43:39 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SNp4BECQKXNaieXVi2LTSlRPZ5kZgdqkkLNs9PJrJu/hgMSMWfY19BtVcguKDn8alE
         mGaID1S3FyOm5zxKu04uR4Pt/SR+m7QPNlqzY12gfOuc9RMRU+k/1bFN205SzkEApvT3
         /uZ3qpnVaetxc9dZ6+/behbuB42UR2GrnH8xY=
MIME-Version: 1.0
In-Reply-To: <20090714153509.51bbec27@lxorguk.ukuu.org.uk>
References: <1247576250-16274-1-git-send-email-tiago.vignatti@nokia.com>
	 <1247576250-16274-2-git-send-email-tiago.vignatti@nokia.com>
	 <20090714153509.51bbec27@lxorguk.ukuu.org.uk>
Date: Wed, 15 Jul 2009 14:43:38 +1000
Message-ID: <21d7e9970907142143y5e289ffdld0cfd73ef0106953@mail.gmail.com>
Subject: Re: [PATCH 1/2] vga: implements VGA arbitration on Linux
From: Dave Airlie <airlied@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tiago Vignatti <tiago.vignatti@nokia.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Dave Airlie <airlied@redhat.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 12:35 AM, Alan Cox<alan@lxorguk.ukuu.org.uk> wrote:
>> +#ifndef __ARCH_HAS_VGA_ENABLE_RESOURCES
>> +static inline void vga_enable_resources(struct pci_dev *pdev,
>> +                                     unsigned int rsrc)
>> +{
>> +     struct pci_bus *bus;
>> +     struct pci_dev *bridge;
>> +     u16 cmd;
>> +
>> +#ifdef DEBUG
>> +     printk(KERN_DEBUG "%s\n", __func__);
>> +#endif
>> +     pci_read_config_word(pdev, PCI_COMMAND, &cmd);
>> +     if (rsrc & (VGA_RSRC_LEGACY_IO | VGA_RSRC_NORMAL_IO))
>> +             cmd |= PCI_COMMAND_IO;
>> +     if (rsrc & (VGA_RSRC_LEGACY_MEM | VGA_RSRC_NORMAL_MEM))
>> +             cmd |= PCI_COMMAND_MEMORY;
>> +     pci_write_config_word(pdev, PCI_COMMAND, cmd);
>
> Locking question - what locks this lot against hotplug also touching
> bridge settings ?
>
>> +
>> +     if (!(rsrc & VGA_RSRC_LEGACY_MASK))
>> +             return;
>> +
>> +     bus = pdev->bus;
>> +     while (bus) {
>> +             bridge = bus->self;
>> +             if (bridge) {
>> +                     pci_read_config_word(bridge, PCI_BRIDGE_CONTROL,
>> +                                          &cmd);
>> +                     if (!(cmd & PCI_BRIDGE_CTL_VGA)) {
>> +                             cmd |= PCI_BRIDGE_CTL_VGA;
>> +                             pci_write_config_word(bridge,
>> +                                                   PCI_BRIDGE_CONTROL,
>> +                                                   cmd);
>> +                     }
>> +             }
>> +             bus = bus->parent;
>> +     }
>> +}
>> +#endif
>
>
>> +     /* The one who calls us should check for this, but lets be sure... */
>> +     if (pdev == NULL)
>> +             pdev = vga_default_device();
>
> What if the BIOS provided device was hot unplugged ?
>
>> +             conflict = __vga_tryget(vgadev, rsrc);
>> +             spin_unlock_irqrestore(&vga_lock, flags);
>> +             if (conflict == NULL)
>> +                     break;
>> +
>> +
>> +             /* We have a conflict, we wait until somebody kicks the
>> +              * work queue. Currently we have one work queue that we
>
> If two drivers own half the resources and both are waiting for the rest
> what handles the deadlock

I'm not sure we should care about resource locking granularity below,
I have all resources, I have no resources, I don't think we gain anything
by it, since really we want to avoid using vga arb as much as we can.

Tiago, the other issue I noticed when using this is we need to provide
 a hook for drm drivers that use an irq to have the irq disabled around
the mem/io space disables otherwise they can get an irq with no mem/io
and boom all fall down.

Old X userspace RAC never worried about interrupts and assumed the
GPU wasn't using one which was true in the 80s.

Dave.
