Return-Path: <linux-kernel-owner+w=401wt.eu-S1762429AbZLPRIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762429AbZLPRIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932169AbZLPRIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:08:12 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50504 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762396AbZLPRII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:08:08 -0500
Date: Wed, 16 Dec 2009 18:08:03 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: linux-kernel@vger.kernel.org, David Vrabel <dvrabel@arcom.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Urs Thuermann <urs.thuermann@volkswagen.de>,
       Oliver Hartkopp <oliver.hartkopp@volkswagen.de>,
       "David S. Miller" <davem@davemloft.net>,
       Kurt Van Dijck <kurt.van.dijck@eia.be>, netdev@vger.kernel.org
Subject: Re: [PATCH 4/7] can/at91: don't check platform_get_irq's return
	value against zero
Message-ID: <20091216170802.GA26325@pengutronix.de>
References: <1260979809-24811-1-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-2-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-3-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-4-git-send-email-u.kleine-koenig@pengutronix.de> <4B290A57.3010705@grandegger.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B290A57.3010705@grandegger.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 05:27:03PM +0100, Wolfgang Grandegger wrote:
> Uwe Kleine-König wrote:
> > platform_get_irq returns -ENXIO on failure, so !irq was probably
> > always true.  Better use (int)irq <= 0.  Note that a return value of
> > zero is still handled as error even though this could mean irq0.
> 
> But only on ARM, which is the only platform still using the infamous
> NO_IRQ (=-1). As this is a driver for ARM hardware, using irq == NO_IRQ
> would make sense, though.

This has nothing to do with NO_IRQ.  You could do:

-       if (!res || !irq) {
+       if (!res || irq <= (int)NO_IRQ) {

but this looks too ugly.  (IMHO using NO_IRQ is already ugly.)

Still, before my patch platform_get_irq return 0 was an error and if
this should be handled as irq0 this is a separate issue that should be
fixed in a separate patch.

Best regards
Uwe

PS:

linux-2.6$ git grep -E 'define *NO_IRQ\>' arch/*/include
arch/arm/include/asm/irq.h:#define NO_IRQ       ((unsigned int)(-1))
arch/microblaze/include/asm/irq.h:#define NO_IRQ (-1)
arch/mn10300/include/asm/irq.h:#define NO_IRQ           INT_MAX
arch/parisc/include/asm/irq.h:#define NO_IRQ            (-1)
arch/powerpc/include/asm/irq.h:#define NO_IRQ                   (0)


-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
