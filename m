Return-Path: <linux-kernel-owner+w=401wt.eu-S1753074AbYJ0Vum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbYJ0Vum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 17:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbYJ0Vue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 17:50:34 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48730 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbYJ0Vud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 17:50:33 -0400
Date: Mon, 27 Oct 2008 14:50:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rjw@sisk.pl,
       dipankar@in.ibm.com, tglx@linuxtronix.de, andi@firstfloor.org
Subject: Re: [PATCH] v3 rudimentary tracing for Classic RCU
Message-ID: <20081027215029.GA31664@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081007152629.GH6384@linux.vnet.ibm.com> <20081007154939.GN20740@one.firstfloor.org> <20081007163401.GJ6384@linux.vnet.ibm.com> <20081007210947.GP20740@one.firstfloor.org> <20081007212215.GN6384@linux.vnet.ibm.com> <20081009010846.GA10188@linux.vnet.ibm.com> <20081010034421.GA12449@linux.vnet.ibm.com> <20081013230914.GA27467@linux.vnet.ibm.com> <49005C09.6010805@cn.fujitsu.com> <20081026215930.GC6236@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081026215930.GC6236@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2008 at 02:59:30PM -0700, Paul E. McKenney wrote:
> On Thu, Oct 23, 2008 at 07:12:09PM +0800, Lai Jiangshan wrote:
> > 
> > trivial ported it to seq_file.
> > seq_file are very good for the output buffer.
> 
> Thank you for putting this together!!!  Looks good at first glance --
> I will test it out.

So it does seem to operate correctly.  I combined it with my patch and
applied against 2.6.27 for ease of testing.

One question -- why the multi-line format?  This would be a bit
awkward on a 128-CPU system, let alone on a 4,096-CPU system.
Or am I missing some trick here?

> 							Thanx, Paul
> 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > ---
> > diff --git a/kernel/rcuclassic_trace.c b/kernel/rcuclassic_trace.c
> > index d19780b..f19217c
> > --- a/kernel/rcuclassic_trace.c
> > +++ b/kernel/rcuclassic_trace.c
> > @@ -23,157 +23,167 @@
> >   * 		Documentation/RCU
> >   *
> >   */
> > -#include <linux/types.h>
> > -#include <linux/kernel.h>
> > -#include <linux/init.h>
> > -#include <linux/spinlock.h>
> > -#include <linux/smp.h>
> >  #include <linux/rcupdate.h>
> > -#include <linux/interrupt.h>
> > -#include <linux/sched.h>
> > -#include <asm/atomic.h>
> > -#include <linux/bitops.h>
> >  #include <linux/module.h>
> > -#include <linux/completion.h>
> > -#include <linux/moduleparam.h>
> > -#include <linux/percpu.h>
> > -#include <linux/notifier.h>
> > -#include <linux/cpu.h>
> > -#include <linux/mutex.h>
> >  #include <linux/debugfs.h>
> > +#include <linux/seq_file.h>
> > 
> > -static DEFINE_MUTEX(rcuclassic_trace_mutex);
> > -static char *rcuclassic_trace_buf;
> > -#define RCUCLASSIC_TRACE_BUF_SIZE (128 * num_possible_cpus() + 100)
> > +static struct rcu_data *get_rcu_data_bh(int cpu)
> > +{
> > +	return &per_cpu(rcu_bh_data, cpu);
> > +}
> > 
> > -static int print_one_rcu_data(struct rcu_data *rdp, char *buf, char *ebuf)
> > +static struct rcu_data *get_rcu_data(int cpu)
> >  {
> > -	int cnt = 0;
> > +	return &per_cpu(rcu_data, cpu);
> > +}
> > 
> > +static int show_rcu_data(struct seq_file *m, void *v)
> > +{
> > +	struct rcu_data *rdp = v;
> >  	if (!rdp->beenonline)
> >  		return 0;
> > -	cnt += snprintf(&buf[cnt], ebuf - &buf[cnt],
> > -		"%3d%cqb=%ld b=%ld pq=%d qsp=%d ql=%ld bl=%ld\n",
> > -		rdp->cpu, cpu_is_offline(rdp->cpu) ? '!' : ' ',
> > -		rdp->quiescbatch, rdp->batch, rdp->passed_quiesc,
> > -		rdp->qs_pending, rdp->qlen, rdp->blimit);
> > -	return cnt;
> > +
> > +	seq_printf(m, "processor\t: %d", rdp->cpu);
> > +	if (cpu_is_offline(rdp->cpu))
> > +		seq_puts(m, "!\n");
> > +	else
> > +		seq_puts(m, "\n");
> > +	seq_printf(m, "quiescbatch\t: %ld\n", rdp->quiescbatch);
> > +	seq_printf(m, "batch\t: %ld\n", rdp->batch);
> > +	seq_printf(m, "passed_quiesc\t: %d\n", rdp->passed_quiesc);
> > +	seq_printf(m, "qs_pending\t: %d\n", rdp->qs_pending);
> > +	seq_printf(m, "qlen\t: %ld\n", rdp->qlen);
> > +	seq_printf(m, "blimit\t: %ld\n", rdp->blimit);
> > +	seq_puts(m, "\n\n");
> > +	return 0;
> >  }
> > 
> > -#define PRINT_RCU_DATA(name, buf, ebuf) \
> > -	do { \
> > -		int _p_r_d_i; \
> > -		\
> > -		for_each_possible_cpu(_p_r_d_i) \
> > -			(buf) += print_one_rcu_data(&per_cpu(name, _p_r_d_i), \
> > -						    buf, ebuf); \
> > -	} while (0)
> > -
> > -static ssize_t rcudata_read(struct file *filp, char __user *buffer,
> > -				size_t count, loff_t *ppos)
> > +static void *c_start(struct seq_file *m, loff_t *pos)
> >  {
> > -	ssize_t bcount;
> > -	char *buf = rcuclassic_trace_buf;
> > -	char *ebuf = &rcuclassic_trace_buf[RCUCLASSIC_TRACE_BUF_SIZE];
> > -
> > -	mutex_lock(&rcuclassic_trace_mutex);
> > -	buf += snprintf(buf, ebuf - buf, "rcu:\n");
> > -	PRINT_RCU_DATA(rcu_data, buf, ebuf);
> > -	buf += snprintf(buf, ebuf - buf, "rcu_bh:\n");
> > -	PRINT_RCU_DATA(rcu_bh_data, buf, ebuf);
> > -	bcount = simple_read_from_buffer(buffer, count, ppos,
> > -			rcuclassic_trace_buf, strlen(rcuclassic_trace_buf));
> > -	mutex_unlock(&rcuclassic_trace_mutex);
> > -	return bcount;
> > +	typedef struct rcu_data *(*get_data_func)(int);
> > +
> > +	if (*pos == 0)	/* just in case, cpu 0 is not the first */
> > +		*pos = first_cpu(cpu_possible_map);
> > +	else
> > +		*pos = next_cpu_nr(*pos - 1, cpu_possible_map);
> > +	if ((*pos) < nr_cpu_ids)
> > +		return ((get_data_func)m->private)(*pos);
> > +	return NULL;
> >  }
> > 
> > -static int print_one_rcu_ctrlblk(struct rcu_ctrlblk *rcp, char *buf, char *ebuf)
> > +static void *c_next(struct seq_file *m, void *v, loff_t *pos)
> >  {
> > -	int cnt = 0;
> > -
> > -	cnt += snprintf(&buf[cnt], ebuf - &buf[cnt], "cur=%ld  completed=%ld  "
> > -			"pending=%ld  s=%d\n\t",
> > -			rcp->cur, rcp->completed,
> > -			rcp->pending, rcp->signaled);
> > -	cnt += cpulist_scnprintf(&buf[cnt], ebuf - &buf[cnt], rcp->cpumask);
> > -	cnt += snprintf(&buf[cnt], ebuf - &buf[cnt], "\n");
> > -	return cnt;
> > +	(*pos)++;
> > +	return c_start(m, pos);
> >  }
> > 
> > -static ssize_t rcucb_read(struct file *filp, char __user *buffer,
> > -				size_t count, loff_t *ppos)
> > +static void c_stop(struct seq_file *m, void *v)
> >  {
> > -	ssize_t bcount;
> > -	char *buf = rcuclassic_trace_buf;
> > -	char *ebuf = &rcuclassic_trace_buf[RCUCLASSIC_TRACE_BUF_SIZE];
> > -
> > -	mutex_lock(&rcuclassic_trace_mutex);
> > -	buf += snprintf(buf, ebuf - buf, "rcu: ");
> > -	buf += print_one_rcu_ctrlblk(&rcu_ctrlblk, buf, ebuf);
> > -	buf += snprintf(buf, ebuf - buf, "rcu_bh: ");
> > -	buf += print_one_rcu_ctrlblk(&rcu_bh_ctrlblk, buf, ebuf);
> > -	buf += snprintf(buf, ebuf - buf, "online: ");
> > -	buf += cpulist_scnprintf(buf, ebuf - buf, cpu_online_map);
> > -	buf += snprintf(buf, ebuf - buf, "\n");
> > -	bcount = simple_read_from_buffer(buffer, count, ppos,
> > -			rcuclassic_trace_buf, strlen(rcuclassic_trace_buf));
> > -	mutex_unlock(&rcuclassic_trace_mutex);
> > -	return bcount;
> >  }
> > 
> > -static struct file_operations rcudata_fops = {
> > -	.owner = THIS_MODULE,
> > -	.read = rcudata_read,
> > +const struct seq_operations rcu_data_seq_op = {
> > +	.start	= c_start,
> > +	.next	= c_next,
> > +	.stop	= c_stop,
> > +	.show	= show_rcu_data,
> >  };
> > 
> > +static int rcu_data_open(struct inode *inode, struct file *file)
> > +{
> > +	int ret = seq_open(file, &rcu_data_seq_op);
> > +	if (ret)
> > +		return ret;
> > +	((struct seq_file *)file->private_data)->private = inode->i_private;
> > +	return 0;
> > +}
> > +
> > +static const struct file_operations rcu_data_fops = {
> > +	.owner		= THIS_MODULE,
> > +	.open		= rcu_data_open,
> > +	.read		= seq_read,
> > +	.llseek		= seq_lseek,
> > +	.release	= seq_release,
> > +};
> > +
> > +static void print_one_rcu_ctrlblk(struct seq_file *m, struct rcu_ctrlblk *rcp)
> > +{
> > +	seq_printf(m, "cur=%ld  completed=%ld   pending=%ld  s=%d\n\t",
> > +			rcp->cur, rcp->completed, rcp->pending, rcp->signaled);
> > +	seq_cpumask(m, &rcp->cpumask);
> > +	seq_puts(m, "\n");
> > +}
> > +
> > +static int show_rcucb(struct seq_file *m, void *unused)
> > +{
> > +	seq_puts(m, "rcu: ");
> > +	print_one_rcu_ctrlblk(m, &rcu_ctrlblk);
> > +	seq_puts(m, "rcu_bh: ");
> > +	print_one_rcu_ctrlblk(m, &rcu_bh_ctrlblk);
> > +	seq_puts(m, "online: ");
> > +	seq_cpumask(m, &cpu_online_map);
> > +	seq_puts(m, "\n");
> > +	return 0;
> > +}
> > +
> > +static int rcucb_open(struct inode *inode, struct file *file)
> > +{
> > +	return single_open(file, show_rcucb, NULL);
> > +}
> > +
> >  static struct file_operations rcucb_fops = {
> > -	.owner = THIS_MODULE,
> > -	.read = rcucb_read,
> > +	.owner		= THIS_MODULE,
> > +	.open		= rcucb_open,
> > +	.read		= seq_read,
> > +	.llseek		= seq_lseek,
> > +	.release	= single_release,
> >  };
> > 
> > -static struct dentry *rcudir, *datadir, *cbdir;
> > -static int rcuclassic_debugfs_init(void)
> > +static struct dentry *rcudir, *rcu_bh_data_file, *rcu_data_file, *rcucb_file;
> > +
> > +static int __init rcuclassic_trace_init(void)
> >  {
> >  	rcudir = debugfs_create_dir("rcu", NULL);
> >  	if (!rcudir)
> >  		goto out;
> > -	datadir = debugfs_create_file("rcudata", 0444, rcudir,
> > -				      NULL, &rcudata_fops);
> > -	if (!datadir)
> > -		goto free_out;
> > -	cbdir = debugfs_create_file("rcucb", 0444, rcudir, NULL, &rcucb_fops);
> > -	if (!cbdir)
> > -		goto free_out;
> > +
> > +	rcu_bh_data_file = debugfs_create_file("rcu_bh_data", 0444, rcudir,
> > +			get_rcu_data_bh, &rcu_data_fops);
> > +	if (!rcu_bh_data_file)
> > +		goto out_rcudir;
> > +
> > +	rcu_data_file = debugfs_create_file("rcu_data", 0444, rcudir,
> > +			get_rcu_data, &rcu_data_fops);
> > +	if (!rcu_data_file)
> > +		goto out_rcudata_bh_file;
> > +
> > +	rcucb_file = debugfs_create_file("rcucb", 0444, rcudir,
> > +			NULL, &rcucb_fops);
> > +	if (!rcucb_file)
> > +		goto out_rcudata_file;
> >  	return 0;
> > -free_out:
> > -	if (datadir)
> > -		debugfs_remove(datadir);
> > +
> > +out_rcudata_file:
> > +	debugfs_remove(rcu_data_file);
> > +out_rcudata_bh_file:
> > +	debugfs_remove(rcu_bh_data_file);
> > +out_rcudir:
> >  	debugfs_remove(rcudir);
> >  out:
> >  	return 1;
> >  }
> > 
> > -static int __init rcuclassic_trace_init(void)
> > -{
> > -	int ret;
> > -
> > -	rcuclassic_trace_buf = kmalloc(RCUCLASSIC_TRACE_BUF_SIZE, GFP_KERNEL);
> > -	if (!rcuclassic_trace_buf)
> > -		return 1;
> > -	ret = rcuclassic_debugfs_init();
> > -	if (ret)
> > -		kfree(rcuclassic_trace_buf);
> > -	return ret;
> > -}
> > -
> >  static void __exit rcuclassic_trace_cleanup(void)
> >  {
> > -	debugfs_remove(datadir);
> > -	debugfs_remove(cbdir);
> > +	debugfs_remove(rcucb_file);
> > +	debugfs_remove(rcu_data_file);
> > +	debugfs_remove(rcu_bh_data_file);
> >  	debugfs_remove(rcudir);
> > -	kfree(rcuclassic_trace_buf);
> >  }
> > 
> > -
> >  module_init(rcuclassic_trace_init);
> >  module_exit(rcuclassic_trace_cleanup);
> > +
> > +MODULE_AUTHOR("Paul E. McKenney");
> > +MODULE_DESCRIPTION("Read-Copy Update tracing for classic implementation");
> > +MODULE_LICENSE("GPL");
> > 
