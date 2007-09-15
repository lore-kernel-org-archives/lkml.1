Return-Path: <linux-kernel-owner+w=401wt.eu-S1756415AbXIOTzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415AbXIOTzd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 15:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbXIOTz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 15:55:26 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4833 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752414AbXIOTzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 15:55:25 -0400
Date: Sat, 15 Sep 2007 15:55:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Christian Volkmann <haveaniceday@cv-sv.de>
cc: Pete Zaitcev <zaitcev@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [linux-usb-devel] 2.6.23-rc6: usb 1-1: device not accepting
 address 2, error -62
In-Reply-To: <46EC113A.4040309@cv-sv.de>
Message-ID: <Pine.LNX.4.44L0.0709151532130.8724-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Sep 2007, Christian Volkmann wrote:

> Please see below for the logs with timestamp and usb-debug.
> 
> Alan Stern wrote:
> > On Sat, 15 Sep 2007, Christian Volkmann wrote:
> > 
> >>> Does the machine otherwise work OK?
> >>>
> >> Yes, the USB is working fine for the easy things I do with it.
> >>
> >> Hmm, so I expect this 2.6.22 message:
> >>>> <6>usb 1-1: USB disconnect, address 2
> >> became this 2.6.23rc6 message:
> >>>> <3>usb 1-1: device not accepting address 2, error -62
> >> and nothing is harmed.
> > 
> > Maybe.  It's hard to tell because you have not provided enough
> > information.  To get a better idea of what's going on you should enable 
> > CONFIG_USB_DEBUG, for both 2.6.22 and 2.6.23, and then post the dmesg 
> > logs.  It wouldn't hurt to enable CONFIG_PRINTK_TIME also.
> > 
> > These sorts of errors can occur because of bad cable connections or
> > other similar hardware problems.  There's an excellent chance they have
> > no connection to the kernel version.
> > 
> > Alan Stern

It looks like both of Pete's guesses were correct.  The highly-edited 
extracts below show a few things.

In 2.6.22, a disconnect occurred because ohci-hcd was loaded before 
ehci-hcd:

> Boot of 2.6.22 with CONFIG_PRINTK_TIME and CONFIG_USB_DEBUG
> <7>[   29.035665] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
> <6>[   29.078652] ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 1
> <6>[   29.406003] ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 2
> <6>[   29.655430] usb 1-1: new low speed USB device using ohci_hcd and address 2
> <6>[   29.736975] ohci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 3
> <6>[   29.935872] usb 1-1: Product: USB Optical Mouse
> <6>[   30.072347] ehci_hcd 0000:00:03.3: new USB bus registered, assigned bus number 4
> <6>[   30.179588] usb 1-1: USB disconnect, address 2
> <6>[   30.386138] ehci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 5
> <7>[   30.606818] ehci_hcd 0000:00:03.3: port 1 low speed --> companion
> <6>[   30.664503] uhci_hcd 0000:00:07.0: UHCI Host Controller
> <6>[   30.681636] uhci_hcd 0000:00:07.0: new USB bus registered, assigned bus number 6
> <7>[   30.854760] ehci_hcd 0000:00:03.3: port 2 full speed --> companion
> <6>[   30.969096] uhci_hcd 0000:00:07.1: new USB bus registered, assigned bus number 7
> <6>[   31.177917] usb 1-1: new low speed USB device using ohci_hcd and address 3
> <6>[   32.537664] usb 2-1: Product: Medion Flash XL V3.0C
> <6>[   32.549438] usb 2-1: Manufacturer: MEDION
> <6>[   32.561308] usb 2-1: SerialNumber: 2003-02

In 2.6.23, a different series of errors occurred because ohci-hcd, 
ehci-hcd, and uhci-hcd were loaded in parallel.

> Boot of 2.6.23rc6 with CONFIG_PRINTK_TIME and CONFIG_USB_DEBUG
> <7>[   27.133379] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
> <7>[   27.133384] ohci_hcd: block sizes: ed 64 td 64
> <6>[   27.136391] USB Universal Host Controller Interface driver v3.0
> <7>[   27.288172] ehci_hcd: block sizes: qh 128 qtd 96 itd 192 sitd 96
> <6>[   28.061139] ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 1
> <6>[   28.337023] uhci_hcd 0000:00:07.0: UHCI Host Controller
> <6>[   28.350241] uhci_hcd 0000:00:07.0: new USB bus registered, assigned bus number 2
> <6>[   28.600358] usb 1-1: new low speed USB device using ohci_hcd and address 2
> <6>[   28.652269] ehci_hcd 0000:00:03.3: new USB bus registered, assigned bus number 3
> <7>[   28.752739] ohci_hcd 0000:00:03.0: urb c5ead340 path 1 ep0out 5ec20000 cc 5 --> status -62
> <3>[   29.166906] usb 1-1: device not accepting address 2, error -62
> <6>[   29.977427] ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 4
> <6>[   30.308993] ohci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 5
> <6>[   30.631777] uhci_hcd 0000:00:07.1: new USB bus registered, assigned bus number 6
> <6>[   30.921451] ehci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 7

None of the nasty-sounding messages indicate any real problem.  They
are normal when a low- or full-speed device is connected while the
companion high-speed controller is initialized.

To prevent all the error messages, make sure the ehci-hcd is loaded
before the other two and after all the PCI devices have been detected.  
(In the presence of the hotplug subsystem, this may not be easy to
accomplish.)

At any rate, this is not a regression because it isn't a bug or a 
mulfunction.  It is normal behavior.

Alan Stern

