Return-Path: <linux-kernel-owner+w=401wt.eu-S1753444AbXJBFz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbXJBFz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 01:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbXJBFzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 01:55:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:52938 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbXJBFzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 01:55:48 -0400
Subject: Re: [PATCH v2 5/6] Sysace: Move IRQ handler registration to occur
	after FSM is initialized
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       axboe@kernel.dk
In-Reply-To: <20070930225726.2476.44211.stgit@trillian.cg.shawcable.net>
References: <20070930225112.2476.49914.stgit@trillian.cg.shawcable.net>
	 <20070930225726.2476.44211.stgit@trillian.cg.shawcable.net>
Content-Type: text/plain
Date: Tue, 02 Oct 2007 15:55:21 +1000
Message-Id: <1191304521.6310.94.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-09-30 at 16:57 -0600, Grant Likely wrote:
>         val |= ACE_CTRL_DATABUFRDYIRQ | ACE_CTRL_ERRORIRQ;
>         ace_out(ace, ACE_CTRL, val);
>  
> +       /* Now we can hook up the irq handler */
> +       if (ace->irq != NO_IRQ) {
> +               rc = request_irq(ace->irq, ace_interrupt, 0,
> "systemace", ace);
> +               if (rc) {
> +                       /* Failure - fall back to polled mode */
> +                       dev_err(ace->dev, "request_irq failed\n");
> +                       ace->irq = NO_IRQ;
> +               }
> +       }
> +

I don't know the HW but from the above, it looks like you enable
interrupt emission on the HW before you register the handler, which is
wrong. You should make sure on the contrary that IRQs on the HW are
disabled until after you have registered a handler.

Only really a problem if you have shared interrupts but still...

Ben.

