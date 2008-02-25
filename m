Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbYBYImS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbYBYImS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 03:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbYBYImE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 03:42:04 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46604 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752825AbYBYImB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 03:42:01 -0500
Date: Mon, 25 Feb 2008 08:32:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eliot Blennerhassett <linux@audioscience.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Q: volatile vs barriers to access memory data changed by device
 DMA
Message-ID: <20080225083201.51067611@core>
In-Reply-To: <200802251404.01874.linux@audioscience.com>
References: <200802251404.01874.linux@audioscience.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> === after conversion
> struct bus_master_interface *interface;
> while (interface->ack != OK) { 
>         delay(a short while);
>         rmb(); 
>         [ after X loops device changes interface->ack by dma ]
> };
> 
> All I need is for the read of interface->ack in the loop not to be optimised 
> away - is rmb() the appropriate incantation to achieve this?

Yes - ish.  You want the equivalent of 

	do {
		rmb();
		if (interface->ack == OK)
			break;
	} while(1);

(eg putting another rmb before the while in your case)

You want a barrier before the *first* read in case the
compiler has managed to cache the value before you enter the loop.


> struct bus_master_interface *interface;
> interface->cmd = command;
> wmb();
> iowrite(device_interrupt, 1);

Yes.

