Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbZLJC35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbZLJC35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 21:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbZLJC3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 21:29:54 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:51643 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbZLJC3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 21:29:53 -0500
Message-Id: <200912100229.nBA2TfTH008226@www262.sakura.ne.jp>
Subject: Re: [patch 1/9] sys: Fix missing rcu protection for __task_cred() access
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       tglx@linutronix.de
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 10 Dec 2009 11:29:41 +0900
References: <20091210001308.247025548@linutronix.de> <20091210004703.029784964@linutronix.de> <20091210012517.GF6938@linux.vnet.ibm.com>
In-Reply-To: <20091210012517.GF6938@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 09122009 #3107263, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As a rough rule of thumb, any dereference of an RCU-protected
> pointer must be covered by rcu_read_lock() or rcu_read_lock_bh()
> or by the appropriate update-side lock.

Does this mean that we need both rcu_read_lock() *and*
read_lock(&tasklist_lock) when calling find_task_by_vpid() because pid_task()
uses rcu_dereference() and find_pid_ns() uses hlist_for_each_entry_rcu ?

378 /*
379  * Must be called under rcu_read_lock() or with tasklist_lock read-held.
380  */
381 struct task_struct *find_task_by_pid_ns(pid_t nr, struct pid_namespace *ns)
382 {
383         return pid_task(find_pid_ns(nr, ns), PIDTYPE_PID);
384 }
385 
386 struct task_struct *find_task_by_vpid(pid_t vnr)
387 {
388         return find_task_by_pid_ns(vnr, current->nsproxy->pid_ns);
389 }
