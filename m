Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbZIRAkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbZIRAkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 20:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbZIRAkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 20:40:09 -0400
Received: from relais.videotron.ca ([24.201.245.36]:29837 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbZIRAkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 20:40:08 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_NPhyFSWPjSt0KWkHUaE7Ig)"
Date: Thu, 17 Sep 2009 20:40:10 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_RISS?= <frederic.riss@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm: Make kprobes unregistration SMP safe
In-reply-to: <1253078476.5021.65.camel@funkybook>
Message-id: <alpine.LFD.2.00.0909172039070.24133@xanadu.home>
References: <1253078476.5021.65.camel@funkybook>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_NPhyFSWPjSt0KWkHUaE7Ig)
Content-type: TEXT/PLAIN; charset=ISO-8859-1
Content-transfer-encoding: 8BIT

On Wed, 16 Sep 2009, Frédéric RISS wrote:

> ARM kprobes use an illegal instruction to trigger kprobes. In the
> current implementation, there's a race between the unregistration of a
> kprobe and the illegal instruction exception handler if they run at the
> same time on different cores. 
> 
> When reading the value of the undefined instruction, the exception
> handler might get the original legal instruction as just patched
> concurrently by arch_disarm_kprobe(). When this happen the kprobe
> handler won't run, and thus the exception handler will oops because it
> believe it just hit an undefined instruction in kernel space.
> 
> The following patch synchronizes the code patching in the kprobes
> unregistration using stop_machine and thus avoids the above race.
> 
> Signed-off-by: Frederic RISS <frederic.riss@gmail.com>

Acked-by: Nicolas Pitre <nico@fluxnic.net>

> ---
> 
> diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/kernel/kprobes.c
> index d28513f..6ada87d 100644
> --- a/arch/arm/kernel/kprobes.c
> +++ b/arch/arm/kernel/kprobes.c
> @@ -22,6 +22,7 @@
>  #include <linux/kernel.h>
>  #include <linux/kprobes.h>
>  #include <linux/module.h>
> +#include <linux/stop_machine.h>
>  #include <linux/stringify.h>
>  #include <asm/traps.h>
>  #include <asm/cacheflush.h>
> @@ -83,10 +84,24 @@ void __kprobes arch_arm_kprobe(struct kprobe *p)
>  	flush_insns(p->addr, 1);
>  }
>  
> +/*
> + * The actual disarming is done here on each CPU and synchronized using
> + * stop_machine. This synchronization is necessary on SMP to avoid removing
> + * a probe between the moment the 'Undefined Instruction' exception is raised
> + * and the moment the exception handler reads the faulting instruction from
> + * memory.
> + */
> +int __kprobes __arch_disarm_kprobe(void *p)
> +{
> +	struct kprobe *kp = p;
> +	*kp->addr = kp->opcode;
> +	flush_insns(kp->addr, 1);
> +	return 0;
> +}
> +
>  void __kprobes arch_disarm_kprobe(struct kprobe *p)
>  {
> -	*p->addr = p->opcode;
> -	flush_insns(p->addr, 1);
> +	stop_machine(__arch_disarm_kprobe, p, &cpu_online_map);
>  }
>  
>  void __kprobes arch_remove_kprobe(struct kprobe *p)
> 
> 

--Boundary_(ID_NPhyFSWPjSt0KWkHUaE7Ig)--
