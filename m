Return-Path: <linux-kernel-owner+w=401wt.eu-S1759615AbXGCPiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759615AbXGCPiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbXGCPhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:37:52 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:47100 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754306AbXGCPhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:37:51 -0400
Date: Tue, 3 Jul 2007 11:37:47 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1 bad_page events.
Message-ID: <20070703153747.GA28808@Krystal>
References: <20070703150656.4f618dd5@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070703150656.4f618dd5@the-village.bc.nu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:35:51 up 2 days, 10:18,  7 users,  load average: 0.47, 1.16, 1.25
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

I already sent a fix to Andrew and Andi for this (hrm, forget to CC
lkml on the original message):


x86_64 mm cpa cache flush fix

X86_64 and i386 cpa cache flush fix:

list_del the deferred list entries to poison their pointers.
clear the flag for every page put in the list.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <ak@suse.de>
---
 arch/i386/mm/pageattr.c   |    3 ++-
 arch/x86_64/mm/pageattr.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/arch/i386/mm/pageattr.c
===================================================================
--- linux-2.6-lttng.orig/arch/i386/mm/pageattr.c	2007-06-29 12:33:47.000000000 -0400
+++ linux-2.6-lttng/arch/i386/mm/pageattr.c	2007-06-29 12:35:45.000000000 -0400
@@ -245,10 +245,11 @@
 	spin_unlock_irq(&cpa_lock);
 	flush_map(&l);
 	list_for_each_entry_safe(pg, next, &l, lru) {
+		clear_bit(PG_arch_1, &pg->flags);
+		list_del(&pg->lru);
 		if (page_private(pg) != 0)
 			continue;
 		ClearPagePrivate(pg);
-		clear_bit(PG_arch_1, &pg->flags);
 		__free_page(pg);
 	}
 }
Index: linux-2.6-lttng/arch/x86_64/mm/pageattr.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86_64/mm/pageattr.c	2007-06-29 12:33:51.000000000 -0400
+++ linux-2.6-lttng/arch/x86_64/mm/pageattr.c	2007-06-29 12:34:57.000000000 -0400
@@ -235,10 +235,11 @@
 	flush_map(&l);
 
 	list_for_each_entry_safe(pg, next, &l, lru) {
+		clear_bit(PG_arch_1, &pg->flags);
+		list_del(&pg->lru);
 		if (page_private(pg) != 0)
 			continue;
 		ClearPagePrivate(pg);
-		clear_bit(PG_arch_1, &pg->flags);
 		__free_page(pg);
 	} 
 } 



* Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> X86 32bit with lots of debug turned on I get this:
> 
> 
> 
> Freeing unused kernel memory: 156k freed
> Write protecting the kernel text: 1668k
> Write protecting the kernel read-only data: 719k
> Bad page state in process 'swapper'
> page:c10000c0 flags:0x00000400 mapping:00000000 mapcount:0 count:0
> Trying to fix it up, but a reboot is needed
> Backtrace:
>  [<c024589c>] bad_page+0x6c/0x100
>  [<c024648d>] free_hot_cold_page+0x5d/0x140
>  [<c02116c2>] global_flush_tlb+0x112/0x130
>  [<c020102d>] init_post+0xd/0xe0
>  [<c047c876>] kernel_init+0x216/0x220
>  [<c0214c50>] schedule_tail+0x0/0xe0
>  [<c047c660>] kernel_init+0x0/0x220
>  [<c047c660>] kernel_init+0x0/0x220
>  [<c0204227>] kernel_thread_helper+0x7/0x10
>  =======================
> Hexdump:
> 000: 00 06 00 00 01 00 00 00 ff ff ff ff 0f 00 00 00
> 010: 00 00 00 00 00 00 00 00 78 00 00 c1 b8 00 00 c1
> 020: 00 06 00 00 01 00 00 00 ff ff ff ff a7 03 00 00
> 030: 00 00 00 00 00 00 00 00 98 00 00 c1 d8 00 00 c1
> 040: 00 04 00 00 00 00 00 00 ff ff ff ff 00 00 00 00
> 050: 00 00 00 00 00 00 00 00 b8 00 00 c1 f8 00 00 c1
> 060: 00 06 00 00 01 00 00 00 ff ff ff ff 00 04 00 00
> 070: 00 00 00 00 00 00 00 00 d8 00 00 c1 18 01 00 c1
> 080: 00 06 00 00 01 00 00 00 ff ff ff ff 9c 03 00 00
> 090: 00 00 00 00 00 00 00 00 f8 00 00 c1 38 01 00 c1
> 0a0: 00 06 00 00 01 00 00 00 ff ff ff ff 00 04 00 00
> 0b0: 00 00 00 00 00 00 00 00 18 01 00 c1 58 01 00 c1
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
