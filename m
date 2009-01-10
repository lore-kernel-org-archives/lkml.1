Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbZAJWcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbZAJWcB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:32:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbZAJWbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:31:53 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59524 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556AbZAJWbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:31:52 -0500
Date: Sat, 10 Jan 2009 14:31:52 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: convert rcupreempt trace to seq file
Message-ID: <20090110223151.GD7061@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <496852DE.7080802@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496852DE.7080802@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2009 at 03:48:46PM +0800, Li Zefan wrote:
> Impact: also fix a bug in show_rcustats()
> 
> Use seq file for simplification, and the global buffer and mutex can be
> removed.

Looks very good, and passes my tests.

> While doing this, I found rcustats will never show 'ggp' and 'rcc' fields
> due to a bug in show_rcustats().

Good eyes!

The only change I ask is that you pull the contents of
rcupreempt_debugfs_init() into the now-one-line rcupreempt_trace_init().

With that change:

Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/rcupreempt_trace.c |  155 ++++++++++++++++++++-------------------------
>  1 files changed, 69 insertions(+), 86 deletions(-)
> 
> diff --git a/kernel/rcupreempt_trace.c b/kernel/rcupreempt_trace.c
> index 7c2665c..a0c8297 100644
> --- a/kernel/rcupreempt_trace.c
> +++ b/kernel/rcupreempt_trace.c
> @@ -39,13 +39,9 @@
>  #include <linux/percpu.h>
>  #include <linux/notifier.h>
>  #include <linux/cpu.h>
> -#include <linux/mutex.h>
>  #include <linux/rcupreempt_trace.h>
>  #include <linux/debugfs.h>
> -
> -static struct mutex rcupreempt_trace_mutex;
> -static char *rcupreempt_trace_buf;
> -#define RCUPREEMPT_TRACE_BUF_SIZE 4096
> +#include <linux/seq_file.h>
> 
>  void rcupreempt_trace_move2done(struct rcupreempt_trace *trace)
>  {
> @@ -170,110 +166,107 @@ static void rcupreempt_trace_sum(struct rcupreempt_trace *sp)
>  	}
>  }
> 
> -static ssize_t rcustats_read(struct file *filp, char __user *buffer,
> -				size_t count, loff_t *ppos)
> +static ssize_t show_rcustats(struct seq_file *m, void *unused)
>  {
>  	struct rcupreempt_trace trace;
> -	ssize_t bcount;
> -	int cnt = 0;
> 
>  	rcupreempt_trace_sum(&trace);
> -	mutex_lock(&rcupreempt_trace_mutex);
> -	snprintf(&rcupreempt_trace_buf[cnt], RCUPREEMPT_TRACE_BUF_SIZE - cnt,
> -		 "ggp=%ld rcc=%ld\n",
> -		 rcu_batches_completed(),
> -		 trace.rcu_check_callbacks);
> -	snprintf(&rcupreempt_trace_buf[cnt], RCUPREEMPT_TRACE_BUF_SIZE - cnt,
> -		 "na=%ld nl=%ld wa=%ld wl=%ld da=%ld dl=%ld dr=%ld di=%d\n"
> -		 "1=%d e1=%d i1=%ld ie1=%ld g1=%ld a1=%ld ae1=%ld a2=%ld\n"
> -		 "z1=%ld ze1=%ld z2=%ld m1=%ld me1=%ld m2=%ld\n",
> 
> -		 trace.next_add, trace.next_length,
> -		 trace.wait_add, trace.wait_length,
> -		 trace.done_add, trace.done_length,
> -		 trace.done_remove, atomic_read(&trace.done_invoked),
> -		 atomic_read(&trace.rcu_try_flip_1),
> -		 atomic_read(&trace.rcu_try_flip_e1),
> -		 trace.rcu_try_flip_i1, trace.rcu_try_flip_ie1,
> -		 trace.rcu_try_flip_g1,
> -		 trace.rcu_try_flip_a1, trace.rcu_try_flip_ae1,
> +	seq_printf(m, "ggp=%ld rcc=%ld\n",
> +		   rcu_batches_completed(),
> +		   trace.rcu_check_callbacks);
> +
> +	seq_printf(m, "na=%ld nl=%ld wa=%ld wl=%ld da=%ld dl=%ld dr=%ld di=%d\n"
> +		      "1=%d e1=%d i1=%ld ie1=%ld g1=%ld a1=%ld ae1=%ld a2=%ld\n"
> +		      "z1=%ld ze1=%ld z2=%ld m1=%ld me1=%ld m2=%ld\n",
> +		   trace.next_add, trace.next_length,
> +		   trace.wait_add, trace.wait_length,
> +		   trace.done_add, trace.done_length,
> +		   trace.done_remove, atomic_read(&trace.done_invoked),
> +		   atomic_read(&trace.rcu_try_flip_1),
> +		   atomic_read(&trace.rcu_try_flip_e1),
> +		   trace.rcu_try_flip_i1, trace.rcu_try_flip_ie1,
> +		   trace.rcu_try_flip_g1,
> +		   trace.rcu_try_flip_a1, trace.rcu_try_flip_ae1,
>  			 trace.rcu_try_flip_a2,
> -		 trace.rcu_try_flip_z1, trace.rcu_try_flip_ze1,
> +		   trace.rcu_try_flip_z1, trace.rcu_try_flip_ze1,
>  			 trace.rcu_try_flip_z2,
> -		 trace.rcu_try_flip_m1, trace.rcu_try_flip_me1,
> -			trace.rcu_try_flip_m2);
> -	bcount = simple_read_from_buffer(buffer, count, ppos,
> -			rcupreempt_trace_buf, strlen(rcupreempt_trace_buf));
> -	mutex_unlock(&rcupreempt_trace_mutex);
> -	return bcount;
> +		   trace.rcu_try_flip_m1, trace.rcu_try_flip_me1,
> +			 trace.rcu_try_flip_m2);
> +
> +	return 0;
> +}
> +
> +static int rcustats_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, show_rcustats, NULL);
>  }
> 
> -static ssize_t rcugp_read(struct file *filp, char __user *buffer,
> -				size_t count, loff_t *ppos)
> +static ssize_t show_rcugp(struct seq_file *m, void *unused)
>  {
>  	long oldgp = rcu_batches_completed();
> -	ssize_t bcount;
> 
> -	mutex_lock(&rcupreempt_trace_mutex);
>  	synchronize_rcu();
> -	snprintf(rcupreempt_trace_buf, RCUPREEMPT_TRACE_BUF_SIZE,
> -		"oldggp=%ld  newggp=%ld\n", oldgp, rcu_batches_completed());
> -	bcount = simple_read_from_buffer(buffer, count, ppos,
> -			rcupreempt_trace_buf, strlen(rcupreempt_trace_buf));
> -	mutex_unlock(&rcupreempt_trace_mutex);
> -	return bcount;
> +	seq_printf(m, "oldggp=%ld  newggp=%ld\n",
> +		   oldgp, rcu_batches_completed());
> +
> +	return 0;
>  }
> 
> -static ssize_t rcuctrs_read(struct file *filp, char __user *buffer,
> -				size_t count, loff_t *ppos)
> +static int rcugp_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, show_rcugp, NULL);
> +}
> +
> +static ssize_t show_rcuctrs(struct seq_file *m, void *unused)
>  {
> -	int cnt = 0;
>  	int cpu;
>  	int f = rcu_batches_completed() & 0x1;
> -	ssize_t bcount;
> -
> -	mutex_lock(&rcupreempt_trace_mutex);
> 
> -	cnt += snprintf(&rcupreempt_trace_buf[cnt], RCUPREEMPT_TRACE_BUF_SIZE,
> -				"CPU last cur F M\n");
> +	seq_puts(m, "CPU last cur F M\n");
>  	for_each_online_cpu(cpu) {
>  		long *flipctr = rcupreempt_flipctr(cpu);
> -		cnt += snprintf(&rcupreempt_trace_buf[cnt],
> -				RCUPREEMPT_TRACE_BUF_SIZE - cnt,
> -					"%3d %4ld %3ld %d %d\n",
> -			       cpu,
> -			       flipctr[!f],
> -			       flipctr[f],
> -			       rcupreempt_flip_flag(cpu),
> -			       rcupreempt_mb_flag(cpu));
> +		seq_printf(m, "%3d %4ld %3ld %d %d\n",
> +			   cpu,
> +			   flipctr[!f],
> +			   flipctr[f],
> +			   rcupreempt_flip_flag(cpu),
> +			   rcupreempt_mb_flag(cpu));
>  	}
> -	cnt += snprintf(&rcupreempt_trace_buf[cnt],
> -			RCUPREEMPT_TRACE_BUF_SIZE - cnt,
> -			"ggp = %ld, state = %s\n",
> -			rcu_batches_completed(),
> -			rcupreempt_try_flip_state_name());
> -	cnt += snprintf(&rcupreempt_trace_buf[cnt],
> -			RCUPREEMPT_TRACE_BUF_SIZE - cnt,
> -			"\n");
> -	bcount = simple_read_from_buffer(buffer, count, ppos,
> -			rcupreempt_trace_buf, strlen(rcupreempt_trace_buf));
> -	mutex_unlock(&rcupreempt_trace_mutex);
> -	return bcount;
> +	seq_printf(m, "ggp = %ld, state = %s\n",
> +		   rcu_batches_completed(),
> +		   rcupreempt_try_flip_state_name());
> +
> +	return 0;
> +}
> +
> +static int rcuctrs_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, show_rcuctrs, NULL);
>  }
> 
>  static struct file_operations rcustats_fops = {
>  	.owner = THIS_MODULE,
> -	.read = rcustats_read,
> +	.open = rcustats_open,
> +	.read = seq_read,
> +	.llseek = seq_lseek,
> +	.release = single_release,
>  };
> 
>  static struct file_operations rcugp_fops = {
>  	.owner = THIS_MODULE,
> -	.read = rcugp_read,
> +	.open = rcugp_open,
> +	.read = seq_read,
> +	.llseek = seq_lseek,
> +	.release = single_release,
>  };
> 
>  static struct file_operations rcuctrs_fops = {
>  	.owner = THIS_MODULE,
> -	.read = rcuctrs_read,
> +	.open = rcuctrs_open,
> +	.read = seq_read,
> +	.llseek = seq_lseek,
> +	.release = single_release,
>  };
> 
>  static struct dentry *rcudir, *statdir, *ctrsdir, *gpdir;
> @@ -308,16 +301,7 @@ out:
> 
>  static int __init rcupreempt_trace_init(void)
>  {
> -	int ret;
> -
> -	mutex_init(&rcupreempt_trace_mutex);
> -	rcupreempt_trace_buf = kmalloc(RCUPREEMPT_TRACE_BUF_SIZE, GFP_KERNEL);
> -	if (!rcupreempt_trace_buf)
> -		return 1;
> -	ret = rcupreempt_debugfs_init();
> -	if (ret)
> -		kfree(rcupreempt_trace_buf);
> -	return ret;
> +	return rcupreempt_debugfs_init();
>  }
> 
>  static void __exit rcupreempt_trace_cleanup(void)
> @@ -326,7 +310,6 @@ static void __exit rcupreempt_trace_cleanup(void)
>  	debugfs_remove(gpdir);
>  	debugfs_remove(ctrsdir);
>  	debugfs_remove(rcudir);
> -	kfree(rcupreempt_trace_buf);
>  }
> 
> 
> -- 
> 1.5.4.rc3
> 
