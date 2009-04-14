Return-Path: <linux-kernel-owner+w=401wt.eu-S1758707AbZDNS2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707AbZDNS2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757378AbZDNS15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:27:57 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:35471 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758639AbZDNS14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:27:56 -0400
Date: Tue, 14 Apr 2009 19:25:42 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Oruba <peter.oruba@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86 microcode: revert some work_on_cpu
Message-ID: <Pine.LNX.4.64.0904141919350.3124@blonde.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revert part of af5c820a3169e81af869c113e18ec7588836cd50
x86: cpumask: use work_on_cpu in arch/x86/kernel/microcode_core.c

That change is causing only one Intel CPU's microcode to be updated e.g.
microcode: CPU3 updated from revision 0x9 to 0x17, date = 2005-04-22 
where before it announced that also for CPU0 and CPU1 and CPU2.

We cannot use work_on_cpu() in the CONFIG_MICROCODE_OLD_INTERFACE code,
because Intel's request_microcode_user() involves a copy_from_user() from
/sbin/microcode_ctl, which therefore needs to be on that CPU at the time.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
This may be not the only problem with that commit: I've seen lockdep
warnings from s2ram when suspending; but I think there have been other
work_on_cpu() lockdep issues, and you may already be on to them?

 arch/x86/kernel/microcode_core.c |   33 +++++++++--------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

--- 2.6.30-rc1/arch/x86/kernel/microcode_core.c	2009-04-08 18:19:28.000000000 +0100
+++ linux/arch/x86/kernel/microcode_core.c	2009-04-12 23:06:57.000000000 +0100
@@ -108,40 +108,29 @@ struct ucode_cpu_info		ucode_cpu_info[NR
 EXPORT_SYMBOL_GPL(ucode_cpu_info);
 
 #ifdef CONFIG_MICROCODE_OLD_INTERFACE
-struct update_for_cpu {
-	const void __user	*buf;
-	size_t			size;
-};
-
-static long update_for_cpu(void *_ufc)
-{
-	struct update_for_cpu *ufc = _ufc;
-	int error;
-
-	error = microcode_ops->request_microcode_user(smp_processor_id(),
-						      ufc->buf, ufc->size);
-	if (error < 0)
-		return error;
-	if (!error)
-		microcode_ops->apply_microcode(smp_processor_id());
-	return error;
-}
-
 static int do_microcode_update(const void __user *buf, size_t size)
 {
+	cpumask_t old;
 	int error = 0;
 	int cpu;
-	struct update_for_cpu ufc = { .buf = buf, .size = size };
+
+	old = current->cpus_allowed;
 
 	for_each_online_cpu(cpu) {
 		struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
 		if (!uci->valid)
 			continue;
-		error = work_on_cpu(cpu, update_for_cpu, &ufc);
+
+		set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+		error = microcode_ops->request_microcode_user(cpu, buf, size);
 		if (error < 0)
-			break;
+			goto out;
+		if (!error)
+			microcode_ops->apply_microcode(cpu);
 	}
+out:
+	set_cpus_allowed_ptr(current, &old);
 	return error;
 }
 
