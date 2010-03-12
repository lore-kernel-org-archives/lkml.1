Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633Ab0CLOkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 09:40:15 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:37291 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab0CLOkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 09:40:13 -0500
Date: Fri, 12 Mar 2010 08:40:02 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Philby John <pjohn@mvista.com>
cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH] MIPS: Fix compile error implicit declaration of function
 cpu_local_wrap
In-Reply-To: <1268337816.29250.3.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1003120839310.32345@router.home>
References: <1268337816.29250.3.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please fix up the mips code!

Sample fix here.

---
 arch/mips/include/asm/fpu_emulator.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/mips/include/asm/fpu_emulator.h
===================================================================
--- linux-2.6.orig/arch/mips/include/asm/fpu_emulator.h	2010-03-03 14:48:45.000000000 -0600
+++ linux-2.6/arch/mips/include/asm/fpu_emulator.h	2010-03-03 14:48:47.000000000 -0600
@@ -41,7 +41,7 @@ struct mips_fpu_emulator_stats {
 DECLARE_PER_CPU(struct mips_fpu_emulator_stats, fpuemustats);

 #define MIPS_FPU_EMU_INC_STATS(M)					\
-	cpu_local_wrap(__local_inc(&__get_cpu_var(fpuemustats).M))
+	local_inc(&__get_cpu_var(fpuemustats).M)

 #else
 #define MIPS_FPU_EMU_INC_STATS(M) do { } while (0)

On Fri, 12 Mar 2010, Philby John wrote:

> The commit 38b7827fc removed cpu_local_xx macros that lead to
> a compile error: implicit declaration of function 'cpu_local_wrap',
> when compiled for the MIPS Cavium Octeon processors. Revert back
> to old code.
>
> CC: Christoph Lameter <cl@linux-foundation.org>
> CC: Tejun Heo <tj@kernel.org>
> CC: David Daney <ddaney@caviumnetworks.com>
> Signed-off-by: Philby John <pjohn@mvista.com>
> ---
>  arch/mips/include/asm/local.h |   25 +++++++++++++++++++++++++
>  1 files changed, 25 insertions(+), 0 deletions(-)
>
> diff --git a/arch/mips/include/asm/local.h b/arch/mips/include/asm/local.h
> index bdcdef0..65ec69d 100644
> --- a/arch/mips/include/asm/local.h
> +++ b/arch/mips/include/asm/local.h
> @@ -193,4 +193,29 @@ static __inline__ long local_sub_return(long i, local_t * l)
>  #define __local_add(i, l)	((l)->a.counter+=(i))
>  #define __local_sub(i, l)	((l)->a.counter-=(i))
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
> +#define cpu_local_add(i, l)  cpu_local_wrap(local_add((i), &__get_cpu_var(l)))
> +#define cpu_local_sub(i, l)  cpu_local_wrap(local_sub((i), &__get_cpu_var(l)))
> +
> +#define __cpu_local_inc(l)      cpu_local_inc(l)
> +#define __cpu_local_dec(l)      cpu_local_dec(l)
> +#define __cpu_local_add(i, l)   cpu_local_add((i), (l))
> +#define __cpu_local_sub(i, l)   cpu_local_sub((i), (l))
> +
>  #endif /* _ARCH_MIPS_LOCAL_H */
>
