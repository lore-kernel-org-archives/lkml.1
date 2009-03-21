Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbZCUCm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbZCUCm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 22:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbZCUCmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 22:42:18 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:56275 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbZCUCmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 22:42:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ifGnVa8lQ8IsO3hGnYqCRci76zyFEkKzDj9Qs0NTfYbimJ4rq6Gk+/az4g4HCpKROi
         fv8hpkshrk9yYLY703m+xlxzNzrgjVjusdsMxjfEJtIq0UbRfovEHuY4ok/aAIvqiz2e
         Lr9bJT67qNRWGrlnGqt63Yeb1UphMXvUOMxxY=
Date: Sat, 21 Mar 2009 03:42:12 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [RFC][PATCH -tip 1/5 V2] tracing: kprobe-tracer plugin core
Message-ID: <20090321024211.GF6044@nowhere>
References: <49C443EA.6030802@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C443EA.6030802@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 09:33:30PM -0400, Masami Hiramatsu wrote:
> Add kprobes based event tracer on ftrace.
> 
> This tracer is similar to the events tracer which is based on Tracepoint
> infrastructure. Instead of Tracepoint, this tracer is based on kprobes(kprobe
> and kretprobe). It probes anywhere where kprobes can probe(this means, all
> functions body except for __kprobes functions).
> 
> changes from v1:
>  - fix a bug in offset parsing.
>  - use __trace_bprintk() instead of __trace_printk().
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> ---

[ ... ]


> +/* Probes listing interfaces */
> +static void *probes_seq_start(struct seq_file *m, loff_t *pos)
> +{
> +	struct trace_probe *probe;
> +	loff_t n = *pos;
> +
> +	mutex_lock(&probe_lock);
> +	if (!list_empty(&probe_list)) {
> +		list_for_each_entry(probe, &probe_list, list)
> +			if (0 == n--)
> +				return probe;
> +	}
> +	return NULL;
> +}
> +
> +static void *probes_seq_next(struct seq_file *m, void *v, loff_t *pos)
> +{
> +	struct trace_probe *tp = v;
> +
> +	(*pos)++;
> +	if (tp->list.next == &probe_list)
> +		tp = NULL;
> +	else
> +		tp = list_entry(tp->list.next, struct trace_probe, list);
> +	return tp;
> +}



Hm, I think seq_list_start/next will be sufficient for your needs.


> +static void probes_seq_stop(struct seq_file *m, void *v)
> +{
> +	mutex_unlock(&probe_lock);
> +}
> +
> +static int probes_seq_show(struct seq_file *m, void *v)
> +{
> +	struct trace_probe *tp = v;
> +
> +	if (tp == NULL)
> +		return 0;
> +
> +	if (tp->symbol)
> +		seq_printf(m, "%c %s%+ld\n",
> +			probe_is_return(tp) ? 'r' : 'p',
> +			probe_symbol(tp), probe_offset(tp));
> +	else
> +		seq_printf(m, "%c 0x%p\n",
> +			probe_is_return(tp) ? 'r' : 'p',
> +			probe_address(tp));
> +	return 0;
> +}
> +
> +static const struct seq_operations probes_seq_op = {
> +	.start  = probes_seq_start,
> +	.next   = probes_seq_next,
> +	.stop   = probes_seq_stop,
> +	.show   = probes_seq_show
> +};
> +
> +static int probes_open(struct inode *inode, struct file *file)
> +{
> +	if ((file->f_mode & FMODE_WRITE) &&
> +	    !(file->f_flags & O_APPEND))
> +		cleanup_all_probes();
> +
> +	return seq_open(file, &probes_seq_op);


This seq_open is only for read case. No?


> +}
> +
> +
> +#define WRITE_BUFSIZE 128
> +
> +ssize_t probes_write(struct file *file, const char __user *buffer,
> +		     size_t count, loff_t *ppos)
> +{
> +	char *kbuf, *tmp;
> +	char **argv = NULL;
> +	int argc = 0;
> +	int ret;
> +	size_t done;
> +	size_t size;
> +
> +	if (!count || count < 0)
> +		return 0;
> +
> +	kbuf = kmalloc(WRITE_BUFSIZE, GFP_KERNEL);
> +	if (!kbuf)
> +		return -ENOMEM;
> +
> +	ret = done = 0;
> +	do {
> +		size = count - done;
> +		if (size > WRITE_BUFSIZE)
> +			size = WRITE_BUFSIZE;
> +		if (copy_from_user(kbuf, buffer + done, size)) {
> +			ret = -EFAULT;
> +			goto out;
> +		}
> +		kbuf[size] = '\0';
> +		tmp = strchr(kbuf, '\n');
> +		if (!tmp) {
> +			pr_warning("Line length is too long: "
> +				   "Should be less than %d.", WRITE_BUFSIZE);
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +		*tmp = '\0';
> +		size = tmp - kbuf + 1;
> +		done += size;
> +
> +		argv = argv_split(GFP_KERNEL, kbuf, &argc);
> +		if (!argv) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}
> +
> +		if (argc)
> +			ret = create_trace_probe(argc, argv);
> +
> +		argv_free(argv);
> +		if (ret < 0)
> +			goto out;
> +
> +	} while (done < count);
> +	ret = done;
> +out:
> +	kfree(kbuf);
> +	return ret;
> +}
> +
> +static const struct file_operations kprobe_points_ops = {
> +	.owner          = THIS_MODULE,
> +	.open           = probes_open,
> +	.read           = seq_read,
> +	.llseek         = seq_lseek,
> +	.release        = seq_release,
> +	.write		= probes_write,
> +};
> +
> +/* event recording functions */
> +static void kprobe_trace_record(unsigned long ip, struct trace_probe *tp,
> +				struct pt_regs *regs)
> +{
> +	__trace_bprintk(ip, "%s%s%+ld\n",
> +			probe_is_return(tp) ? "<-" : "@",
> +			probe_symbol(tp), probe_offset(tp));
> +}
> +
> +/* Make a debugfs interface for controling probe points */
> +static __init int init_kprobe_trace(void)
> +{
> +	struct dentry *d_tracer;
> +	struct dentry *entry;
> +
> +	d_tracer = tracing_init_dentry();
> +	if (!d_tracer)
> +		return 0;
> +
> +	entry = debugfs_create_file("kprobe_probes", 0444, d_tracer,


Shouldn't it be 0644 ?
Since its first intend, and the most important one, is to receive
commands from user?

Thanks,
Frederic.


> +				    NULL, &kprobe_points_ops);
> +
> +	if (!entry)
> +		pr_warning("Could not create debugfs "
> +			   "'kprobe_probess' entry\n");
> +	return 0;
> +}
> +fs_initcall(init_kprobe_trace);
> +
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 
> 

