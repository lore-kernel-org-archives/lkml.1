Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbYH0SVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbYH0SVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 14:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbYH0SVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 14:21:41 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:10532 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbYH0SVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 14:21:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=piccR1VC/2cT8s3oan+3EMWtwmhLBGcLKI+KbJ3E8GtmW0wSO2IL6gOZxD4LECfkj3
         X+h3QTYVKk/IaBXS626gvFv43VaRbsEpkBg9ZYwdrRTgi3mwD05bN9QlSnqKXlKi2moV
         hxpNJKW/sM0GxzL3u+TUOX0ofifFHo4R9t3Kc=
Date: Wed, 27 Aug 2008 21:21:30 +0300
From: Pekka Paalanen <pq@iki.fi>
To: "=?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker" <fweisbec@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Tracing/ftrace: Adds a marker to allow user comments
Message-ID: <20080827212130.4b8365a8@daedalus.pq.iki.fi>
In-Reply-To: <c62985530808270259i491e32e2r40adf719e32e4086@mail.gmail.com>
References: <48B1D5CA.8000607@gmail.com>
	<c62985530808270259i491e32e2r40adf719e32e4086@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nice to hear from you, Frédéric!

I have some comments in the following.

On Wed, 27 Aug 2008 10:59:33 +0100
"Frédéric Weisbecker" <fweisbec@gmail.com> wrote:

> 2008/8/24 Frédéric Weisbecker <fweisbec@gmail.com>:
> > The documentation of mmiotrace describes an unimplemented feature which allows the user
> > to write any comments on his trace by writing on a tracing/marker file.
> > Here is an implementation of this idea.
> >
> > It applies on last version of tip tree.
> >
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  kernel/trace/trace.c |  264 ++++++++++++++++++++++++++++++++++++--------------
> >  kernel/trace/trace.h |    5 +
> >  2 files changed, 198 insertions(+), 71 deletions(-)
> >
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index 1801900..ee06849 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -955,6 +955,121 @@ __trace_special(void *__tr, void *__data,
> >        trace_wake_up();
> >  }
> >
> > +/* Add a message provided by the user (TRACE_MARK) or by __ftrace_printk */
> > +
> > +void trace_print(char *buf, int len, struct trace_entry *tmp_ent,
> > +               struct trace_array *tr, struct trace_array_cpu *data,
> > +               unsigned long flags)
> > +{
> > +       struct trace_entry *entry;
> > +       int write, written = 0;
> > +
> > +       __raw_spin_lock(&data->lock);
> > +       entry = tracing_get_trace_entry(tr, data);
> > +       tracing_generic_entry_update(entry, flags);
> > +       entry->type = tmp_ent->type;
> > +
> > +       if (entry->type == TRACE_PRINT)
> > +               entry->field.print.ip = tmp_ent->field.print.ip;
> > +
> > +       write = min(len, (int)(TRACE_PRINT_BUF_SIZE-1));
> > +       memcpy(&entry->field.print.buf, buf, write);
> > +       entry->field.print.buf[write] = 0;
> > +
> > +       written = write;
> > +
> > +       if (written != len)
> > +               entry->field.flags |= TRACE_FLAG_CONT;
> > +
> > +       while (written != len) {
> > +               entry = tracing_get_trace_entry(tr, data);
> > +
> > +               entry->type = TRACE_CONT;
> > +               write = min(len - written, (int)(TRACE_CONT_BUF_SIZE-1));
> > +               memcpy(&entry->cont.buf, buf+written, write);
> > +               entry->cont.buf[write] = 0;
> > +               written += write;
> > +       }
> > +       __raw_spin_unlock(&data->lock);
> > +}
> > +
> > +/* Add a message provided by the user towards the tracing_mark file */
> > +int tracing_mark(char *buf, int size)
> > +{
> > +       struct trace_array *tr = &global_trace;
> > +       struct trace_array_cpu *data;
> > +       struct trace_entry tmp_ent;
> > +       unsigned long flags;
> > +       long disabled;
> > +       int cpu;
> > +
> > +       local_irq_save(flags);
> > +       cpu = raw_smp_processor_id();
> > +       data = tr->data[cpu];
> > +       disabled = atomic_inc_return(&data->disabled);
> > +
> > +       if (unlikely(disabled != 1))
> > +               goto out;
> > +
> > +       size = min(size, TRACE_BUF_SIZE - 1);
> > +       tmp_ent.type = TRACE_MARK;
> > +       buf[size - 1] = 0;
> > +
> > +       trace_print(buf, size, &tmp_ent, tr, data, flags);
> > +
> > +out:
> > +       atomic_dec(&data->disabled);
> > +       local_irq_restore(flags);
> > +       return size;
> > +}

IMHO we could just make ftrace_printk() work for all tracers. I doubt
there will be need to be able to record nil bytes. The idea of a marker
is to be a line of human readable text.

> > +int __ftrace_printk(unsigned long ip, const char *fmt, ...)
> > +{
> > +       struct trace_array *tr = &global_trace;
> > +       static DEFINE_SPINLOCK(trace_buf_lock);
> > +       static char trace_buf[TRACE_BUF_SIZE];
> > +       struct trace_array_cpu *data;
> > +       struct trace_entry tmp_ent;
> > +       unsigned long flags;
> > +       long disabled;
> > +       va_list ap;
> > +       int cpu, len = 0;
> > +
> > +       if (likely(!ftrace_function_enabled))
> > +               return 0;

And that is the kind of check that makes current ftrace_printk() unusable.
I think this restriction should be lifted and allow it to work on all
tracers. I would also like to be able to have e.g. mmiotrace_marker(),
which would have the same signature as ftrace_printk(), but is a no-op if
mmiotrace is not active. So, we could have an __ftrace_vprintk() to make
writing such wrappers easy. And the wrappers could be #ifdef'd away, if
the corresponding tracer is not built.

I recall somewhere mentioning, that one shouldn't leave ftrace_printk's
lying around in "final" code, so I'm not sure how people feel about this
wrapping idea, especially when e.g. mmiotrace is hoped to be built-in by
default. OTOH, I don't think in-tree drivers and stuff want to use them,
so they would be mostly offered for out-of-tree modules
(reverse-engineering) and developers (debugging). That makes me wonder
if they would be accepted (as exported symbols).

> > +
> > +       local_irq_save(flags);
> > +       cpu = raw_smp_processor_id();
> > +       data = tr->data[cpu];
> > +       disabled = atomic_inc_return(&data->disabled);
> > +
> > +       if (unlikely(disabled != 1 || !ftrace_function_enabled))
> > +               goto out;
> > +
> > +       tmp_ent.type = TRACE_PRINT;
> > +       tmp_ent.field.print.ip = ip;
> > +
> > +       spin_lock(&trace_buf_lock);
> > +       va_start(ap, fmt);
> > +       len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, ap);
> > +       va_end(ap);
> > +
> > +       len = min(len, TRACE_BUF_SIZE-1);
> > +       trace_buf[len] = 0;
> > +
> > +       trace_print(trace_buf, len, &tmp_ent, tr, data, flags);
> > +
> > +       spin_unlock(&trace_buf_lock);
> > +
> > + out:
> > +       atomic_dec(&data->disabled);
> > +       local_irq_restore(flags);
> > +
> > +       return len;
> > +}
> > +EXPORT_SYMBOL_GPL(__ftrace_printk);
> > +
> >  void
> >  tracing_sched_switch_trace(struct trace_array *tr,
> >                           struct trace_array_cpu *data,
> > @@ -1943,6 +2058,26 @@ static int print_bin_fmt(struct trace_iterator *iter)
> >        return 1;
> >  }
> >
> > +/* Add the user message on the pipe */
> > +static int print_mark(struct trace_iterator *iter)
> > +{
> > +       struct trace_seq *s = &iter->seq;
> > +       struct trace_entry *entry = iter->ent;
> > +       struct trace_field *field = &entry->field;
> > +
> > +       int ret;
> > +
> > +       ret = trace_seq_printf(s, field->print.buf);
> > +       if (field->flags && TRACE_FLAG_CONT)
> > +               trace_seq_print_cont(s, iter);
> > +       trace_seq_printf(s, "\n");
> > +
> > +       if (ret)
> > +               return 1;
> > +       return 0;
> > +}
> > +
> > +
> >  static int trace_empty(struct trace_iterator *iter)
> >  {
> >        struct trace_array_cpu *data;
> > @@ -1961,6 +2096,9 @@ static int trace_empty(struct trace_iterator *iter)
> >
> >  static int print_trace_line(struct trace_iterator *iter)
> >  {
> > +       if (iter->ent->type == TRACE_MARK)
> > +               return print_mark(iter);
> > +

Please, put this call after the following...

> >        if (iter->trace && iter->trace->print_line)
> >                return iter->trace->print_line(iter);

..so that tracers may override it at will. Mmiotrace needs to replace
newlines and nil characters, before printing it in its own style, i.e.
prefixed with a tag and a timestamp, which are specified in the mmiotrace
log format.

> >
> > @@ -2918,6 +3056,49 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
> >        return cnt;
> >  }
> >
> > +static int tracing_open_mark(struct inode *inode, struct file *filp)
> > +{
> > +       int ret;
> > +
> > +       ret = tracing_open_generic(inode, filp);
> > +       if (ret)
> > +               return ret;
> > +
> > +       if (current_trace == &no_tracer)
> > +               return -ENODEV;
> > +
> > +       return 0;
> > +}
> > +
> > +
> > +static ssize_t
> > +tracing_mark_write(struct file *filp, const char __user *ubuf,
> > +               size_t cnt, loff_t *fpos)
> > +{
> > +       char *buf;
> > +
> > +       if (cnt > TRACE_BUF_SIZE)
> > +               cnt = TRACE_BUF_SIZE;
> > +
> > +       buf = kmalloc(cnt, GFP_KERNEL);
> > +
> > +       if (buf == NULL)
> > +               return -ENOMEM;
> > +
> > +       if (copy_from_user(buf, ubuf, cnt)) {
> > +               kfree(buf);
> > +               return -EFAULT;
> > +       }
> > +
> > +       cnt = tracing_mark(buf, cnt);
> > +       kfree(buf);
> > +       *fpos += cnt;
> > +
> > +       return cnt;
> > +}
> > +
> > +
> > +
> >  static struct file_operations tracing_max_lat_fops = {
> >        .open           = tracing_open_generic,
> >        .read           = tracing_max_lat_read,
> > @@ -2949,6 +3130,11 @@ static struct file_operations tracing_entries_fops = {
> >        .write          = tracing_entries_write,
> >  };
> >
> > +static struct file_operations tracing_mark_fops = {
> > +       .open           = tracing_open_mark,
> > +       .write          = tracing_mark_write,
> > +};
> > +
> >  #ifdef CONFIG_DYNAMIC_FTRACE
> >
> >  static ssize_t
> > @@ -3066,6 +3252,13 @@ static __init void tracer_init_debugfs(void)
> >                pr_warning("Could not create debugfs "
> >                           "'trace_entries' entry\n");
> >
> > +       entry = debugfs_create_file("trace_marker", 0220, d_tracer,
> > +                                   NULL, &tracing_mark_fops);
> > +
> > +       if (!entry)
> > +               pr_warning("Could not create debugfs "
> > +                          "'trace_marker' entry\n");
> > +
> >  #ifdef CONFIG_DYNAMIC_FTRACE
> >        entry = debugfs_create_file("dyn_ftrace_total_info", 0444, d_tracer,
> >                                    &ftrace_update_tot_cnt,
> > @@ -3079,77 +3272,6 @@ static __init void tracer_init_debugfs(void)
> >  #endif
> >  }
> >
> > -#define TRACE_BUF_SIZE 1024
> > -#define TRACE_PRINT_BUF_SIZE \
> > -       (sizeof(struct trace_field) - offsetof(struct trace_field, print.buf))
> > -#define TRACE_CONT_BUF_SIZE sizeof(struct trace_field)
> > -
> > -int __ftrace_printk(unsigned long ip, const char *fmt, ...)
> > -{
> > -       struct trace_array *tr = &global_trace;
> > -       static DEFINE_SPINLOCK(trace_buf_lock);
> > -       static char trace_buf[TRACE_BUF_SIZE];
> > -       struct trace_array_cpu *data;
> > -       struct trace_entry *entry;
> > -       unsigned long flags;
> > -       long disabled;
> > -       va_list ap;
> > -       int cpu, len = 0, write, written = 0;
> > -
> > -       if (likely(!ftrace_function_enabled))
> > -               return 0;
> > -
> > -       local_irq_save(flags);
> > -       cpu = raw_smp_processor_id();
> > -       data = tr->data[cpu];
> > -       disabled = atomic_inc_return(&data->disabled);
> > -
> > -       if (unlikely(disabled != 1 || !ftrace_function_enabled))
> > -               goto out;
> > -
> > -       spin_lock(&trace_buf_lock);
> > -       va_start(ap, fmt);
> > -       len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, ap);
> > -       va_end(ap);
> > -
> > -       len = min(len, TRACE_BUF_SIZE-1);
> > -       trace_buf[len] = 0;
> > -
> > -       __raw_spin_lock(&data->lock);
> > -       entry                           = tracing_get_trace_entry(tr, data);
> > -       tracing_generic_entry_update(entry, flags);
> > -       entry->type                     = TRACE_PRINT;
> > -       entry->field.print.ip           = ip;
> > -
> > -       write = min(len, (int)(TRACE_PRINT_BUF_SIZE-1));
> > -
> > -       memcpy(&entry->field.print.buf, trace_buf, write);
> > -       entry->field.print.buf[write] = 0;
> > -       written = write;
> > -
> > -       if (written != len)
> > -               entry->field.flags |= TRACE_FLAG_CONT;
> > -
> > -       while (written != len) {
> > -               entry = tracing_get_trace_entry(tr, data);
> > -
> > -               entry->type = TRACE_CONT;
> > -               write = min(len - written, (int)(TRACE_CONT_BUF_SIZE-1));
> > -               memcpy(&entry->cont.buf, trace_buf+written, write);
> > -               entry->cont.buf[write] = 0;
> > -               written += write;
> > -       }
> > -       __raw_spin_unlock(&data->lock);
> > -
> > -       spin_unlock(&trace_buf_lock);
> > -
> > - out:
> > -       atomic_dec(&data->disabled);
> > -       local_irq_restore(flags);
> > -
> > -       return len;
> > -}
> > -EXPORT_SYMBOL_GPL(__ftrace_printk);
> >
> >  static int trace_panic_handler(struct notifier_block *this,
> >                               unsigned long event, void *unused)
> > diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> > index 50b6d7a..ccc245c 100644
> > --- a/kernel/trace/trace.h
> > +++ b/kernel/trace/trace.h
> > @@ -14,6 +14,7 @@ enum trace_type {
> >        TRACE_CTX,
> >        TRACE_WAKE,
> >        TRACE_CONT,
> > +       TRACE_MARK,
> >        TRACE_STACK,
> >        TRACE_PRINT,

I think TRACE_MARK and TRACE_PRINT are equivalent, so we could stick
to TRACE_PRINT.

> >        TRACE_SPECIAL,
> > @@ -106,6 +107,10 @@ struct trace_entry {
> >  };
> >
> >  #define TRACE_ENTRY_SIZE       sizeof(struct trace_entry)
> > +#define TRACE_BUF_SIZE 1024
> > +#define TRACE_PRINT_BUF_SIZE \
> > +       (sizeof(struct trace_field) - offsetof(struct trace_field, print.buf))
> > +#define TRACE_CONT_BUF_SIZE sizeof(struct trace_field)
> >
> >  /*
> >  * The CPU trace array - it consists of thousands of trace entries
> >
> 
> Do you think I should modify something or use a way to make it better?
> (Added Pekka Paalanen in Cc since it concerns an idea from his
> mmiotrace's documentation)...

Thanks for adding me, I've been brewing my own version of this stuff,
but didn't yet solve the __ftrace_printk-is-unusable issue yet.
I have the mmiotrace specific parts written for TRACE_PRINT, so we haven't
really overlapped each other's work yet.

Ingo recently told me it would be good to have a generic debugfs file
for adding markers to any tracer log, and this is basically what you did.

I didn't try the patch yet, or read it too carefully, but I should.
Unfortunately I'm away the next weekend, so I hope to continue working
on it the weekend after that.


Thanks,
pq

-- 
Pekka Paalanen
http://www.iki.fi/pq/
