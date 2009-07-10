Return-Path: <linux-kernel-owner+w=401wt.eu-S1751956AbZGJHNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbZGJHNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 03:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbZGJHNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 03:13:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59036 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbZGJHNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 03:13:34 -0400
Message-ID: <4A56EA17.8000508@cn.fujitsu.com>
Date: Fri, 10 Jul 2009 15:13:27 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH -tip -v11 08/11] tracing: add kprobe-based event tracer
References: <20090709202220.13223.97114.stgit@localhost.localdomain> <20090709202309.13223.9431.stgit@localhost.localdomain>
In-Reply-To: <20090709202309.13223.9431.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static __kprobes unsigned long fetch_memory(struct pt_regs *regs, void *addr)
> +{
> +	unsigned long retval;

need a space after local variable declarations.

> +	if (probe_kernel_address(addr, retval))
> +		return 0;
> +	return retval;
> +}
> +
> +static __kprobes unsigned long fetch_argument(struct pt_regs *regs, void *num)
> +{
> +	return regs_get_argument_nth(regs, (unsigned int)((unsigned long)num));
> +}
> +
> +static __kprobes unsigned long fetch_retvalue(struct pt_regs *regs,
> +					      void *dummy)
> +{
> +	return regs_return_value(regs);
> +}
> +
> +static __kprobes unsigned long fetch_ip(struct pt_regs *regs, void *dummy)
> +{
> +	return instruction_pointer(regs);
> +}
> +
> +/* Memory fetching by symbol */
> +struct symbol_cache {
> +	char *symbol;
> +	long offset;
> +	unsigned long addr;
> +};
> +
> +static unsigned long update_symbol_cache(struct symbol_cache *sc)
> +{
> +	sc->addr = (unsigned long)kallsyms_lookup_name(sc->symbol);
> +	if (sc->addr)
> +		sc->addr += sc->offset;
> +	return sc->addr;
> +}
> +
> +static void free_symbol_cache(struct symbol_cache *sc)
> +{
> +	kfree(sc->symbol);
> +	kfree(sc);
> +}
> +
> +static struct symbol_cache *alloc_symbol_cache(const char *sym, long offset)
> +{
> +	struct symbol_cache *sc;

ditto.

and in some other places

> +	if (!sym || strlen(sym) == 0)
> +		return NULL;
> +	sc = kzalloc(sizeof(struct symbol_cache), GFP_KERNEL);
> +	if (!sc)
> +		return NULL;
> +
> +	sc->symbol = kstrdup(sym, GFP_KERNEL);
> +	if (!sc->symbol) {
> +		kfree(sc);
> +		return NULL;
> +	}
> +	sc->offset = offset;
> +
> +	update_symbol_cache(sc);
> +	return sc;
> +}

...

> +static int probes_seq_show(struct seq_file *m, void *v)
> +{
> +	struct trace_probe *tp = v;
> +	int i, ret;
> +	char buf[MAX_ARGSTR_LEN + 1];
> +
> +	if (tp == NULL)
> +		return 0;
> +

redundant check. tp won't be NULL.

> +	seq_printf(m, "%c", probe_is_return(tp) ? 'r' : 'p');
> +	if (tp->call.name)
> +		seq_printf(m, ":%s", tp->call.name);
> +
> +	if (tp->symbol)
> +		seq_printf(m, " %s%+ld", probe_symbol(tp), probe_offset(tp));
> +	else
> +		seq_printf(m, " 0x%p", probe_address(tp));
> +
> +	for (i = 0; i < tp->nr_args; i++) {
> +		ret = trace_arg_string(buf, MAX_ARGSTR_LEN, &tp->args[i]);
> +		if (ret) {
> +			pr_warning("Argument%d is too long.\n", i);
> +			break;
> +		}
> +		seq_printf(m, " %s", buf);
> +	}
> +	seq_printf(m, "\n");
> +	return 0;
> +}

...

> +static ssize_t probes_write(struct file *file, const char __user *buffer,
> +			    size_t count, loff_t *ppos)
> +{
> +	char *kbuf, *tmp;
> +	int ret;
> +	size_t done;
> +	size_t size;
> +
> +	if (!count || count < 0)
> +		return 0;

count is unsigned, so won't < 0. Also I don't think you
need to treat (count == 0) specially.

> +
> +	kbuf = kmalloc(WRITE_BUFSIZE, GFP_KERNEL);

should be kmalloc(WRITE_BUFSIZE+1), or...

> +	if (!kbuf)
> +		return -ENOMEM;
> +
> +	ret = done = 0;
> +	do {
> +		size = count - done;
> +		if (size > WRITE_BUFSIZE)
> +			size = WRITE_BUFSIZE;

if (size >= WRITE_BUFSIZE)
	size = WRITE_BUFSIZE - 1;

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
> +		/* Remove comments */
> +		tmp = strchr(kbuf, '#');
> +		if (tmp)
> +			*tmp = '\0';
> +
> +		ret = command_trace_probe(kbuf);
> +		if (ret)
> +			goto out;
> +
> +	} while (done < count);
> +	ret = done;
> +out:
> +	kfree(kbuf);
> +	return ret;
> +}

...

> +enum print_line_t
> +print_kretprobe_event(struct trace_iterator *iter, int flags)
> +{
> +	struct kretprobe_trace_entry *field;
> +	struct trace_seq *s = &iter->seq;
> +	int i;
> +
> +	trace_assign_type(field, iter->ent);
> +
> +	if (!seq_print_ip_sym(s, field->ret_ip, flags | TRACE_ITER_SYM_OFFSET))
> +		goto partial;
> +

can't we use %pF?

> +	if (!trace_seq_puts(s, " <- "))
> +		goto partial;
> +
> +	if (!seq_print_ip_sym(s, field->func, flags & ~TRACE_ITER_SYM_OFFSET))
> +		goto partial;
> +

and $pf?

> +	if (!trace_seq_puts(s, ":"))
> +		goto partial;
> +

so all the above:

	trace_seq_puts(s, "%pF <- %pf:", (void *)field->ret_ip,
			(void *)field->func);

> +	for (i = 0; i < field->nargs; i++)
> +		if (!trace_seq_printf(s, " 0x%lx", field->args[i]))
> +			goto partial;
> +
> +	if (!trace_seq_puts(s, "\n"))
> +		goto partial;
> +
> +	return TRACE_TYPE_HANDLED;
> +partial:
> +	return TRACE_TYPE_PARTIAL_LINE;
> +}
