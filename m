Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbXIWBFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbXIWBFz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 21:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbXIWBFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 21:05:47 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:61957 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbXIWBFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 21:05:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Lh3v7gHX3DAsQKXzRgFmoo+kQfLyRgP6niW+FMKBPYW9PtM6kqMlfraLyhm8padEzDVsbLZ3F6OmeqMAWTPr65fPNatfGFbttWhBDcCFCuuXy+2b6RHWeMiIebBIwp5XUsEihBujUoGWBOl+OtbLub4FS11SFNsgCWiz+HoZLIk=
Message-ID: <653402b90709221805pd1b7efel165a1c55100e3610@mail.gmail.com>
Date: Sun, 23 Sep 2007 03:05:44 +0200
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [RFC] New kernel-message logging API
Cc: LKML <linux-kernel@vger.kernel.org>, holzheu <holzheu@linux.vnet.ibm.com>,
       "Joe Perches" <joe@perches.com>, "Rob Landley" <rob@landley.net>,
       "Dick Streefland" <dick.streefland@altium.nl>
In-Reply-To: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/22/07, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> After recent discussions on LKML and a general dissatisfaction at the
> current printk() kernel-message logging interface, I've decided to
> write down some of the ideas for a better system.

Nice. I would suggest having some kind of standard way to show the
information on the screen/dmesg. I mean, instead of having plain lines
being written to the log, having something very short like:

SSL: Message sent.

Being:

SS - Subsystem ("EA"  for early code, "MM" for memory managment, "PU"
for processor stuff, "HD" for hard disks, "PP" for parallel port, "NT"
for networking, "VI" for video stuff, "FB" for framebuffers, "SN" for
sound stuff, "KE" for keyboard, "MO" for mouse, ... I think you get
the idea, just generic things).
L - Log level (0 for emerg, ..., 7 for debug)

And maybe some other character for other information. This would be
great to read pretty easily dmesg and for grepping, like:

  $ dmesg | grep ^FB

for getting just information about framebuffers, or

  $ dmesg | grep ^..[0123]

to get all the problems of the whole kernel/system.

So, for example, userspace scripts will be able to separate into
different log files the kernel stuff:

  #!/bin/sh
  dmesg | grep ^..[0123] > klog.errors
  dmesg | grep ^NT > klog.networking
  dmesg | grep ^HD > klog.harddisks
  dmesg | grep ^FB > klog.framebuffers

Maybe its weird at first, but I think it will speed up the reading of
plain dmesg's outputs for everyone at the cost of 3-5 more characters
at every line in dmesg.

Also, it may help to make printk()'s messages to be more uniform,
instead of having every .c file having differents ways to express
similar things.

Getting more complex, lets add another character:

SSLR: Message sent.

being R the reason of the message (D for information about a
probed-and-detected hardware [like a PCI card], R for a new
succesfully registered device [like a framebuffer], S for new settings
in a device [like taking up a ethernet link, or that messages about
IRQs], C for copyright/about/info lines, ...).

Now we have at some dmesg (for example):

  eth0: Broadcom 4400 10/100BaseT Ethernet 00:1f:a2:0c:4a:72
  ieee80211_crypt: registered algorithm 'TKIP'
  ipw3945: Intel(R) PRO/Wireless 3945 Network Connection 1.2.2d
  ipw3945: Copyright(c) 2003-2006 Intel Corporation
  ACPI: PCI Interrupt 0000:0c:00.0[A] -> GSI 17 (level, low) -> IRQ 17
  PCI: Setting latency timer of device 0000:0c:00.0 to 64
  ipw3945: Detected Intel PRO/Wireless 3945ABG Network Connection
  ipw3945: Detected geography ABG (13 802.11bg channels, 23 802.11a channels)
  usb 6-1: new low speed USB device using uhci_hcd and address 2
  usb 6-1: configuration #1 chosen from 1 choice
  usbcore: registered new interface driver hiddev

and we could have:

  NT6R eth0: Broadcom 4400 10/100BaseT Ethernet 00:1f:a2:0c:4a:72
  NT6R ieee80211_crypt: algorithm 'TKIP'
  NT6C ipw3945: Intel(R) PRO/Wireless 3945 Network Connection driver 1.2.2d
  NT7C ipw3945: Copyright(c) 2003-2006 Intel Corporation
  XX6S ACPI: PCI Interrupt 0000:0c:00.0[A] -> GSI 17 (level, low) -> IRQ 17
  XX6S PCI: Latency timer of device 0000:0c:00.0 to 64
  NT6R ipw3945: Intel PRO/Wireless 3945ABG Network Connection
  NT6D ipw3945: geography ABG (13 802.11bg channels, 23 802.11a channels)
  US6R usb 6-1: low speed USB device using uhci_hcd and address 2
  US6S usb 6-1: configuration #1 chosen from 1 choice
  US6R usbcore: new interface driver hiddev

which I think its much more clear... Wanna know about registered
networking-related devices? Then grep using "^NT.R":

  NT6R eth0: Broadcom 4400 10/100BaseT Ethernet 00:1f:a2:0c:4a:72
  NT6R ieee80211_crypt: algorithm 'TKIP'
  NT6R ipw3945: Intel PRO/Wireless 3945ABG Network Connection

...

Nothing more, thanks for reading :)

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
