Return-Path: <linux-kernel-owner+w=401wt.eu-S1761357AbYFIOXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357AbYFIOXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760734AbYFIOTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:19:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759326AbYFIOTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:19:13 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       hugh@veritas.com
Subject: [PATCH 15/15] x86: take load_sp0 out of smpboot.c
Date: Mon,  9 Jun 2008 11:16:58 -0300
Message-Id: <1213021018-14159-16-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1213021018-14159-15-git-send-email-gcosta@redhat.com>
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com>
 <1213021018-14159-2-git-send-email-gcosta@redhat.com>
 <1213021018-14159-3-git-send-email-gcosta@redhat.com>
 <1213021018-14159-4-git-send-email-gcosta@redhat.com>
 <1213021018-14159-5-git-send-email-gcosta@redhat.com>
 <1213021018-14159-6-git-send-email-gcosta@redhat.com>
 <1213021018-14159-7-git-send-email-gcosta@redhat.com>
 <1213021018-14159-8-git-send-email-gcosta@redhat.com>
 <1213021018-14159-9-git-send-email-gcosta@redhat.com>
 <1213021018-14159-10-git-send-email-gcosta@redhat.com>
 <1213021018-14159-11-git-send-email-gcosta@redhat.com>
 <1213021018-14159-12-git-send-email-gcosta@redhat.com>
 <1213021018-14159-13-git-send-email-gcosta@redhat.com>
 <1213021018-14159-14-git-send-email-gcosta@redhat.com>
 <1213021018-14159-15-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

there's no particular reason to do load_sp0 in different
places for i386 and x86_64. They should all be in cpu_init.
Right now, cpu_init itself is not integrated, but with this patch,
the code becomes closer to each other, making in easier to integrate
when the time comes.

Furthermore, although doing it in do_boot_cpu for x86_64 is fine, since it's
only a copy, load_sp0 should be executed in the cpu it refers to anyway.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/setup64.c |    1 +
 arch/x86/kernel/smpboot.c |    1 -
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup64.c b/arch/x86/kernel/setup64.c
index 70ff071..151d315 100644
--- a/arch/x86/kernel/setup64.c
+++ b/arch/x86/kernel/setup64.c
@@ -247,6 +247,7 @@ void __cpuinit cpu_init (void)
 		BUG();
 	enter_lazy_tlb(&init_mm, me);
 
+	load_sp0(t, &current->thread);
 	set_tss_desc(cpu, t);
 	load_TR_desc();
 	load_LDT(&init_mm.context);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7952c39..371113a 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -864,7 +864,6 @@ do_rest:
 	irq_ctx_init(cpu);
 #else
 	cpu_pda(cpu)->pcurrent = c_idle.idle;
-	load_sp0(&per_cpu(init_tss, cpu), &c_idle.idle->thread);
 	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
 #endif
 	initial_code = (unsigned long)start_secondary;
-- 
1.5.4.5

