Return-Path: <linux-kernel-owner+w=401wt.eu-S1751771AbXA3VkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbXA3VkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 16:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbXA3Vj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 16:39:57 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:46904 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbXA3Vjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 16:39:48 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 4] Teach paths to wake a specific void * target instead
	of a whole task_struct
X-Mercurial-Node: 4ea674e8825ed09b554eab78476b2658f218fd9f
Message-Id: <4ea674e8825ed09b554e.1170193184@tetsuo.zabbo.net>
In-Reply-To: <patchbomb.1170193181@tetsuo.zabbo.net>
Date: Tue, 30 Jan 2007 13:39:44 -0700
From: Zach Brown <zach.brown@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The addition of multiple sleeping fibrils under a task_struct means that we
can't simply wake a task_struct to be able to wake a specific sleeping code
path.

This patch introduces task_wake_target() as a way to refer to a code path that
is about to sleep and will be woken in the future.  Sleepers that used to wake
a current task_struct reference with wake_up_process() now use this helper to
get a wake target cookie and wake it with wake_up_target().

Some paths know that waking a task will be sufficient.  Paths working with
kernel threads that never use fibrils fall into this category.  They're changed
to use wake_up_task() instead of wake_up_process().

This is not an exhaustive patch.  It isn't yet clear how signals are going to
interract with fibrils.  Once that is decided callers of wake_up_state() are
going to need to reflect the desired behaviour.  I add __deprecated to it to
highlight this detail.

The actual act of performing the wake-up is hidden under try_to_wake_up() and
is serialized with the scheduler under the runqueue lock.  This is very
fiddly stuff.  I'm sure I've missed some details.  I've tried to comment
the intent above try_to_wake_up_fibril().

diff -r df7bc026d50e -r 4ea674e8825e arch/i386/kernel/ptrace.c
--- a/arch/i386/kernel/ptrace.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/arch/i386/kernel/ptrace.c	Mon Jan 29 15:46:47 2007 -0800
@@ -492,7 +492,7 @@ long arch_ptrace(struct task_struct *chi
 		child->exit_code = data;
 		/* make sure the single step bit is not set. */
 		clear_singlestep(child);
-		wake_up_process(child);
+		wake_up_task(child);
 		ret = 0;
 		break;
 
@@ -508,7 +508,7 @@ long arch_ptrace(struct task_struct *chi
 		child->exit_code = SIGKILL;
 		/* make sure the single step bit is not set. */
 		clear_singlestep(child);
-		wake_up_process(child);
+		wake_up_task(child);
 		break;
 
 	case PTRACE_SYSEMU_SINGLESTEP: /* Same as SYSEMU, but singlestep if not syscall */
@@ -526,7 +526,7 @@ long arch_ptrace(struct task_struct *chi
 		set_singlestep(child);
 		child->exit_code = data;
 		/* give it a chance to run. */
-		wake_up_process(child);
+		wake_up_task(child);
 		ret = 0;
 		break;
 
diff -r df7bc026d50e -r 4ea674e8825e drivers/block/loop.c
--- a/drivers/block/loop.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/drivers/block/loop.c	Mon Jan 29 15:46:47 2007 -0800
@@ -824,7 +824,7 @@ static int loop_set_fd(struct loop_devic
 		goto out_clr;
 	}
 	lo->lo_state = Lo_bound;
-	wake_up_process(lo->lo_thread);
+	wake_up_task(lo->lo_thread);
 	return 0;
 
 out_clr:
diff -r df7bc026d50e -r 4ea674e8825e drivers/md/dm-io.c
--- a/drivers/md/dm-io.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/drivers/md/dm-io.c	Mon Jan 29 15:46:47 2007 -0800
@@ -18,7 +18,7 @@ struct io {
 struct io {
 	unsigned long error;
 	atomic_t count;
-	struct task_struct *sleeper;
+	void *wake_target;
 	io_notify_fn callback;
 	void *context;
 };
@@ -110,8 +110,8 @@ static void dec_count(struct io *io, uns
 		set_bit(region, &io->error);
 
 	if (atomic_dec_and_test(&io->count)) {
-		if (io->sleeper)
-			wake_up_process(io->sleeper);
+		if (io->wake_target)
+			wake_up_task(io->wake_target);
 
 		else {
 			int r = io->error;
@@ -323,7 +323,7 @@ static int sync_io(unsigned int num_regi
 
 	io.error = 0;
 	atomic_set(&io.count, 1); /* see dispatch_io() */
-	io.sleeper = current;
+	io.wake_target = task_wake_target(current);
 
 	dispatch_io(rw, num_regions, where, dp, &io, 1);
 
@@ -358,7 +358,7 @@ static int async_io(unsigned int num_reg
 	io = mempool_alloc(_io_pool, GFP_NOIO);
 	io->error = 0;
 	atomic_set(&io->count, 1); /* see dispatch_io() */
-	io->sleeper = NULL;
+	io->wake_target = NULL;
 	io->callback = fn;
 	io->context = context;
 
diff -r df7bc026d50e -r 4ea674e8825e drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/drivers/scsi/qla2xxx/qla_os.c	Mon Jan 29 15:46:47 2007 -0800
@@ -2403,7 +2403,7 @@ qla2xxx_wake_dpc(scsi_qla_host_t *ha)
 qla2xxx_wake_dpc(scsi_qla_host_t *ha)
 {
 	if (ha->dpc_thread)
-		wake_up_process(ha->dpc_thread);
+		wake_up_task(ha->dpc_thread);
 }
 
 /*
diff -r df7bc026d50e -r 4ea674e8825e drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/drivers/scsi/scsi_error.c	Mon Jan 29 15:46:47 2007 -0800
@@ -51,7 +51,7 @@ void scsi_eh_wakeup(struct Scsi_Host *sh
 void scsi_eh_wakeup(struct Scsi_Host *shost)
 {
 	if (shost->host_busy == shost->host_failed) {
-		wake_up_process(shost->ehandler);
+		wake_up_task(shost->ehandler);
 		SCSI_LOG_ERROR_RECOVERY(5,
 				printk("Waking error handler thread\n"));
 	}
diff -r df7bc026d50e -r 4ea674e8825e fs/aio.c
--- a/fs/aio.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/fs/aio.c	Mon Jan 29 15:46:47 2007 -0800
@@ -907,7 +907,7 @@ void fastcall kick_iocb(struct kiocb *io
 	 * single context. */
 	if (is_sync_kiocb(iocb)) {
 		kiocbSetKicked(iocb);
-	        wake_up_process(iocb->ki_obj.tsk);
+	        wake_up_target(iocb->ki_obj.wake_target);
 		return;
 	}
 
@@ -941,7 +941,7 @@ int fastcall aio_complete(struct kiocb *
 		BUG_ON(iocb->ki_users != 1);
 		iocb->ki_user_data = res;
 		iocb->ki_users = 0;
-		wake_up_process(iocb->ki_obj.tsk);
+		wake_up_target(iocb->ki_obj.wake_target);
 		return 1;
 	}
 
@@ -1053,7 +1053,7 @@ struct aio_timeout {
 struct aio_timeout {
 	struct timer_list	timer;
 	int			timed_out;
-	struct task_struct	*p;
+	void			*wake_target;
 };
 
 static void timeout_func(unsigned long data)
@@ -1061,7 +1061,7 @@ static void timeout_func(unsigned long d
 	struct aio_timeout *to = (struct aio_timeout *)data;
 
 	to->timed_out = 1;
-	wake_up_process(to->p);
+	wake_up_target(to->wake_target);
 }
 
 static inline void init_timeout(struct aio_timeout *to)
@@ -1070,7 +1070,7 @@ static inline void init_timeout(struct a
 	to->timer.data = (unsigned long)to;
 	to->timer.function = timeout_func;
 	to->timed_out = 0;
-	to->p = current;
+	to->wake_target = task_wake_target(current);
 }
 
 static inline void set_timeout(long start_jiffies, struct aio_timeout *to,
diff -r df7bc026d50e -r 4ea674e8825e fs/direct-io.c
--- a/fs/direct-io.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/fs/direct-io.c	Mon Jan 29 15:46:47 2007 -0800
@@ -124,7 +124,7 @@ struct dio {
 	spinlock_t bio_lock;		/* protects BIO fields below */
 	unsigned long refcount;		/* direct_io_worker() and bios */
 	struct bio *bio_list;		/* singly linked via bi_private */
-	struct task_struct *waiter;	/* waiting task (NULL if none) */
+	void *wake_target;		/* waiting initiator (NULL if none) */
 
 	/* AIO related stuff */
 	struct kiocb *iocb;		/* kiocb */
@@ -278,8 +278,8 @@ static int dio_bio_end_aio(struct bio *b
 
 	spin_lock_irqsave(&dio->bio_lock, flags);
 	remaining = --dio->refcount;
-	if (remaining == 1 && dio->waiter)
-		wake_up_process(dio->waiter);
+	if (remaining == 1 && dio->wake_target)
+		wake_up_target(dio->wake_target);
 	spin_unlock_irqrestore(&dio->bio_lock, flags);
 
 	if (remaining == 0) {
@@ -309,8 +309,8 @@ static int dio_bio_end_io(struct bio *bi
 	spin_lock_irqsave(&dio->bio_lock, flags);
 	bio->bi_private = dio->bio_list;
 	dio->bio_list = bio;
-	if (--dio->refcount == 1 && dio->waiter)
-		wake_up_process(dio->waiter);
+	if (--dio->refcount == 1 && dio->wake_target)
+		wake_up_target(dio->wake_target);
 	spin_unlock_irqrestore(&dio->bio_lock, flags);
 	return 0;
 }
@@ -393,12 +393,12 @@ static struct bio *dio_await_one(struct 
 	 */
 	while (dio->refcount > 1 && dio->bio_list == NULL) {
 		__set_current_state(TASK_UNINTERRUPTIBLE);
-		dio->waiter = current;
+		dio->wake_target = task_wake_target(current);
 		spin_unlock_irqrestore(&dio->bio_lock, flags);
 		io_schedule();
 		/* wake up sets us TASK_RUNNING */
 		spin_lock_irqsave(&dio->bio_lock, flags);
-		dio->waiter = NULL;
+		dio->wake_target = NULL;
 	}
 	if (dio->bio_list) {
 		bio = dio->bio_list;
@@ -990,7 +990,7 @@ direct_io_worker(int rw, struct kiocb *i
 	spin_lock_init(&dio->bio_lock);
 	dio->refcount = 1;
 	dio->bio_list = NULL;
-	dio->waiter = NULL;
+	dio->wake_target = NULL;
 
 	/*
 	 * In case of non-aligned buffers, we may need 2 more
diff -r df7bc026d50e -r 4ea674e8825e fs/jbd/journal.c
--- a/fs/jbd/journal.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/fs/jbd/journal.c	Mon Jan 29 15:46:47 2007 -0800
@@ -94,7 +94,7 @@ static void commit_timeout(unsigned long
 {
 	struct task_struct * p = (struct task_struct *) __data;
 
-	wake_up_process(p);
+	wake_up_task(p);
 }
 
 /*
diff -r df7bc026d50e -r 4ea674e8825e include/linux/aio.h
--- a/include/linux/aio.h	Mon Jan 29 15:36:16 2007 -0800
+++ b/include/linux/aio.h	Mon Jan 29 15:46:47 2007 -0800
@@ -98,7 +98,7 @@ struct kiocb {
 
 	union {
 		void __user		*user;
-		struct task_struct	*tsk;
+		void 			*wake_target;
 	} ki_obj;
 
 	__u64			ki_user_data;	/* user's data for completion */
@@ -124,7 +124,6 @@ struct kiocb {
 #define is_sync_kiocb(iocb)	((iocb)->ki_key == KIOCB_SYNC_KEY)
 #define init_sync_kiocb(x, filp)			\
 	do {						\
-		struct task_struct *tsk = current;	\
 		(x)->ki_flags = 0;			\
 		(x)->ki_users = 1;			\
 		(x)->ki_key = KIOCB_SYNC_KEY;		\
@@ -133,7 +132,7 @@ struct kiocb {
 		(x)->ki_cancel = NULL;			\
 		(x)->ki_retry = NULL;			\
 		(x)->ki_dtor = NULL;			\
-		(x)->ki_obj.tsk = tsk;			\
+		(x)->ki_obj.wake_target = task_wake_target(current);	\
 		(x)->ki_user_data = 0;                  \
 		init_wait((&(x)->ki_wait));             \
 	} while (0)
diff -r df7bc026d50e -r 4ea674e8825e include/linux/freezer.h
--- a/include/linux/freezer.h	Mon Jan 29 15:36:16 2007 -0800
+++ b/include/linux/freezer.h	Mon Jan 29 15:46:47 2007 -0800
@@ -42,7 +42,7 @@ static inline int thaw_process(struct ta
 {
 	if (frozen(p)) {
 		p->flags &= ~PF_FROZEN;
-		wake_up_process(p);
+		wake_up_task(p);
 		return 1;
 	}
 	return 0;
diff -r df7bc026d50e -r 4ea674e8825e include/linux/hrtimer.h
--- a/include/linux/hrtimer.h	Mon Jan 29 15:36:16 2007 -0800
+++ b/include/linux/hrtimer.h	Mon Jan 29 15:46:47 2007 -0800
@@ -65,7 +65,7 @@ struct hrtimer {
  */
 struct hrtimer_sleeper {
 	struct hrtimer timer;
-	struct task_struct *task;
+	void *wake_target;
 };
 
 /**
diff -r df7bc026d50e -r 4ea674e8825e include/linux/kthread.h
--- a/include/linux/kthread.h	Mon Jan 29 15:36:16 2007 -0800
+++ b/include/linux/kthread.h	Mon Jan 29 15:46:47 2007 -0800
@@ -22,7 +22,7 @@ struct task_struct *kthread_create(int (
 	struct task_struct *__k						   \
 		= kthread_create(threadfn, data, namefmt, ## __VA_ARGS__); \
 	if (!IS_ERR(__k))						   \
-		wake_up_process(__k);					   \
+		wake_up_task(__k);					   \
 	__k;								   \
 })
 
diff -r df7bc026d50e -r 4ea674e8825e include/linux/module.h
--- a/include/linux/module.h	Mon Jan 29 15:36:16 2007 -0800
+++ b/include/linux/module.h	Mon Jan 29 15:46:47 2007 -0800
@@ -334,7 +334,7 @@ struct module
 	struct list_head modules_which_use_me;
 
 	/* Who is waiting for us to be unloaded */
-	struct task_struct *waiter;
+	void *wake_target;
 
 	/* Destruction function. */
 	void (*exit)(void);
diff -r df7bc026d50e -r 4ea674e8825e include/linux/mutex.h
--- a/include/linux/mutex.h	Mon Jan 29 15:36:16 2007 -0800
+++ b/include/linux/mutex.h	Mon Jan 29 15:46:47 2007 -0800
@@ -65,7 +65,7 @@ struct mutex {
  */
 struct mutex_waiter {
 	struct list_head	list;
-	struct task_struct	*task;
+	void			*wake_target;
 #ifdef CONFIG_DEBUG_MUTEXES
 	struct mutex		*lock;
 	void			*magic;
diff -r df7bc026d50e -r 4ea674e8825e include/linux/posix-timers.h
--- a/include/linux/posix-timers.h	Mon Jan 29 15:36:16 2007 -0800
+++ b/include/linux/posix-timers.h	Mon Jan 29 15:46:47 2007 -0800
@@ -48,6 +48,7 @@ struct k_itimer {
 	int it_sigev_signo;		/* signo word of sigevent struct */
 	sigval_t it_sigev_value;	/* value word of sigevent struct */
 	struct task_struct *it_process;	/* process to send signal to */
+	void *it_wake_target;		/* wake target for nanosleep case */
 	struct sigqueue *sigq;		/* signal queue entry. */
 	union {
 		struct {
diff -r df7bc026d50e -r 4ea674e8825e include/linux/sched.h
--- a/include/linux/sched.h	Mon Jan 29 15:36:16 2007 -0800
+++ b/include/linux/sched.h	Mon Jan 29 15:46:47 2007 -0800
@@ -1338,8 +1338,14 @@ extern void switch_uid(struct user_struc
 
 extern void do_timer(unsigned long ticks);
 
-extern int FASTCALL(wake_up_state(struct task_struct * tsk, unsigned int state));
-extern int FASTCALL(wake_up_process(struct task_struct * tsk));
+/* 
+ * XXX We need to figure out how signal delivery will wake the fibrils in
+ * a task.  This is marked deprecated so that we get a compile-time warning
+ * to worry about it.
+ */
+extern int FASTCALL(wake_up_state(struct task_struct * tsk, unsigned int state)) __deprecated;
+extern int FASTCALL(wake_up_target(void *wake_target));
+extern int FASTCALL(wake_up_task(struct task_struct *task));
 extern void FASTCALL(wake_up_new_task(struct task_struct * tsk,
 						unsigned long clone_flags));
 #ifdef CONFIG_SMP
diff -r df7bc026d50e -r 4ea674e8825e include/linux/sem.h
--- a/include/linux/sem.h	Mon Jan 29 15:36:16 2007 -0800
+++ b/include/linux/sem.h	Mon Jan 29 15:46:47 2007 -0800
@@ -104,7 +104,7 @@ struct sem_queue {
 struct sem_queue {
 	struct sem_queue *	next;	 /* next entry in the queue */
 	struct sem_queue **	prev;	 /* previous entry in the queue, *(q->prev) == q */
-	struct task_struct*	sleeper; /* this process */
+	void			*wake_target;
 	struct sem_undo *	undo;	 /* undo structure */
 	int    			pid;	 /* process id of requesting process */
 	int    			status;	 /* completion status of operation */
diff -r df7bc026d50e -r 4ea674e8825e include/linux/wait.h
--- a/include/linux/wait.h	Mon Jan 29 15:36:16 2007 -0800
+++ b/include/linux/wait.h	Mon Jan 29 15:46:47 2007 -0800
@@ -54,13 +54,16 @@ typedef struct __wait_queue_head wait_qu
 typedef struct __wait_queue_head wait_queue_head_t;
 
 struct task_struct;
+/* XXX sigh, wait.h <-> sched.h have some fun ordering */
+void *task_wake_target(struct task_struct *task);
+struct task_struct *wake_target_to_task(void *wake_target);
 
 /*
  * Macros for declaration and initialisaton of the datatypes
  */
 
 #define __WAITQUEUE_INITIALIZER(name, tsk) {				\
-	.private	= tsk,						\
+	.private	= task_wake_target(tsk),			\
 	.func		= default_wake_function,			\
 	.task_list	= { NULL, NULL } }
 
@@ -91,7 +94,7 @@ static inline void init_waitqueue_entry(
 static inline void init_waitqueue_entry(wait_queue_t *q, struct task_struct *p)
 {
 	q->flags = 0;
-	q->private = p;
+	q->private = task_wake_target(p);
 	q->func = default_wake_function;
 }
 
@@ -389,7 +392,7 @@ int wake_bit_function(wait_queue_t *wait
 
 #define DEFINE_WAIT(name)						\
 	wait_queue_t name = {						\
-		.private	= current,				\
+		.private	= task_wake_target(current),		\
 		.func		= autoremove_wake_function,		\
 		.task_list	= LIST_HEAD_INIT((name).task_list),	\
 	}
@@ -398,7 +401,7 @@ int wake_bit_function(wait_queue_t *wait
 	struct wait_bit_queue name = {					\
 		.key = __WAIT_BIT_KEY_INITIALIZER(word, bit),		\
 		.wait	= {						\
-			.private	= current,			\
+			.private	= task_wake_target(current),	\
 			.func		= wake_bit_function,		\
 			.task_list	=				\
 				LIST_HEAD_INIT((name).wait.task_list),	\
@@ -407,7 +410,7 @@ int wake_bit_function(wait_queue_t *wait
 
 #define init_wait(wait)							\
 	do {								\
-		(wait)->private = current;				\
+		(wait)->private = task_wake_target(current);		\
 		(wait)->func = autoremove_wake_function;		\
 		INIT_LIST_HEAD(&(wait)->task_list);			\
 	} while (0)
diff -r df7bc026d50e -r 4ea674e8825e ipc/mqueue.c
--- a/ipc/mqueue.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/ipc/mqueue.c	Mon Jan 29 15:46:47 2007 -0800
@@ -58,7 +58,7 @@
 
 
 struct ext_wait_queue {		/* queue of sleeping tasks */
-	struct task_struct *task;
+	void *wake_target;
 	struct list_head list;
 	struct msg_msg *msg;	/* ptr of loaded message */
 	int state;		/* one of STATE_* values */
@@ -394,10 +394,11 @@ static void wq_add(struct mqueue_inode_i
 {
 	struct ext_wait_queue *walk;
 
-	ewp->task = current;
+	ewp->wake_target = task_wake_target(current);
 
 	list_for_each_entry(walk, &info->e_wait_q[sr].list, list) {
-		if (walk->task->static_prio <= current->static_prio) {
+		if (wake_target_to_task(walk->wake_target)->static_prio 
+		    <= current->static_prio) {
 			list_add_tail(&ewp->list, &walk->list);
 			return;
 		}
@@ -785,7 +786,7 @@ static inline void pipelined_send(struct
 	receiver->msg = message;
 	list_del(&receiver->list);
 	receiver->state = STATE_PENDING;
-	wake_up_process(receiver->task);
+	wake_up_target(receiver->wake_target);
 	smp_wmb();
 	receiver->state = STATE_READY;
 }
@@ -804,7 +805,7 @@ static inline void pipelined_receive(str
 	msg_insert(sender->msg, info);
 	list_del(&sender->list);
 	sender->state = STATE_PENDING;
-	wake_up_process(sender->task);
+	wake_up_target(sender->wake_target);
 	smp_wmb();
 	sender->state = STATE_READY;
 }
@@ -869,7 +870,7 @@ asmlinkage long sys_mq_timedsend(mqd_t m
 			spin_unlock(&info->lock);
 			ret = timeout;
 		} else {
-			wait.task = current;
+			wait.wake_target = task_wake_target(current);
 			wait.msg = (void *) msg_ptr;
 			wait.state = STATE_NONE;
 			ret = wq_sleep(info, SEND, timeout, &wait);
@@ -944,7 +945,7 @@ asmlinkage ssize_t sys_mq_timedreceive(m
 			ret = timeout;
 			msg_ptr = NULL;
 		} else {
-			wait.task = current;
+			wait.wake_target = task_wake_target(current);
 			wait.state = STATE_NONE;
 			ret = wq_sleep(info, RECV, timeout, &wait);
 			msg_ptr = wait.msg;
diff -r df7bc026d50e -r 4ea674e8825e ipc/msg.c
--- a/ipc/msg.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/ipc/msg.c	Mon Jan 29 15:46:47 2007 -0800
@@ -46,7 +46,7 @@
  */
 struct msg_receiver {
 	struct list_head	r_list;
-	struct task_struct	*r_tsk;
+	struct task_struct	*r_wake_target;
 
 	int			r_mode;
 	long			r_msgtype;
@@ -58,7 +58,7 @@ struct msg_receiver {
 /* one msg_sender for each sleeping sender */
 struct msg_sender {
 	struct list_head	list;
-	struct task_struct	*tsk;
+	void			*wake_target;
 };
 
 #define SEARCH_ANY		1
@@ -180,7 +180,7 @@ static int newque (struct ipc_namespace 
 
 static inline void ss_add(struct msg_queue *msq, struct msg_sender *mss)
 {
-	mss->tsk = current;
+	mss->wake_target = task_wake_target(current);
 	current->state = TASK_INTERRUPTIBLE;
 	list_add_tail(&mss->list, &msq->q_senders);
 }
@@ -203,7 +203,7 @@ static void ss_wakeup(struct list_head *
 		tmp = tmp->next;
 		if (kill)
 			mss->list.next = NULL;
-		wake_up_process(mss->tsk);
+		wake_up_target(mss->wake_target);
 	}
 }
 
@@ -218,7 +218,7 @@ static void expunge_all(struct msg_queue
 		msr = list_entry(tmp, struct msg_receiver, r_list);
 		tmp = tmp->next;
 		msr->r_msg = NULL;
-		wake_up_process(msr->r_tsk);
+		wake_up_target(msr->r_wake_target);
 		smp_mb();
 		msr->r_msg = ERR_PTR(res);
 	}
@@ -602,20 +602,21 @@ static inline int pipelined_send(struct 
 		msr = list_entry(tmp, struct msg_receiver, r_list);
 		tmp = tmp->next;
 		if (testmsg(msg, msr->r_msgtype, msr->r_mode) &&
-		    !security_msg_queue_msgrcv(msq, msg, msr->r_tsk,
-					       msr->r_msgtype, msr->r_mode)) {
+		    !security_msg_queue_msgrcv(msq, msg,
+				wake_target_to_task(msr->r_wake_target),
+				msr->r_msgtype, msr->r_mode)) {
 
 			list_del(&msr->r_list);
 			if (msr->r_maxsize < msg->m_ts) {
 				msr->r_msg = NULL;
-				wake_up_process(msr->r_tsk);
+				wake_up_target(msr->r_wake_target);
 				smp_mb();
 				msr->r_msg = ERR_PTR(-E2BIG);
 			} else {
 				msr->r_msg = NULL;
-				msq->q_lrpid = msr->r_tsk->pid;
+				msq->q_lrpid = wake_target_to_task(msr->r_wake_target)->pid;
 				msq->q_rtime = get_seconds();
-				wake_up_process(msr->r_tsk);
+				wake_up_target(msr->r_wake_target);
 				smp_mb();
 				msr->r_msg = msg;
 
@@ -826,7 +827,7 @@ long do_msgrcv(int msqid, long *pmtype, 
 			goto out_unlock;
 		}
 		list_add_tail(&msr_d.r_list, &msq->q_receivers);
-		msr_d.r_tsk = current;
+		msr_d.r_wake_target = task_wake_target(current);
 		msr_d.r_msgtype = msgtyp;
 		msr_d.r_mode = mode;
 		if (msgflg & MSG_NOERROR)
diff -r df7bc026d50e -r 4ea674e8825e ipc/sem.c
--- a/ipc/sem.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/ipc/sem.c	Mon Jan 29 15:46:47 2007 -0800
@@ -411,7 +411,7 @@ static void update_queue (struct sem_arr
 		error = try_atomic_semop(sma, q->sops, q->nsops,
 					 q->undo, q->pid);
 
-		/* Does q->sleeper still need to sleep? */
+		/* Does q->wake_target still need to sleep? */
 		if (error <= 0) {
 			struct sem_queue *n;
 			remove_from_queue(sma,q);
@@ -431,7 +431,7 @@ static void update_queue (struct sem_arr
 				n = sma->sem_pending;
 			else
 				n = q->next;
-			wake_up_process(q->sleeper);
+			wake_up_target(q->wake_target);
 			/* hands-off: q will disappear immediately after
 			 * writing q->status.
 			 */
@@ -515,7 +515,7 @@ static void freeary (struct ipc_namespac
 		q->prev = NULL;
 		n = q->next;
 		q->status = IN_WAKEUP;
-		wake_up_process(q->sleeper); /* doesn't sleep */
+		wake_up_target(q->wake_target); /* doesn't sleep */
 		smp_wmb();
 		q->status = -EIDRM;	/* hands-off q */
 		q = n;
@@ -1223,7 +1223,7 @@ retry_undos:
 		prepend_to_queue(sma ,&queue);
 
 	queue.status = -EINTR;
-	queue.sleeper = current;
+	queue.wake_target = task_wake_target(current);
 	current->state = TASK_INTERRUPTIBLE;
 	sem_unlock(sma);
 
diff -r df7bc026d50e -r 4ea674e8825e kernel/exit.c
--- a/kernel/exit.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/kernel/exit.c	Mon Jan 29 15:46:47 2007 -0800
@@ -91,7 +91,7 @@ static void __exit_signal(struct task_st
 		 * then notify it:
 		 */
 		if (sig->group_exit_task && atomic_read(&sig->count) == sig->notify_count) {
-			wake_up_process(sig->group_exit_task);
+			wake_up_task(sig->group_exit_task);
 			sig->group_exit_task = NULL;
 		}
 		if (tsk == sig->curr_target)
diff -r df7bc026d50e -r 4ea674e8825e kernel/hrtimer.c
--- a/kernel/hrtimer.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/kernel/hrtimer.c	Mon Jan 29 15:46:47 2007 -0800
@@ -660,11 +660,11 @@ static int hrtimer_wakeup(struct hrtimer
 {
 	struct hrtimer_sleeper *t =
 		container_of(timer, struct hrtimer_sleeper, timer);
-	struct task_struct *task = t->task;
-
-	t->task = NULL;
-	if (task)
-		wake_up_process(task);
+	void *wake_target = t->wake_target;
+
+	t->wake_target = NULL;
+	if (wake_target)
+		wake_up_target(wake_target);
 
 	return HRTIMER_NORESTART;
 }
@@ -672,7 +672,7 @@ void hrtimer_init_sleeper(struct hrtimer
 void hrtimer_init_sleeper(struct hrtimer_sleeper *sl, struct task_struct *task)
 {
 	sl->timer.function = hrtimer_wakeup;
-	sl->task = task;
+	sl->wake_target = task_wake_target(task);
 }
 
 static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mode)
@@ -688,9 +688,9 @@ static int __sched do_nanosleep(struct h
 		hrtimer_cancel(&t->timer);
 		mode = HRTIMER_ABS;
 
-	} while (t->task && !signal_pending(current));
-
-	return t->task == NULL;
+	} while (t->wake_target && !signal_pending(current));
+
+	return t->wake_target == NULL;
 }
 
 long __sched hrtimer_nanosleep_restart(struct restart_block *restart)
diff -r df7bc026d50e -r 4ea674e8825e kernel/kthread.c
--- a/kernel/kthread.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/kernel/kthread.c	Mon Jan 29 15:46:47 2007 -0800
@@ -232,7 +232,7 @@ int kthread_stop(struct task_struct *k)
 
 	/* Now set kthread_should_stop() to true, and wake it up. */
 	kthread_stop_info.k = k;
-	wake_up_process(k);
+	wake_up_task(k);
 	put_task_struct(k);
 
 	/* Once it dies, reset stop ptr, gather result and we're done. */
diff -r df7bc026d50e -r 4ea674e8825e kernel/module.c
--- a/kernel/module.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/kernel/module.c	Mon Jan 29 15:46:47 2007 -0800
@@ -508,7 +508,7 @@ static void module_unload_init(struct mo
 	/* Hold reference count during initialization. */
 	local_set(&mod->ref[raw_smp_processor_id()].count, 1);
 	/* Backwards compatibility macros put refcount during init. */
-	mod->waiter = current;
+	mod->wake_target = task_wake_target(current);
 }
 
 /* modules using other modules */
@@ -699,7 +699,7 @@ sys_delete_module(const char __user *nam
 	}
 
 	/* Set this up before setting mod->state */
-	mod->waiter = current;
+	mod->wake_target = task_wake_target(current);
 
 	/* Stop the machine so refcounts can't move and disable module. */
 	ret = try_stop_module(mod, flags, &forced);
@@ -797,7 +797,7 @@ void module_put(struct module *module)
 		local_dec(&module->ref[cpu].count);
 		/* Maybe they're waiting for us to drop reference? */
 		if (unlikely(!module_is_live(module)))
-			wake_up_process(module->waiter);
+			wake_up_target(module->wake_target);
 		put_cpu();
 	}
 }
diff -r df7bc026d50e -r 4ea674e8825e kernel/mutex-debug.c
--- a/kernel/mutex-debug.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/kernel/mutex-debug.c	Mon Jan 29 15:46:47 2007 -0800
@@ -53,6 +53,7 @@ void debug_mutex_free_waiter(struct mute
 	memset(waiter, MUTEX_DEBUG_FREE, sizeof(*waiter));
 }
 
+#warning "this is going to need updating for fibrils"
 void debug_mutex_add_waiter(struct mutex *lock, struct mutex_waiter *waiter,
 			    struct thread_info *ti)
 {
@@ -67,12 +68,12 @@ void mutex_remove_waiter(struct mutex *l
 			 struct thread_info *ti)
 {
 	DEBUG_LOCKS_WARN_ON(list_empty(&waiter->list));
-	DEBUG_LOCKS_WARN_ON(waiter->task != ti->task);
+	DEBUG_LOCKS_WARN_ON(waiter->wake_target != task_wake_target(ti->task));
 	DEBUG_LOCKS_WARN_ON(ti->task->blocked_on != waiter);
 	ti->task->blocked_on = NULL;
 
 	list_del_init(&waiter->list);
-	waiter->task = NULL;
+	waiter->wake_target = NULL;
 }
 
 void debug_mutex_unlock(struct mutex *lock)
diff -r df7bc026d50e -r 4ea674e8825e kernel/mutex.c
--- a/kernel/mutex.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/kernel/mutex.c	Mon Jan 29 15:46:47 2007 -0800
@@ -137,7 +137,7 @@ __mutex_lock_common(struct mutex *lock, 
 
 	/* add waiting tasks to the end of the waitqueue (FIFO): */
 	list_add_tail(&waiter.list, &lock->wait_list);
-	waiter.task = task;
+	waiter.wake_target = task_wake_target(task);
 
 	for (;;) {
 		/*
@@ -246,7 +246,7 @@ __mutex_unlock_common_slowpath(atomic_t 
 
 		debug_mutex_wake_waiter(lock, waiter);
 
-		wake_up_process(waiter->task);
+		wake_up_target(waiter->wake_target);
 	}
 
 	debug_mutex_clear_owner(lock);
diff -r df7bc026d50e -r 4ea674e8825e kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/kernel/posix-cpu-timers.c	Mon Jan 29 15:46:47 2007 -0800
@@ -673,7 +673,7 @@ static void cpu_timer_fire(struct k_itim
 		 * This a special case for clock_nanosleep,
 		 * not a normal timer from sys_timer_create.
 		 */
-		wake_up_process(timer->it_process);
+		wake_up_target(timer->it_wake_target);
 		timer->it.cpu.expires.sched = 0;
 	} else if (timer->it.cpu.incr.sched == 0) {
 		/*
@@ -1423,6 +1423,12 @@ static int do_cpu_nanosleep(const clocki
 	timer.it_overrun = -1;
 	error = posix_cpu_timer_create(&timer);
 	timer.it_process = current;
+	/* 
+	 * XXX This isn't quite right, but the rest of the it_process users
+	 * fall under the currently unresolved question of how signal delivery
+	 * will behave.
+	 */
+	timer.it_wake_target = task_wake_target(current);
 	if (!error) {
 		static struct itimerspec zero_it;
 
diff -r df7bc026d50e -r 4ea674e8825e kernel/ptrace.c
--- a/kernel/ptrace.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/kernel/ptrace.c	Mon Jan 29 15:46:47 2007 -0800
@@ -221,7 +221,7 @@ static inline void __ptrace_detach(struc
 	__ptrace_unlink(child);
 	/* .. and wake it up. */
 	if (child->exit_state != EXIT_ZOMBIE)
-		wake_up_process(child);
+		wake_up_task(child);
 }
 
 int ptrace_detach(struct task_struct *child, unsigned int data)
diff -r df7bc026d50e -r 4ea674e8825e kernel/rtmutex.c
--- a/kernel/rtmutex.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/kernel/rtmutex.c	Mon Jan 29 15:46:47 2007 -0800
@@ -516,7 +516,8 @@ static void wakeup_next_waiter(struct rt
 	}
 	spin_unlock_irqrestore(&pendowner->pi_lock, flags);
 
-	wake_up_process(pendowner);
+#warning "this looks like it needs expert attention"
+	wake_up_task(pendowner);
 }
 
 /*
@@ -640,7 +641,7 @@ rt_mutex_slowlock(struct rt_mutex *lock,
 			/* Signal pending? */
 			if (signal_pending(current))
 				ret = -EINTR;
-			if (timeout && !timeout->task)
+			if (timeout && !timeout->wake_target)
 				ret = -ETIMEDOUT;
 			if (ret)
 				break;
diff -r df7bc026d50e -r 4ea674e8825e kernel/sched.c
--- a/kernel/sched.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/kernel/sched.c	Mon Jan 29 15:46:47 2007 -0800
@@ -1381,10 +1381,52 @@ static inline int wake_idle(int cpu, str
 }
 #endif
 
+/*
+ * This path wakes a fibril.
+ *
+ * In the common case, a task will be sleeping with multiple pending
+ * sleeping fibrils.  In that case we need to put the fibril on the task's
+ * runnable list and wake the task itself.  We need it to go back through
+ * the scheduler to find the runnable fibril so we set TIF_NEED_RESCHED.
+ *
+ * A derivative of that case is when the fibril that we're waking is already
+ * current on the sleeping task.  In that case we just need to wake the
+ * task itself, it will already be executing the fibril we're waking.  We
+ * do not put it on the runnable list in that case.
+ *
+ * XXX Obviously, there are lots of very scary races here.  We should get
+ * more confidence that they're taken care of.
+ */
+static int try_to_wake_up_fibril(struct task_struct *tsk, void *wake_target,
+				 unsigned int state)
+{
+	struct fibril *fibril = (struct fibril *)
+					((unsigned long)wake_target & ~1UL);
+	long old_state = fibril->state;
+	int ret = 1;
+
+	if (!(old_state & state))
+		goto out;
+
+	ret = 0;
+	fibril->state = TASK_RUNNING;
+
+	if (fibril->ti->task->fibril != fibril) {
+		BUG_ON(!list_empty(&fibril->run_list));
+		list_add_tail(&fibril->run_list, &tsk->runnable_fibrils);
+		if (!tsk->array)
+			set_ti_thread_flag(task_thread_info(tsk),
+					   TIF_NEED_RESCHED);
+	}
+
+out:
+	return ret;
+}
+
 /***
  * try_to_wake_up - wake up a thread
- * @p: the to-be-woken-up thread
- * @state: the mask of task states that can be woken
+ * @wake_target: the to-be-woken-up sleeper, from task_wake_target()
+ * @state: the mask of states that can be woken
  * @sync: do a synchronous wakeup?
  *
  * Put it on the run-queue if it's not already there. The "current"
@@ -1395,9 +1437,10 @@ static inline int wake_idle(int cpu, str
  *
  * returns failure only if the task is already active.
  */
-static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
+static int try_to_wake_up(void *wake_target, unsigned int state, int sync)
 {
 	int cpu, this_cpu, success = 0;
+	struct task_struct *p = wake_target_to_task(wake_target);
 	unsigned long flags;
 	long old_state;
 	struct rq *rq;
@@ -1408,6 +1451,12 @@ static int try_to_wake_up(struct task_st
 #endif
 
 	rq = task_rq_lock(p, &flags);
+
+	/* See if we're just putting a fibril on its task's runnable list */
+	if (unlikely(((unsigned long)wake_target & 1) &&
+		     try_to_wake_up_fibril(p, wake_target, state)))
+		goto out;
+
 	old_state = p->state;
 	if (!(old_state & state))
 		goto out;
@@ -1555,16 +1604,27 @@ out:
 	return success;
 }
 
-int fastcall wake_up_process(struct task_struct *p)
-{
-	return try_to_wake_up(p, TASK_STOPPED | TASK_TRACED |
+int fastcall wake_up_task(struct task_struct *task)
+{
+	return try_to_wake_up((void *)task, TASK_STOPPED | TASK_TRACED |
 				 TASK_INTERRUPTIBLE | TASK_UNINTERRUPTIBLE, 0);
 }
-EXPORT_SYMBOL(wake_up_process);
-
+EXPORT_SYMBOL(wake_up_task);
+
+int fastcall wake_up_target(void *wake_target)
+{
+	return try_to_wake_up(wake_target, TASK_STOPPED | TASK_TRACED |
+				 TASK_INTERRUPTIBLE | TASK_UNINTERRUPTIBLE, 0);
+}
+EXPORT_SYMBOL(wake_up_target);
+
+/* 
+ * XXX We need to figure out how signal delivery will wake the fibrils in
+ * a task.
+ */
 int fastcall wake_up_state(struct task_struct *p, unsigned int state)
 {
-	return try_to_wake_up(p, state, 0);
+	return try_to_wake_up((void *)p, state, 0);
 }
 
 static void task_running_tick(struct rq *rq, struct task_struct *p);
@@ -2041,7 +2101,7 @@ static void sched_migrate_task(struct ta
 
 		get_task_struct(mt);
 		task_rq_unlock(rq, &flags);
-		wake_up_process(mt);
+		wake_up_task(mt);
 		put_task_struct(mt);
 		wait_for_completion(&req.done);
 
@@ -2673,7 +2733,7 @@ redo:
 			}
 			spin_unlock_irqrestore(&busiest->lock, flags);
 			if (active_balance)
-				wake_up_process(busiest->migration_thread);
+				wake_up_task(busiest->migration_thread);
 
 			/*
 			 * We've kicked active balancing, reset the failure
@@ -3781,6 +3841,33 @@ need_resched:
 
 #endif /* CONFIG_PREEMPT */
 
+/*
+ * This is a void * so that it's harder for people to stash it in a small 
+ * scalar without getting warnings.
+ */
+void *task_wake_target(struct task_struct *task)
+{
+	if (task->fibril) {
+		return (void *)((unsigned long)task->fibril | 1);
+	} else {
+		BUG_ON((unsigned long)task & 1);
+		return task;
+	}
+}
+EXPORT_SYMBOL(task_wake_target);
+
+struct task_struct *wake_target_to_task(void *wake_target)
+{
+	if ((unsigned long)wake_target & 1) {
+		struct fibril *fibril;
+		fibril = (struct fibril *) ((unsigned long)wake_target ^ 1);
+		return fibril->ti->task;
+	} else
+		return (struct task_struct *)((unsigned long)wake_target);
+}
+EXPORT_SYMBOL(wake_target_to_task);
+
+
 int default_wake_function(wait_queue_t *curr, unsigned mode, int sync,
 			  void *key)
 {
@@ -5140,7 +5227,7 @@ int set_cpus_allowed(struct task_struct 
 	if (migrate_task(p, any_online_cpu(new_mask), &req)) {
 		/* Need help from migration thread: drop lock and wait. */
 		task_rq_unlock(rq, &flags);
-		wake_up_process(rq->migration_thread);
+		wake_up_task(rq->migration_thread);
 		wait_for_completion(&req.done);
 		tlb_migrate_finish(p->mm);
 		return 0;
@@ -5462,7 +5549,7 @@ migration_call(struct notifier_block *nf
 
 	case CPU_ONLINE:
 		/* Strictly unneccessary, as first user will wake it. */
-		wake_up_process(cpu_rq(cpu)->migration_thread);
+		wake_up_task(cpu_rq(cpu)->migration_thread);
 		break;
 
 #ifdef CONFIG_HOTPLUG_CPU
diff -r df7bc026d50e -r 4ea674e8825e kernel/signal.c
--- a/kernel/signal.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/kernel/signal.c	Mon Jan 29 15:46:47 2007 -0800
@@ -948,7 +948,7 @@ __group_complete_signal(int sig, struct 
 			signal_wake_up(t, 0);
 			t = next_thread(t);
 		} while (t != p);
-		wake_up_process(p->signal->group_exit_task);
+		wake_up_task(p->signal->group_exit_task);
 		return;
 	}
 
diff -r df7bc026d50e -r 4ea674e8825e kernel/softirq.c
--- a/kernel/softirq.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/kernel/softirq.c	Mon Jan 29 15:46:47 2007 -0800
@@ -58,7 +58,7 @@ static inline void wakeup_softirqd(void)
 	struct task_struct *tsk = __get_cpu_var(ksoftirqd);
 
 	if (tsk && tsk->state != TASK_RUNNING)
-		wake_up_process(tsk);
+		wake_up_task(tsk);
 }
 
 /*
@@ -583,7 +583,7 @@ static int __cpuinit cpu_callback(struct
   		per_cpu(ksoftirqd, hotcpu) = p;
  		break;
 	case CPU_ONLINE:
-		wake_up_process(per_cpu(ksoftirqd, hotcpu));
+		wake_up_task(per_cpu(ksoftirqd, hotcpu));
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
diff -r df7bc026d50e -r 4ea674e8825e kernel/stop_machine.c
--- a/kernel/stop_machine.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/kernel/stop_machine.c	Mon Jan 29 15:46:47 2007 -0800
@@ -185,7 +185,7 @@ struct task_struct *__stop_machine_run(i
 	p = kthread_create(do_stop, &smdata, "kstopmachine");
 	if (!IS_ERR(p)) {
 		kthread_bind(p, cpu);
-		wake_up_process(p);
+		wake_up_task(p);
 		wait_for_completion(&smdata.done);
 	}
 	up(&stopmachine_mutex);
diff -r df7bc026d50e -r 4ea674e8825e kernel/timer.c
--- a/kernel/timer.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/kernel/timer.c	Mon Jan 29 15:46:47 2007 -0800
@@ -1290,7 +1290,7 @@ asmlinkage long sys_getegid(void)
 
 static void process_timeout(unsigned long __data)
 {
-	wake_up_process((struct task_struct *)__data);
+	wake_up_task((struct task_struct *)__data);
 }
 
 /**
diff -r df7bc026d50e -r 4ea674e8825e kernel/workqueue.c
--- a/kernel/workqueue.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/kernel/workqueue.c	Mon Jan 29 15:46:47 2007 -0800
@@ -504,14 +504,14 @@ struct workqueue_struct *__create_workqu
 		if (!p)
 			destroy = 1;
 		else
-			wake_up_process(p);
+			wake_up_task(p);
 	} else {
 		list_add(&wq->list, &workqueues);
 		for_each_online_cpu(cpu) {
 			p = create_workqueue_thread(wq, cpu, freezeable);
 			if (p) {
 				kthread_bind(p, cpu);
-				wake_up_process(p);
+				wake_up_task(p);
 			} else
 				destroy = 1;
 		}
@@ -773,7 +773,7 @@ static int __devinit workqueue_cpu_callb
 
 			cwq = per_cpu_ptr(wq->cpu_wq, hotcpu);
 			kthread_bind(cwq->thread, hotcpu);
-			wake_up_process(cwq->thread);
+			wake_up_task(cwq->thread);
 		}
 		mutex_unlock(&workqueue_mutex);
 		break;
diff -r df7bc026d50e -r 4ea674e8825e lib/rwsem.c
--- a/lib/rwsem.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/lib/rwsem.c	Mon Jan 29 15:46:47 2007 -0800
@@ -30,7 +30,7 @@ EXPORT_SYMBOL(__init_rwsem);
 
 struct rwsem_waiter {
 	struct list_head list;
-	struct task_struct *task;
+	void *wake_target;
 	unsigned int flags;
 #define RWSEM_WAITING_FOR_READ	0x00000001
 #define RWSEM_WAITING_FOR_WRITE	0x00000002
@@ -50,7 +50,7 @@ __rwsem_do_wake(struct rw_semaphore *sem
 __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 {
 	struct rwsem_waiter *waiter;
-	struct task_struct *tsk;
+	void *wake_target;
 	struct list_head *next;
 	signed long oldcount, woken, loop;
 
@@ -75,16 +75,17 @@ __rwsem_do_wake(struct rw_semaphore *sem
 	if (!(waiter->flags & RWSEM_WAITING_FOR_WRITE))
 		goto readers_only;
 
-	/* We must be careful not to touch 'waiter' after we set ->task = NULL.
-	 * It is an allocated on the waiter's stack and may become invalid at
-	 * any time after that point (due to a wakeup from another source).
+	/* We must be careful not to touch 'waiter' after we set ->wake_target
+	 * = NULL.  It is an allocated on the waiter's stack and may become
+	 * invalid at any time after that point (due to a wakeup from another
+	 * source).
 	 */
 	list_del(&waiter->list);
-	tsk = waiter->task;
+	wake_target = waiter->wake_target;
 	smp_mb();
-	waiter->task = NULL;
-	wake_up_process(tsk);
-	put_task_struct(tsk);
+	waiter->wake_target = NULL;
+	wake_up_target(wake_target);
+	put_task_struct(wake_target_to_task(wake_target));
 	goto out;
 
 	/* don't want to wake any writers */
@@ -123,11 +124,11 @@ __rwsem_do_wake(struct rw_semaphore *sem
 	for (; loop > 0; loop--) {
 		waiter = list_entry(next, struct rwsem_waiter, list);
 		next = waiter->list.next;
-		tsk = waiter->task;
+		wake_target = waiter->wake_target;
 		smp_mb();
-		waiter->task = NULL;
-		wake_up_process(tsk);
-		put_task_struct(tsk);
+		waiter->wake_target = NULL;
+		wake_up_target(wake_target);
+		put_task_struct(wake_target_to_task(wake_target));
 	}
 
 	sem->wait_list.next = next;
@@ -157,7 +158,7 @@ rwsem_down_failed_common(struct rw_semap
 
 	/* set up my own style of waitqueue */
 	spin_lock_irq(&sem->wait_lock);
-	waiter->task = tsk;
+	waiter->wake_target = task_wake_target(tsk);
 	get_task_struct(tsk);
 
 	list_add_tail(&waiter->list, &sem->wait_list);
@@ -173,7 +174,7 @@ rwsem_down_failed_common(struct rw_semap
 
 	/* wait to be given the lock */
 	for (;;) {
-		if (!waiter->task)
+		if (!waiter->wake_target)
 			break;
 		schedule();
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
diff -r df7bc026d50e -r 4ea674e8825e mm/pdflush.c
--- a/mm/pdflush.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/mm/pdflush.c	Mon Jan 29 15:46:47 2007 -0800
@@ -217,7 +217,7 @@ int pdflush_operation(void (*fn)(unsigne
 			last_empty_jifs = jiffies;
 		pdf->fn = fn;
 		pdf->arg0 = arg0;
-		wake_up_process(pdf->who);
+		wake_up_task(pdf->who);
 		spin_unlock_irqrestore(&pdflush_lock, flags);
 	}
 	return ret;
diff -r df7bc026d50e -r 4ea674e8825e net/core/pktgen.c
--- a/net/core/pktgen.c	Mon Jan 29 15:36:16 2007 -0800
+++ b/net/core/pktgen.c	Mon Jan 29 15:46:47 2007 -0800
@@ -3505,7 +3505,7 @@ static int __init pktgen_create_thread(i
 	pe->proc_fops = &pktgen_thread_fops;
 	pe->data = t;
 
-	wake_up_process(p);
+	wake_up_task(p);
 
 	return 0;
 }
