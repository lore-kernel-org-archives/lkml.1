Return-Path: <linux-kernel-owner+w=401wt.eu-S1760101AbYEIPI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101AbYEIPI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 11:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbYEIPIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 11:08:18 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:6838 "EHLO
	outbound2-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751675AbYEIPIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 11:08:17 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0K0LWP7-01-OPH-01
Date: Fri, 9 May 2008 17:07:59 +0200
From: Robert Richter <robert.richter@amd.com>
To: Carl Love <cel@us.ibm.com>
Cc: linuxppc-dev@ozlabs.org, cbe-oss-dev@ozlabs.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [Cbe-oss-dev]  [PATCH] Updated: Reworked Cell OProfile: SPU
	mutex lock fix
Message-ID: <20080509150759.GL24041@erda.amd.com>
References: <1209587712.7531.42.camel@carll-linux-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209587712.7531.42.camel@carll-linux-desktop>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 09 May 2008 15:07:59.0794 (UTC) FILETIME=[783D5920:01C8B1E6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please see my comments below.

-Roberta

On 30.04.08 13:35:12, Carl Love wrote:

[...]

> -int spu_sync_stop(void)
> +void spu_sync_stop(void)
>  {
>  	unsigned long flags = 0;
> -	int ret = spu_switch_event_unregister(&spu_active);
> -	if (ret) {
> -		printk(KERN_ERR "SPU_PROF: "
> -			"%s, line %d: spu_switch_event_unregister returned %d\n",
> -			__FUNCTION__, __LINE__, ret);
> -		goto out;
> -	}
> +
> +	/* Ignoring the return value from the unregister
> +	 * call.  A failed return value simply says there
> +	 * was no registered event.  Hence there will not
> +	 * be any calls to process a switch event that
> +	 * could cause a problem.
> +	 */
> +	spu_switch_event_unregister(&spu_active);

Better to use this here, to show the return value is ignored:

       (void)spu_switch_event_unregister(...)

>  
>  	spin_lock_irqsave(&cache_lock, flags);
> -	ret = release_cached_info(RELEASE_ALL);
> +	release_cached_info(RELEASE_ALL);

Dito.

>  	spin_unlock_irqrestore(&cache_lock, flags);
> -out:
>  	pr_debug("spu_sync_stop -- done.\n");
> -	return ret;
> +	return;
>  }
>  
>  
> Index: Cell_kernel_4_15_2008/arch/powerpc/oprofile/op_model_cell.c
> ===================================================================
> --- Cell_kernel_4_15_2008.orig/arch/powerpc/oprofile/op_model_cell.c
> +++ Cell_kernel_4_15_2008/arch/powerpc/oprofile/op_model_cell.c
> @@ -1191,15 +1191,15 @@ static int cell_sync_start(void)
>  	if (spu_cycle_reset)
>  		return spu_sync_start();
>  	else
> -		return DO_GENERIC_SYNC;
> +		return 0;
>  }
>  
> -static int cell_sync_stop(void)
> +static void cell_sync_stop(void)
>  {
>  	if (spu_cycle_reset)
> -		return spu_sync_stop();
> -	else
> -		return 1;
> +		spu_sync_stop();

Same here.

> +
> +	return;
>  }
>  
>  struct op_powerpc_model op_model_cell = {

[...]

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

