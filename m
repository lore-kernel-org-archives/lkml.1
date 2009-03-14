Return-Path: <linux-kernel-owner+w=401wt.eu-S1765470AbZCNB57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765470AbZCNB57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755856AbZCNBVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:21:53 -0400
Received: from kroah.org ([198.145.64.141]:35810 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755073AbZCNBVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:21:22 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:46 2009
Message-Id: <20090314011046.066141918@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:11:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 099/114] x86/paravirt: make arch_flush_lazy_mmu/cpu disable preemption
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=x86-paravirt-make-arch_flush_lazy_mmu-cpu-disable-preemption.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeremy Fitzhardinge <jeremy@goop.org>

commit d85cf93da66977dbc645352be1b2084a659d8a0b upstream.

Impact: avoid access to percpu vars in preempible context

They are intended to be used whenever there's the possibility
that there's some stale state which is going to be overwritten
with a queued update, or to force a state change when we may be
in lazy mode.  Either way, we could end up calling it with
preemption enabled, so wrap the functions in their own little
preempt-disable section so they can be safely called in any
context (though preemption should never be enabled if we're actually
in a lazy state).

(Move out of line to avoid #include dependencies.)

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/paravirt.h |   17 ++---------------
 arch/x86/kernel/paravirt.c      |   24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 15 deletions(-)

--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -1352,14 +1352,7 @@ static inline void arch_leave_lazy_cpu_m
 	PVOP_VCALL0(pv_cpu_ops.lazy_mode.leave);
 }
 
-static inline void arch_flush_lazy_cpu_mode(void)
-{
-	if (unlikely(paravirt_get_lazy_mode() == PARAVIRT_LAZY_CPU)) {
-		arch_leave_lazy_cpu_mode();
-		arch_enter_lazy_cpu_mode();
-	}
-}
-
+void arch_flush_lazy_cpu_mode(void);
 
 #define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 static inline void arch_enter_lazy_mmu_mode(void)
@@ -1372,13 +1365,7 @@ static inline void arch_leave_lazy_mmu_m
 	PVOP_VCALL0(pv_mmu_ops.lazy_mode.leave);
 }
 
-static inline void arch_flush_lazy_mmu_mode(void)
-{
-	if (unlikely(paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU)) {
-		arch_leave_lazy_mmu_mode();
-		arch_enter_lazy_mmu_mode();
-	}
-}
+void arch_flush_lazy_mmu_mode(void);
 
 static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
 				unsigned long phys, pgprot_t flags)
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -268,6 +268,30 @@ enum paravirt_lazy_mode paravirt_get_laz
 	return __get_cpu_var(paravirt_lazy_mode);
 }
 
+void arch_flush_lazy_mmu_mode(void)
+{
+	preempt_disable();
+
+	if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU) {
+		arch_leave_lazy_mmu_mode();
+		arch_enter_lazy_mmu_mode();
+	}
+
+	preempt_enable();
+}
+
+void arch_flush_lazy_cpu_mode(void)
+{
+	preempt_disable();
+
+	if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_CPU) {
+		arch_leave_lazy_cpu_mode();
+		arch_enter_lazy_cpu_mode();
+	}
+
+	preempt_enable();
+}
+
 struct pv_info pv_info = {
 	.name = "bare hardware",
 	.paravirt_enabled = 0,


