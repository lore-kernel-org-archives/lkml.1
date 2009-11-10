Return-Path: <linux-kernel-owner+w=401wt.eu-S1757238AbZKJRKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbZKJRKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757046AbZKJRKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:10:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756782AbZKJRKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:10:31 -0500
Date: Tue, 10 Nov 2009 18:04:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Bryan Donlan <bdonlan@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Timo Sirainen <tss@iki.fi>, Ulrich Drepper <drepper@redhat.com>,
       WANG Cong <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: + prctl-add-pr_set_proctitle_area-option.patch added to -mm
	tree
Message-ID: <20091110170453.GA11771@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

@@ -1424,6 +1424,28 @@ static void k_getrusage(struct task_stru
 			} while (t != p);
 			break;
 
+		case PR_SET_PROCTITLE_AREA: {
+			struct mm_struct *mm = current->mm;
+			unsigned long addr = arg2;
+			unsigned long len = arg3;
+			unsigned long end = arg2 + arg3;
+
+			if (len > PAGE_SIZE)
+				return -EINVAL;
+
+			if (addr >= end)
+				return -EINVAL;
+
+			if (!access_ok(VERIFY_READ, addr, len))
+				return -EFAULT;
+
+			mutex_lock(&mm->arg_lock);
+			mm->arg_start = addr;
+			mm->arg_end = end;
+			mutex_unlock(&mm->arg_lock);

This looks like the merging error, I guess this code should go into
sys_prct(), not k_getrusage().


The patch adds mm_struct->arg_lock mutex. Can't we reuse mm->mmap_sem?
A bit ugly to have mm->arg_lock just to synchronize sys_prctl() and
proc_pid_cmdline(), imho.

Yes, we can't do access_process_vm() under ->mmap_sem, but we can add
the new helper, say, access_process_vm_locked(tsk, mm, ...) which does
the actual work. Then proc_pid_cmdline() can take mmap_sem for reading,
read arg_start/arg_end and call access_process_vm_locked().

No?

Oleg.

