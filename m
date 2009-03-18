Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbZCRN47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbZCRN47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 09:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbZCRN4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 09:56:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:47020 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717AbZCRN4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 09:56:49 -0400
Message-ID: <49C0FD63.2050900@windriver.com>
Date: Wed, 18 Mar 2009 09:55:47 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Yasunori Goto <y-goto@jp.fujitsu.com>
CC: Clemens Ladisch <clemens@ladisch.de>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>, robert.picco@hp.com,
       venkatesh.pallipadi@intel.com, vojtech@suse.cz, mingo@redhat.com
Subject: Re: [Patch] Fix the possibility of insane return value of hpet_calibrate()
 against SMI. (take 2)
References: <49BFA1D7.8020302@windriver.com> <20090318094346.7BA9.E1E9C6FF@jp.fujitsu.com> <20090318113948.7BAD.E1E9C6FF@jp.fujitsu.com>
In-Reply-To: <20090318113948.7BAD.E1E9C6FF@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Mar 2009 13:55:50.0611 (UTC) FILETIME=[3F243230:01C9A7D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yasunori Goto wrote:
>>>>>> Each calibration of this has 1 milli second.
>>>>>> Do you think 5 msec is too long?
>>>>>>       
>>>>>>             
>>>>> This shouldn't matter when booting.  Anyway, I think it's possible to
>>>>> increase TICK_CALIBRATE without losing too much accuracy.
>>>>>     
>>>>>           
>>>> Hmm. If the person who is trying to reduce boot time for fastboot dislikes this impact,
>>>> then I'll try Vojtech-san's way.
>>>>   
>>>>         
>>> That probably makes sense -- if it is extremely rare, and if you get two
>>> values that are the same (within some small delta) then you probably
>>> are 99.99% confident that you have the right data.
>>>       
>> Ok. I'll make it.
>>
>> Thanks for your comment.
>>     
>
> Here is updated version.
>
> --------
>
> hpet_calibrate() has a possibility of miss-calibration due to SMI.
> If SMI interrupts in the while loop of calibration, then return value
> will be big. This change calibrates until stabilizing by the return
> value with a small value.
>
>
> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
>
>
> ---
>  drivers/char/hpet.c |   21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
>
> Index: hpet_test/drivers/char/hpet.c
> ===================================================================
> --- hpet_test.orig/drivers/char/hpet.c	2009-03-12 15:47:45.000000000 +0900
> +++ hpet_test/drivers/char/hpet.c	2009-03-18 11:12:42.000000000 +0900
> @@ -713,7 +713,7 @@
>   */
>  #define	TICK_CALIBRATE	(1000UL)
>  
> -static unsigned long hpet_calibrate(struct hpets *hpetp)
> +static unsigned long __hpet_calibrate(struct hpets *hpetp)
>  {
>  	struct hpet_timer __iomem *timer = NULL;
>  	unsigned long t, m, count, i, flags, start;
> @@ -750,6 +750,25 @@
>  	return (m - start) / i;
>  }
>  
> +static unsigned long hpet_calibrate(struct hpets *hpetp)
> +{
> +	unsigned long ret = ~0UL, tmp;
> +
> +	/*
> +	 * Try to calibrate until return value becomes stable small value.
> +	 * If SMI interruption occurs in calibration loop, the return value
> +	 * will be big. This avoids its impact.
> +	 */
> +	do {
> +		tmp = __hpet_calibrate(hpetp);
> +		if (ret <= tmp)
> +			break;
> +		ret = tmp;
> +	} while (1);
>   

For what it is worth, if a situation arose where continued calls to
hpet_calibrate() represented a monotonically decreasing function,
(perhaps some insane power management?) you could be stuck
in this function for an unbounded amount of time.   I don't expect
that should ever happen, but I figured I'd mention it.

Paul.

> +
> +	return ret;
> +}
> +
>  int hpet_alloc(struct hpet_data *hdp)
>  {
>  	u64 cap, mcfg;
>
>   

