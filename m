Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445AbYLATxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbYLATxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 14:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbYLATxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 14:53:12 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:60812 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbYLATxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 14:53:11 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49344092.9050908@s5r6.in-berlin.de>
Date: Mon, 01 Dec 2008 20:52:50 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ieee1394: sbp2: fix race condition in state change
References: <tkrat.b365b7fbc771f9d0@s5r6.in-berlin.de>
In-Reply-To: <tkrat.b365b7fbc771f9d0@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> An intermediate transition from _RUNNING to _IN_SHUTDOWN could have been
> missed by the former code.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>  drivers/ieee1394/sbp2.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> Index: linux/drivers/ieee1394/sbp2.c
> ===================================================================
> --- linux.orig/drivers/ieee1394/sbp2.c
> +++ linux/drivers/ieee1394/sbp2.c
> @@ -895,12 +895,13 @@ static void sbp2_host_reset(struct hpsb_
>  		return;
>  
>  	read_lock_irqsave(&sbp2_hi_logical_units_lock, flags);
> +
>  	list_for_each_entry(lu, &hi->logical_units, lu_list)
> -		if (likely(atomic_read(&lu->state) !=
> -			   SBP2LU_STATE_IN_SHUTDOWN)) {
> -			atomic_set(&lu->state, SBP2LU_STATE_IN_RESET);
> +		if (atomic_cmpxchg(&lu->state,
> +				   SBP2LU_STATE_RUNNING, SBP2LU_STATE_IN_RESET)
> +		    == SBP2LU_STATE_RUNNING)
>  			scsi_block_requests(lu->shost);
> -		}
> +
>  	read_unlock_irqrestore(&sbp2_hi_logical_units_lock, flags);
>  }
>  

Still not entirely correct.  Maybe

		scsi_block_requests(lu->shost);
		if (atomic_cmpxchg(&lu->state,
				   SBP2LU_STATE_RUNNING,
				   SBP2LU_STATE_IN_RESET)
		    == SBP2LU_IN_SHUTDOWN)
			scsi_unblock_requests(lu->shost);

Does What I Mean.  Or I should just put a lock around all lu->state and
shost->host_self_blocked manipulations.
-- 
Stefan Richter
-=====-==--- ==-- ----=
http://arcgraph.de/sr/
