Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbZCIRlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbZCIRlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 13:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbZCIRlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 13:41:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49786 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbZCIRlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 13:41:10 -0400
Message-ID: <49B54688.8090403@redhat.com>
Date: Mon, 09 Mar 2009 12:40:40 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH -tip 5/4] Expands irq-off region in text_poke()
References: <49B1428A.9050500@redhat.com> <49B14352.2040705@redhat.com> <20090306181356.GD14236@Krystal> <49B16C69.6060203@redhat.com> <20090306190828.GA28582@elte.hu> <20090306191517.GG14236@Krystal> <20090306192246.GF28582@elte.hu> <49B186A9.3030506@redhat.com> <20090306210116.GB20603@Krystal> <49B19C5B.30805@redhat.com> <20090307014219.GA27154@Krystal>
In-Reply-To: <20090307014219.GA27154@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
>>> I think irq off should cover the BUG_ON too. This safety check assumes
>>> we are the only ones modifying "addr".
>> I think others don't change without text_mutex, don't it?
>>
> 
> They shouldn't, but given we decided to grow the irq off region to
> contain all the code that needs to be executed atomically, it should
> also contain the BUG_ON, because it is expected to be as atomic as the
> rest of the code.

Hm, sure, I updated the delta patch.

Expand irq-off region to cover fixmap using code and cache synchronizing.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/alternative.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/alternative.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/alternative.c
+++ linux-2.6-tip/arch/x86/kernel/alternative.c
@@ -526,13 +526,12 @@ void *__kprobes text_poke(void *addr, co
 		pages[1] = virt_to_page(addr + PAGE_SIZE);
 	}
 	BUG_ON(!pages[0]);
+	local_irq_save(flags);
 	set_fixmap(FIX_TEXT_POKE0, page_to_phys(pages[0]));
 	if (pages[1])
 		set_fixmap(FIX_TEXT_POKE1, page_to_phys(pages[1]));
 	vaddr = (char *)fix_to_virt(FIX_TEXT_POKE0);
-	local_irq_save(flags);
 	memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
-	local_irq_restore(flags);
 	clear_fixmap(FIX_TEXT_POKE0);
 	if (pages[1])
 		clear_fixmap(FIX_TEXT_POKE1);
@@ -542,5 +541,6 @@ void *__kprobes text_poke(void *addr, co
 	   that causes hangs on some VIA CPUs. */
 	for (i = 0; i < len; i++)
 		BUG_ON(((char *)addr)[i] != ((char *)opcode)[i]);
+	local_irq_restore(flags);
 	return addr;
 }

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

