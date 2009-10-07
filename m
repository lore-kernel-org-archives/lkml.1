Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbZJGK3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbZJGK3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 06:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758368AbZJGK33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 06:29:29 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37061 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758166AbZJGK32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 06:29:28 -0400
Date: Wed, 7 Oct 2009 11:28:36 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       linux-rt-users@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: Using set_irq_handler in set_irq_type callback?
Message-ID: <20091007102836.GA27860@flint.arm.linux.org.uk>
References: <20091007100756.GA5478@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091007100756.GA5478@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 12:07:56PM +0200, Uwe Kleine-König wrote:
> Hallo,
> 
> I'm seeing an imx31 (ARCH=arm) based system failing to boot .31.2-rt13.
> 
> The reason is that the irq for the ethernet device is level triggered,
> but the handler for that interrupt is handle_edge_irq.

There's nothing wrong with that with the conventional interrupt handling
scheme.

> As the handler is threaded with PREEMPT_RT=y, the irq is only acked but
> neither masked (as it is believed to be an edge irq) nor handled.  This
> stucks the machine as the irq is still active.

Actually, the problem is that I misnamed the edge/level handlers.
What follows here is the non-RT case.

Really, what the two are about is that the level handler is there for
interrupt controllers which behave in a good way - in other words, for
level-based inputs and for edge-based inputs which "remember" new
transitions while the input is masked.

The edge handler is for edge-based inputs where the controller does not
remember transitions with the input masked.

Forcing people to use the edge handler all the time for edge based inputs
is highly sub-optimal - it means greater interrupt load since the input
is left unmasked.

So really, the choice of the handler should be determined by how the
hardware behaves, and not by the input type requested.


When it comes to RT and its thread-based interrupt model, the assumptions
which these handlers were designed around are no longer true.  What is
now required is a different handling philosophy - rather than leaving
the interrupt-time decision about what to do with a signalled interrupt
to the flow handler, it should be immediately ack'ed and disabled, and
the interrupt thread scheduled.

It is then up to the interrupt thread to determine how to handle the
interrupt - if it's really a level interrupt, then the interrupt thread
has to call the handlers before re-enabling the input.  If it's edge
based, the input has to be re-enabled before running the handlers (so
that new edges received during the running of those handlers are
recognised.)


So, the technical aspects of handling of interrupts between the RT and
non-RT cases are quite different, and I feel that we shouldn't be
re-using the same flow handlers between the two cases.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
