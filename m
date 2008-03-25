Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbYCYIxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbYCYIxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 04:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbYCYIxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 04:53:23 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:34252 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbYCYIxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 04:53:22 -0400
From: Junio C Hamano <gitster@pobox.com>
To: corbet@lwn.net (Jonathan Corbet)
Cc: Andrew Morton <akpm@linux-foundation.org>, stern@rowland.harvard.edu,
       khali@linux-fr.org, mb@bu3sch.de, hmh@hmh.eng.br, david-b@pacbell.net,
       rpurdie@rpsys.net, linux-kernel@vger.kernel.org, mingo@elte.hu,
       geert@linux-m68k.org
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
References: <20080324124229.5d49ded6.akpm@linux-foundation.org>
 <25897.1206388397@vena.lwn.net>
Date: Tue, 25 Mar 2008 01:52:58 -0700
In-Reply-To: <25897.1206388397@vena.lwn.net> (Jonathan Corbet's message of
 "Mon, 24 Mar 2008 13:53:17 -0600")
Message-ID: <7vbq53mbh1.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

corbet@lwn.net (Jonathan Corbet) writes:

> diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
> index 4982998..63a7782 100644
> --- a/include/linux/hardirq.h
> +++ b/include/linux/hardirq.h
> @@ -72,6 +72,13 @@
>  #define in_softirq()		(softirq_count())
>  #define in_interrupt()		(irq_count())
>  
> +/*
> + * Are we running in atomic context?  WARNING: this macro cannot
> + * always detect atomic context; in particular, it cannot know about
> + * held spinlocks in non-preemptible kernels.  Thus it should not be
> + * used in the general case to determine whether sleeping is possible.
> + * Do not use in_atomic() in driver code.
> + */
>  #define in_atomic()		((preempt_count() & ~PREEMPT_ACTIVE) != 0)
>  
>  #ifdef CONFIG_PREEMPT

Is it just me who feels this comment that says "in_atomic() is not a way
to tell if we are in atomic reliably and cannot be used for such and such"
very reader-unfriendly?  Ok, maybe the macro is not reliable and is not
meant to be used for the purpose its name seems to suggest (at least to a
non-kernel person).  An inevitable question is, then what is it good for?
What's the right situation to use this macro?

I guess an additional comment "even if this says no, you could still be in
atomic, but if this says yes, then you definitely are in atomic and cannot
sleep" may help unconfuse a clueless reader like myself.
