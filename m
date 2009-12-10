Return-Path: <linux-kernel-owner+w=401wt.eu-S1761701AbZLJVRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761701AbZLJVRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 16:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761637AbZLJVRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 16:17:52 -0500
Received: from www.tglx.de ([62.245.132.106]:33927 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761636AbZLJVRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 16:17:52 -0500
Date: Thu, 10 Dec 2009 22:17:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: oleg@redhat.com, linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       linux-security-module@vger.kernel.org
Subject: Re: [patch 1/9] sys: Fix missing rcu protection for
 __task_cred()access
In-Reply-To: <200912110008.BEJ00511.FVOJLtSMOFHOQF@I-love.SAKURA.ne.jp>
Message-ID: <alpine.LFD.2.00.0912102214180.3089@localhost.localdomain>
References: <20091210001308.247025548@linutronix.de> <20091210004703.029784964@linutronix.de> <20091210142036.GA8226@redhat.com> <200912110008.BEJ00511.FVOJLtSMOFHOQF@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Dec 2009, Tetsuo Handa wrote:
> > Usually tasklist gives enough protection, but if copy_process() fails
> > it calls free_pid() lockless and does call_rcu(delayed_put_pid().
> > This means, without rcu lock find_pid_ns() can't scan the hash table
> > safely.
> 
> So, we need to change below comment from "or" to "and" ?

No, both functions must be called with rcu_read_lock()

tasklist_lock read-held is not protecting the rcu lists and does not
protect against a concurrent update. It merily protects against tasks
going away or being added while we look up the lists.
 
> 378 /*
> 379  * Must be called under rcu_read_lock() or with tasklist_lock read-held.
> 380  */
> 381 struct task_struct *find_task_by_pid_ns(pid_t nr, struct pid_namespace *ns)
> 382 {
> 383         return pid_task(find_pid_ns(nr, ns), PIDTYPE_PID);
> 384 }
> 385
> 386 struct task_struct *find_task_by_vpid(pid_t vnr)
> 387 {
> 388         return find_task_by_pid_ns(vnr, current->nsproxy->pid_ns);
> 389 }
> 

Thanks,

	tglx
