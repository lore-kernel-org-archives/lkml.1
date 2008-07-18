Return-Path: <linux-kernel-owner+w=401wt.eu-S1757949AbYGRWgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949AbYGRWgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbYGRWgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:36:44 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48542 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753101AbYGRWgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:36:44 -0400
Message-ID: <48811AFA.3060403@sgi.com>
Date: Fri, 18 Jul 2008 15:36:42 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] cpumask: Optimize cpumask_of_cpu in	lib/smp_processor_id.c
References: <20080715211429.454823000@polaris-admin.engr.sgi.com> <20080715211430.306421000@polaris-admin.engr.sgi.com> <20080718203321.GA21280@elte.hu> <20080718203511.GA24194@elte.hu>
In-Reply-To: <20080718203511.GA24194@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> hmmm:
>>
>>> --- linux-2.6.tip.orig/lib/smp_processor_id.c
>>> +++ linux-2.6.tip/lib/smp_processor_id.c
>>>  	unsigned long preempt_count = preempt_count();
>>>  	int this_cpu = raw_smp_processor_id();
>>> -	cpumask_t this_mask;
>>> +	cpumask_of_cpu_ptr_declare(this_mask);
>>> -	this_mask = cpumask_of_cpu(this_cpu);
>>> +	cpumask_of_cpu_ptr_next(this_mask, cpu);
>> 'cpu' is not declared ...

Hmm is right...!  ;-)

Went through my logs and didn't see the file explicitly listed as
compiled but it still should have caught it.

Thanks for the fix!

> 
> commit 06f8d00e9eecb738c99b737ac38a585ea7583ad5
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Fri Jul 18 22:34:00 2008 +0200
> 
>     cpumask: Optimize cpumask_of_cpu in lib/smp_processor_id.c, fix
>     
>     fix typo.
>     
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  lib/smp_processor_id.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
> index 9fb2df0..c4381d9 100644
> --- a/lib/smp_processor_id.c
> +++ b/lib/smp_processor_id.c
> @@ -23,7 +23,7 @@ notrace unsigned int debug_smp_processor_id(void)
>  	 * Kernel threads bound to a single CPU can safely use
>  	 * smp_processor_id():
>  	 */
> -	cpumask_of_cpu_ptr_next(this_mask, cpu);
> +	cpumask_of_cpu_ptr_next(this_mask, this_cpu);
>  
>  	if (cpus_equal(current->cpus_allowed, *this_mask))
>  		goto out;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

