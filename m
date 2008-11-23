Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbYKWCUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbYKWCUJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 21:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755156AbYKWCT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 21:19:56 -0500
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:45614 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754912AbYKWCTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 21:19:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qWoiMNRnr60PvTZZvado2KpHbq3ash2kmnETJxxAXloHdVMubirnR7zBh1XqqANT5tA0/yObsdvD+EDC4Zg4htDCNhtk2ZNgrJDAqrTPj7t6G90pIaDp8MLdX2A3cGjonv1uyMpvLuN30lMkP1Ri+5d1gIdCtc45PS3fs3tQoO8=  ;
X-YMail-OSG: 2XCW7NUVM1mftWNuFGzCZcQwJC02txUn9gBQJjY3._u4TFSc_bDFA6ftUsryvdjQHXRthhFf9stZMA1qvFcUPk9O1Uj6c6y80BB9JTxtyJ2_gwXp2Mtsre.tbK5p14bGek8axoOajdSXvh_Z2yecqbu_.AlZS4FiKs0CyC4-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Stefan Schmidt <stefan@datenfreihafen.org>
Subject: Re: [spi-devel-general] [patch 05/14] mfd: PCAP2 driver
Date: Sat, 22 Nov 2008 18:19:52 -0800
User-Agent: KMail/1.9.10
Cc: spi-devel-general@lists.sourceforge.net,
       Stefan Schmidt <stefan@openmoko.org>, eric.y.miao@gmail.com,
       linux-kernel@vger.kernel.org, sameo@openedhand.com,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Daniel Ribeiro <drwyrm@gmail.com>
References: <20081121160403.073751031@dodger.lab.datenfreihafen.org> <200811221558.03915.david-b@pacbell.net> <20081123003306.GE24437@datenfreihafen.org>
In-Reply-To: <20081123003306.GE24437@datenfreihafen.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200811221819.53186.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 November 2008, Stefan Schmidt wrote:
> > 
> > Looks to me like you're almost all the way there already!  :)
> 
> We hope so, yes. :) Once we have the EZX/PXA dep gone you are fine with this
> patch? All SPI related stuff is ok from you?

SPI-specific bits:

 - I'd have to see the patch.  The last one I saw still didn't
   list a SPI_MASTER dependency for the core MFD module.

 - You should make ezx_pcap_write() and ezx_pcap_read() switch
   over to spi_write_then_read(), to ensure it's never doing
   DMA to/from the stack.  I see a byte-order dependency too...

 - For general paranoia, the probe() should abort if pcap.spi is
   already set ... and its cleanup path, plus remove(), should
   null that pointer.

 - If you're going to mark the probe() as __devinit, then mark
   the remove() as __devexit and use __devexit_p() in the driver
   struct.

Other comments about the pcap2 core:

 - The set_vreg() stuff would seem to make more sense in a
   regulator subdevice and driver ... but that's more of a
   general driver structure thing, and might be fixed later.

 - Andrew seems to always want a comment explaining why the
   IRQ handler for I2C and SPI devices needs to queue_work().
   Maybe the threaded IRQ stuff will help there...

 - The mask_event()/unmask_event() stuff looks like you're
   more or less reinventing a baby "struct irq_chip", with
   register_event() instead of request_irq().

 - Those show_regs/store_regs calls would IMO make more sense
   in debugfs than in sysfs.

 - And the ADC sysfs support isn't supporting hwmon models.
   (Neither does the twl4030 ADC support, but that's not been
   submitted for mainline yet either...)

Re the IRQ stuff, this looks more like what i2c/chips/menelaus.c
did than mfd/twl4030-irq.c ... in general I think it's better to
pursue the latter approach, making genirq handle such stuff.
(Even though it's kind of awkward to use it for I2C or SPI based
interrupt controllers just now.)

- Dave
