Return-Path: <linux-kernel-owner+w=401wt.eu-S1754310AbZLJOfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbZLJOfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 09:35:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbZLJOfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 09:35:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbZLJOfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 09:35:37 -0500
Date: Thu, 10 Dec 2009 15:29:15 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-security-module@vger.kernel.org
Subject: Re: [patch 1/9] sys: Fix missing rcu protection for __task_cred()
	access
Message-ID: <20091210142915.GB8226@redhat.com>
References: <20091210001308.247025548@linutronix.de> <20091210004703.029784964@linutronix.de> <20091210024324.GH6938@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210024324.GH6938@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09, Paul E. McKenney wrote:
>
> On Thu, Dec 10, 2009 at 12:52:51AM -0000, Thomas Gleixner wrote:
> > commit c69e8d9 (CRED: Use RCU to access another task's creds and to
> > release a task's own creds) added non rcu_read_lock() protected access
> > to task creds of the target task in set_prio_one().
> >
> > The comment above the function says:
> >  * - the caller must hold the RCU read lock
> >
> > The calling code in sys_setpriority does read_lock(&tasklist_lock) but
> > not rcu_read_lock(). This works only when CONFIG_TREE_PREEMPT_RCU=n.
> > With CONFIG_TREE_PREEMPT_RCU=y the rcu_callbacks can run in the tick
> > interrupt when they see no read side critical section.
> >
> > There is another instance of __task_cred() in sys_setpriority() itself
> > which is equally unprotected.
> >
> > Wrap the whole code section into a rcu read side critical section to
> > fix this quick and dirty.
> >
> > Will be revisited in course of the read_lock(&tasklist_lock) -> rcu
> > crusade.
>
> OK, I will bite...  Don't the corresponding updates write-hold
> tasklist_lock?  If so, then the fact that the code below is read-holding
> tasklist_lock would prevent any of the data from changing, which would
> remove the need to do the rcu_read_lock().
>
> Or are there updates that are carried out without write-holding
> tasklist_lock that I am missing?

Yes, commit_creds() is called lockless.

Or I misunderstood the question/patch...

Oleg.

