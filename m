Return-Path: <linux-kernel-owner+w=401wt.eu-S1760388AbYARAhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760388AbYARAhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759822AbYARAgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 19:36:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759794AbYARAgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 19:36:05 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org
Subject: [PATCH 0/7] More lguest massage.
Date: Thu, 17 Jan 2008 22:35:47 -0200
Message-Id: <12006165701019-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12006165651341-git-send-email-gcosta@redhat.com>
References: <1200616550283-git-send-email-gcosta@redhat.com> <12006165571406-git-send-email-gcosta@redhat.com> <1200616561270-git-send-email-gcosta@redhat.com> <12006165651341-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eventsrepresented in the 'changed' bitmap are per-cpu, not per-guest.
moveit to the lg_cpu structure

Signed-off-by:Glauber de Oliveira Costa <gcosta@redhat.com>
---
drivers/lguest/interrupts_and_traps.c |    2 +-
drivers/lguest/lg.h                   |    6 +++---
drivers/lguest/segments.c             |    4 ++--
drivers/lguest/x86/core.c             |   11 +++++------
4 files changed, 11 insertions(+), 12 deletions(-)

diff--git a/drivers/lguest/interrupts_and_traps.c b/drivers/lguest/interrupts_and_traps.c
index6bbfce4..9ac7455 100644
---a/drivers/lguest/interrupts_and_traps.c
+++b/drivers/lguest/interrupts_and_traps.c
@@-395,7 +395,7 @@ void load_guest_idt_entry(struct lg_cpu *cpu, unsigned int num, u32 lo, u32 hi)

	/* Mark the IDT as changed: next time the Guest runs we'll know we have
	 * to copy this again. */
-	cpu->lg->changed|= CHANGED_IDT;
+	cpu->changed|= CHANGED_IDT;

	/* Check that the Guest doesn't try to step outside the bounds. */
	if (num >= ARRAY_SIZE(cpu->arch.idt))
diff--git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
indexeb473a5..5458af8 100644
---a/drivers/lguest/lg.h
+++b/drivers/lguest/lg.h
@@-51,6 +51,9 @@ struct lg_cpu {
	u32 esp1;
	u8 ss1;

+	/*Bitmap of what has changed: see CHANGED_* above. */
+	intchanged;
+
	unsigned long pending_notify; /* pfn from LHCALL_NOTIFY */

	/* At end of a page shared mapped over lguest_pages in guest.  */
@@-92,9 +95,6 @@ struct lguest
	void __user *mem_base;
	unsigned long kernel_address;

-	/*Bitmap of what has changed: see CHANGED_* above. */
-	intchanged;
-
	struct pgdir pgdirs[4];

	unsigned long noirq_start, noirq_end;
diff--git a/drivers/lguest/segments.c b/drivers/lguest/segments.c
index0213845..635f54c 100644
---a/drivers/lguest/segments.c
+++b/drivers/lguest/segments.c
@@-159,7 +159,7 @@ void load_guest_gdt(struct lg_cpu *cpu, unsigned long table, u32 num)
	fixup_gdt_table(cpu, 0, ARRAY_SIZE(cpu->arch.gdt));
	/* Mark that the GDT changed so the core knows it has to copy it again,
	 * even if the Guest is run on the same CPU. */
-	lg->changed|= CHANGED_GDT;
+	cpu->changed|= CHANGED_GDT;
}

/* This is the fast-track version for just changing the three TLS entries.
@@-174,7 +174,7 @@ void guest_load_tls(struct lg_cpu *cpu, unsigned long gtls)
	__lgread(lg, tls, gtls, sizeof(*tls)*GDT_ENTRY_TLS_ENTRIES);
	fixup_gdt_table(cpu, GDT_ENTRY_TLS_MIN, GDT_ENTRY_TLS_MAX+1);
	/* Note that just the TLS entries have changed. */
-	lg->changed|= CHANGED_GDT_TLS;
+	cpu->changed|= CHANGED_GDT_TLS;
}
/*:*/

diff--git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index3e457f2..dea52d5 100644
---a/drivers/lguest/x86/core.c
+++b/drivers/lguest/x86/core.c
@@-75,7 +75,6 @@ static DEFINE_PER_CPU(struct lg_cpu *, last_cpu);
 */
static void copy_in_guest_info(struct lg_cpu *cpu, struct lguest_pages *pages)
{
-	structlguest *lg = cpu->lg;
	/* Copying all this data can be quite expensive.  We usually run the
	 * same Guest we ran last time (and that Guest hasn't run anywhere else
	 * meanwhile).  If that's not the case, we pretend everything in the
@@-83,7 +82,7 @@ static void copy_in_guest_info(struct lg_cpu *cpu, struct lguest_pages *pages)
	if (__get_cpu_var(last_cpu) != cpu || cpu->last_pages != pages) {
		__get_cpu_var(last_cpu) = cpu;
		cpu->last_pages = pages;
-		lg->changed= CHANGED_ALL;
+		cpu->changed= CHANGED_ALL;
	}

	/* These copies are pretty cheap, so we do them unconditionally: */
@@-99,18 +98,18 @@ static void copy_in_guest_info(struct lg_cpu *cpu, struct lguest_pages *pages)
	pages->state.guest_tss.ss1 = cpu->ss1;

	/* Copy direct-to-Guest trap entries. */
-	if(lg->changed & CHANGED_IDT)
+	if(cpu->changed & CHANGED_IDT)
		copy_traps(cpu, pages->state.guest_idt, default_idt_entries);

	/* Copy all GDT entries which the Guest can change. */
-	if(lg->changed & CHANGED_GDT)
+	if(cpu->changed & CHANGED_GDT)
		copy_gdt(cpu, pages->state.guest_gdt);
	/* If only the TLS entries have changed, copy them. */
-	elseif (lg->changed & CHANGED_GDT_TLS)
+	elseif (cpu->changed & CHANGED_GDT_TLS)
		copy_gdt_tls(cpu, pages->state.guest_gdt);

	/* Mark the Guest as unchanged for next time. */
-	lg->changed= 0;
+	cpu->changed= 0;
}

/* Finally: the code to actually call into the Switcher to run the Guest. */
--
1.5.0.6

