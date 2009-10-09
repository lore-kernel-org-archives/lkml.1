Return-Path: <linux-kernel-owner+w=401wt.eu-S1760184AbZJICmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184AbZJICmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 22:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754269AbZJICmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 22:42:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:1355 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200AbZJICmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 22:42:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,529,1249282800"; 
   d="scan'208";a="455845527"
Subject: Re: [RFC] x86-64: make compat_start_thread() match start_thread()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4ACE8D51.1080606@zytor.com>
References: <4ACE8D51.1080606@zytor.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 08 Oct 2009 19:41:04 -0700
Message-Id: <1255056064.2638.9.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-08 at 18:09 -0700, H. Peter Anvin wrote:
> diff --git a/arch/x86/kernel/process_64.c
> b/arch/x86/kernel/process_64.c
> index ad535b6..ec223a8 100644
> --- a/arch/x86/kernel/process_64.c
> +++ b/arch/x86/kernel/process_64.c
> @@ -356,7 +356,7 @@ start_thread(struct pt_regs *regs, unsigned long
> new_ip, unsigned long new_sp)
>         percpu_write(old_rsp, new_sp);
>         regs->cs                = __USER_CS;
>         regs->ss                = __USER_DS;
> -       regs->flags             = 0x200;
> +       regs->flags             = X86_EFLAGS_IF;
>         set_fs(USER_DS);
>         /*
>          * Free the old FP and other extended state
> @@ -365,6 +365,27 @@ start_thread(struct pt_regs *regs, unsigned long
> new_ip, unsigned long new_sp)
>  }
>  EXPORT_SYMBOL_GPL(start_thread);
>  
> +#ifdef CONFIG_IA32_EMULATION
> +void compat_start_thread(struct pt_regs *regs, u32 new_ip, u32
> new_sp)
> +{
> +       loadsegment(fs, 0);
> +       loadsegment(ds, __USER32_DS);
> +       loadsegment(es, __USER32_DS);
> +       load_gs_index(0);
> +       regs->ip                = new_ip;
> +       regs->sp                = new_sp;
> +       percpu_write(old_rsp, new_sp);
> +       regs->cs                = __USER32_CS;
> +       regs->ss                = __USER32_DS;
> +       regs->flags             = X86_EFLAGS_IF;
> +       set_fs(USER_DS);
> +       /*
> +        * Free the old FP and other extended state
> +        */
> +       free_thread_xstate(current);
> +}
> +#endif
> +

Peter, While you are it, we should just merge most of the meat into one
common function handling both modes. That will be more cleaner.

thanks,
suresh

