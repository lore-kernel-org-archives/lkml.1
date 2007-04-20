Return-Path: <linux-kernel-owner+w=401wt.eu-S1422958AbXDTGPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422958AbXDTGPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 02:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422963AbXDTGPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 02:15:25 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:35911 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422958AbXDTGPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 02:15:24 -0400
From: Sripathi Kodi <sripathik@in.ibm.com>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PREEMPT_RT] [PATCH] scheduling with irqs disabled: strace/0x00000000/2011
Date: Fri, 20 Apr 2007 11:45:07 +0530
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704201145.07532.sripathik@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While running strace on some testcase running on -rt kernel (2.6.20-rt8 and 
2.6.21-rc6-rt0), I have seen the following BUG:

BUG: scheduling with irqs disabled: strace/0x00000000/2011
caller is rt_spin_lock_slowlock+0x102/0x1af

Call Trace:
 [<ffffffff8026d828>] dump_trace+0xbd/0x3d8
 [<ffffffff8026db87>] show_trace+0x44/0x6d
 [<ffffffff8026ddc8>] dump_stack+0x13/0x15
 [<ffffffff80264dc6>] schedule+0x87/0x10b
 [<ffffffff80265b06>] rt_spin_lock_slowlock+0x102/0x1af
 [<ffffffff802661af>] rt_spin_lock+0x1f/0x21
 [<ffffffff8029af0c>] force_sig_info+0x26/0xb5
 [<ffffffff8029b018>] force_sig_specific+0x11/0x13
 [<ffffffff80298659>] ptrace_attach+0xdf/0x10b
 [<ffffffff802986d7>] sys_ptrace+0x52/0xb8
 [<ffffffff8025f42c>] tracesys+0x151/0x1be
 [<00000034ecec71c9>]

---------------------------
| preempt count: 00000000 ]
| 0-level deep critical section nesting:
----------------------------------------

In ptrace_attach, this is what happens:

task_lock
local_irq_disable
write_lock(tasklist_lock) Using trylocks.
	Some work 
	__ptrace_link
	Send SIGSTOP to target thread
write_unlock_irq(tasklist_lock)
task_unlock

On -rt, write_unlock_irq doesn't do local_irq_enable. Even if it did, we are 
calling it after sending SIGSTOP to target thread. To fix the problem, I 
think we should call write_unlock(tasklist_lock) and local_irq_enable() 
instead of write_unlock_irq. Also, we should call them before calling 
force_sig_specific(). I think there is no need to hold the tasklist lock 
while calling force_sig_specific(). Is my understanding correct? 
Alternatively, can we remove the call to local_irq_disable() in -rt kernel?

For the non-rt kernel too, I think we should do 
write_unlock_irq(tasklist_lock) before sending SIGSTOP.

The following patch solves the problem for me. 

Thanks and regards,
Sripathi.

Signed-off-by: Sripathi Kodi <sripathik@in.ibm.com>

--- linux-2.6.21-rc6-rt0-org/kernel/ptrace.c	2007-04-06 08:06:56.000000000 
+0530
+++ linux-2.6.21-rc6-rt0/kernel/ptrace.c	2007-04-19 18:18:40.000000000 +0530
@@ -205,10 +205,16 @@ repeat:
 
 	__ptrace_link(task, current);
 
+	write_unlock(&tasklist_lock);
+	local_irq_enable();
+
 	force_sig_specific(SIGSTOP, task);
+	goto out2;
 
 bad:
-	write_unlock_irq(&tasklist_lock);
+	write_unlock(&tasklist_lock);
+	local_irq_enable();
+out2:
 	task_unlock(task);
 out:
 	return retval;
