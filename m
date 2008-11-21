Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbYKUAMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbYKUAMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 19:12:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbYKUAL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 19:11:57 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:4985 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbYKUAL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 19:11:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=u3ah60wphqM/EvudkxsIQtvS8mCDsM0TXnGxIujhEJRicqpGtbuD81bSGQcVOQsgPu
         IaXUwBB2E2LQKX9CPGlonvJUBy0zeeZAkC48P3OtGgWpEp1Hc7S3ivF7xK61bujCGAXn
         Ervkd0pZIpve2rt2fUsabHJb7IHEi6Ml3V4Ws=
Date: Fri, 21 Nov 2008 03:15:39 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 11/45] FS-Cache: Add use of /proc and presentation of
	statistics [ver #41]
Message-ID: <20081121001539.GA5889@x200.localdomain>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk> <20081120144236.10667.83390.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120144236.10667.83390.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 02:42:36PM +0000, David Howells wrote:
> Make FS-Cache create its /proc interface and present various statistical
> information through it.  Also provide the functions for updating this
> information.
> 
> These features are enabled by:
> 
> 	CONFIG_FSCACHE_PROC
> 	CONFIG_FSCACHE_STATS
> 	CONFIG_FSCACHE_HISTOGRAM

I'd say, if one enabled PROC_FS and this fscache stuff, one should get files
in /proc. More, if one enables "gather statistics" (if it's performance-
or space- sensitive), one also gets fs/fscache/stats et al.

config option per proc file is way too much.

> The /proc directory for FS-Cache is also exported so that caching modules can
> add their own statistics there too.

No need, see below.

> The FS-Cache module is loadable at this point, and the statistics files can be
> examined by userspace:
> 
> 	cat /proc/fs/fscache/stats
> 	cat /proc/fs/fscache/histogram


> --- /dev/null
> +++ b/fs/fscache/fsc-proc.c
> @@ -0,0 +1,370 @@
> +struct fscache_proc {
> +	unsigned			nlines;
> +	const struct seq_operations	*ops;
> +};
> +
> +struct proc_dir_entry *proc_fscache;
> +EXPORT_SYMBOL(proc_fscache);

Export isn't needed because other modules can just create by path their proc
files and it will work as expected:

	pde = proc_create("fs/fscache/xxx",...)

> +#if defined(CONFIG_FSCACHE_STATS) || defined(CONFIG_FSCACHE_HISTOGRAM)
> +static int fscache_proc_open(struct inode *inode, struct file *file);
> +static void *fscache_proc_start(struct seq_file *m, loff_t *pos);
> +static void fscache_proc_stop(struct seq_file *m, void *v);
> +static void *fscache_proc_next(struct seq_file *m, void *v, loff_t *pos);
> +
> +static const struct file_operations fscache_proc_fops = {
> +	.open		= fscache_proc_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= seq_release,
> +};
> +#endif
> +
> +#ifdef CONFIG_FSCACHE_STATS
> +static int fscache_stats_show(struct seq_file *m, void *v);
> +
> +static const struct seq_operations fscache_stats_ops = {
> +	.start		= fscache_proc_start,
> +	.stop		= fscache_proc_stop,
> +	.next		= fscache_proc_next,
> +	.show		= fscache_stats_show,
> +};
> +
> +static const struct fscache_proc fscache_stats = {
> +	.nlines		= 17,
> +	.ops		= &fscache_stats_ops,
> +};
> +#endif
> +
> +#ifdef CONFIG_FSCACHE_HISTOGRAM
> +static int fscache_histogram_show(struct seq_file *m, void *v);
> +
> +static const struct seq_operations fscache_histogram_ops = {
> +	.start		= fscache_proc_start,
> +	.stop		= fscache_proc_stop,
> +	.next		= fscache_proc_next,
> +	.show		= fscache_histogram_show,
> +};
> +
> +static const struct fscache_proc fscache_histogram = {
> +	.nlines		= HZ + 1,
> +	.ops		= &fscache_histogram_ops,
> +};
> +#endif
> +
> +#define FSC_DESC(SELECT, N) ((void *) (unsigned long) (((SELECT) << 16) | (N)))
> +
> +/*
> + * initialise the /proc/fs/fscache/ directory
> + */
> +int __init fscache_proc_init(void)
> +{
> +#if defined(CONFIG_FSCACHE_STATS) || defined(CONFIG_FSCACHE_HISTOGRAM)
> +	struct proc_dir_entry *p;
> +#endif
> +
> +	_enter("");
> +
> +	proc_fscache = proc_mkdir("fs/fscache", NULL);
> +	if (!proc_fscache)
> +		goto error_dir;
> +	proc_fscache->owner = THIS_MODULE;

->owner settings is not needed nowadays.

> +#ifdef CONFIG_FSCACHE_STATS
> +	p = create_proc_entry("stats", 0, proc_fscache);
> +	if (!p)
> +		goto error_stats;
> +	p->proc_fops = &fscache_proc_fops;
> +	p->owner = THIS_MODULE;
> +	p->data = (void *) &fscache_stats;
> +#endif

a) set .owner in ->proc_fops instead
b) use (in your case) proc_create_data()

> +
> +#ifdef CONFIG_FSCACHE_HISTOGRAM
> +	p = create_proc_entry("histogram", 0, proc_fscache);
> +	if (!p)
> +		goto error_histogram;
> +	p->proc_fops = &fscache_proc_fops;
> +	p->owner = THIS_MODULE;
> +	p->data = (void *) &fscache_histogram;
> +#endif

ditto

> +#if defined(CONFIG_FSCACHE_STATS) || defined(CONFIG_FSCACHE_HISTOGRAM)
> +/*
> + * open "/proc/fs/fscache/XXX" which provide statistics summaries
> + */
> +static int fscache_proc_open(struct inode *inode, struct file *file)
> +{
> +	const struct fscache_proc *proc = PDE(inode)->data;
> +	struct seq_file *m;
> +	int ret;
> +
> +	ret = seq_open(file, proc->ops);
> +	if (ret == 0) {
> +		m = file->private_data;
> +		m->private = (void *) proc;
> +	}
> +	return ret;
> +}
> +
> +/*
> + * set up the iterator to start reading from the first line
> + */
> +static void *fscache_proc_start(struct seq_file *m, loff_t *_pos)
> +{
> +	if (*_pos == 0)
> +		*_pos = 1;
> +	return (void *)(unsigned long) *_pos;
> +}
> +
> +/*
> + * move to the next line
> + */
> +static void *fscache_proc_next(struct seq_file *m, void *v, loff_t *pos)
> +{
> +	const struct fscache_proc *proc = m->private;
> +
> +	(*pos)++;
> +	return *pos > proc->nlines ? NULL : (void *)(unsigned long) *pos;
> +}
> +
> +/*
> + * clean up after reading
> + */
> +static void fscache_proc_stop(struct seq_file *m, void *v)
> +{
> +}
> +#endif
> +
> +#ifdef CONFIG_FSCACHE_STATS
> +/*
> + * display the general statistics
> + */
> +static int fscache_stats_show(struct seq_file *m, void *v)
> +{
> +	unsigned long line = (unsigned long) v;
> +
> +	switch (line) {
> +	case 1:
> +		seq_puts(m, "FS-Cache statistics\n");
> +		break;
> +
> +	case 2:
> +		seq_printf(m, "Cookies: idx=%u dat=%u spc=%u\n",
> +			   atomic_read(&fscache_n_cookie_index),
> +			   atomic_read(&fscache_n_cookie_data),
> +			   atomic_read(&fscache_n_cookie_special));
> +		break;

This is overly complex for unclear need. Just set_printf() all these lines
and drop iterator business. Use single_open()! Ditto for histo stuff.

> +	case 3:
> +	case 4:
> +	case 5:
> +	case 6:
> +	case 7:
> +	case 8:
> +	case 9:
> +	case 10:
> +	case 11:
> +	case 12:
> +	case 13:
> +	case 14:
> +	case 15:
> +	case 16:
> +	case 17:
> +	case 18:

> +	return 0;
> +}
> +
> +#endif /* end CONFIG_FSCACHE_STATS */
> +
> +#ifdef CONFIG_FSCACHE_HISTOGRAM
	...
