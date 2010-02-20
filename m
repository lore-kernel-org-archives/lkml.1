Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab0BTIE5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 03:04:57 -0500
Received: from www.tglx.de ([62.245.132.106]:39874 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab0BTIE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 03:04:56 -0500
Date: Sat, 20 Feb 2010 09:04:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: mingo@redhat.com, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Pan, Jacob jun" <jacob.jun.pan@intel.com>
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mrst] x86: Initialize stack canary in secondary start
In-Reply-To: <tip-35f720c5930f689647d51ad77e2a8d6f0abf66c8@git.kernel.org>
Message-ID: <alpine.LFD.2.00.1002200903170.2811@localhost.localdomain>
References: <43F901BD926A4E43B106BF17856F07559FB80D02@orsmsx508.amr.corp.intel.com> <tip-35f720c5930f689647d51ad77e2a8d6f0abf66c8@git.kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Feb 2010, tip-bot for Jacob Pan wrote:

> Commit-ID:  35f720c5930f689647d51ad77e2a8d6f0abf66c8
> Gitweb:     http://git.kernel.org/tip/35f720c5930f689647d51ad77e2a8d6f0abf66c8
> Author:     Jacob Pan <jacob.jun.pan@intel.com>
> AuthorDate: Thu, 17 Sep 2009 07:36:43 -0700
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Fri, 19 Feb 2010 16:25:17 -0800
> 
> x86: Initialize stack canary in secondary start
> 
> Some secondary clockevent setup code needs to call request_irq, which
> will cause fake stack check failure in schedule() if voluntary
> preemption model is chosen.  It is safe to have stack canary
> initialized here early, since start_secondary() does not return.

So with that patch applied we can remove the boot_init_stack_canary()
in process_32/64.c cpu_idle(), can't we ?

Thanks,

	tglx


> Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
> LKML-Reference: <43F901BD926A4E43B106BF17856F07559FB80D02@orsmsx508.amr.corp.intel.com>
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> ---
>  arch/x86/kernel/smpboot.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index b4e870c..3e6150d 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -48,6 +48,7 @@
>  #include <linux/err.h>
>  #include <linux/nmi.h>
>  #include <linux/tboot.h>
> +#include <linux/stackprotector.h>
>  
>  #include <asm/acpi.h>
>  #include <asm/desc.h>
> @@ -324,6 +325,9 @@ notrace static void __cpuinit start_secondary(void *unused)
>  	/* enable local interrupts */
>  	local_irq_enable();
>  
> +	/* to prevent fake stack check failure in clock setup */
> +	boot_init_stack_canary();
> +
>  	x86_cpuinit.setup_percpu_clockev();
>  
>  	wmb();
> 
