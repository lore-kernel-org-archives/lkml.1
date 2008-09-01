Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbYIAQfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbYIAQfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 12:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbYIAQe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 12:34:59 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:8231 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756710AbYIAQe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 12:34:57 -0400
Date: Mon, 1 Sep 2008 20:34:53 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Li Yang <leoli@freescale.com>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, dbrownell@users.sourceforge.net,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Robert Jarzmik <rjarzmik@free.fr>
Subject: Re: [PATCH] usb: add Freescale QE/CPM USB peripheral controller
	driver
Message-ID: <20080901163453.GA6178@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1219916613-28827-1-git-send-email-leoli@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <1219916613-28827-1-git-send-email-leoli@freescale.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 05:43:33PM +0800, Li Yang wrote:
> Some of Freescale SoC chips have a QE or CPM co-processor which
> supports full speed USB.  The driver adds device mode support
> of both QE and CPM USB controller to Linux USB gadget.  The
> driver is tested with MPC8360 and MPC8272, and should work with
> other models having QE/CPM given minor tweaks.
> 
> Signed-off-by: Xie Xiaobo <X.Xie@freescale.com>
> Signed-off-by: Li Yang <leoli@freescale.com>
> ---

Just found a recursive locking bug:

[...]
> +static int reset_queues(struct qe_udc *udc)
> +{

Note: this function is called from the IRQ, the IRQ handler
grabs udc->lock spinlock..

> +	u8 pipe;
> +
> +	for (pipe = 0; pipe < USB_MAX_ENDPOINTS; pipe++)
> +		udc_reset_ep_queue(udc, pipe);
> +
> +	/* report disconnect; the driver is already quiesced */
> +	udc->driver->disconnect(&udc->gadget);

In the disconnect(), g_ether driver will immediately call
qe_ep_disable() function which will try to grab &udc->lock
spinlock once again..

Not sure how to fix this properly... :-/

p.s. the same bug exists in omap_udc.c, pxa27x_udc.c and probably
other drivers as well... The only reason why it does not exploit
in most cases is that the spin_lock_irqsave for !SMP case turns
into simple local_irq_save().

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
