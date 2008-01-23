Return-Path: <linux-kernel-owner+w=401wt.eu-S1754250AbYAWWEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbYAWWEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 17:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbYAWWEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 17:04:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39769 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751507AbYAWWEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 17:04:33 -0500
Date: Wed, 23 Jan 2008 14:04:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BUG_ON() bad input to request_irq
Message-Id: <20080123140414.e1ff2263.akpm@linux-foundation.org>
In-Reply-To: <200801171759.59029.rusty@rustcorp.com.au>
References: <200801171757.59026.rusty@rustcorp.com.au>
	<200801171759.59029.rusty@rustcorp.com.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 17 Jan 2008 17:59:58 +1100 Rusty Russell <rusty@rustcorp.com.au> wrote:
> Is there any reason why these bugs should be treated gently?  The
> caller might not want to check NR_IRQS and IRQ_NOREQUEST cases, but
> a NULL handler or NULL dev_id w/ shared are coding bugs.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  kernel/irq/manage.c |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff -r c2eb8ef5a0be kernel/irq/manage.c
> --- a/kernel/irq/manage.c	Thu Jan 17 15:48:03 2008 +1100
> +++ b/kernel/irq/manage.c	Thu Jan 17 15:49:33 2008 +1100
> @@ -532,13 +532,12 @@ int request_irq(unsigned int irq, irq_ha
>  	 * which interrupt is which (messes up the interrupt freeing
>  	 * logic etc).
>  	 */
> -	if ((irqflags & IRQF_SHARED) && !dev_id)
> -		return -EINVAL;
> +	BUG_ON((irqflags & IRQF_SHARED) && !dev_id);
> +	BUG_ON(!handler);
> +
>  	if (irq >= NR_IRQS)
>  		return -EINVAL;
>  	if (irq_desc[irq].status & IRQ_NOREQUEST)
> -		return -EINVAL;
> -	if (!handler)
>  		return -EINVAL;
>  
>  	action = kmalloc(sizeof(struct irqaction), GFP_ATOMIC);

If no driver is passing in args which will trigger this BUG, we presumably
don't need the patch.

If some driver _is_ passing in ags which will trigger these BUGs then it is
presumably working OK anyway.  Taking a working system and making it go BUG
is likely to upset people.

IOW: WARN_ON, please.
