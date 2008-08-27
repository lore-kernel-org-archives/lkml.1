Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbYH0LMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbYH0LMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 07:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754618AbYH0LMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 07:12:33 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:54773 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753147AbYH0LMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 07:12:31 -0400
Message-ID: <48B53695.3020703@linux.vnet.ibm.com>
Date: Wed, 27 Aug 2008 16:42:21 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080724)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       mingo@elte.hu, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUG] linux-next: Tree for August 26 - Badness at kernel/notifier.c:25
References: <20080826184008.6be39f19.sfr@canb.auug.org.au> <48B44B2D.8070809@linux.vnet.ibm.com> <48B46610.1010809@linux.intel.com>
In-Reply-To: <48B46610.1010809@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Kamalesh Babulal wrote:
>> Hi Stephen,
>>
>> Badness warning is seen, while booting up the next-20080825/26 kernels on 
>> the powerpc boxes
>>
> 
> this is fixed in the patch I sent to Ingo earlier today
> (attached again for reference)
> 
> 
> ------------------------------------------------------------------------
> 
> From eafa461d187448998b1f66c9134e66b125db9531 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Tue, 26 Aug 2008 09:01:06 -0700
> Subject: [PATCH] debug: add notifier chain debugging
> 
> during some development we suspected a case where we left something
> in a notifier chain that was from a module that was unloaded already...
> and that sort of thing is rather hard to track down.
> 
> This patch adds a very simple sanity check (which isn't all that
> expensive) to make sure the notifier we're about to call is
> actually from either the kernel itself of from a still-loaded
> module, avoiding a hard-to-chase-down crash.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> Acked-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/kernel.h |    3 +++
>  kernel/extable.c       |   16 ++++++++++++++++
>  kernel/notifier.c      |    6 ++++++
>  lib/vsprintf.c         |    2 +-
>  4 files changed, 26 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 2651f80..4e1366b 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -187,6 +187,9 @@ extern unsigned long long memparse(char *ptr, char **retptr);
>  extern int core_kernel_text(unsigned long addr);
>  extern int __kernel_text_address(unsigned long addr);
>  extern int kernel_text_address(unsigned long addr);
> +extern int func_ptr_is_kernel_text(void *ptr);
> +extern void *dereference_function_descriptor(void *ptr);
> +
>  struct pid;
>  extern struct pid *session_of_pgrp(struct pid *pgrp);
> 
> diff --git a/kernel/extable.c b/kernel/extable.c
> index a26cb2e..adf0cc9 100644
> --- a/kernel/extable.c
> +++ b/kernel/extable.c
> @@ -66,3 +66,19 @@ int kernel_text_address(unsigned long addr)
>  		return 1;
>  	return module_text_address(addr) != NULL;
>  }
> +
> +/*
> + * On some architectures (PPC64, IA64) function pointers
> + * are actually only tokens to some data that then holds the
> + * real function address. As a result, to find if a function
> + * pointer is part of the kernel text, we need to do some
> + * special dereferencing first.
> + */
> +int func_ptr_is_kernel_text(void *ptr)
> +{
> +	unsigned long addr;
> +	addr = (unsigned long) dereference_function_descriptor(ptr);
> +	if (core_kernel_text(addr))
> +		return 1;
> +	return module_text_address(addr) != NULL;
> +}
> diff --git a/kernel/notifier.c b/kernel/notifier.c
> index 823be11..522277c 100644
> --- a/kernel/notifier.c
> +++ b/kernel/notifier.c
> @@ -82,6 +82,12 @@ static int __kprobes notifier_call_chain(struct notifier_block **nl,
> 
>  	while (nb && nr_to_call) {
>  		next_nb = rcu_dereference(nb->next);
> +		if (!func_ptr_is_kernel_text(nb->notifier_call)) {
> +			WARN(1, "Invalid notifier called!");
> +			nb = next_nb;
> +			continue;
> +		}
> +
>  		ret = nb->notifier_call(nb, val, v);
> 
>  		if (nr_calls)
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index d8d1d11..f5e5ffb 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -513,7 +513,7 @@ static char *string(char *buf, char *end, char *s, int field_width, int precisio
>  	return buf;
>  }
> 
> -static inline void *dereference_function_descriptor(void *ptr)
> +void *dereference_function_descriptor(void *ptr)
>  {
>  #if defined(CONFIG_IA64) || defined(CONFIG_PPC64)
>  	void *p;

Thanks for reference of the patch, After replacing the patch with the latest 
one above on the powerpc, the warning still remains

Badness at kernel/notifier.c:86
NIP: c000000000081470 LR: c000000000081494 CTR: c00000000005a2d0
REGS: c0000021ce0bfaf0 TRAP: 0700   Not tainted  (2.6.27-rc4-next-20080826-autotest)
MSR: 8000000000029032 <EE,ME,IR,DR>  CR: 24008042  XER: 00000005
TASK = c0000015de080000[1] 'swapper' THREAD: c0000021ce0bc000 CPU: 0
GPR00: c000000000081494 c0000021ce0bfd70 c00000000081e940 c000000000749c38 
GPR04: 0000000000000003 0000000000000001 ffffffffffffffff c0000021ce0bfe90 
GPR08: ffffffffffffffff ffffffffffffffff c0000000004fd9f0 c0000000004fd9f0 
GPR12: 0000000024000042 c00000000089c300 0000000002307ef0 c0000000006332a0 
GPR16: c000000000631f28 c000000000633388 00000000018bf8b0 0000000002700000 
GPR20: c00000000070b07c c000000000707ef0 c000000000708160 c000000000631c58 
GPR24: 0000000000000003 0000000000000001 c0000021ce0bfe90 0000000000000000 
GPR28: ffffffffffffffff c000000000749c20 c0000000007bf338 c000000000749c38 
NIP [c000000000081470] .notifier_call_chain+0x70/0x140
LR [c000000000081494] .notifier_call_chain+0x94/0x140
Call Trace:
[c0000021ce0bfd70] [c000000000081494] .notifier_call_chain+0x94/0x140 (unreliable)
[c0000021ce0bfe20] [c0000000004fe3fc] .cpu_up+0x10c/0x200
[c0000021ce0bfee0] [c0000000006cdcc0] .kernel_init+0x1b0/0x440
[c0000021ce0bff90] [c0000000000299cc] .kernel_thread+0x4c/0x68
Instruction dump:
e8630000 2fa30000 419e00f0 2fa60000 419e00e8 2e270000 7c7f1b78 3b600000 
48000028 60000000 60000000 60000000 <0fe00000> 2fbd0000 2f3c0000 7fbfeb78 


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
