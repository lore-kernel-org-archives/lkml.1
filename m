Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbZA1CjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbZA1CjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 21:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbZA1CjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 21:39:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36091 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbZA1CjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 21:39:10 -0500
Message-ID: <497FC560.2000204@redhat.com>
Date: Tue, 27 Jan 2009 21:39:28 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: LKML <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: [PATCH][bugfix?][kprobes][vunmap?]: use vm_map_ram() in text_poke()
References: <497FC3B1.7050805@redhat.com>
In-Reply-To: <497FC3B1.7050805@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use vm_map_ram() instead of vmap() in text_poke(), because text_poke()
just want to map pages temporarily.

---
As far as I tested, this patch works fine for me.
However, there might be another hidden bug in the kernel...
We need to fix that too.

 arch/x86/kernel/alternative.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: 2.6-rc/arch/x86/kernel/alternative.c
===================================================================
--- 2.6-rc.orig/arch/x86/kernel/alternative.c
+++ 2.6-rc/arch/x86/kernel/alternative.c
@@ -515,12 +515,12 @@ void *__kprobes text_poke(void *addr, co
 	BUG_ON(!pages[0]);
 	if (!pages[1])
 		nr_pages = 1;
-	vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
+	vaddr = vm_map_ram(pages, nr_pages, -1, PAGE_KERNEL);
 	BUG_ON(!vaddr);
 	local_irq_save(flags);
 	memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
 	local_irq_restore(flags);
-	vunmap(vaddr);
+	vm_unmap_ram(vaddr, nr_pages);
 	sync_core();
 	/* Could also do a CLFLUSH here to speed up CPU recovery; but
 	   that causes hangs on some VIA CPUs. */
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

