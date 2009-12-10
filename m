Return-Path: <linux-kernel-owner+w=401wt.eu-S1759151AbZLJOlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151AbZLJOlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 09:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbZLJOlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 09:41:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041AbZLJOlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 09:41:17 -0500
Date: Thu, 10 Dec 2009 15:34:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 7/9] signals: Fix more rcu assumptions
Message-ID: <20091210143435.GC8226@redhat.com>
References: <20091210001308.247025548@linutronix.de> <20091210004703.269843657@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210004703.269843657@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10, Thomas Gleixner wrote:
>
> 1) Remove the misleading comment in __sigqueue_alloc() which claims
>    that holding a spinlock is equivalent to rcu_read_lock().
>
> 2) Wrap the __send_signal() call in send_signal() into a rcu read side
>    critical section to guarantee that the __sigqueue_alloc()
>    requirement is met in any case.
> ...
>  static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
>  			int group)
>  {
> -	int from_ancestor_ns = 0;
> +	int ret, from_ancestor_ns = 0;
>
>  #ifdef CONFIG_PID_NS
>  	if (!is_si_special(info) && SI_FROMUSER(info) &&
> @@ -954,7 +953,11 @@ static int send_signal(int sig, struct s
>  		from_ancestor_ns = 1;
>  #endif
>
> -	return __send_signal(sig, info, t, group, from_ancestor_ns);
> +	rcu_read_lock();
> +	ret = __send_signal(sig, info, t, group, from_ancestor_ns);
> +	rcu_read_unlock();

But, without a comment it is very unobvious why do we need rcu_read_lock().

Perhaps it is better to modify __sigqueue_alloc() instead? It can take
rcu_lock() around cred->user itself.

Oleg.	

