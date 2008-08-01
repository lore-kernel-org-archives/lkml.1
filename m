Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbYHAN6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbYHAN6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 09:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbYHAN6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 09:58:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbYHAN6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 09:58:10 -0400
Message-ID: <4893164D.1@redhat.com>
Date: Fri, 01 Aug 2008 09:57:33 -0400
From: Ric Wheeler <rwheeler@redhat.com>
Reply-To: rwheeler@redhat.com
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Josef Bacik <jbacik@redhat.com>
CC: Ric Wheeler <rwheeler@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, linux-fsdevel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: high resolution timers, scheduling & sleep granularity
References: <4892FC11.4020105@redhat.com> <20080801132537.GB14001@unused.rdu.redhat.com>
In-Reply-To: <20080801132537.GB14001@unused.rdu.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josef Bacik wrote:
> On Fri, Aug 01, 2008 at 08:05:37AM -0400, Ric Wheeler wrote:
>   
>> Hi Thomas & Ingo,
>>
>> Josef has been working on some patches to try and get ext3/4 to dynamically 
>> detect the latency of a storage device and use that base latency to tune 
>> the amount of time we sleep waiting for others to join in a transaction. 
>> The logic in question lives in jbd/transaction.c (transaction_stop).
>>
>> The code was originally developed to try and allow multiple threads to join 
>> in a big, slow transaction. For example, transacations that write to a slow 
>> ATA or S-ATA drive take in the neighborhood of 10 to 20 ms.
>>
>> Faster devices, for example a disk array,  can complete the transaction in 
>> 1.3 ms. Even higher speed SSD devices boast of a latency of 0.1ms, not to 
>> mention RAM disks ;-)
>>
>> The current logic makes us wait way too long, especially with a 250HZ 
>> kernel since we sleep many times longer than it takes to complete the IO 
>> ;-)
>>
>> Do either of you have any thoughts on how to get a better, fine grained 
>> sleep capability that we could use that would allow us to sleep in 
>> sub-jiffie chunks?
>>
>>     
>
> Hello,
>
> This is the most recent iteration of my patch using hrtimers.  It works really
> well for ramdisks, so anything with low latency writes is going to be really
> fast, but I'm still trying to come up with a smart way to sleep long enough to
> not hurt SATA performance.  As it stands now I'm getting a 5% decrease in speed
> on SATA.  So I think I've got the sleep as little as possible part down right,
> just can't quite get it to sleep long enough if the disk is slow.  Thanks,
>
> Josef
>   

I think that this (or similar) kind of precision_sleep() should be 
generically useful.

One question on the code, would it be better to measure the average 
transaction time in the same units as your precision sleep uses - aren't 
jiffies are still too coarse?

It also might be interesting to export the measured average commit time 
via some non-printk method (/sys/fs ??)

ric




>
> Index: linux-2.6/fs/jbd/commit.c
> ===================================================================
> --- linux-2.6.orig/fs/jbd/commit.c
> +++ linux-2.6/fs/jbd/commit.c
> @@ -288,6 +288,7 @@ void journal_commit_transaction(journal_
>  	int flags;
>  	int err;
>  	unsigned long blocknr;
> +	unsigned long long commit_time, start_time;
>  	char *tagp = NULL;
>  	journal_header_t *header;
>  	journal_block_tag_t *tag = NULL;
> @@ -400,6 +401,7 @@ void journal_commit_transaction(journal_
>  	commit_transaction->t_state = T_FLUSH;
>  	journal->j_committing_transaction = commit_transaction;
>  	journal->j_running_transaction = NULL;
> +	start_time = jiffies;
>  	commit_transaction->t_log_start = journal->j_head;
>  	wake_up(&journal->j_wait_transaction_locked);
>  	spin_unlock(&journal->j_state_lock);
> @@ -873,6 +875,19 @@ restart_loop:
>  	J_ASSERT(commit_transaction == journal->j_committing_transaction);
>  	journal->j_commit_sequence = commit_transaction->t_tid;
>  	journal->j_committing_transaction = NULL;
> +	commit_time = elapsed_jiffies(start_time, jiffies);
> +	if (unlikely(!journal->j_average_commit_time))
> +		journal->j_average_commit_time = commit_time;
> +	else
> +		journal->j_average_commit_time = (commit_time +
> +					journal->j_average_commit_time) / 2;
> +
> +	if (journal->print_count < 100) {
> +		journal->print_count++;
> +		printk(KERN_ERR "avg commit time = %lu\n",
> +		       journal->j_average_commit_time);
> +	}
> +
>  	spin_unlock(&journal->j_state_lock);
>  
>  	if (commit_transaction->t_checkpoint_list == NULL &&
> Index: linux-2.6/fs/jbd/transaction.c
> ===================================================================
> --- linux-2.6.orig/fs/jbd/transaction.c
> +++ linux-2.6/fs/jbd/transaction.c
> @@ -25,6 +25,7 @@
>  #include <linux/timer.h>
>  #include <linux/mm.h>
>  #include <linux/highmem.h>
> +#include <linux/hrtimer.h>
>  
>  static void __journal_temp_unlink_buffer(struct journal_head *jh);
>  
> @@ -49,6 +50,7 @@ get_transaction(journal_t *journal, tran
>  {
>  	transaction->t_journal = journal;
>  	transaction->t_state = T_RUNNING;
> +	transaction->t_start_time = jiffies;
>  	transaction->t_tid = journal->j_transaction_sequence++;
>  	transaction->t_expires = jiffies + journal->j_commit_interval;
>  	spin_lock_init(&transaction->t_handle_lock);
> @@ -63,6 +65,32 @@ get_transaction(journal_t *journal, tran
>  	return transaction;
>  }
>  
> +static void precision_sleep(unsigned long time)
> +{
> +	struct hrtimer_sleeper t;
> +
> +	hrtimer_init_on_stack(&t.timer, CLOCK_REALTIME, HRTIMER_MODE_ABS);
> +	hrtimer_init_sleeper(&t, current);
> +	t.timer.expires = ktime_add_ns(ktime_get_real(), time);
> +
> +	do {
> +		set_current_state(TASK_UNINTERRUPTIBLE);
> +
> +		hrtimer_start(&t.timer, t.timer.expires, HRTIMER_MODE_ABS);
> +		if (!hrtimer_active(&t.timer))
> +			t.task = NULL;
> +
> +		if (likely(t.task))
> +			schedule();
> +
> +		hrtimer_cancel(&t.timer);
> +	} while (t.task);
> +
> +	set_current_state(TASK_RUNNING);
> +
> +	destroy_hrtimer_on_stack(&t.timer);
> +}
> +
>  /*
>   * Handle management.
>   *
> @@ -1361,7 +1389,7 @@ int journal_stop(handle_t *handle)
>  {
>  	transaction_t *transaction = handle->h_transaction;
>  	journal_t *journal = transaction->t_journal;
> -	int old_handle_count, err;
> +	int err;
>  	pid_t pid;
>  
>  	J_ASSERT(journal_current_handle() == handle);
> @@ -1397,11 +1425,31 @@ int journal_stop(handle_t *handle)
>  	 */
>  	pid = current->pid;
>  	if (handle->h_sync && journal->j_last_sync_writer != pid) {
> +		unsigned long commit_time;
> +		int print_count;
> +		unsigned long sleep_time;
> +
>  		journal->j_last_sync_writer = pid;
> -		do {
> -			old_handle_count = transaction->t_handle_count;
> -			schedule_timeout_uninterruptible(1);
> -		} while (old_handle_count != transaction->t_handle_count);
> +
> +		spin_lock(&journal->j_state_lock);
> +		commit_time = journal->j_average_commit_time;
> +		spin_unlock(&journal->j_state_lock);
> +
> +		sleep_time = elapsed_jiffies(transaction->t_start_time, jiffies);
> +		if (!sleep_time)
> +			sleep_time = 1;
> +		sleep_time = (commit_time / sleep_time) * commit_time;
> +
> +		/*
> +		if (print_count >= 100 && print_count < 200) {
> +			journal->print_count++;
> +			printk(KERN_ERR "sleep_time=%lu\n", (unsigned long)sleep_time);
> +		}
> +
> +		sleep_time = (long)(commit_time - sleep_time);
> +		*/
> +
> +		precision_sleep((unsigned long)sleep_time);
>  	}
>  
>  	current->journal_info = NULL;
> Index: linux-2.6/include/linux/jbd.h
> ===================================================================
> --- linux-2.6.orig/include/linux/jbd.h
> +++ linux-2.6/include/linux/jbd.h
> @@ -31,6 +31,7 @@
>  #include <linux/mutex.h>
>  #include <linux/timer.h>
>  #include <linux/lockdep.h>
> +#include <linux/jiffies.h>
>  
>  #define journal_oom_retry 1
>  
> @@ -79,6 +80,15 @@ static inline void jbd_free(void *ptr, s
>  	free_pages((unsigned long)ptr, get_order(size));
>  };
>  
> +static inline unsigned long elapsed_jiffies(unsigned long start,
> +					    unsigned long end)
> +{
> +	if (end >= start)
> +		return end - start;
> +
> +	return end + (MAX_JIFFY_OFFSET - start) + 1;
> +}
> +
>  #define JFS_MIN_JOURNAL_BLOCKS 1024
>  
>  
> @@ -543,6 +553,11 @@ struct transaction_s
>  	unsigned long		t_expires;
>  
>  	/*
> +	 * When this transaction started, in jiffies [no locking]
> +	 */
> +	unsigned long		t_start_time;
> +
> +	/*
>  	 * How many handles used this transaction? [t_handle_lock]
>  	 */
>  	int t_handle_count;
> @@ -800,6 +815,10 @@ struct journal_s
>  
>  	pid_t			j_last_sync_writer;
>  
> +	unsigned long		j_average_commit_time;
> +
> +	int print_count;
> +
>  	/*
>  	 * An opaque pointer to fs-private information.  ext3 puts its
>  	 * superblock pointer here
> Index: linux-2.6/kernel/hrtimer.c
> ===================================================================
> --- linux-2.6.orig/kernel/hrtimer.c
> +++ linux-2.6/kernel/hrtimer.c
> @@ -1458,6 +1458,7 @@ void hrtimer_init_sleeper(struct hrtimer
>  	sl->timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
>  #endif
>  }
> +EXPORT_SYMBOL_GPL(hrtimer_init_sleeper);
>  
>  static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mode)
>  {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

