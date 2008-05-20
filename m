Return-Path: <linux-kernel-owner+w=401wt.eu-S1764531AbYETLBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764531AbYETLBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 07:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759438AbYETLBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 07:01:07 -0400
Received: from homer.mvista.com ([63.81.120.155]:56519 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756822AbYETLBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 07:01:06 -0400
Message-ID: <4832AF59.1020808@ru.mvista.com>
Date: Tue, 20 May 2008 15:00:41 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/40] ide-floppy: start DMA engine in idefloppy_transfer_pc1()
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain> <20080518185745.5636.55162.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185745.5636.55162.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> Start DMA engine and set PC_FLAG_DMA_IN_PROGRESS flag in
> idefloppy_transfer_pc1() instead of idefloppy_issue_pc()

    Good. I have long ago noticed that DMA is started too early in ide-floppy 
which is known to cobfuse some chips (like PDC20246) and was going to do a 
patch at first but the lack of hardware (and time) stopped me...

> so the Status Register and the Interrupt Reason Register
> are checked first.

> Cc: Borislav Petkov <petkovbb@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

> Index: b/drivers/ide/ide-floppy.c
> ===================================================================
> --- a/drivers/ide/ide-floppy.c
> +++ b/drivers/ide/ide-floppy.c
[...]
> @@ -568,6 +569,12 @@ static ide_startstop_t idefloppy_transfe
>  
>  	ide_set_handler(drive, &idefloppy_pc_intr, timeout, expiry);
>  
> +	/* Begin DMA, if necessary */
> +	if (pc->flags & PC_FLAG_DMA_OK) {
> +		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
> +		hwif->dma_ops->dma_start(drive);
> +	}
> +

    May be too early still... ide-cd does this after writing the command packet.

WBR, Sergei
