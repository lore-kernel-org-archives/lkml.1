Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbZGWSnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbZGWSnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 14:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbZGWSnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 14:43:33 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:54184 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbZGWSnc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 14:43:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=X15FlNfPPleWQNn8B1OCqW0UL8JbX16ncYVGNlxU/ul84Ihk4ZpZ96zgqQifgzoaTE
         pHM+9QtMaGRUF/HDNBOa4dVDvwvy9SGgoXFtPdDU7s0erZypV/P077RhdhbySNbWxUEt
         dtvHQDRdUiS/MzkJX66rsNDm75QDBzZcncEIM=
MIME-Version: 1.0
In-Reply-To: <1244471650-4632-5-git-send-email-joerg.roedel@amd.com>
References: <1244471650-4632-1-git-send-email-joerg.roedel@amd.com>
	 <1244471650-4632-5-git-send-email-joerg.roedel@amd.com>
Date: Thu, 23 Jul 2009 20:43:30 +0200
Message-ID: <c384c5ea0907231143h696406fcu7219800e5998fa4b@mail.gmail.com>
Subject: Re: [PATCH 4/5] dma-debug: disable/enable irqs only once in 
	device_dma_allocations
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jun 8, 2009 at 4:34 PM, Joerg Roedel<joerg.roedel@amd.com> wrote:
> There is no need to disable/enable irqs on each loop iteration. Just
> disable irqs for the whole time the loop runs.
>
A typical need would be low interrupt latency.


> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  lib/dma-debug.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index 24c4a2c..27b369d 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -649,15 +649,19 @@ static int device_dma_allocations(struct device *dev)
>        unsigned long flags;
>        int count = 0, i;
>
> +       local_irq_save(flags);
> +
>        for (i = 0; i < HASH_SIZE; ++i) {
> -               spin_lock_irqsave(&dma_entry_hash[i].lock, flags);
> +               spin_lock(&dma_entry_hash[i].lock);
>                list_for_each_entry(entry, &dma_entry_hash[i].list, list) {
>                        if (entry->dev == dev)
>                                count += 1;
>                }
> -               spin_unlock_irqrestore(&dma_entry_hash[i].lock, flags);
> +               spin_unlock(&dma_entry_hash[i].lock);
>        }
>
> +       local_irq_restore(flags);
> +
>        return count;
>  }

Does this mean that on a UP system, interrupts are disabled for O(HASH_SIZE)?
How would that affect interrupt latencies?

Regards,
-- 
Leon
