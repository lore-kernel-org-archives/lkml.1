Return-Path: <linux-kernel-owner+w=401wt.eu-S1758838AbXK1OoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838AbXK1OoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 09:44:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbXK1Onw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 09:43:52 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:63608 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbXK1Onv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 09:43:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=jS57mxPxiq7TnXhVkUOJ5nIsXMgZuhBSWA67h44acCWqXefKZlVNOJCTxrIq1uAdx2hymm9y8C3sD5wDCqTLYmF7MAVDrzKdDmrecNyS8QkBFWUmMWIynKR5vuN6HEAwiMxPIzi8TFkTUc7+P0mbTvuxMb1Yb8C/jBTSaOhL5bU=
Message-ID: <3efb10970711280643q50a91aeeoee2a28455e80cb8e@mail.gmail.com>
Date: Wed, 28 Nov 2007 15:43:49 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Kevin Hilman" <khilman@mvista.com>
Subject: Re: [PATCH PREEMPT_RT]: On AT91 ARM: GPIO Interrupt handling can/will stall forever
Cc: "Daniel Walker" <dwalker@mvista.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <87bq9fqpoi.fsf@vence.hilman.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3efb10970711260531x5e9f05acgfabdfa885a220192@mail.gmail.com>
	 <87bq9fqpoi.fsf@vence.hilman.org>
X-Google-Sender-Auth: d611fa325b6b2f54
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kevin,

Just copied your mail to the list, maybe your solution is also worth looking at.

Remy

> I had a similar issue when using the chained GPIO interrupts on OMAP
> under PREEMPT_RT.
>
> I believe the chained handler itself is supposed to be doing the
> ack/unmask instead of the simple_handler.
>
> However, currently there is no way for the chained handler to know
> when the threaded handler has acutally run.  So the way I fixed this
> was to have the simple handler call the chip->end hook so that the
> chained handler could do the ack/unmask after the threaded handler has
> actually run.
>
> I've been using this against the -rt patch since 2.6.21, and submitted
> and RFC a while back, but got no comments.
>
> This patch is against 2.6.24-rc2-rt1.
>
> Signed-off-by: Kevin Hilman <khilman@mvista.com>
>
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index b35d209..2f9e09e 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -661,6 +661,8 @@ static void thread_simple_irq(irq_desc_t *desc)
>                         note_interrupt(irq, desc, action_ret);
>         }
>         desc->status &= ~IRQ_INPROGRESS;
> +       if (desc->chip->end)
> +               desc->chip->end(irq);
>  }
>
>  /*
>
>
>
>
