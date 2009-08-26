Return-Path: <linux-kernel-owner+w=401wt.eu-S1756256AbZHZBOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbZHZBOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 21:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356AbZHZBOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 21:14:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59677 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbZHZBOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 21:14:19 -0400
Message-ID: <4A948C4A.8040004@cn.fujitsu.com>
Date: Wed, 26 Aug 2009 09:13:46 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zachary Amsden <zach@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: linux-next: reservetop fix disables mem=
References: <Pine.LNX.4.64.0908241736520.32764@sister.anvils> <4A92D029.8090807@kernel.org>
In-Reply-To: <4A92D029.8090807@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Yinghai Lu wrote:

> 
> yes, that patch will break other built-in command too.
> 
> need drop that patch.
> 

Sorry for trouble you all by my stupid patch.

The main problem is that can't parse 'reservetop' and 'mem'/'memmap'
parameters at the same time, because we should parse 'mem'/'memmap'
after e820 map detected, and it might use early_memremap() during
e820 map detecting, so we should call early_ioremap_init() before it,
'reservetop' parameter can change 'FIXADDR_TOP', so we parse
'reservetop' first,

like below sequences:
  ......
  ___parse 'reservetop'___  ->
  early_ioremap_init()	  ->
  setup_memory_map(); /* might call early_memremap()*/  ->
  parse_setup_data(); /* might call early_memremap()*/  ->
  e820_reserve_setup_data();	->
  ___parse 'mem'/'memmap' and other parameters___
  ......

(the same as 'early_ioremap_debug' parameter)

So, I'm afraid that we need separate parse 'reservetop'/
'early_ioremap_debug' parameters early

Thanks,
Xiao

> also the problem was caused by vmi patch, and that commit should be reverted.
> 
> commit ae8d04e2ecbb233926860e9ce145eac19c7835dc
> Author: Zachary Amsden <zach@vmware.com>
> Date:   Sat Dec 13 12:36:58 2008 -0800
> 
>     x86 Fix VMI crash on boot in 2.6.28-rc8
>     
>     VMI initialiation can relocate the fixmap, causing early_ioremap to
>     malfunction if it is initialized before the relocation.  To fix this,
>     VMI activation is split into two phases; the detection, which must
>     happen before setting up ioremap, and the activation, which must happen
>     after parsing early boot parameters.
>     
>     This fixes a crash on boot when VMI is enabled under VMware.
>     
>     Signed-off-by: Zachary Amsden <zach@vmware.com>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 9d5674f..bdec76e 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -794,6 +794,9 @@ void __init setup_arch(char **cmdline_p)
>         printk(KERN_INFO "Command line: %s\n", boot_command_line);
>  #endif
>  
> +       /* VMI may relocate the fixmap; do this before touching ioremap area */
> +       vmi_init();
> +
>         early_cpu_init();
>         early_ioremap_init();
>  
> @@ -880,13 +883,8 @@ void __init setup_arch(char **cmdline_p)
>         check_efer();
>  #endif
>  
> -#if defined(CONFIG_VMI) && defined(CONFIG_X86_32)
> -       /*
> -        * Must be before kernel pagetables are setup
> -        * or fixmap area is touched.
> -        */
> -       vmi_init();
> -#endif
> +       /* Must be before kernel pagetables are setup */
> +       vmi_activate();
>  
>         /* after early param, so could get panic from serial */
>         reserve_early_setup_data();
> 
> 
> and according to
> http://lkml.org/lkml/2008/12/10/388
> http://lkml.org/lkml/2008/12/10/456
> 
> Zachary should split reserve_top_address() to two functions... before sending that patch to Linus
> 
> 
> YH
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
