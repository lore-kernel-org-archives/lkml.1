Return-Path: <linux-kernel-owner+w=401wt.eu-S1752465AbYGYSUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbYGYSUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 14:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbYGYSTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 14:19:49 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:7795 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159AbYGYSTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 14:19:48 -0400
Subject: Re: [PATCH v3 4/4] powerpc/mpc5200: Add mpc5200-spi (non-PSC)
	device driver
From: Daniel Walker <dwalker@mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       spi-devel-general@lists.sourceforge.net,
       dbrownell@users.sourceforge.net, linuxppc-dev@ozlabs.org,
       jonsmirl@gmail.com
In-Reply-To: <20080725073326.8485.99210.stgit@trillian.secretlab.ca>
References: <20080725072549.8485.90723.stgit@trillian.secretlab.ca>
	 <20080725073326.8485.99210.stgit@trillian.secretlab.ca>
Content-Type: text/plain
Date: Fri, 25 Jul 2008 14:19:14 -0400
Message-Id: <1217009954.13539.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-25 at 03:33 -0400, Grant Likely wrote:

> +	if (status && (irq != NO_IRQ))
> +		dev_err(&ms->master->dev, "spurious irq, status=0x%.2x\n",
> +			status);
> +
> +	/* Check if there is another transfer waiting */
> +	if (list_empty(&ms->queue))
> +		return FSM_STOP;

I don't think doing list_empty outside the critical section is totally
safe.. You might want to move it down inside the spin_lock() section.

> +	/* Get the next message */
> +	spin_lock(&ms->lock);

The part that's a little confusing here is that the interrupt can
actually activate the workqueue .. So I'm wondering if maybe you could
have this interrupt driven any workqueue driven at the same time? If you
could then you would need the above to be 
spin_lock_irq/spin_lock_irqsave ..

Daniel

