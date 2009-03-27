Return-Path: <linux-kernel-owner+w=401wt.eu-S1760240AbZC0SFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240AbZC0SFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 14:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbZC0SCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 14:02:51 -0400
Received: from gw.goop.org ([64.81.55.164]:58160 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753600AbZC0SCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 14:02:48 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 8/8] x86/paravirt: use percpu_ rather than __get_cpu_var
Date: Fri, 27 Mar 2009 11:02:43 -0700
Message-Id: <1238176963-21093-9-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1238176963-21093-1-git-send-email-jeremy@goop.org>
References: <1238176963-21093-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Impact: minor optimisation

percpu_read/write is a slightly more direct way of getting
to percpu data.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/paravirt.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index c59a9d3..aa34423 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -246,16 +246,16 @@ static DEFINE_PER_CPU(enum paravirt_lazy_mode, paravirt_lazy_mode) = PARAVIRT_LA
 
 static inline void enter_lazy(enum paravirt_lazy_mode mode)
 {
-	BUG_ON(__get_cpu_var(paravirt_lazy_mode) != PARAVIRT_LAZY_NONE);
+	BUG_ON(percpu_read(paravirt_lazy_mode) != PARAVIRT_LAZY_NONE);
 
-	__get_cpu_var(paravirt_lazy_mode) = mode;
+	percpu_write(paravirt_lazy_mode, mode);
 }
 
 static void leave_lazy(enum paravirt_lazy_mode mode)
 {
-	BUG_ON(__get_cpu_var(paravirt_lazy_mode) != mode);
+	BUG_ON(percpu_read(paravirt_lazy_mode) != mode);
 
-	__get_cpu_var(paravirt_lazy_mode) = PARAVIRT_LAZY_NONE;
+	percpu_write(paravirt_lazy_mode, PARAVIRT_LAZY_NONE);
 }
 
 void paravirt_enter_lazy_mmu(void)
@@ -294,7 +294,7 @@ enum paravirt_lazy_mode paravirt_get_lazy_mode(void)
 	if (in_interrupt())
 		return PARAVIRT_LAZY_NONE;
 
-	return __get_cpu_var(paravirt_lazy_mode);
+	return percpu_read(paravirt_lazy_mode);
 }
 
 void arch_flush_lazy_mmu_mode(void)
-- 
1.6.0.6

