Return-Path: <linux-kernel-owner+w=401wt.eu-S1757927AbYKWDjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbYKWDjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 22:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755411AbYKWDjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 22:39:09 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:37559 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbYKWDjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 22:39:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TRUFENIwMKyquQbYFy22dgRhd7zIE6Aj06NAKkPgwypVgf4fIMisudKVYp2s6k+26w
         tSKBWhiul714wmFFjS9EI3A2YhuekYzLb8SHrKVFV+8yX4FTervlM1QLQpxv++QODsdJ
         dMMdv3d614kOu4e8Vd4wr2dA00NO08PnuC8TI=
Subject: Re: [spi-devel-general] [patch 05/14] mfd: PCAP2 driver
From: Daniel Ribeiro <drwyrm@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: Stefan Schmidt <stefan@datenfreihafen.org>,
       spi-devel-general@lists.sourceforge.net,
       Stefan Schmidt <stefan@openmoko.org>, eric.y.miao@gmail.com,
       linux-kernel@vger.kernel.org, sameo@openedhand.com,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <200811221819.53186.david-b@pacbell.net>
References: <20081121160403.073751031@dodger.lab.datenfreihafen.org>
	 <200811221558.03915.david-b@pacbell.net>
	 <20081123003306.GE24437@datenfreihafen.org>
	 <200811221819.53186.david-b@pacbell.net>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 23 Nov 2008 01:38:57 -0200
Message-Id: <1227411537.3148.22.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sáb, 2008-11-22 às 18:19 -0800, David Brownell escreveu:
> SPI-specific bits:
> 
>  - I'd have to see the patch.  The last one I saw still didn't
>    list a SPI_MASTER dependency for the core MFD module.

The next one will.

>  - You should make ezx_pcap_write() and ezx_pcap_read() switch
>    over to spi_write_then_read(), to ensure it's never doing
>    DMA to/from the stack.  I see a byte-order dependency too...

I tried spi_write_then_read before, but it didn't work. I supposed it
was because it was doing 2 transfers as the second transfer rx_buf
always came zeroed. I see that commit
f9b90e39cbc5c4d6ef60022fd1f25d541df0aad1 changed it to do a single
transfer, so i will try it again.

>  - For general paranoia, the probe() should abort if pcap.spi is
>    already set ... and its cleanup path, plus remove(), should
>    null that pointer.

Ok.

>  - If you're going to mark the probe() as __devinit, then mark
>    the remove() as __devexit and use __devexit_p() in the driver
>    struct.

Ok. Shouldn't i use __init instead?

> Other comments about the pcap2 core:

> - Those show_regs/store_regs calls would IMO make more sense
>    in debugfs than in sysfs.

I will just remove those for now.

>  - The set_vreg() stuff would seem to make more sense in a
>    regulator subdevice and driver ... but that's more of a
>    general driver structure thing, and might be fixed later.
> 
>  - Andrew seems to always want a comment explaining why the
>    IRQ handler for I2C and SPI devices needs to queue_work().
>    Maybe the threaded IRQ stuff will help there...
> 
>  - The mask_event()/unmask_event() stuff looks like you're
>    more or less reinventing a baby "struct irq_chip", with
>    register_event() instead of request_irq().

> Re the IRQ stuff, this looks more like what i2c/chips/menelaus.c
> did than mfd/twl4030-irq.c ... in general I think it's better to
> pursue the latter approach, making genirq handle such stuff.
> (Even though it's kind of awkward to use it for I2C or SPI based
> interrupt controllers just now.)

I didn't know i could use genirq with spi. In fact i was using genirq
before, when the driver was using ssp.c. Now, looking at twl4030-irq.c
its clear how i should have done this. Thanks!!

>  - And the ADC sysfs support isn't supporting hwmon models.
>    (Neither does the twl4030 ADC support, but that's not been
>    submitted for mainline yet either...)

I will look into this after i finish the irq stuff.


This is a lot of stuff, thanks for the review. :)

-- 
Daniel Ribeiro

