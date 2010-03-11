Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174Ab0CKUSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 15:18:06 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:19108 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab0CKUSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 15:18:04 -0500
Message-ID: <4B994E0C.1010503@caviumnetworks.com>
Date: Thu, 11 Mar 2010 12:09:48 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: pjohn@mvista.com, Ralf Baechle <ralf@linux-mips.org>
CC: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] MIPS: Fix compile error implicit declaration of function
 cpu_local_wrap
References: <1268337816.29250.3.camel@localhost.localdomain>
In-Reply-To: <1268337816.29250.3.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Mar 2010 20:09:53.0413 (UTC) FILETIME=[CFFA8350:01CAC156]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2010 12:03 PM, Philby John wrote:
> The commit 38b7827fc removed cpu_local_xx macros that lead to
> a compile error: implicit declaration of function 'cpu_local_wrap',
> when compiled for the MIPS Cavium Octeon processors. Revert back
> to old code.
>
> CC: Christoph Lameter<cl@linux-foundation.org>
> CC: Tejun Heo<tj@kernel.org>
> CC: David Daney<ddaney@caviumnetworks.com>
> Signed-off-by: Philby John<pjohn@mvista.com>

Ralf is testing a different patch for this problem.

David Daney


> ---
>   arch/mips/include/asm/local.h |   25 +++++++++++++++++++++++++
>   1 files changed, 25 insertions(+), 0 deletions(-)
>
> diff --git a/arch/mips/include/asm/local.h b/arch/mips/include/asm/local.h
> index bdcdef0..65ec69d 100644
> --- a/arch/mips/include/asm/local.h
> +++ b/arch/mips/include/asm/local.h
> @@ -193,4 +193,29 @@ static __inline__ long local_sub_return(long i, local_t * l)
>   #define __local_add(i, l)	((l)->a.counter+=(i))
>   #define __local_sub(i, l)	((l)->a.counter-=(i))
>
> +/* Need to disable preemption for the cpu local counters otherwise we could
> +   still access a variable of a previous CPU in a non atomic way. */
> +#define cpu_local_wrap_v(l)             \
> +	({ local_t res__;               \
> +	   preempt_disable();           \
> +	   res__ = (l);                 \
> +	   preempt_enable();            \
> +	   res__; })
> +#define cpu_local_wrap(l)               \
> +	({ preempt_disable();           \
> +	   l;                           \
> +	   preempt_enable(); })         \
> +
> +#define cpu_local_read(l)    cpu_local_wrap_v(local_read(&__get_cpu_var(l)))
> +#define cpu_local_set(l, i)  cpu_local_wrap(local_set(&__get_cpu_var(l), (i)))
> +#define cpu_local_inc(l)     cpu_local_wrap(local_inc(&__get_cpu_var(l)))
> +#define cpu_local_dec(l)     cpu_local_wrap(local_dec(&__get_cpu_var(l)))
> +#define cpu_local_add(i, l)  cpu_local_wrap(local_add((i),&__get_cpu_var(l)))
> +#define cpu_local_sub(i, l)  cpu_local_wrap(local_sub((i),&__get_cpu_var(l)))
> +
> +#define __cpu_local_inc(l)      cpu_local_inc(l)
> +#define __cpu_local_dec(l)      cpu_local_dec(l)
> +#define __cpu_local_add(i, l)   cpu_local_add((i), (l))
> +#define __cpu_local_sub(i, l)   cpu_local_sub((i), (l))
> +
>   #endif /* _ARCH_MIPS_LOCAL_H */

