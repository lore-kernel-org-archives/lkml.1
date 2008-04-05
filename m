Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbYDEQzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbYDEQzo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 12:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbYDEQzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 12:55:35 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:43044 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbYDEQze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 12:55:34 -0400
Date: Sat, 5 Apr 2008 18:55:01 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: pci: add to global list before sysfs?
Message-ID: <20080405185501.41ec42a7@mjolnir.drzeus.cx>
In-Reply-To: <20080405155323.GA27252@suse.de>
References: <20080404191350.7f0183a5@mjolnir.drzeus.cx>
	<20080404210132.GA14418@suse.de>
	<20080405115727.1265e8a9@mjolnir.drzeus.cx>
	<20080405155323.GA27252@suse.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Apr 2008 08:53:23 -0700
Greg KH <gregkh@suse.de> wrote:

> On Sat, Apr 05, 2008 at 11:57:27AM +0200, Pierre Ossman wrote:
> > 
> > Yes. Things work fine when the driver is loaded after the entire PCI
> > bus has been scanned, but not when new cards are hotplugged with the
> > driver already present. I'd like the behaviour to be the same in both
> > cases.
> 
> Why not just create a thread in your driver, or timer, and sleep until
> you see the other devices?  If after a certian time you never do, then
> bail out.
> 
> That should work properly for you for both cases (startup and loading
> later.)
> 

I'm not sure how that could be done in a clean way. Right now I have
the following:

                sd_dev = NULL;
                while ((sd_dev = pci_get_device(PCI_VENDOR_ID_JMICRON,
                        PCI_DEVICE_ID_JMICRON_JMB38X_SD, sd_dev)) != NULL) {
                        if ((PCI_SLOT(chip->pdev->devfn) ==
                                PCI_SLOT(sd_dev->devfn)) &&
                                (chip->pdev->bus == sd_dev->bus))
                                break;
                }

                if (sd_dev) {
                        pci_dev_put(sd_dev);
                        dev_info(&chip->pdev->dev, "Refusing to bind to "
                                "secondary interface.\n");
                        return -ENODEV;
                }

If I do this threaded, I'd have to return success to the driver core
and then act like a possum later. Doable, but not very clean. It could
be solved if it was possible to sleep in probe functions, but from what
I can tell that will stop the probing of subsequent devices.

Also, the timeout would introduce an inherent race. Which means either
putting a high timeout to make the race insignificant, or a low timeout
so users don't have to wait for their device to actually become usable.

Is it possible to write some routines that can walk the PCI device tree
without having any pci_dev structures to hang on to? To solve my basic
problem I just need to know how the tree looks like, not actually poke
any of the other devices.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
