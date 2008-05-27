Return-Path: <linux-kernel-owner+w=401wt.eu-S1757780AbYE0NCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780AbYE0NCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 09:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756950AbYE0NCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 09:02:42 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:33853 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153AbYE0NCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 09:02:41 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-8.tower-164.messagelabs.com!1211893359!10047004!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Tue, 27 May 2008 15:02:36 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: David Brownell <dbrownell@users.sourceforge.net>
CC: <linux-kernel@vger.kernel.org>
Subject: configure gpio for interrupt function
Message-ID: <20080527130236.GA18546@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 27 May 2008 13:02:36.0450 (UTC) FILETIME=[EF69A820:01C8BFF9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

I want to use a driver that in turn uses the gpio API (i.e.
drivers/input/keyboard/gpio_keys.c).  My problem with that is, that my
machine[1]'s external irqs don't fit into the GPIO API model.  The main
problem is that gpio_direction_input isn't enough to get an irq.
I need to explicitly set the gpio to an EXT_IRQ function.
(I can workaround that because the EXT_IRQ function allows to read the
state of the gpio.  So I can use the EXT_IRQ function if input is
requested.)

Another problem is that I cannot implement irq_to_gpio correctly,
because several gpio's share the same irq.
(Note this makes the workaround above less reliable.  Consider two
gpios sharing the same irq.  I cannot assert that only one of them can
trigger the interrupt.)

So I suggest to extend the gpio API with two functions like:

	int gpio_direction_inputirq(unsigned gpio, unsigned flags);
	void gpio_ackirq(unsigned gpio);

with flags being similar to the IRQF_TRIGGER_* defines in
include/linux/interrupt.h.  I need gpio_ackirq because ns9xxx requires
that an edge triggered irq is acknowledged separatly in the "External
Interrupt X Control register"[2].  (If you have better names ...)

Moreover this makes the API more flexible because the irq type can be
configured.

OTOH I'd like to deprecate irq_to_gpio.  $(git grep -l irq_to_gpio
drivers) suggests that this function is only used in two places.  One of
them[3] is AT91 specific, the other[4] seems specific for the
RouterBoard 532.
(There are some other users below arch/, but I expect no breakage here.
I expect that every arch that uses the function have it implemented
anyhow.)

What do you think?

Best regards
Uwe

[1] http://www.digi.com/products/embeddedsolutions/ns9215.jsp
    Interesting sections are "Pinout -> General purpose I/O (GPIO)" and
    "I/O Control Module".  E.g. GPIO4's func1 is "Ext Int Ch 2"
[2] System Control Module -> External Interrupt 0­3 Control register
[3] drivers/mmc/host/at91_mci.c
[4] drivers/ata/pata_rb532_cf.c

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
