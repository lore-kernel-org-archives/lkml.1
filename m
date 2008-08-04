Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbYHDOO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbYHDOO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbYHDONy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:13:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52627 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756841AbYHDONw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:13:52 -0400
Date: Mon, 4 Aug 2008 10:13:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Frans Pop <elendil@planet.nl>
cc: linux-kernel@vger.kernel.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: [regression?] usb: new errors during device detection
In-Reply-To: <200808032211.22483.elendil@planet.nl>
Message-ID: <Pine.LNX.4.44L0.0808041006060.2815-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Aug 2008, Frans Pop wrote:

> Not sure how I should interpret this difference between dmesg output for
> 2.6.26 and 2.6.27-rc1 (after 'grep -i usb'):
> 
>  usbcore: registered new interface driver usbfs
>  usbcore: registered new interface driver hub
>  usbcore: registered new device driver usb
>  USB Universal Host Controller Interface driver v3.0
>  uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
>  usb usb1: configuration #1 chosen from 1 choice
>  hub 1-0:1.0: USB hub found
>  uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
>  usb usb2: configuration #1 chosen from 1 choice
>  hub 2-0:1.0: USB hub found
>  uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
>  usb usb3: configuration #1 chosen from 1 choice
>  hub 3-0:1.0: USB hub found
>  uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
>  usb usb4: configuration #1 chosen from 1 choice
>  hub 4-0:1.0: USB hub found
> +usb 3-1: new low speed USB device using uhci_hcd and address 2
>  ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
>  ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
>  usb usb5: configuration #1 chosen from 1 choice
>  hub 5-0:1.0: USB hub found
> -usb 3-1: new low speed USB device using uhci_hcd and address 2
> +usb 3-1: device not accepting address 2, error -71
> +hub 3-0:1.0: unable to enumerate USB device on port 1
> +usb 3-1: new low speed USB device using uhci_hcd and address 4
>  usb 3-1: configuration #1 chosen from 1 choice
>  usb 4-1: new low speed USB device using uhci_hcd and address 2
>  usb 4-1: configuration #1 chosen from 1 choice
>  usbcore: registered new interface driver hiddev
>  input: USB Compliant Keyboard as /class/input/input0
>  input: USB HID v1.10 Keyboard [USB Compliant Keyboard] on usb-0000:00:1d.2-1
>  input: USB Compliant Keyboard as /class/input/input1
>  input: USB HID v1.10 Device [USB Compliant Keyboard] on usb-0000:00:1d.2-1
>  input: Logitech USB Receiver as /class/input/input2
>  input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:1d.3-1
>  usbcore: registered new interface driver usbhid
>  usbhid: v2.6:USB HID core driver

The difference is most likely meaningless; it is probably caused a 
different order of initialization of the EHCI and UHCI controllers.

> Note that 3-1 is first assigned address 2 and then 4. With 2.6.26 3-1 did
> not have any problem accepting address 2. I assume the "unable to enumerate"
> error is a result of the rejection of the address?

No.  It is caused by the EHCI controller being initialized.

When an EHCI controller is initialized, it switches all the USB
connections from its companion controllers to itself.  Hence any device
which _was_ connected to the UHCI controller will _now_ be connected to
the EHCI controller.  Consequently the UHCI controller is unable to
communicate with the device and cannot enumerate it.

After a short time, the EHCI controller driver realizes that the device 
can't run at high speed and switches it back to the UHCI controller.  
At that point it gets enumerated for the second time, successfully.

The difference must have been that under 2.6.26 the EHCI controller was 
initialized _before_ the 3-1 device was detected, so there was no 
aborted attempt at enumeration.

If you want to prevent all errors of this sort, all you have to do is 
insure that ehci-hcd is loaded before either uhci-hcd or ohci-hcd 
during system startup.

Alan Stern

