Return-Path: <linux-kernel-owner+w=401wt.eu-S1757698AbZBRWbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698AbZBRWbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbZBRWaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:30:25 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:43891
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752793AbZBRWaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:30:23 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       Alok N Kataria <akataria@vmware.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 8/9] x86/paravirt: use percpu_ rather than __get_cpu_var
Date: Wed, 18 Feb 2009 14:30:17 -0800
Message-Id: <7085aa1b0de087d3ca45257b2c1355d3de7a9cf2.1234988621.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

percpu_read/write is a slightly more direct way of getting
to percpu data.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/paravirt.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 1a81ce9..0811730 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -247,16 +247,16 @@ static DEFINE_PER_CPU(enum paravirt_lazy_mode, paravirt_lazy_mode) = PARAVIRT_LA
 
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
@@ -295,7 +295,7 @@ enum paravirt_lazy_mode paravirt_get_lazy_mode(void)
 	if (in_interrupt())
 		return PARAVIRT_LAZY_NONE;
 
-	return __get_cpu_var(paravirt_lazy_mode);
+	return percpu_read(paravirt_lazy_mode);
 }
 
 void arch_flush_lazy_mmu_mode(void)
-- 
1.6.0.6

