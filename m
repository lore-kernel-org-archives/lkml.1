Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbYFAKS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbYFAKS4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 06:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbYFAKSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 06:18:48 -0400
Received: from server.drzeus.cx ([85.8.24.28]:41689 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751418AbYFAKSs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 06:18:48 -0400
Date: Sun, 1 Jun 2008 12:18:41 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: avorontsov@ru.mvista.com
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>,
       Gary Jennejohn <garyj@denx.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] mmc_spi: export probe and remove functions
Message-ID: <20080601121841.0392b01c@mjolnir.drzeus.cx>
In-Reply-To: <20080526131009.GA19861@polina.dev.rtsoft.ru>
References: <20080523182754.GA26891@polina.dev.rtsoft.ru>
	<20080523182834.GA469@polina.dev.rtsoft.ru>
	<20080526141836.72db0623@mjolnir.drzeus.cx>
	<20080526122533.GA9595@polina.dev.rtsoft.ru>
	<20080526131009.GA19861@polina.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008 17:10:09 +0400
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> 
> Btw, this isn't actually drivers encapsulating. This is about making
> mmc_spi export some "library" function which could be used by other
> bindings.
> 
> Think of usb_add_hcd() used by various drivers' bindings for e.g.
> drivers/usb/host/ehci-*.c. Though usb_add_hcd() is more generic
> than just "EHCI" bindings, but only because there is nothing to
> share between them. (for MMC over SPI bindings all we want to do is fill
> the platform data).
> 

There's a big difference. usb_add_hcd() is designed specifically to be
called by other, real probe functions. mmc_spi_probe() _is_ a probe
function. Also exporting it as a library function is very confusing.

> 
> Maybe something like this? I don't like it so much, but given that
> you don't like to export functions from mmc_spi, we'll have to place
> some calls into the driver itself. :-/ And there is no easy way to do
> generic callbacks, since that way we'll have implement "mmc_spi
> callbacks subsystem". :-)

That's not a callback, but an explicit call to another module.


All of this work looks a bit like trying to wedge a square piece into a
round hole. It looks to me that the kernel needs a bit of restructuring
to handle it. You can't really export every probe function of every
platform device so that you can add OF hooks to it.

>From what I can tell, the OF stuff behaves very much like the PNP
system on PCs. The information relayed is a bit more versatile though.
Perhaps what is needed is a more advanced "platform" bus that is
modeled after the PNP bus, but with the extra ability of handling the
stuff currently crammed into the platform structures. mmc_spi would
then be extended to be driver for the "platform" bus and we could have
generic calls like platform_get_pin(dev, "ro");.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
