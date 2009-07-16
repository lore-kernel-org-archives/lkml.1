Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZGPIsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZGPIsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 04:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbZGPIsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 04:48:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50067 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754144AbZGPIsQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 04:48:16 -0400
Date: Thu, 16 Jul 2009 09:48:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Airlie <airlied@gmail.com>
Cc: Tiago Vignatti <tiago.vignatti@nokia.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Dave Airlie <airlied@redhat.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vga: implements VGA arbitration on Linux
Message-ID: <20090716094855.455c3f77@lxorguk.ukuu.org.uk>
In-Reply-To: <21d7e9970907152125i52dc3f4dqd540f7d65667cfb5@mail.gmail.com>
References: <1247576250-16274-1-git-send-email-tiago.vignatti@nokia.com>
	<1247576250-16274-2-git-send-email-tiago.vignatti@nokia.com>
	<20090714153509.51bbec27@lxorguk.ukuu.org.uk>
	<21d7e9970907152125i52dc3f4dqd540f7d65667cfb5@mail.gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +     pci_read_config_word(pdev, PCI_COMMAND, &cmd);
> >> +     if (rsrc & (VGA_RSRC_LEGACY_IO | VGA_RSRC_NORMAL_IO))
> >> +             cmd |= PCI_COMMAND_IO;
> >> +     if (rsrc & (VGA_RSRC_LEGACY_MEM | VGA_RSRC_NORMAL_MEM))
> >> +             cmd |= PCI_COMMAND_MEMORY;
> >> +     pci_write_config_word(pdev, PCI_COMMAND, cmd);
> >
> > Locking question - what locks this lot against hotplug also touching
> > bridge settings ?
> 
> well here we just bang on device config space registers which means we
> can probably
> race against lots of other things that rmw the PCI_COMMAND not just hotplug.
> 
> Perhaps we need some sort per device PCI command space lock,
> granted this still means we race against anyone directly hacking it
> behind our backs.

I suspect the right thing to do is to move that function into the
drivers/pci code and lock it properly there. That would keep all the
locking detail internal and private (and someone else's problem ;))

> >> +             pdev = vga_default_device();
> >
> > What if the BIOS provided device was hot unplugged ?
> 
> we just use the pdev as a cookie, if it was hot unplugged we'll
> have gotten a callback to remove it from the VGA device list
> and the lookup which happens 5 lines later inside the spinlock
> will fail.

What if I inserted a new device - the allocator might give me a new
device with the same pointer if its reusing the same slab entry for that
size. Unlikely but given a zillion boxes this starts to occur 8(

> >> +             /* We have a conflict, we wait until somebody kicks the
> >> +              * work queue. Currently we have one work queue that we
> >
> > If two drivers own half the resources and both are waiting for the rest
> > what handles the deadlock
> >

Not commented on - but a serious question would be "do we actually care
enough or are there really devices with just I/O and just vga memory
access used ?"

> > PCI device refcounting ?
> 
> Again its just used a cookie for a later lookup in our vgadev array,
> its gone away it'll have been removed from the array,
> 
> We could use pci_dev_get/pci_dev_put I suppose but its only used as
> a cookie so far.

Your cookie validity is suspect I fear. Also holding the device reference
means you stop that exact set of resources being reissued too early and
you (or clients) scribbling on them through unfortunate timing. So I
think you actually do need to grab references properly, Doesn't make the
code much more complex that I can see.

Alan
