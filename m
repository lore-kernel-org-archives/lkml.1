Return-Path: <linux-kernel-owner+w=401wt.eu-S1759314AbXFDVj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbXFDVj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 17:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbXFDVjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 17:39:21 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:36801 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752631AbXFDVjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 17:39:20 -0400
Subject: Re: [bug] very high non-preempt latency in
	context_struct_compute_av()
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Paul Moore <paul.moore@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Carter <jwcart2@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>,
       Karl MacMillan <kmacmillan@mentalrootkit.com>,
       "Christopher J. PeBenito" <cpebenito@tresys.com>,
       Joshua Brindle <method@manicmethod.com>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>
In-Reply-To: <200706041711.42755.paul.moore@hp.com>
References: <20070604112745.GA26350@elte.hu>
	 <200706041711.42755.paul.moore@hp.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 04 Jun 2007 17:39:00 -0400
Message-Id: <1180993140.14220.168.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-04 at 17:11 -0400, Paul Moore wrote:
> On Monday, June 4 2007 7:27:45 am Ingo Molnar wrote:
> > a simple ssh login triggers a ~130 msecs non-preemptible latency even
> > with CONFIG_PREEMPT enabled, on a fast Core2Duo CPU (!).
> >
> > the latency is caused by a _very_ long loop in the SELinux code:
> >
> >     sshd-4828  0.N.. 465894us : avtab_search_node
> > (context_struct_compute_av) sshd-4828  0.N.. 465895us : cond_compute_av
> > (context_struct_compute_av) sshd-4828  0.N.. 465895us : avtab_search_node
> > (cond_compute_av) sshd-4828  0.N.. 465895us : avtab_search_node
> > (context_struct_compute_av) sshd-4828  0.N.. 465896us : cond_compute_av
> > (context_struct_compute_av) sshd-4828  0.N.. 465896us : avtab_search_node
> > (cond_compute_av) sshd-4828  0.N.. 465896us : avtab_search_node
> > (context_struct_compute_av) sshd-4828  0.N.. 465896us : cond_compute_av
> > (context_struct_compute_av) sshd-4828  0.N.. 465896us : avtab_search_node
> > (cond_compute_av)
> >
> > it is triggered like this:
> >
> >     sshd-4828  0..s. 462986us : tasklet_action (__do_softirq)
> >     sshd-4828  0..s. 462986us : rcu_process_callbacks (tasklet_action)
> >     sshd-4828  0..s. 462986us : __rcu_process_callbacks
> > (rcu_process_callbacks) sshd-4828  0..s. 462987us : __rcu_process_callbacks
> > (rcu_process_callbacks) sshd-4828  0D.s. 462987us : _local_bh_enable
> > (__do_softirq)
> >     sshd-4828  0DN.. 462987us : idle_cpu (irq_exit)
> >     sshd-4828  0.N.. 462988us : avtab_search_node
> > (context_struct_compute_av) sshd-4828  0.N.. 462989us : cond_compute_av
> > (context_struct_compute_av)
> >
> > {snip}
> >
> > The distribution is Fedora 7, v2.6.21 (but also happens in recent -git)
> > and a simple 'ssh localhost' login is enough to trigger this. It
> > triggers every time and this is causing audio skipping in certain apps.
> > It is even visible in glxgears smoothness: a small 'bump' is visible in
> > the otherwise smooth rotation of glxgears. Enabling CONFIG_PREEMPT does
> > not fix this issue as the function runs under spinlocks. (enabling
> > CONFIG_PREEMPT_RT in -rt fixes the issue - but that still leaves us with
> > the huge 130 msecs cost of that function.)
> 
> I'm not an expert on the SELinux security server guts like the other people on 
> the To/CC line of this thread, but here are my two cents on the issue above.
> 
> >From what I can tell the nasty loop that is taking so long is the actual 
> access vector lookup which determines if the subject has access to the object 
> (i.e. can user/application X access resource Y on the system).  While it may 
> be possible to optimize this code I wonder if a quicker/easier solution would 
> be to refactor the lock.  At present SELinux uses a read/write spinlock to 
> protect the policy stored in the kernel with macros to take and release the 
> lock, POLICY_{RD,WR}LOCK and POLICY_{RD,WR}UNLOCK.  From personal 
> observations as well as a quick check of the code, it appears that most of 
> the time we only want to read lock the policy and not write lock the policy - 
> a spinlock, even a read/write spinlock, seems a bit expensive here.
> 
> If we were to convert from a read/write spinlock to a RCU locking mechanism 
> would this solve the preemption problem (I'm not a lock expert either)?  If 
> so, can anyone think of any reasons why converting the policy lock to RCU is 
> a bad idea (James, Stephen, the other James)?

rcu_read_lock disables preemption in mainline (see rcupdate.h).
Conversion to RCU is also complicated by conditional policy support
(changing of policy boolean states via selinuxfs).  However, there were
experimental patches to do that a while ago by KaiGai Kohei.

I think that there are several factors here:
- targeted policy yields an explosion in the possible transitions at
login time since users are effectively unconfined there.  There would be
far fewer computations under strict policy.
- sel_write_user -> security_get_user_sids does a lot of work while
holding the policy rdlock, including all of those compute_av calls
inside of its own loops.  This is the function that is computing
reachable contexts for the user (role set) based on policy from the
initial login context at login time.  I think this function can be
refactored to drop and retake locks appropriately and to introduce
cond_resched calls.
- compute_av has potentially long loops internally if the policy makes
significant use of attributes; this was the tradeoff in memory vs.
performance introduced by the patches to reduce the avtab memory use
introduced in 2.6.14.  In the common case, you don't see it due to the
AVC caching the results of compute_av but security_get_user_sids doesn't
go through the AVC.  That's harder to fix.

I think we can try refactoring security_get_user_sids and see how much
that helps.

-- 
Stephen Smalley
National Security Agency

