Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbZG0Ad6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbZG0Ad6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 20:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbZG0Ad6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 20:33:58 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:33439 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbZG0Ad5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 20:33:57 -0400
Message-ID: <4A6CF466.9040608@ct.jp.nec.com>
Date: Mon, 27 Jul 2009 09:27:18 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] task_struct cleanup: move binfmt field to mm_struct
References: <4A56FEF7.80207@ct.jp.nec.com> <20090722132302.a9889eb3.akpm@linux-foundation.org> <20090722220353.88B2A67B6E@magilla.sf.frob.com> <20090723161806.GA5690@redhat.com> <4A68FD3B.7040606@ct.jp.nec.com> <4A693569.1090009@ct.jp.nec.com> <20090724161449.GA3509@redhat.com>
In-Reply-To: <20090724161449.GA3509@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 07/24, Hiroshi Shimamoto wrote:
>>  int set_binfmt(struct linux_binfmt *new)
>>  {
>> -	struct linux_binfmt *old = current->binfmt;
>> +	struct linux_binfmt *old;
>>
>> +	if (!current->mm)
>> +		return -1;
>> +
>> +	old = current->mm->binfmt;
>>  	if (new) {
>>  		if (!try_module_get(new->module))
>>  			return -1;
>>  	}
>> -	current->binfmt = new;
>> +	current->mm->binfmt = new;
> 
> Hmm. Of-topic, but I think set_binfmt() is buggy (with or without this patch),
> it should use __module_get(). I'll send the fix in a minute.
> 
>> @@ -1730,7 +1734,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>>
>>  	audit_core_dumps(signr);
>>
>> -	binfmt = current->binfmt;
>> +	binfmt = current->mm ? current->mm->binfmt : NULL;
> 
> current->mm can't be NULL here. And please note we already have
> struct mm_struct *mm = current->mm, so the above should be
> 
> 	 binfmt = mm->binfmt;
> 
>> @@ -953,6 +953,9 @@ NORET_TYPE void do_exit(long code)
>>  	tsk->exit_code = code;
>>  	taskstats_exit(tsk, group_dead);
>>
>> +	if (tsk->mm && tsk->mm->binfmt)
>> +		module_put(tsk->mm->binfmt->module);
> 
> This is not right. We leak ->binfmt on exec.
> 
> Seems to be fixed by the next patch, but still this is not good.
> I'd suggest you to merge these 2 patches into single patch, because
> module_put(->binfmt) should go to mmput() from the very beginning.

Hi Oleg, thank you very much for comments, here is an update patch.
This patch can be applied after your set_binfmt() fix.

========
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: [PATCH] task_struct cleanup: move binfmt field to mm_struct

Because the binfmt is not different between threads in the same process,
it can be moved from task_struct to mm_struct. And binfmt moudle is handled
per mm_struct instead of task_struct.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 fs/exec.c                |   11 +++++++----
 include/linux/mm_types.h |    2 ++
 include/linux/sched.h    |    1 -
 kernel/exit.c            |    2 --
 kernel/fork.c            |   11 +++++------
 5 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 61d5be2..41aea26 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1377,10 +1377,13 @@ out_ret:
 
 void set_binfmt(struct linux_binfmt *new)
 {
-	if (current->binfmt)
-		module_put(current->binfmt->module);
+	struct mm_struct *mm = current->mm;
+
+	BUG_ON(!mm);
+	if (mm->binfmt)
+		module_put(mm->binfmt->module);
 
-	current->binfmt = new;
+	mm->binfmt = new;
 	if (new)
 		__module_get(new->module);
 }
@@ -1726,7 +1729,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 
 	audit_core_dumps(signr);
 
-	binfmt = current->binfmt;
+	binfmt = mm->binfmt;
 	if (!binfmt || !binfmt->core_dump)
 		goto fail;
 
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 7acc843..6719040 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -240,6 +240,8 @@ struct mm_struct {
 
 	unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
 
+	struct linux_binfmt *binfmt;
+
 	s8 oom_adj;	/* OOM kill score adjustment (bit shift) */
 
 	cpumask_t cpu_vm_mask;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3ab08e4..940b070 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1220,7 +1220,6 @@ struct task_struct {
 	struct mm_struct *mm, *active_mm;
 
 /* task state */
-	struct linux_binfmt *binfmt;
 	int exit_state;
 	int exit_code, exit_signal;
 	int pdeath_signal;  /*  The signal sent when the parent dies  */
diff --git a/kernel/exit.c b/kernel/exit.c
index 869dc22..77b01be 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -970,8 +970,6 @@ NORET_TYPE void do_exit(long code)
 		disassociate_ctty(1);
 
 	module_put(task_thread_info(tsk)->exec_domain->module);
-	if (tsk->binfmt)
-		module_put(tsk->binfmt->module);
 
 	proc_exit_connector(tsk);
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 9b42695..9c21984 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -494,6 +494,8 @@ void mmput(struct mm_struct *mm)
 			spin_unlock(&mmlist_lock);
 		}
 		put_swap_token(mm);
+		if (mm->binfmt)
+			module_put(mm->binfmt->module);
 		mmdrop(mm);
 	}
 }
@@ -619,6 +621,9 @@ struct mm_struct *dup_mm(struct task_struct *tsk)
 	mm->hiwater_rss = get_mm_rss(mm);
 	mm->hiwater_vm = mm->total_vm;
 
+	if (mm->binfmt && !try_module_get(mm->binfmt->module))
+		goto free_pt;
+
 	return mm;
 
 free_pt:
@@ -1013,9 +1018,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	if (!try_module_get(task_thread_info(p)->exec_domain->module))
 		goto bad_fork_cleanup_count;
 
-	if (p->binfmt && !try_module_get(p->binfmt->module))
-		goto bad_fork_cleanup_put_domain;
-
 	p->did_exec = 0;
 	delayacct_tsk_init(p);	/* Must remain after dup_task_struct() */
 	copy_flags(clone_flags, p);
@@ -1300,9 +1302,6 @@ bad_fork_cleanup_cgroup:
 #endif
 	cgroup_exit(p, cgroup_callbacks_done);
 	delayacct_tsk_free(p);
-	if (p->binfmt)
-		module_put(p->binfmt->module);
-bad_fork_cleanup_put_domain:
 	module_put(task_thread_info(p)->exec_domain->module);
 bad_fork_cleanup_count:
 	atomic_dec(&p->cred->user->processes);
-- 
1.6.3.3

