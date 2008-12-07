Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbYLGR3C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbYLGR3C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 12:29:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbYLGR2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 12:28:52 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58218 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751216AbYLGR2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 12:28:51 -0500
Date: Sun, 7 Dec 2008 17:28:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: "Evgeniy Polyakov" <zbr@ioremap.net>,
       "Herbert Xu" <herbert@gondor.apana.org.au>,
       linux-kernel@vger.kernel.org,
       "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>
Subject: Re: Runaway loop with the current git.
Message-ID: <20081207172855.55fee78f@lxorguk.ukuu.org.uk>
In-Reply-To: <ac3eb2510812070922q2531a188v37874a042b259ac9@mail.gmail.com>
References: <20081207112335.0afd5192@lxorguk.ukuu.org.uk>
	<E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au>
	<20081207155507.GA15355@gondor.apana.org.au>
	<ac3eb2510812070803i150d91e7led58128796e8045e@mail.gmail.com>
	<20081207160921.693f637a@lxorguk.ukuu.org.uk>
	<20081207163151.GA31838@ioremap.net>
	<20081207170108.39dfd93f@lxorguk.ukuu.org.uk>
	<ac3eb2510812070922q2531a188v37874a042b259ac9@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > /dev/console is a logical mapping to a device which may well be
> > different, loaded after PCI is initialised and dependant on PCI.
> 
> So wrong. If no driver is associated, like early, in that case, we
> must return -ENODEV, instead of calling modprobe in a loop. It's a
> built-in device, and it's easy to fix.

You've clearly no idea how initrd even works have you ? If it just
returned -ENODEV you wouldn't be able to open the console and you
wouldn't trigger the loading of the module to get the console running. So
you've now completely buggered the boot process.

The correct sequence is

	Open device
		Kernel issues hotplug message
			Hotplug script loads drivers to policy


The problem case you have due to initrd bugs is

	Open device
		Kernel issues hotplug message
			Hotplug script opens same device (BUG)
				Kernel issues hotplug message
				.....
				Kernel detects this is stuck
				Kernel replies with -ENODEV/-ENXIO to try
and rescue itself from buggy initrd scripts

That is how it has worked since we first had script based module
requesting which is some years now.

