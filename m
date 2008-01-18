Return-Path: <linux-kernel-owner+w=401wt.eu-S1762750AbYARQVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762750AbYARQVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 11:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760872AbYARQV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:21:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760142AbYARQV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:21:26 -0500
Message-ID: <4790D1DE.8030700@redhat.com>
Date: Fri, 18 Jan 2008 11:20:46 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: tony.luck@intel.com, Shaohua Li <shaohua.li@intel.com>
CC: ia64 <linux-ia64@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: [PATCH]Fix the order of atomic operations in restore_previous_kprobes
 on ia64
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Fix the order of atomic operations to prevent overwriting prev_kprobe[0].
To pop values from stack, we must decrement stack index right AFTER
reading values.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
Details of this issue was reported to
http://sources.redhat.com/bugzilla/show_bug.cgi?id=2071

   arch/ia64/kernel/kprobes.c |    7 ++++---
   1 file changed, 4 insertions(+), 3 deletions(-)

Index: 2.6.24-rc8/arch/ia64/kernel/kprobes.c
===================================================================
--- 2.6.24-rc8.orig/arch/ia64/kernel/kprobes.c	2008-01-17 21:14:01.000000000 -0500
+++ 2.6.24-rc8/arch/ia64/kernel/kprobes.c	2008-01-17 21:14:01.000000000 -0500
@@ -381,9 +381,10 @@
   static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
   {
   	unsigned int i;
-	i = atomic_sub_return(1, &kcb->prev_kprobe_index);
-	__get_cpu_var(current_kprobe) = kcb->prev_kprobe[i].kp;
-	kcb->kprobe_status = kcb->prev_kprobe[i].status;
+	i = atomic_read(&kcb->prev_kprobe_index);
+	__get_cpu_var(current_kprobe) = kcb->prev_kprobe[i-1].kp;
+	kcb->kprobe_status = kcb->prev_kprobe[i-1].status;
+	atomic_sub(1, &kcb->prev_kprobe_index);
   }

   static void __kprobes set_current_kprobe(struct kprobe *p,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com


