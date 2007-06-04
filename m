Return-Path: <linux-kernel-owner+w=401wt.eu-S1760096AbXFDVME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096AbXFDVME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 17:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbXFDVLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 17:11:54 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:35771 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbXFDVLy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 17:11:54 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [bug] very high non-preempt latency in context_struct_compute_av()
Date: Mon, 4 Jun 2007 17:11:42 -0400
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>,
       James Carter <jwcart2@tycho.nsa.gov>, James Morris <jmorris@namei.org>
References: <20070604112745.GA26350@elte.hu>
In-Reply-To: <20070604112745.GA26350@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200706041711.42755.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 4 2007 7:27:45 am Ingo Molnar wrote:
> a simple ssh login triggers a ~130 msecs non-preemptible latency even
> with CONFIG_PREEMPT enabled, on a fast Core2Duo CPU (!).
>
> the latency is caused by a _very_ long loop in the SELinux code:
>
>     sshd-4828  0.N.. 465894us : avtab_search_node
> (context_struct_compute_av) sshd-4828  0.N.. 465895us : cond_compute_av
> (context_struct_compute_av) sshd-4828  0.N.. 465895us : avtab_search_node
> (cond_compute_av) sshd-4828  0.N.. 465895us : avtab_search_node
> (context_struct_compute_av) sshd-4828  0.N.. 465896us : cond_compute_av
> (context_struct_compute_av) sshd-4828  0.N.. 465896us : avtab_search_node
> (cond_compute_av) sshd-4828  0.N.. 465896us : avtab_search_node
> (context_struct_compute_av) sshd-4828  0.N.. 465896us : cond_compute_av
> (context_struct_compute_av) sshd-4828  0.N.. 465896us : avtab_search_node
> (cond_compute_av)
>
> it is triggered like this:
>
>     sshd-4828  0..s. 462986us : tasklet_action (__do_softirq)
>     sshd-4828  0..s. 462986us : rcu_process_callbacks (tasklet_action)
>     sshd-4828  0..s. 462986us : __rcu_process_callbacks
> (rcu_process_callbacks) sshd-4828  0..s. 462987us : __rcu_process_callbacks
> (rcu_process_callbacks) sshd-4828  0D.s. 462987us : _local_bh_enable
> (__do_softirq)
>     sshd-4828  0DN.. 462987us : idle_cpu (irq_exit)
>     sshd-4828  0.N.. 462988us : avtab_search_node
> (context_struct_compute_av) sshd-4828  0.N.. 462989us : cond_compute_av
> (context_struct_compute_av)
>
> {snip}
>
> The distribution is Fedora 7, v2.6.21 (but also happens in recent -git)
> and a simple 'ssh localhost' login is enough to trigger this. It
> triggers every time and this is causing audio skipping in certain apps.
> It is even visible in glxgears smoothness: a small 'bump' is visible in
> the otherwise smooth rotation of glxgears. Enabling CONFIG_PREEMPT does
> not fix this issue as the function runs under spinlocks. (enabling
> CONFIG_PREEMPT_RT in -rt fixes the issue - but that still leaves us with
> the huge 130 msecs cost of that function.)

I'm not an expert on the SELinux security server guts like the other people on 
the To/CC line of this thread, but here are my two cents on the issue above.

>From what I can tell the nasty loop that is taking so long is the actual 
access vector lookup which determines if the subject has access to the object 
(i.e. can user/application X access resource Y on the system).  While it may 
be possible to optimize this code I wonder if a quicker/easier solution would 
be to refactor the lock.  At present SELinux uses a read/write spinlock to 
protect the policy stored in the kernel with macros to take and release the 
lock, POLICY_{RD,WR}LOCK and POLICY_{RD,WR}UNLOCK.  From personal 
observations as well as a quick check of the code, it appears that most of 
the time we only want to read lock the policy and not write lock the policy - 
a spinlock, even a read/write spinlock, seems a bit expensive here.

If we were to convert from a read/write spinlock to a RCU locking mechanism 
would this solve the preemption problem (I'm not a lock expert either)?  If 
so, can anyone think of any reasons why converting the policy lock to RCU is 
a bad idea (James, Stephen, the other James)?

-- 
paul moore
linux security @ hp
