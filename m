Return-Path: <linux-kernel-owner+w=401wt.eu-S1758039AbZLKNus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039AbZLKNus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 08:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757677AbZLKNuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 08:50:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757571AbZLKNuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 08:50:44 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20091210004703.148689096@linutronix.de>
References: <20091210004703.148689096@linutronix.de> <20091210001308.247025548@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [patch 4/9] oom: Add missing rcu protection of __task_cred() in dump_tasks
Date: Fri, 11 Dec 2009 13:49:31 +0000
Message-ID: <13284.1260539371@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> wrote:

> +		/* Protect __task_cred() access */
> +		rcu_read_lock();
>  		printk(KERN_INFO "[%5d] %5d %5d %8lu %8lu %3d     %3d %s\n",
>  		       p->pid, __task_cred(p)->uid, p->tgid, mm->total_vm,
>  		       get_mm_rss(mm), (int)task_cpu(p), p->signal->oom_adj,
>  		       p->comm);
> +		rcu_read_unlock();

No.  If there's only one access to __task_cred() like this, use
task_cred_xxx() or one of its wrappers instead:

-		       p->pid, __task_cred(p)->uid, p->tgid, mm->total_vm,
+		       p->pid, task_uid(p), p->tgid, mm->total_vm,

that limits the size of the critical section.

David
