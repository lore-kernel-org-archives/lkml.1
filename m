Return-Path: <linux-kernel-owner+w=401wt.eu-S1759783AbXHKJpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759783AbXHKJpm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 05:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbXHKJpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 05:45:34 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34864 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947AbXHKJpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 05:45:34 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 11 Aug 2007 11:45:21 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] fix crash in sbp2_remove_device() when dma_set_mask()
 fails
To: Olaf Hering <olh@suse.de>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20070806122059.GA1951@suse.de>
Message-ID: <tkrat.743d7d7e44325432@s5r6.in-berlin.de>
References: <20070806122059.GA1951@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On  6 Aug, Olaf Hering wrote:
> --- a/drivers/ieee1394/sbp2.c
> +++ b/drivers/ieee1394/sbp2.c
> @@ -929,13 +929,14 @@ static void sbp2_remove_device(struct sb
>  	if (!lu)
>  		return;
>  
> -	hi = lu->hi;
> -
>  	if (lu->shost) {
>  		scsi_remove_host(lu->shost);
>  		scsi_host_put(lu->shost);
>  	}
>  	flush_scheduled_work();
> +	hi = lu->hi;
> +	if (!hi)
> +		return;

We need to kfree lu here.  Patch comes right away.

>  	sbp2util_remove_command_orb_pool(lu);
>  
>  	list_del(&lu->lu_list);
> @@ -977,8 +978,7 @@ static void sbp2_remove_device(struct sb
>  
>  	lu->ud->device.driver_data = NULL;
>  
> -	if (hi)
> -		module_put(hi->host->driver->owner);
> +	module_put(hi->host->driver->owner);
>  
>  	kfree(lu);
>  }


-- 
Stefan Richter
-=====-=-=== =--- -=-==
http://arcgraph.de/sr/

