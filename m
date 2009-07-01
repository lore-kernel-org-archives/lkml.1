Return-Path: <linux-kernel-owner+w=401wt.eu-S1754969AbZGAVRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbZGAVRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 17:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbZGAVRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 17:17:32 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:57763 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751212AbZGAVRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 17:17:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqcFAC9rS0pMQWU3/2dsb2JhbACBUc8ehBEF
Date: Wed, 1 Jul 2009 17:17:30 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [BUGFIX PATCH -tip] x86: Fix fixmap page order in text_poke()
Message-ID: <20090701211730.GG19926@Krystal>
References: <20090701210246.22089.65697.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090701210246.22089.65697.stgit@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:16:35 up 123 days, 17:42,  3 users,  load average: 0.29, 0.38,
	0.46
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Since the fixmap pages are assigned higher address to lower, text_poke()
> has to use it with inverted order (FIX_TEXT_POKE1 to FIX_TEXT_POKE0).
> 

Hrm, is that only true for x86_32 or also for x86_64 ?

Reading arch/x86/include/asm/fixmap.h :

 * for x86_32: We allocate these special addresses
 * from the end of virtual memory (0xfffff000) backwards.
 * Also this lets us do fail-safe vmalloc(), we
 * can guarantee that these special addresses and
 * vmalloc()-ed addresses never overlap.

Mathieu

> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
> 
>  arch/x86/kernel/alternative.c |   14 +++++++++-----
>  1 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index f576587..4d8b40b 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -527,14 +527,18 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
>  	}
>  	BUG_ON(!pages[0]);
>  	local_irq_save(flags);
> -	set_fixmap(FIX_TEXT_POKE0, page_to_phys(pages[0]));
> +	/*
> +	 * Since the fixmaps are assinged from higher address to lower,
> +	 * we use FIX_TEXT_POKE1 first, and FIX_TEXT_POKE0 second.
> +	 */
> +	set_fixmap(FIX_TEXT_POKE1, page_to_phys(pages[0]));
>  	if (pages[1])
> -		set_fixmap(FIX_TEXT_POKE1, page_to_phys(pages[1]));
> -	vaddr = (char *)fix_to_virt(FIX_TEXT_POKE0);
> +		set_fixmap(FIX_TEXT_POKE0, page_to_phys(pages[1]));
> +	vaddr = (char *)fix_to_virt(FIX_TEXT_POKE1);
>  	memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
> -	clear_fixmap(FIX_TEXT_POKE0);
> +	clear_fixmap(FIX_TEXT_POKE1);
>  	if (pages[1])
> -		clear_fixmap(FIX_TEXT_POKE1);
> +		clear_fixmap(FIX_TEXT_POKE0);
>  	local_flush_tlb();
>  	sync_core();
>  	/* Could also do a CLFLUSH here to speed up CPU recovery; but
> 
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America), Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
