Return-Path: <linux-kernel-owner+w=401wt.eu-S1756914AbZABDUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbZABDUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 22:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792AbZABDUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 22:20:10 -0500
Received: from main.gmane.org ([80.91.229.2]:53745 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729AbZABDUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 22:20:08 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Raja R Harinath <harinath@hurrynot.org>
Subject: Re: [PATCH for -tip 4/4] irq: for_each_irq_desc() makes simplify
Date: Thu, 01 Jan 2009 23:35:21 +0530
Message-ID: <87wsdezyu6.fsf@hariville.hurrynot.org>
References: <20081226121703.5CA3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20081226122830.5CAF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 59.96.115.95
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
Cancel-Lock: sha1:/7QksPgAYijkdPRuwX7uAGx7zcY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:

> Subject: [PATCH] irq: for_each_irq_desc() makes simplify
> Impact: cleanup
>
> all for_each_irq_desc() usage point have !desc check.
> then its check can move into for_each_irq_desc() macro.
[snip]
> Index: b/include/linux/irqnr.h
> ===================================================================
> --- a/include/linux/irqnr.h
> +++ b/include/linux/irqnr.h
> @@ -25,10 +25,14 @@ extern struct irq_desc *irq_to_desc(unsi
>  
>  # define for_each_irq_desc(irq, desc)					\
>  	for (irq = 0, desc = irq_to_desc(irq); irq < nr_irqs;		\
> -	     irq++, desc = irq_to_desc(irq))
> +	     irq++, desc = irq_to_desc(irq))				\
> +		if (desc)
> +
> +
>  # define for_each_irq_desc_reverse(irq, desc)				\
>  	for (irq = nr_irqs - 1, desc = irq_to_desc(irq); irq >= 0;	\
> -	     irq--, desc = irq_to_desc(irq))
> +	     irq--, desc = irq_to_desc(irq))				\
> +		if (desc)

I know this has gone in, but isn't this naked 'if' unsafe.  Consider the
following hypothetical code:

  if (safe)
    for_each_irq_desc(irq, desc) {
       ...
    }
  else
    panic();

With the macro definition above, the loop would panic() each time !desc,
and _not_ panic() when !safe.  I'd consider this behaviour to be
unexpected, to say the least :-)

The fix is to change the

  if (desc)

in the macro to

  if (!desc) ; else

- Hari

