Return-Path: <linux-kernel-owner+w=401wt.eu-S1755106AbYHXLlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbYHXLlh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 07:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbYHXLl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 07:41:27 -0400
Received: from homer.mvista.com ([63.81.120.155]:40532 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752971AbYHXLl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 07:41:26 -0400
Message-ID: <48B148DE.8000101@ru.mvista.com>
Date: Sun, 24 Aug 2008 15:41:18 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: petkovbb@gmail.com, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide-atapi: use drive->waiting_for_dma
References: <20080824070119.GA18284@gollum.tnic>
In-Reply-To: <20080824070119.GA18284@gollum.tnic>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Borislav Petkov wrote:

> .. and remove PC_FLAG_DMA_IN_PROGRESS. There should
> be no functionality change resulting from this patch.
>
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
>   

   Unfortunately, this 'patch doesnt look right...

> diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
> index a1d8c35..09ac062 100644
> --- a/drivers/ide/ide-atapi.c
> +++ b/drivers/ide/ide-atapi.c
>   
[...]
> @@ -303,7 +303,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
>  		debug_log("Packet command completed, %d bytes transferred\n",
>  			  pc->xferred);
>  
> -		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
> +		drive->waiting_for_dma = 0;
>   

   Must've been already cleared by the dma_end() method called from this 
function.

> @@ -347,8 +347,8 @@ cmd_finished:
>  		return ide_stopped;
>  	}
>  
> -	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
> -		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
> +	if (drive->waiting_for_dma) {
> +		drive->waiting_for_dma = 0;
>   

   Same here...

> @@ -528,7 +528,7 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
>  
>  	/* Begin DMA, if necessary */
>  	if (pc->flags & PC_FLAG_DMA_OK) {
> -		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
> +		drive->waiting_for_dma = 1;
>   

   This flag must've been already set by the dma_setup() method called 
from ide_issue_pc().

MBR, Sergei


