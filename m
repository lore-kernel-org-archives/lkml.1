Return-Path: <linux-kernel-owner+w=401wt.eu-S1757885AbZJGKJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbZJGKJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 06:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbZJGKJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 06:09:16 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43039 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740AbZJGKJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 06:09:15 -0400
Date: Wed, 7 Oct 2009 12:07:56 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Russell King <rmk@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       linux-rt-users@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Using set_irq_handler in set_irq_type callback?
Message-ID: <20091007100756.GA5478@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo,

I'm seeing an imx31 (ARCH=arm) based system failing to boot .31.2-rt13.

The reason is that the irq for the ethernet device is level triggered,
but the handler for that interrupt is handle_edge_irq.
As the handler is threaded with PREEMPT_RT=y, the irq is only acked but
neither masked (as it is believed to be an edge irq) nor handled.  This
stucks the machine as the irq is still active.

I think the fix for that is adding something like:

	if (type & IRQ_TYPE_EDGE_BOTH)
		set_irq_handler(irq, handle_edge_irq);
	else
		set_irq_handler(irq, handle_level_irq);

to the chip's .set_type callback.  (Doing this directly fails, as
.set_type holds desc->lock which set_irq_handler acquires, too.  So
maybe I need to code up a handler that checks how a given irq triggers
and then calls handle_edge_irq or handle_level_irq.)

The thing that let's me question that change is that I only found[1] a
single .set_type callback that does something like that (i.e.
arch/blackfin/mach-common/ints-priority.c).

Do I just miss something or are there more than one platforms that are
in the need of handling this issue, too?

Best regards
Uwe

[1] checking files found by 

	git grep -c set_irq_handler | awk -F: '$2 >= 2'

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
