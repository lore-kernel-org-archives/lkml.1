Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbYKFVgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbYKFVgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbYKFVf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:35:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733AbYKFVf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:35:56 -0500
Date: Thu, 6 Nov 2008 13:35:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/1] irq: Maintain user set affinity
Message-Id: <20081106133524.75588d96.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0811041030520.25054@blarg.am.freescale.net>
References: <Pine.LNX.4.64.0811041030520.25054@blarg.am.freescale.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008 10:31:05 -0600 (CST)
Kumar Gala <galak@kernel.crashing.org> wrote:

> >From 819ad3ed4660f4238e053728a8b5aa93d22b13d7 Mon Sep 17 00:00:00 2001
> From: Kumar Gala <galak@kernel.crashing.org>
> Date: Tue, 4 Nov 2008 10:13:53 -0600
> Subject: [PATCH 1/1] irq: Maintain user set affinity
> 
> This addresses a regression in that if a user specified an affinity
> for an interrupt that affinity information would get reset between
> a request_irq(), free_irq() and request_irq() for the same irq.
> 
> On example of this is bringing up an ethernet interface, taking
> it down and bringing it back up again.
> 
> Instead of always using the irq_default_affinity we use the
> previous setting of the IRQs affinity with the assumption that
> at boot the IRQs affinity will be set to irq_default_affinity.
> 
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
>  kernel/irq/manage.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index c498a1b..ea7d11b 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -115,9 +115,12 @@ int irq_select_affinity(unsigned int irq)
>  	if (!irq_can_set_affinity(irq))
>  		return 0;
> 
> -	cpus_and(mask, cpu_online_map, irq_default_affinity);
> -
>  	desc = irq_to_desc(irq);
> +
> +	mask = desc->affinity;
> +
> +	cpus_and(mask, cpu_online_map, mask);
> +
>  	desc->affinity = mask;
>  	desc->chip->set_affinity(irq, mask);
> 

Are you able to identify when this regression occurred?  It isn't
immediately obvious to me.

If the regression is present in 2.6.27 or earlier, do you think we
should backport the fix?  If so, a different patch would be needed due
to the presence of

commit 08678b0841267c1d00d771fe01548d86043d065e
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Tue Aug 19 20:50:05 2008 -0700

    generic: sparse irqs: use irq_desc() together with dyn_array, instead of irq_desc[]

