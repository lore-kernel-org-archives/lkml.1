Return-Path: <linux-kernel-owner+w=401wt.eu-S934120AbXGQQXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934120AbXGQQXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 12:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759292AbXGQQX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:23:29 -0400
Received: from mail.ccur.com ([66.10.65.12]:21236 "EHLO mail.ccur.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755422AbXGQQX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:23:28 -0400
Message-ID: <469CECFE.6060408@ccur.com>
Date: Tue, 17 Jul 2007 12:23:26 -0400
From: John Blackwood <john.blackwood@ccur.com>
Reply-To: john.blackwood@ccur.com
Organization: Concurrent Computer Corporation
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@xensource.com>
CC: Andi Kleen <ak@suse.de>, Roland McGrath <roland@redhat.com>,
       bugsy@ccur.com
Subject: [PATCH] Reading the VDSO area - i386
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jul 2007 16:23:27.0554 (UTC) FILETIME=[CE4EF220:01C7C88E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy,

I was doing some tests that attempt to read the VDSO area of a
task through either the /proc/pid/mem or ptrace(PTRACE_PEEKTEXT,
...) interfaces, and it seems that when the CONFIG_COMPAT_VDSO kernel
parameter is enabled, we can no longer successfully read the VDSO area
on i386 kernels.

I believe that debuggers such as gdb will attempt to sometimes walkback
through the vsyscall area, and not being able to read the vsyscall/vdso
area would thus cause debuggers problems.

So assuming that this change in behavior was not intentional, I've
provided my stab (just an idea) at a fix.  With this change below,
the code in places such as get_user_pages() can now successfully call
in_gate_area() and then subsequently call get_gate_vma(), which already
properly returns the correct info.

Thanks for taking the time to read over this.


---
/userland/johnb/s/os/kernel/linux-2.6.22/arch/i386/kernel/sysenter.c
2007-07-17 08:38:48.000000000 -0400
+++ new/arch/i386/kernel/./sysenter.c	2007-07-17 11:48:28.000000000 -0400
@@ -336,6 +336,14 @@ struct vm_area_struct *get_gate_vma(stru

  int in_gate_area(struct task_struct *task, unsigned long addr)
  {
+	struct mm_struct *mm = task->mm;
+
+	/* Check to see if this task was created in compat vdso mode
+	 * and if the address is within the gate_vma area.
+	 */
+	if (mm && mm->context.vdso == (void *)VDSO_HIGH_BASE &&
+			addr >= gate_vma.vm_start && addr <= gate_vma.vm_end)
+		return 1;
  	return 0;
  }


