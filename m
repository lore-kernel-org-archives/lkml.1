Return-Path: <linux-kernel-owner+w=401wt.eu-S1750788AbXCJI6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750788AbXCJI6k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 03:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbXCJI6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 03:58:40 -0500
Received: from smtp.osdl.org ([65.172.181.24]:37445 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbXCJI6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 03:58:39 -0500
Date: Sat, 10 Mar 2007 00:58:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc3-mm1
Message-Id: <20070310005828.0ab608b1.akpm@linux-foundation.org>
In-Reply-To: <200703100933.35743.m.kozlowski@tuxland.pl>
References: <20070307201839.6f45735b.akpm@linux-foundation.org>
	<200703100933.35743.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 10 Mar 2007 09:33:35 +0100 Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:
> Hello, 
> 
> > - The wireless changes in here need a lot of testers, please.  It is major
> >   rework.
> 
> Works for me ... so far ;-) Anyway to the point:
> 
> When moving my laptop I reattached the usb mouse. Then I found this in syslog:
> 
> usb 2-1: new low speed USB device using uhci_hcd and address 3
> usb 2-1: new device found, idVendor=046d, idProduct=c00e
> usb 2-1: new device strings: Mfr=1, Product=2, SerialNumber=0
> usb 2-1: Product: USB-PS/2 Optical Mouse
> usb 2-1: Manufacturer: Logitech
> usb 2-1: configuration #1 chosen from 1 choice
> khubd: page allocation failure. order:5, mode:0xd0
>  [<c01045c4>] show_trace_log_lvl+0x1a/0x30
>  [<c0104d50>] show_trace+0x12/0x14
>  [<c0104e07>] dump_stack+0x16/0x18
>  [<c014acc6>] __alloc_pages+0x2e4/0x303
>  [<c01604df>] cache_alloc_refill+0x2e4/0x516
>  [<c01608e4>] kmem_cache_zalloc+0x78/0x7c
>  [<c0341343>] hid_parse_report+0xce/0x26b
>  [<c032d99b>] hid_probe+0x264/0xdba
>  [<c030feb9>] usb_probe_interface+0x5a/0x89
>  [<c02bf74f>] driver_probe_device+0x86/0x178
>  [<c02bf849>] __device_attach+0x8/0xa
>  [<c02beadc>] bus_for_each_drv+0x4a/0x68
>  [<c02bfb39>] device_attach+0x8b/0xd2
>  [<c02bea4e>] bus_attach_device+0x40/0x84
>  [<c02bd835>] device_add+0x5d0/0x6c8
>  [<c030e8bd>] usb_set_configuration+0x2d6/0x4c6
>  [<c03158ab>] generic_probe+0x15c/0x251
>  [<c030fb87>] usb_probe_device+0x36/0x3c
>  [<c02bf74f>] driver_probe_device+0x86/0x178
>  [<c02bf849>] __device_attach+0x8/0xa
>  [<c02beadc>] bus_for_each_drv+0x4a/0x68
>  [<c02bfb39>] device_attach+0x8b/0xd2
>  [<c02bea4e>] bus_attach_device+0x40/0x84
>  [<c02bd835>] device_add+0x5d0/0x6c8
>  [<c030a078>] usb_new_device+0x128/0x196
>  [<c030aedd>] hub_thread+0x28a/0xb4a
>  [<c0126c75>] kthread+0xa2/0xc9
>  [<c010422f>] kernel_thread_helper+0x7/0x18
>  =======================

hid_parse_report() is doing kmalloc(128k kbytes).  We canot sanely support
that and the code shold be rewritten to not do that.  A simple though
somewhat lame fix would be to switch to vmalloc().

It's been this way for some time, so it's odd that the failures have just
popped up now.
