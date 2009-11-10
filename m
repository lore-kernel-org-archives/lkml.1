Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbZKJK0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbZKJK0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 05:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbZKJK0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 05:26:03 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:62696 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303AbZKJK0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 05:26:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=quGiy80xwNqr3Uje5hA2xcjwdIDSxJjbmZF9sfpdJGTTEJ4iE+Hut7Sr7VjJiM9t2h
         Z9OlFjuiQTHYepv9vpaBqRcWWDY01RLeUYAP3LzvwSZ+FUQhdNh0l3NxC/Onw4YCv1fU
         AOVEg4i/7F5iOd7GuTbwguKK8yig6Oe6tMKHU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Kiszka <jan.kiszka@web.de>, Avi Kivity <avi@redhat.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jiri Slaby <jirislaby@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 4/4] hw-breakpoints: Wrap in the KVM breakpoint active state check
Date: Tue, 10 Nov 2009 11:26:00 +0100
Message-Id: <1257848760-9407-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1257848760-9407-1-git-send-email-fweisbec@gmail.com>
References: <1257848760-9407-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap in the cpu dr7 check that tells if we have active
breakpoints that need to be restored in the cpu.

This wrapper makes the check more self-explainable and also
reusable for any further other uses.

Reported-by: Jan Kiszka <jan.kiszka@web.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: "K. Prasad" <prasad@linux.vnet.ibm.com>
---
 arch/x86/include/asm/debugreg.h |    5 +++++
 arch/x86/kvm/x86.c              |    2 +-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
index f1b673f..0f6e92a 100644
--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -89,6 +89,11 @@ static inline void hw_breakpoint_disable(void)
 	set_debugreg(0UL, 3);
 }
 
+static inline int hw_breakpoint_active(void)
+{
+	return __get_cpu_var(dr7) & DR_GLOBAL_ENABLE_MASK;
+}
+
 extern void aout_dump_debugregs(struct user *dump);
 
 #ifdef CONFIG_KVM
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 22dee7a..3817220 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3651,7 +3651,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	 * care about the messed up debug address registers. But if
 	 * we have some of them active, restore the old state.
 	 */
-	if (__get_cpu_var(dr7) & DR_GLOBAL_ENABLE_MASK)
+	if (hw_breakpoint_active())
 		hw_breakpoint_restore();
 
 	set_bit(KVM_REQ_KICK, &vcpu->requests);
-- 
1.6.2.3

