Return-Path: <linux-kernel-owner+w=401wt.eu-S1765762AbXGYONA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765762AbXGYONA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 10:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbXGYOMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 10:12:52 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36532 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540AbXGYOMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 10:12:51 -0400
Date: Wed, 25 Jul 2007 19:41:17 +0530
From: "S. P. Prasanna" <prasanna@in.ibm.com>
To: Srinivasa Ds <srinivasa@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, jkenisto@us.ibm.com,
       systemtap@sources.redhat.com, suzuki@in.ibm.com
Subject: Re: [RFC] [PATCH] To vunmap correct address in text_poke()(kprobes)
Message-ID: <20070725141117.GA7254@in.ibm.com>
Reply-To: prasanna@in.ibm.com
References: <200707251221.49827.srinivasa@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707251221.49827.srinivasa@in.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 12:21:49PM +0530, Srinivasa Ds wrote:
> 
> When I was testing kprobes on x86_64 and I come across the below error message 
> on latest 2.6.23-rc1 kernel.
> ==========================================
> Trying to vfree() bad address (ffffc20002233199)
>  WARNING: at mm/vmalloc.c:330 __vunmap()
> 
>  Call Trace:
>  [<ffffffff8023d199>] sys_gettimeofday+0x0/0x62
>   [<ffffffff8047636c>] text_poke+0x119/0x124
>   [<ffffffff80476b42>] arch_arm_kprobe+0x1c/0x21
>   [<ffffffff80477cfd>] __register_kprobe+0x28a/0x2ed
>   [<ffffffff8815a039>] :gettimeofday:kprobe_init+0x39/0x65
>   [<ffffffff8025b5cf>] sys_init_module+0x1626/0x1788
>   [<ffffffff802aaf12>] dput+0x3f/0xfa
>   [<ffffffff8026bf91>] audit_syscall_entry+0x141/0x174
>   [<ffffffff8020bee5>] tracesys+0xdc/0xe1
> 
> ======================================================
> 
> This indicates that vunmap() is not receving the page-aligned address in 
> text_poke(). So the below attached patch will address this issue. Please let 
> me know your comments.
> 
> Signed-off-by: Srinivasa DS <srinivasa@in.ibm.com>
> Signed-off-by: Suzuki K P   <suzuki@in.ibm.com>
> 
> 
> Index: linux-2.6.23-rc1/arch/i386/kernel/alternative.c
> ===================================================================
> --- linux-2.6.23-rc1.orig/arch/i386/kernel/alternative.c	2007-07-23 
> 02:11:00.000000000 +0530
> +++ linux-2.6.23-rc1/arch/i386/kernel/alternative.c	2007-07-25 
> 11:45:53.000000000 +0530
> @@ -447,5 +447,5 @@ void __kprobes text_poke(void *oaddr, un
>  	if (cpu_has_clflush)
>  		asm("clflush (%0) " :: "r" (oaddr) : "memory");
>  	if (addr != oaddr)
> -		vunmap(addr);
> +		vunmap(addr-(((unsigned long)oaddr) % PAGE_SIZE));
		
It is appropriate to use PAGE_MASK rather than doing all this,
as shown below.

		vunmap((u8 *)((unsigned long)addr & PAGE_MASK));

Thanks
Prasanna

-- 
Prasanna S.P.
Linux Technology Center
India Software Labs, IBM Bangalore
Email: prasanna@in.ibm.com
Ph: 91-80-41776329
