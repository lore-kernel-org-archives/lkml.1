Return-Path: <linux-kernel-owner+w=401wt.eu-S1752368AbZGPE0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbZGPE0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 00:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbZGPEZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 00:25:59 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:48100 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbZGPEZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 00:25:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fvY8SkYLzgy2peJy51Wm3W/vSb1zssrrkLXwX/zcKMa6OhSj8OsyFj/b/FjESiyX4D
         bZRjYqOjHtiCjCojGsp8CcrNMM4CDpHkqwx6omMvhJeLstU4UwnZP5Z0rLLLWwsWPyps
         cXZ52MvMIN54+VkaHotegDVIUt8iqxOPqNACQ=
MIME-Version: 1.0
In-Reply-To: <20090714153509.51bbec27@lxorguk.ukuu.org.uk>
References: <1247576250-16274-1-git-send-email-tiago.vignatti@nokia.com>
	 <1247576250-16274-2-git-send-email-tiago.vignatti@nokia.com>
	 <20090714153509.51bbec27@lxorguk.ukuu.org.uk>
Date: Thu, 16 Jul 2009 14:25:55 +1000
Message-ID: <21d7e9970907152125i52dc3f4dqd540f7d65667cfb5@mail.gmail.com>
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

Hi Alan,

some hopeful answers,


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

well here we just bang on device config space registers which means we
can probably
race against lots of other things that rmw the PCI_COMMAND not just hotplug.

Perhaps we need some sort per device PCI command space lock,
granted this still means we race against anyone directly hacking it
behind our backs.

As for the bridge settings, it sounds like we need to have a per
bridge pci spinlock
if hotplug is also doing this.

>
>
>> +     /* The one who calls us should check for this, but lets be sure... */
>> +     if (pdev == NULL)
>> +             pdev = vga_default_device();
>
> What if the BIOS provided device was hot unplugged ?

we just use the pdev as a cookie, if it was hot unplugged we'll
have gotten a callback to remove it from the VGA device list
and the lookup which happens 5 lines later inside the spinlock
will fail.

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
>
>> +              * kick each time some resources are released, but it would
>> +              * be fairly easy to have a per device one so that we only
>> +              * need to attach to the conflicting device
>> +              */
>> +             init_waitqueue_entry(&wait, current);
>> +             add_wait_queue(&vga_wait_queue, &wait);
>> +             set_current_state(interruptible ?
>> +                               TASK_INTERRUPTIBLE :
>> +                               TASK_UNINTERRUPTIBLE);
>> +             if (signal_pending(current)) {
>> +                     rc = -EINTR;
>> +                     break;
>> +             }
>> +             schedule();
>> +             remove_wait_queue(&vga_wait_queue, &wait);
>> +             set_current_state(TASK_RUNNING);
>
> Seems a very long winded way to write
>
>        wait_event_interruptible(...)

Is it? it looks close to wait_event_interruptible(vga_wait_queue, 1);
maybe __wait_even_interruptible(vga_wait_queue, 1)

maybe we can restructure the whole locking above to make it
more like a simple condition.

>
>
>> +     /* Allocate structure */
>> +     vgadev = kmalloc(sizeof(struct vga_device), GFP_KERNEL);
>> +     if (vgadev == NULL) {
>> +             /* What to do on allocation failure ? For now, let's
>> +              * just do nothing, I'm not sure there is anything saner
>> +              * to be done
>> +              */
>
> If this is an "oh dear" moment then at least printk something
>

Cool, fixed that one.


>>
>> +     /* Set the client' lists of locks */
>> +     priv->target = vga_default_device(); /* Maybe this is still null! */
>
> PCI device refcounting ?

Again its just used a cookie for a later lookup in our vgadev array,
its gone away it'll have been removed from the array,

We could use pci_dev_get/pci_dev_put I suppose but its only used as
a cookie so far.

Dave.
