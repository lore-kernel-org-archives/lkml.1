Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbYFTIUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbYFTIUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 04:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYFTIT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 04:19:58 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:30983 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbYFTIT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 04:19:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Y5N8a2TV5QFm0HUtUTdB05Q8dbGtjFCZ5nTB9zD7TaBae6fEPCIl1cZ2P0TACLZtyv
         Yg7Go3u2tX/SXe9M0CHdU03QSWfrGG5d0fy2jeJW5bV4TTgmZic4yWE+mf1BHD2JfdI4
         KOQwQxmJ9aUZ4H8j5TSIIMhxmzSlqy113qAqQ=
Message-ID: <d2b9ea600806200119h665dd355u9122a09ce3b91045@mail.gmail.com>
Date: Fri, 20 Jun 2008 10:19:55 +0200
From: "Esben Haabendal" <esbenhaabendal@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add support for IRQ_NOAUTOEN in __set_irq_handler
In-Reply-To: <485AB581.9070509@doredevelopment.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <485AB581.9070509@doredevelopment.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, IRQ_NOAUTOEN is only supported with request_irq, and not fx.
set_irq_chained_handler(). As the IRQ_NOAUTOEN flag is silently ignored by
__set_irq_handler, you risk writing faulty code that start with irq enabled
although the developer expects irq disabled.

If the flag is not handled, wouldn't it make sense to return an error?

/Esben

On Thu, Jun 19, 2008 at 9:37 PM, Esben Haabendal <eha@doredevelopment.dk> wrote:
>
> Any reason for __set_irq_handler not supporting the IRQ_NOAUTOEN flag?
>
> /Esben
>
>  kernel/irq/chip.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index 964964b..42bb163 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -584,10 +584,15 @@ __set_irq_handler(unsigned int irq,
> irq_flow_handler_t handle, int is_chained,
>        desc->name = name;
>
>        if (handle != handle_bad_irq && is_chained) {
> -               desc->status &= ~IRQ_DISABLED;
>                desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
> -               desc->depth = 0;
> -               desc->chip->unmask(irq);
> +               if (!(desc->status & IRQ_NOAUTOEN)) {
> +                       desc->depth = 0;
> +                       desc->status &= ~IRQ_DISABLED;
> +                       desc->chip->unmask(irq);
> +               } else {
> +                       /* Undo nested disables: */
> +                       desc->depth = 1;
> +               }
>        }
>        spin_unlock_irqrestore(&desc->lock, flags);
>  }
