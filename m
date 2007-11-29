Return-Path: <linux-kernel-owner+w=401wt.eu-S1762804AbXK2OST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762804AbXK2OST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 09:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761651AbXK2OSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 09:18:08 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:63615 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567AbXK2OSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 09:18:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=xgljW9+DYr3HUlBL2nrPZhCfwBLEpNdDMO7AcwNu9LVvRIpAc17x0GWu1UHPpVKRL3zwYSsQvTxOPS5X6s6Kecz3O6EXw2LCg7BtPg6RE3KXQOwa6HEYu9oy4a9AneHZKt06b+7q7z6eGD6R1KLEy3mRBcUhScoa7BhRQRRvBes=
Message-ID: <3efb10970711290618v2bd93edfrbc53d9df4b73b33b@mail.gmail.com>
Date: Thu, 29 Nov 2007 15:18:04 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH PREEMPT_RT]: On AT91 ARM: GPIO Interrupt handling can/will stall forever
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Daniel Walker" <dwalker@mvista.com>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20071129133604.GA23845@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1196177122.23808.7.camel@imap.mvista.com>
	 <3efb10970711280638l3f57104y8cf9f2e58235c3@mail.gmail.com>
	 <20071128172509.GA30173@flint.arm.linux.org.uk>
	 <Pine.LNX.4.58.0711281402210.3341@gandalf.stny.rr.com>
	 <20071128200550.GA3494@flint.arm.linux.org.uk>
	 <Pine.LNX.4.58.0711281510580.4247@gandalf.stny.rr.com>
	 <3efb10970711290214v37d85a27k9a84876d9099d7c5@mail.gmail.com>
	 <20071129102506.GB22793@flint.arm.linux.org.uk>
	 <3efb10970711290327s3c60da1ey3b6fae738090ca5@mail.gmail.com>
	 <20071129133604.GA23845@flint.arm.linux.org.uk>
X-Google-Sender-Auth: 86a3050694e3618c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

> If people insist on adding the mask/unmask crap to it, the function
> might as well be deleted and be an alias for handle_level_IRQ.  Because
> that's _precisely_ what you lot are turning it into.

First, I want to make clear that I am just debugging a problem on RT
that does not exist on mainline, and I am trying to find a way to get
it solved nicely _on RT_, and preferable in a way that it works for
everybody with the least chance for regression.

I already mentioned that RT is doing masking in this code during
normal use, where the mainline kernel does not do this, **except** in
an error situation.

I also mentioned that there are 2 ways of solving it on RT:
1) do not do masking at all, (just as on mainline), and only mask it
when there is an error (just as on mainline)
2) Fix it by adding an unmask, which I proposed in my first patch, and
which others also did in their patches. (not knowing your opinion, as
I do know)

Still, I believe, that the fact if a interrupt **can** be masked is
not a reason to forbid the simple_irq type(), and surely does not make
it automatically a level type interrupt.
The interrupt type I talk about is actually edge triggered (the
interrupt triggers on _BOTH_ edges of the input-line), but there is no
way of 'acknowledging' the interrupt, which makes the edge type
handler unsuitable, and much too heavy.
As mentioned, this type of irq is never pending, and unmasking it will
never lead to get a interrupt request immediately; the interrupt that
occurs during the masked time, is just lost.

So, as far as I can tell , the type really used on at91 for the GPIO
stuff _is_ a simple_irq as you describe, but one that can be
masked/unmasked **in case of errors**. It should never be masked
during normal use.

So, I propose option 1 to solve it on RT, and thus to trigger Steven
to NACK my first patch. I will try and see if I can make it work
_without_ masking on RT (except in case of errors, just as in
mainline).
...and probably add some clear description about the purpose of
simple_irq, especially related to masking...

Do you agree on this Russell?

> Ah, and looking at the changes to the file, the addition of the mask
> and unmask was done by someone who didn't understand what this was
> trying to do.  So that change should be backed out.

Maybe he was trying to mask the irq during an error situation?


Kind regards,

Remy
