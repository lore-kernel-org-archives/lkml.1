Return-Path: <linux-kernel-owner+w=401wt.eu-S1756190AbZLFHfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbZLFHfy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 02:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754428AbZLFHfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 02:35:51 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35687 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221AbZLFHfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 02:35:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OmWQ1apd2NXeeux/z9klijEZPwr8ho8+NRrePBSj1rNT5dGtVDBef1P7i9qwVdMcIJ
         Sgk5rPhHykk6aandXrdMdH+0E1ux8HdV77vQLF/bEmxV38Oi+GMTTdz1eD4oQSiF5UOE
         b9OXEDZ00Gk3qSvrQGrVuZ+r+3l/GwjyGyaC0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 7/9] x86/perf: Exclude the debug stack from the callchains
Date: Sun,  6 Dec 2009 08:34:56 +0100
Message-Id: <1260084898-11686-8-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1260084898-11686-1-git-send-regression-fweisbec@gmail.com>
References: <1260084898-11686-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dumping the callchains from breakpoint events with perf gives strange
results:

3.75%             perf  [kernel]           [k] _raw_read_unlock
                       |
                       --- _raw_read_unlock
                           perf_callchain
                           perf_prepare_sample
                           __perf_event_overflow
                           perf_swevent_overflow
                           perf_swevent_add
                           perf_bp_event
                           hw_breakpoint_exceptions_notify
                           notifier_call_chain
                           __atomic_notifier_call_chain
                           atomic_notifier_call_chain
                           notify_die
                           do_debug
                           debug
                           munmap

We are infected with all the debug stack. Like the nmi stack, the debug
stack is undesired as it is part of the profiling path, not helpful for
the user.

Ignore it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: "K. Prasad" <prasad@linux.vnet.ibm.com>
---
 arch/x86/kernel/cpu/perf_event.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index c1bbed1..d35f260 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2287,7 +2287,7 @@ void callchain_store(struct perf_callchain_entry *entry, u64 ip)
 
 static DEFINE_PER_CPU(struct perf_callchain_entry, pmc_irq_entry);
 static DEFINE_PER_CPU(struct perf_callchain_entry, pmc_nmi_entry);
-static DEFINE_PER_CPU(int, in_nmi_frame);
+static DEFINE_PER_CPU(int, in_ignored_frame);
 
 
 static void
@@ -2303,8 +2303,9 @@ static void backtrace_warning(void *data, char *msg)
 
 static int backtrace_stack(void *data, char *name)
 {
-	per_cpu(in_nmi_frame, smp_processor_id()) =
-			x86_is_stack_id(NMI_STACK, name);
+	per_cpu(in_ignored_frame, smp_processor_id()) =
+			x86_is_stack_id(NMI_STACK, name) ||
+			x86_is_stack_id(DEBUG_STACK, name);
 
 	return 0;
 }
@@ -2313,7 +2314,7 @@ static void backtrace_address(void *data, unsigned long addr, int reliable)
 {
 	struct perf_callchain_entry *entry = data;
 
-	if (per_cpu(in_nmi_frame, smp_processor_id()))
+	if (per_cpu(in_ignored_frame, smp_processor_id()))
 		return;
 
 	if (reliable)
-- 
1.6.2.3

