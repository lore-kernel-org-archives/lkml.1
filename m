Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbYCNNlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbYCNNlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 09:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbYCNNlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 09:41:23 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:42586 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbYCNNlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 09:41:22 -0400
Message-ID: <47DA8078.7060804@hp.com>
Date: Fri, 14 Mar 2008 09:41:12 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, dgc@sgi.com
Subject: Re: IO CPU affinity test results
References: <47DA6C1E.8010000@hp.com> <20080314123606.GL17940@kernel.dk> <20080314130545.GO17940@kernel.dk>
In-Reply-To: <20080314130545.GO17940@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Fri, Mar 14 2008, Jens Axboe wrote:
>> I think that is encouraging, for such a small setup. The make results
>> are particularly nice. The hangs are a bother, I have no good ideas on
>> why the occur. The fact that it happens on both archs indicates that
>> this is perhaps a generic problem, which is good. The code to support
>> this is relatively simple, so it should be possible to go over it with a
>> fine toothed comb and see if anything shows up.
>>
>> You didn't get any watchdog triggers on the serial console, or anything
>> like that?
>
> Here's something that may explain it - if interrupts aren't disabled
> when generic_smp_call_function_single() is called, we could deadlock
> on the dst->lock. I think that the IPI invoke will have interrupt
> disabled, but I'm not 100% certain.
>
> Can you see if this passes the muster?
>
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 852abd3..65808df 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -24,12 +24,13 @@ void __cpuinit generic_init_call_single_data(void)
>  void generic_smp_call_function_single_interrupt(void)
>  {
>  	struct call_single_queue *q;
> +	unsigned long flags;
>  	LIST_HEAD(list);
> 
>  	q = &__get_cpu_var(call_single_queue);
> -	spin_lock(&q->lock);
> +	spin_lock_irqsave(&q->lock);
>  	list_replace_init(&q->list, &list);
> -	spin_unlock(&q->lock);
> +	spin_unlock_irqrestore(&q->lock);
> 
>  	while (!list_empty(&list)) {
>  		struct call_single_data *data;
>

Well, putting in these two small patches (/always/ invoke send_IPI_single + this one, modified to include flags on the two spin calls), things look better after two runs (without profiling enabled), this was done on the 4-way ia64 box:

Part  RQ   MIN     AVG     MAX      Dev
----- --  ------  ------  ------  ------
 mkfs  0  18.151  18.311  18.472   0.227
 mkfs  1  18.420  18.456  18.492   0.051

untar  0  18.260  18.420  18.581   0.228
untar  1  18.594  19.477  20.360   1.249

 make  0  23.730  24.149  24.567   0.592
 make  1  23.401  23.599  23.797   0.280

 comb  0  60.141  60.881  61.620   1.046
 comb  1  60.810  61.532  62.253   1.020

 psys  0   4.16%   4.17%   4.18%   0.011
 psys  1   3.80%   3.93%   4.06%   0.180

Will do a longer set of runs and report out on that. As you had noticed earlier Jens, the make results look good...

Alan
