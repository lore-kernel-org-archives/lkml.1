Return-Path: <linux-kernel-owner+w=401wt.eu-S1762976AbYDVNWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762976AbYDVNWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbYDVNWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:22:00 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:62240 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759654AbYDVNV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:21:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmIFACCDDUhMROPA/2dsb2JhbACBUqsB
Date: Tue, 22 Apr 2008 09:21:51 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: mingo@elte.hu
Cc: akpm@osdl.org, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix x86_64 page fault scheduler race
Message-ID: <20080422132151.GA32120@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:19:00 up 53 days,  9:29,  5 users,  load average: 3.83, 1.91,
	0.94
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think you're vastly overestimating what is sane to do from an NMI
> context.  It is utterly and totally insane to assume vmalloc is available
> in NMI.
>
>       -hpa
>

Ok, please tell me where I am wrong then.. by looking into
arch/x86/mm/fault.c, I see that vmalloc_sync_all() touches pgd_list
entries while the pgd_lock spinlock is taken, with interrupts disabled.
So it's protected against concurrent pgd_list modification from

a - vmalloc_sync_all() on other CPUs
b - local interrupts

However, a completely normal interrupt can come on a remote CPU, run
vmalloc_fault() and issue a set_pgd concurrently. Therefore I conclude
this interrupt disable is not there to insure any kind of protection
against concurrent updates.

Also, we see that vmalloc_fault has comments such as :

(for x86_32)
         * Do _not_ use "current" here. We might be inside
         * an interrupt in the middle of a task switch..

So it takes the pgd_addr from cr3, not from current. Using only the
stack/registers makes this NMI-safe even if "current" is invalid when
the NMI comes. This is caused by the fact that __switch_to will update
the registers before updating current_task without disabling interrupts.

You are right in that x86_64 does not seems to play as safely as x86_32
on this matter; it uses current->mm. Probably it shouldn't assume
"current" is valid. Actually, I don't see where x86_64 disables
interrupts around __switch_to, so this would seem to be a race
condition. Or have I missed something ?

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@osdl.org
CC: mingo@elte.hu
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
---
 arch/x86/mm/fault.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/arch/x86/mm/fault.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/mm/fault.c	2008-04-21 13:54:54.000000000 -0400
+++ linux-2.6-lttng/arch/x86/mm/fault.c	2008-04-21 14:26:12.000000000 -0400
@@ -513,6 +513,7 @@ static int vmalloc_fault(unsigned long a
 		return -1;
 	return 0;
 #else
+	unsigned long pgd_paddr;
 	pgd_t *pgd, *pgd_ref;
 	pud_t *pud, *pud_ref;
 	pmd_t *pmd, *pmd_ref;
@@ -526,7 +527,8 @@ static int vmalloc_fault(unsigned long a
 	   happen within a race in page table update. In the later
 	   case just flush. */
 
-	pgd = pgd_offset(current->mm ?: &init_mm, address);
+	pgd_paddr = read_cr3();
+	pgd = __va(pgd_paddr) + pgd_index(address);
 	pgd_ref = pgd_offset_k(address);
 	if (pgd_none(*pgd_ref))
 		return -1;

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
