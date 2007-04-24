Return-Path: <linux-kernel-owner+w=401wt.eu-S1423124AbXDXVFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423124AbXDXVFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423118AbXDXVFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:05:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35811 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423124AbXDXVFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:05:36 -0400
Date: Tue, 24 Apr 2007 23:05:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: 'Scheduler Economy' prototype patch for CFS
Message-ID: <20070424210529.GA26277@elte.hu>
References: <20070420140457.GA14017@elte.hu> <200704220155.20856.kernel@kolivas.org> <20070421160008.GA28783@elte.hu> <200704220959.34978.kernel@kolivas.org> <87647oblx5.fsf@pps.jussieu.fr> <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org> <20070423013429.GB25162@wotan.suse.de> <alpine.LFD.0.98.0704230844410.9964@woody.linux-foundation.org> <20070423191143.GA16849@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423191143.GA16849@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > but the point I'm trying to make is that X shouldn't get more 
> > CPU-time because it's "more important" (it's not: and as noted 
> > earlier, thinking that it's more important skews the problem and 
> > makes for too *much* scheduling). X should get more CPU time simply 
> > because it should get it's "fair CPU share" relative to the *sum* of 
> > the clients, not relative to any client individually.
> 
> yeah. And this is not a pipe dream and i think it does not need a 
> 'wakeup matrix' or other complexities.
> 
> I am --->.<---- this close to being able to do this very robustly 
> under CFS via simple rules of economy and trade: there the 
> p->wait_runtime metric is intentionally a "physical resource" of 
> "hard-earned right to execute on the CPU, by having waited on it" the 
> sum of which is bound for the whole system.
> 
> So while with other, heuristic approaches we always had the problem of 
> creating a "hyper-inflation" of an uneconomic virtual currency that 
> could be freely printed by certain tasks, in CFS the economy of this 
> is strict and the finegrained plus/minus balance is strictly managed 
> by a conservative and independent central bank.
> 
> So we can actually let tasks "trade" in these very physical units of 
> "right to execute on the CPU". A task giving it to another task means 
> that this task _already gave up CPU time in the past_. So it's the 
> robust equivalent of an economy's "money earned" concept, and this 
> "money"'s distribution (and redistribution) is totally fair and 
> totally balanced and is not prone to "inflation".
> 
> The "give scheduler money" transaction can be both an "implicit 
> transaction" (for example when writing to UNIX domain sockets or 
> blocking on a pipe, etc.), or it could be an "explicit transaction": 
> sched_yield_to(). This latter i've already implemented for CFS, but 
> it's much less useful than the really significant implicit ones, the 
> ones which will help X.

today i've implemented a quick prototype of this "Scheduler Economy" 
feature, ontop of CFS. (I added a sysctl to be able to easily test with 
it turned on or off - in a final version no such sysctl would be 
available.)

initial testing shows that clients are indeed able to shuffle measurable 
amount of CPU time from themselves into the X server.

to test it, i took the xterm portion of Bill Davidsen's X test-script, 
to create 4 really busy scrolling-xterms:

  for n in 1 2 3 4; do
    vpos=$[(n-1)*80+50]
    xterm -geom 100x2-0+${vpos} -e bash -c "while true; do echo \$RANDOM; done" &
  done

starting this on an idle 1-CPU system gives an about ~40% busy X 
(everything including X running at nice level 0), with the remaining 60% 
CPU time split between the xterm and bash processes.

then i started 5 busy-loops to 'starve' X:

  for (( i=0; i < 5; i++ )) do
    bash -c "while :; do :; done" &
  done

this resulted in X getting only about 13% of CPU time, the bash 
busy-loops got around 13% each too.

then i turned on the 'Scheduler Economy' feature:

  echo 1 > /proc/sys/kernel/sched_economy

at which point clients started passing small units of 'scheduler money' 
to the X server, which resulted in X's CPU utilization going up to near 
20%, and the busy-loops dropping down to 10% each. [i'm still seeing 
occasional hickups though that happen due to X clients starving 
themselves, so this is still preliminary.]

about the implementation: i tried to keep it as simple as possible. 
There's no costly tracking of individual "transactions", a summary 
account is used per work object (attached to the X unix domain socket in 
this case). The overhead to unix domain socket performance is not 
measurable:

  # echo 1 > /proc/sys/kernel/sched_economy
  # ./lat_unix
  AF_UNIX sock stream latency: 8.0439 microseconds
  # ./lat_unix
  AF_UNIX sock stream latency: 8.0219 microseconds

  # echo 0 > /proc/sys/kernel/sched_economy
  # ./lat_unix
  AF_UNIX sock stream latency: 8.0702 microseconds
  # ./lat_unix
  AF_UNIX sock stream latency: 8.0451 microseconds

the patch is below. Again, it is a prototype, with a few hacks to 
separate 'X client' from 'X server' unix domain socket use. The real 
solution will probably need some API additions either via new syscalls, 
or via new options to unix domain sockets. The kernel side was pretty 
straightforward - it was easy to embedd the 'account' in the socket data 
structure and it was easy to find the places that give/take 'money'.

	Ingo

---
 include/linux/sched.h |   31 ++++++++++++++++++++
 include/net/af_unix.h |    2 +
 kernel/sched.c        |   75 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_fair.c   |    9 ++++++
 kernel/sysctl.c       |    8 +++++
 net/unix/af_unix.c    |   22 ++++++++++++++
 6 files changed, 147 insertions(+)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -805,6 +805,36 @@ struct sched_class {
 	void (*task_new) (struct rq *rq, struct task_struct *p);
 };
 
+/*
+ * Scheduler work account object: it consists of the price, the current
+ * amount of money attached to the account, plus a limit over which tasks
+ * should not have to refill the bucket:
+ */
+struct sched_account {
+	u64 price;
+	u64 balance;
+	u64 limit;
+};
+
+/*
+ * Set up a scheduler work account object:
+ */
+extern void sched_setup_account(struct sched_account *account, u64 price);
+
+/*
+ * A client task can pay into a given work account and can thus
+ * instruct the scheduler to move CPU resources from the current
+ * task to the server task:
+ */
+extern void sched_pay(struct sched_account *account);
+
+/*
+ * A server task can pick up payment from a work account object,
+ * and thus get the CPU resources that clients commited to that
+ * account:
+ */
+extern void sched_withdraw(struct sched_account *account);
+
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	struct thread_info *thread_info;
@@ -1233,6 +1263,7 @@ static inline void idle_task_exit(void) 
 extern void sched_idle_next(void);
 extern char * sched_print_task_state(struct task_struct *p, char *buffer);
 
+extern unsigned int sysctl_sched_economy;
 extern unsigned int sysctl_sched_granularity;
 extern unsigned int sysctl_sched_child_runs_first;
 extern unsigned int sysctl_sched_delayed_wakeups;
Index: linux/include/net/af_unix.h
===================================================================
--- linux.orig/include/net/af_unix.h
+++ linux/include/net/af_unix.h
@@ -4,6 +4,7 @@
 #include <linux/socket.h>
 #include <linux/un.h>
 #include <linux/mutex.h>
+#include <linux/sched.h>
 #include <net/sock.h>
 
 extern void unix_inflight(struct file *fp);
@@ -85,6 +86,7 @@ struct unix_sock {
         atomic_t                inflight;
         spinlock_t		lock;
         wait_queue_head_t       peer_wait;
+	struct sched_account	work_account;
 };
 #define unix_sk(__sk) ((struct unix_sock *)__sk)
 
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -3158,6 +3158,81 @@ long fastcall __sched sleep_on_timeout(w
 
 EXPORT_SYMBOL(sleep_on_timeout);
 
+/*
+ * Set up a scheduler work account object:
+ */
+void sched_setup_account(struct sched_account *account, u64 price)
+{
+	account->price = price;
+	account->balance = 0;
+	/*
+	 * Set up a reasonable limit, so that clients do not waste
+	 * their resources when the server has had enough pay
+	 * already:
+	 */
+	account->limit = sysctl_sched_granularity * 10;
+}
+
+/*
+ * A client task can pay into a given work account and can thus
+ * instruct the scheduler to move CPU resources from the current
+ * task to the server task:
+ */
+void sched_pay(struct sched_account *account)
+{
+	s64 money_available = current->wait_runtime;
+	u64 balance = account->balance;
+	u64 price = account->price;
+	u64 limit = account->limit;
+
+	if (!sysctl_sched_economy)
+		return;
+
+	/*
+	 * There's not enough money available, the task wont be able
+	 * to help the server:
+	 */
+	if (money_available < price)
+		return;
+	/*
+	 * Pay the server - but only up to a reasonable limit:
+	 */
+	if (balance >= limit)
+		return;
+
+	account->balance = balance + price;
+	current->wait_runtime = money_available - price;
+}
+
+/*
+ * A server task can pick up payment from a work account object,
+ * and thus get the CPU resources that clients commited to that
+ * account:
+ */
+void sched_withdraw(struct sched_account *account)
+{
+	struct task_struct *server = current;
+	u64 balance = account->balance;
+	u64 price = account->price;
+
+	if (!sysctl_sched_economy)
+		return;
+
+	/*
+	 * Note that we only pick up the price for this particular
+	 * work transaction - we dont withdraw the whole balance:
+	 */
+	if (balance < price)
+		return;
+	/*
+	 * No need to lock anything - we are running already.
+	 * The new wait_runtime value will be taken into account
+	 * (and will be an advantage) next time this task reschedules:
+	 */
+	server->wait_runtime += price;
+	account->balance = balance - price;
+}
+
 #ifdef CONFIG_RT_MUTEXES
 
 /*
Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -15,6 +15,15 @@
 unsigned int sysctl_sched_granularity __read_mostly = 3000000;
 
 /*
+ * debug: "Scheduler Economy" flag. This flag activates the scheduler
+ * payment system which transforms 'money' from client tasks to server
+ * tasks. This flag can be turned on and off anytime. (It is for debugging
+ * purposes, if it works out then the economy will be enabled
+ * unconditionally.)
+ */
+unsigned int sysctl_sched_economy = 0;
+
+/*
  * Debug: delay the effect of wakeups to until the next scheduler tick.
  * (default: off, no effect)
  */
Index: linux/kernel/sysctl.c
===================================================================
--- linux.orig/kernel/sysctl.c
+++ linux/kernel/sysctl.c
@@ -230,6 +230,14 @@ static ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_economy",
+		.data		= &sysctl_sched_economy,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
 		.ctl_name	= KERN_PANIC,
 		.procname	= "panic",
 		.data		= &panic_timeout,
Index: linux/net/unix/af_unix.c
===================================================================
--- linux.orig/net/unix/af_unix.c
+++ linux/net/unix/af_unix.c
@@ -596,6 +596,12 @@ static struct sock * unix_create1(struct
 	atomic_set(&u->inflight, sock ? 0 : -1);
 	mutex_init(&u->readlock); /* single task reading lock */
 	init_waitqueue_head(&u->peer_wait);
+	/*
+	 * Set up a scheduler work account object, with a default
+	 * price of 100 usecs:
+	 */
+	sched_setup_account(&u->work_account, 100000ULL);
+
 	unix_insert_socket(unix_sockets_unbound, sk);
 out:
 	return sk;
@@ -1501,6 +1507,14 @@ static int unix_stream_sendmsg(struct ki
 		    (other->sk_shutdown & RCV_SHUTDOWN))
 			goto pipe_err_free;
 
+		/*
+		 * Payment for the work the server is going to do on
+		 * behalf of this client (the uid test is a hack to
+		 * detect X clients):
+		 */
+		if (current->uid)
+			sched_pay(&unix_sk(other)->work_account);
+
 		skb_queue_tail(&other->sk_receive_queue, skb);
 		unix_state_runlock(other);
 		other->sk_data_ready(other, size);
@@ -1806,6 +1820,14 @@ static int unix_stream_recvmsg(struct ki
 	mutex_unlock(&u->readlock);
 	scm_recv(sock, msg, siocb->scm, flags);
 out:
+	/*
+	 * Get payment for the work the server is now going to do on
+	 * behalf of clients (the !uid test is a hack to detect the
+	 * X server):
+	 */
+	if (copied && !current->uid)
+		sched_withdraw(&u->work_account);
+
 	return copied ? : err;
 }
 
