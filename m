Return-Path: <linux-kernel-owner+w=401wt.eu-S1759057AbZARExO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057AbZARExO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 23:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbZAREw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 23:52:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:34786 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbZAREw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 23:52:58 -0500
Message-ID: <4972B5A1.9090708@kernel.org>
Date: Sun, 18 Jan 2009 13:52:49 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/17] x86-64: Remove the PDA
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com> <1232115396-26367-1-git-send-email-brgerst@gmail.com> <1232115396-26367-2-git-send-email-brgerst@gmail.com> <1232115396-26367-3-git-send-email-brgerst@gmail.com> <1232115396-26367-4-git-send-email-brgerst@gmail.com> <1232115396-26367-5-git-send-email-brgerst@gmail.com> <1232115396-26367-6-git-send-email-brgerst@gmail.com> <1232115396-26367-7-git-send-email-brgerst@gmail.com> <1232115396-26367-8-git-send-email-brgerst@gmail.com> <1232115396-26367-9-git-send-email-brgerst@gmail.com> <1232115396-26367-10-git-send-email-brgerst@gmail.com> <1232115396-26367-11-git-send-email-brgerst@gmail.com> <1232115396-26367-12-git-send-email-brgerst@gmail.com> <1232115396-26367-13-git-send-email-brgerst@gmail.com> <1232115396-26367-14-git-send-email-brgerst@gmail.com> <1232115396-26367-15-git-send-email-brgerst@gmail.com> <1232115396-26367-16-git-send-email-brgerst@gmail.com>
In-Reply-To: <1232115396-26367-16-git-send-email-brgerst@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 18 Jan 2009 04:52:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Brian Gerst wrote:
> Now that the PDA is empty except for the stack canary, it can be removed.
> The irqstack is moved to the start of the per-cpu section.  If the stack
> protector is enabled, the canary overlaps the bottom 48 bytes of the irqstack
> on SMP.  On UP it is a seperate variable, since it is the only thing referenced
> via %gs.

Eh... I don't know.  Locating stack canary at hard 40byte offset is a
dirty thing to do one way or another.  I kind of like doing it
directly in the linker script as it makes the dirty nature more
obvious and doesn't require hunting down the definition in the first
section.

How about something like the following?

#define CANARY_OFFSET	40
#define CANARY_SIZE	8

DECLARE_PER_CPU(unsigned long, stack_canary);

and in linker script,

PERCPU_VADDR_PREALLOC(0, :percpu, CANARY_OFFSET + CANARY_SIZE)
per_cpu__stack_canary = __per_cpu_start + CANARY_OFFSET;

> diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
> index a09abb8..c52af06 100644
> --- a/arch/x86/kernel/vmlinux_64.lds.S
> +++ b/arch/x86/kernel/vmlinux_64.lds.S
> @@ -4,6 +4,10 @@
>  
>  #define LOAD_OFFSET __START_KERNEL_map
>  
> +#define PER_CPU_SECTIONS \
> +	*(.data.percpu.irqstack) \
> +	DEFAULT_PER_CPU_SECTIONS
> +

Where is this used?

>  #define PERCPU_VADDR(vaddr, phdr)					\
>  	PERCPU_PROLOG(vaddr)						\
> +		*(.data.percpu.first)					\
>  		*(.data.percpu.page_aligned)				\
>  		*(.data.percpu)						\
>  		*(.data.percpu.shared_aligned)				\

If this is gonna go in the generic PERCPU script directly, why just
not add DEFINE_PER_CPU_FIRST() too?

Thanks.

-- 
tejun
