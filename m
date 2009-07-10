Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbZGJUbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbZGJUbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 16:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756229AbZGJUa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 16:30:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57901 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916AbZGJUa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 16:30:58 -0400
Message-ID: <4A57A58B.8010909@redhat.com>
Date: Fri, 10 Jul 2009 16:33:15 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH -tip -v11 08/11] tracing: add kprobe-based event tracer
References: <20090709202220.13223.97114.stgit@localhost.localdomain> <20090709202309.13223.9431.stgit@localhost.localdomain> <4A56EA17.8000508@cn.fujitsu.com>
In-Reply-To: <4A56EA17.8000508@cn.fujitsu.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
>> +static __kprobes unsigned long fetch_memory(struct pt_regs *regs, void *addr)
>> +{
>> +	unsigned long retval;
> 
> need a space after local variable declarations.
> 
>> +	if (probe_kernel_address(addr, retval))
>> +		return 0;
>> +	return retval;
>> +}
>> +
>> +static __kprobes unsigned long fetch_argument(struct pt_regs *regs, void *num)
>> +{
>> +	return regs_get_argument_nth(regs, (unsigned int)((unsigned long)num));
>> +}
>> +
>> +static __kprobes unsigned long fetch_retvalue(struct pt_regs *regs,
>> +					      void *dummy)
>> +{
>> +	return regs_return_value(regs);
>> +}
>> +
>> +static __kprobes unsigned long fetch_ip(struct pt_regs *regs, void *dummy)
>> +{
>> +	return instruction_pointer(regs);
>> +}
>> +
>> +/* Memory fetching by symbol */
>> +struct symbol_cache {
>> +	char *symbol;
>> +	long offset;
>> +	unsigned long addr;
>> +};
>> +
>> +static unsigned long update_symbol_cache(struct symbol_cache *sc)
>> +{
>> +	sc->addr = (unsigned long)kallsyms_lookup_name(sc->symbol);
>> +	if (sc->addr)
>> +		sc->addr += sc->offset;
>> +	return sc->addr;
>> +}
>> +
>> +static void free_symbol_cache(struct symbol_cache *sc)
>> +{
>> +	kfree(sc->symbol);
>> +	kfree(sc);
>> +}
>> +
>> +static struct symbol_cache *alloc_symbol_cache(const char *sym, long offset)
>> +{
>> +	struct symbol_cache *sc;
> 
> ditto.
> 
> and in some other places

Agreed, I'll fix all of it.


>> +static int probes_seq_show(struct seq_file *m, void *v)
>> +{
>> +	struct trace_probe *tp = v;
>> +	int i, ret;
>> +	char buf[MAX_ARGSTR_LEN + 1];
>> +
>> +	if (tp == NULL)
>> +		return 0;
>> +
> 
> redundant check. tp won't be NULL.

Sure.


>> +static ssize_t probes_write(struct file *file, const char __user *buffer,
>> +			    size_t count, loff_t *ppos)
>> +{
>> +	char *kbuf, *tmp;
>> +	int ret;
>> +	size_t done;
>> +	size_t size;
>> +
>> +	if (!count || count < 0)
>> +		return 0;
> 
> count is unsigned, so won't < 0. Also I don't think you
> need to treat (count == 0) specially.

Ah, right. That was another redundant check too...

>> +
>> +	kbuf = kmalloc(WRITE_BUFSIZE, GFP_KERNEL);
> 
> should be kmalloc(WRITE_BUFSIZE+1), or...
> 
>> +	if (!kbuf)
>> +		return -ENOMEM;
>> +
>> +	ret = done = 0;
>> +	do {
>> +		size = count - done;
>> +		if (size > WRITE_BUFSIZE)
>> +			size = WRITE_BUFSIZE;
> 
> if (size >= WRITE_BUFSIZE)
> 	size = WRITE_BUFSIZE - 1;

Hm, I'll take this, because WRITE_BUFSIZE should be the size
of buffer.

>> +		if (copy_from_user(kbuf, buffer + done, size)) {
>> +			ret = -EFAULT;
>> +			goto out;
>> +		}
>> +		kbuf[size] = '\0';
>> +		tmp = strchr(kbuf, '\n');
>> +		if (!tmp) {
>> +			pr_warning("Line length is too long: "
>> +				   "Should be less than %d.", WRITE_BUFSIZE);
>> +			ret = -EINVAL;
>> +			goto out;
>> +		}

Hmm, here, there will be a case that the last line is
terminated without a new line...

>> +		*tmp = '\0';
>> +		size = tmp - kbuf + 1;
>> +		done += size;
>> +		/* Remove comments */
>> +		tmp = strchr(kbuf, '#');
>> +		if (tmp)
>> +			*tmp = '\0';
>> +
>> +		ret = command_trace_probe(kbuf);
>> +		if (ret)
>> +			goto out;
>> +
>> +	} while (done < count);
>> +	ret = done;
>> +out:
>> +	kfree(kbuf);
>> +	return ret;
>> +}
> 
> ...
> 
>> +enum print_line_t
>> +print_kretprobe_event(struct trace_iterator *iter, int flags)
>> +{
>> +	struct kretprobe_trace_entry *field;
>> +	struct trace_seq *s = &iter->seq;
>> +	int i;
>> +
>> +	trace_assign_type(field, iter->ent);
>> +
>> +	if (!seq_print_ip_sym(s, field->ret_ip, flags | TRACE_ITER_SYM_OFFSET))
>> +		goto partial;
>> +
> 
> can't we use %pF?
> 
>> +	if (!trace_seq_puts(s, " <- "))
>> +		goto partial;
>> +
>> +	if (!seq_print_ip_sym(s, field->func, flags & ~TRACE_ITER_SYM_OFFSET))
>> +		goto partial;
>> +
> 
> and $pf?
> 
>> +	if (!trace_seq_puts(s, ":"))
>> +		goto partial;
>> +
> 
> so all the above:
> 
> 	trace_seq_puts(s, "%pF <- %pf:", (void *)field->ret_ip,
> 			(void *)field->func);

Hmm, I'd like to use seq_print_ip_sym() rather than %pF/%pf,
because there is a difference between them when ftrace's sym-addr
option is set.

Set a probe and a return probe on vfs_read, like

echo p vfs_read > kprobe_events
echo r vfs_read >> kprobe_events

And if we use seq_print_ip_sym() and sym-addr is 1,
we'll see below output;

<...>-1908  [001] 875089.743395: vfs_read+0x0/0x102 <ffffffff810dfe00>:
<...>-1908  [001] 875089.743398: sys_read+0x47/0x70 <ffffffff810dffc6> <- vfs_read <ffffffff810dfe00>:

On the other hand, if we use trace_seq_printf("%pf...), then:

<...>-1861  [001] 873504.331268: vfs_read+0x0/0x102 <ffffffff810dfdd0>:
<...>-1861  [001] 873504.331272: sys_read+0x47/0x70 <- vfs_read:

In this case, we can't see the real address of those symbols.

Thank you for review my patch!

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

