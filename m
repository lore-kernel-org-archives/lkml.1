Return-Path: <linux-kernel-owner+w=401wt.eu-S935567AbYBCANf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935567AbYBCANf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 19:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765348AbYBCAN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 19:13:26 -0500
Received: from mga06.intel.com ([134.134.136.21]:13758 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764489AbYBCANZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 19:13:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,296,1199692800"; 
   d="scan'208";a="333947587"
Message-ID: <47A506B8.9030609@linux.intel.com>
Date: Sat, 02 Feb 2008 16:11:36 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: latencytop: optimize LT_BACKTRACEDEPTH loops a bit
References: <1201993171.12880.8.camel@earth>
In-Reply-To: <1201993171.12880.8.camel@earth>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko wrote:
> Subject: latencytop: optimize LT_BACKTRACEDEPTH loops a bit.
> 
> It looks like there is no need to loop any longer when 'same == 0'.

thanks for the contribution!
while I like your patch, I wonder if we should go even a little further in
cleaning this up

> @@ -73,12 +73,12 @@ account_global_scheduler_latency(struct task_struct *tsk, struct latency_record
>  			continue;
>  		}
>  		for (q = 0 ; q < LT_BACKTRACEDEPTH ; q++) {
> -			if (latency_record[i].backtrace[q] !=
> -				lat->backtrace[q])
> +			unsigned long record = lat->backtrace[q];
> +
> +			if (latency_record[i].backtrace[q] != record)
>  				same = 0;
> -			if (same && lat->backtrace[q] == 0)
> -				break;
> -			if (same && lat->backtrace[q] == ULONG_MAX)
> +
> +			if (!same || record == 0 || record == ULONG_MAX)
>  				break;
>  		}

I mean, we could make it look like this:

if (latency_record[i].backtrace[q] != record) {
	same = 0;
	break;
}
/* 0 and ULONG_MAX entries denote the end of backtrace */
if (record == 0)
	break;
if (record == ULONG_MAX)
	break;


to me at least this is a bit more readable/simple than the good first step you've
already taken..
Do you want to do it this way? I'd sure encourage/endorse such a patch...
