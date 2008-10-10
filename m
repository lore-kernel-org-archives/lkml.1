Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbYJJIrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbYJJIrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 04:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbYJJIrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 04:47:17 -0400
Received: from nebensachen.de ([195.34.83.29]:39817 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbYJJIrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 04:47:15 -0400
From: Elias Oltmanns <eo@nebensachen.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] ide: ide_hwgroup_t.rq doesn't need an ide_lock held
Date: Fri, 10 Oct 2008 10:34:28 +0200
Message-ID: <87abdcg86j.fsf@denkblock.local>
References: <20081008202930.19112.90371.sendpatchset@localhost.localdomain>
	<20081008203002.19112.519.sendpatchset@localhost.localdomain>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
X-Hashcash: 1:20:081010:bzolnier@gmail.com::UhFQIjPeVuLYtliA:00000000000000000000000000000000000000000000wQR
X-Hashcash: 1:20:081010:linux-ide@vger.kernel.org::DlmVgkLjjfFLSXHM:0000000000000000000000000000000000007QK2
X-Hashcash: 1:20:081010:linux-kernel@vger.kernel.org::t1AlVzKnJCrTvVqn:0000000000000000000000000000000002sYk
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: ide_hwgroup_t.rq doesn't need an ide_lock held
>
> While at it:
> - no need to check for hwgroup presence in ide_dump_opcode()
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
[...]
> Index: b/drivers/ide/ide-io.c
> ===================================================================
> --- a/drivers/ide/ide-io.c
> +++ b/drivers/ide/ide-io.c
[...]
> @@ -274,7 +269,11 @@ static void ide_complete_pm_request (ide
>  		drive->dev_flags &= ~IDE_DFLAG_BLOCKED;
>  		blk_start_queue(drive->queue);
>  	}
> -	HWGROUP(drive)->rq = NULL;
> +	spin_unlock_irqrestore(&ide_lock, flags);
> +
> +	drive->hwif->hwgroup->rq = NULL;
> +
> +	spin_lock_irqsave(&ide_lock, flags);
>  	if (__blk_end_request(rq, 0, 0))
>  		BUG();
>  	spin_unlock_irqrestore(&ide_lock, flags);

Is it really an improvement to release the lock here?

Regards,

Elias
