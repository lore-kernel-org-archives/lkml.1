Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbYH0J7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbYH0J7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 05:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754269AbYH0J7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 05:59:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:58469 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbYH0J7f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 05:59:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=h3J53GOUbzJ5wwhNpl4EmoWCoaVMiUxnIf9+CDcuie6yaD8zY225fbXHhNwHVj1CFC
         jJ1vtfYGylyGR2f1Mj9/au2Usoa1R4YfeCuwavbkt51jhUllsAqaoUwhoW//owqO7h7b
         v3RBOysYY9QxtQKS1R/OnGavMK6bzaCPqmw7I=
Message-ID: <c62985530808270259i491e32e2r40adf719e32e4086@mail.gmail.com>
Date: Wed, 27 Aug 2008 10:59:33 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [Patch] Tracing/ftrace: Adds a marker to allow user comments
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Pekka Paalanen" <pq@iki.fi>
In-Reply-To: <48B1D5CA.8000607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <48B1D5CA.8000607@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/24 Frédéric Weisbecker <fweisbec@gmail.com>:
> The documentation of mmiotrace describes an unimplemented feature which allows the user
> to write any comments on his trace by writing on a tracing/marker file.
> Here is an implementation of this idea.
>
> It applies on last version of tip tree.
>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/trace.c |  264 ++++++++++++++++++++++++++++++++++++--------------
>  kernel/trace/trace.h |    5 +
>  2 files changed, 198 insertions(+), 71 deletions(-)
>
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 1801900..ee06849 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -955,6 +955,121 @@ __trace_special(void *__tr, void *__data,
>        trace_wake_up();
>  }
>
> +/* Add a message provided by the user (TRACE_MARK) or by __ftrace_printk */
> +
> +void trace_print(char *buf, int len, struct trace_entry *tmp_ent,
> +               struct trace_array *tr, struct trace_array_cpu *data,
> +               unsigned long flags)
> +{
> +       struct trace_entry *entry;
> +       int write, written = 0;
> +
> +       __raw_spin_lock(&data->lock);
> +       entry = tracing_get_trace_entry(tr, data);
> +       tracing_generic_entry_update(entry, flags);
> +       entry->type = tmp_ent->type;
> +
> +       if (entry->type == TRACE_PRINT)
> +               entry->field.print.ip = tmp_ent->field.print.ip;
> +
> +       write = min(len, (int)(TRACE_PRINT_BUF_SIZE-1));
> +       memcpy(&entry->field.print.buf, buf, write);
> +       entry->field.print.buf[write] = 0;
> +
> +       written = write;
> +
> +       if (written != len)
> +               entry->field.flags |= TRACE_FLAG_CONT;
> +
> +       while (written != len) {
> +               entry = tracing_get_trace_entry(tr, data);
> +
> +               entry->type = TRACE_CONT;
> +               write = min(len - written, (int)(TRACE_CONT_BUF_SIZE-1));
> +               memcpy(&entry->cont.buf, buf+written, write);
> +               entry->cont.buf[write] = 0;
> +               written += write;
> +       }
> +       __raw_spin_unlock(&data->lock);
> +}
> +
> +/* Add a message provided by the user towards the tracing_mark file */
> +int tracing_mark(char *buf, int size)
> +{
> +       struct trace_array *tr = &global_trace;
> +       struct trace_array_cpu *data;
> +       struct trace_entry tmp_ent;
> +       unsigned long flags;
> +       long disabled;
> +       int cpu;
> +
> +       local_irq_save(flags);
> +       cpu = raw_smp_processor_id();
> +       data = tr->data[cpu];
> +       disabled = atomic_inc_return(&data->disabled);
> +
> +       if (unlikely(disabled != 1))
> +               goto out;
> +
> +       size = min(size, TRACE_BUF_SIZE - 1);
> +       tmp_ent.type = TRACE_MARK;
> +       buf[size - 1] = 0;
> +
> +       trace_print(buf, size, &tmp_ent, tr, data, flags);
> +
> +out:
> +       atomic_dec(&data->disabled);
> +       local_irq_restore(flags);
> +       return size;
> +}
> +
> +
> +int __ftrace_printk(unsigned long ip, const char *fmt, ...)
> +{
> +       struct trace_array *tr = &global_trace;
> +       static DEFINE_SPINLOCK(trace_buf_lock);
> +       static char trace_buf[TRACE_BUF_SIZE];
> +       struct trace_array_cpu *data;
> +       struct trace_entry tmp_ent;
> +       unsigned long flags;
> +       long disabled;
> +       va_list ap;
> +       int cpu, len = 0;
> +
> +       if (likely(!ftrace_function_enabled))
> +               return 0;
> +
> +       local_irq_save(flags);
> +       cpu = raw_smp_processor_id();
> +       data = tr->data[cpu];
> +       disabled = atomic_inc_return(&data->disabled);
> +
> +       if (unlikely(disabled != 1 || !ftrace_function_enabled))
> +               goto out;
> +
> +       tmp_ent.type = TRACE_PRINT;
> +       tmp_ent.field.print.ip = ip;
> +
> +       spin_lock(&trace_buf_lock);
> +       va_start(ap, fmt);
> +       len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, ap);
> +       va_end(ap);
> +
> +       len = min(len, TRACE_BUF_SIZE-1);
> +       trace_buf[len] = 0;
> +
> +       trace_print(trace_buf, len, &tmp_ent, tr, data, flags);
> +
> +       spin_unlock(&trace_buf_lock);
> +
> + out:
> +       atomic_dec(&data->disabled);
> +       local_irq_restore(flags);
> +
> +       return len;
> +}
> +EXPORT_SYMBOL_GPL(__ftrace_printk);
> +
>  void
>  tracing_sched_switch_trace(struct trace_array *tr,
>                           struct trace_array_cpu *data,
> @@ -1943,6 +2058,26 @@ static int print_bin_fmt(struct trace_iterator *iter)
>        return 1;
>  }
>
> +/* Add the user message on the pipe */
> +static int print_mark(struct trace_iterator *iter)
> +{
> +       struct trace_seq *s = &iter->seq;
> +       struct trace_entry *entry = iter->ent;
> +       struct trace_field *field = &entry->field;
> +
> +       int ret;
> +
> +       ret = trace_seq_printf(s, field->print.buf);
> +       if (field->flags && TRACE_FLAG_CONT)
> +               trace_seq_print_cont(s, iter);
> +       trace_seq_printf(s, "\n");
> +
> +       if (ret)
> +               return 1;
> +       return 0;
> +}
> +
> +
>  static int trace_empty(struct trace_iterator *iter)
>  {
>        struct trace_array_cpu *data;
> @@ -1961,6 +2096,9 @@ static int trace_empty(struct trace_iterator *iter)
>
>  static int print_trace_line(struct trace_iterator *iter)
>  {
> +       if (iter->ent->type == TRACE_MARK)
> +               return print_mark(iter);
> +
>        if (iter->trace && iter->trace->print_line)
>                return iter->trace->print_line(iter);
>
> @@ -2918,6 +3056,49 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
>        return cnt;
>  }
>
> +static int tracing_open_mark(struct inode *inode, struct file *filp)
> +{
> +       int ret;
> +
> +       ret = tracing_open_generic(inode, filp);
> +       if (ret)
> +               return ret;
> +
> +       if (current_trace == &no_tracer)
> +               return -ENODEV;
> +
> +       return 0;
> +}
> +
> +
> +static ssize_t
> +tracing_mark_write(struct file *filp, const char __user *ubuf,
> +               size_t cnt, loff_t *fpos)
> +{
> +       char *buf;
> +
> +       if (cnt > TRACE_BUF_SIZE)
> +               cnt = TRACE_BUF_SIZE;
> +
> +       buf = kmalloc(cnt, GFP_KERNEL);
> +
> +       if (buf == NULL)
> +               return -ENOMEM;
> +
> +       if (copy_from_user(buf, ubuf, cnt)) {
> +               kfree(buf);
> +               return -EFAULT;
> +       }
> +
> +       cnt = tracing_mark(buf, cnt);
> +       kfree(buf);
> +       *fpos += cnt;
> +
> +       return cnt;
> +}
> +
> +
> +
>  static struct file_operations tracing_max_lat_fops = {
>        .open           = tracing_open_generic,
>        .read           = tracing_max_lat_read,
> @@ -2949,6 +3130,11 @@ static struct file_operations tracing_entries_fops = {
>        .write          = tracing_entries_write,
>  };
>
> +static struct file_operations tracing_mark_fops = {
> +       .open           = tracing_open_mark,
> +       .write          = tracing_mark_write,
> +};
> +
>  #ifdef CONFIG_DYNAMIC_FTRACE
>
>  static ssize_t
> @@ -3066,6 +3252,13 @@ static __init void tracer_init_debugfs(void)
>                pr_warning("Could not create debugfs "
>                           "'trace_entries' entry\n");
>
> +       entry = debugfs_create_file("trace_marker", 0220, d_tracer,
> +                                   NULL, &tracing_mark_fops);
> +
> +       if (!entry)
> +               pr_warning("Could not create debugfs "
> +                          "'trace_marker' entry\n");
> +
>  #ifdef CONFIG_DYNAMIC_FTRACE
>        entry = debugfs_create_file("dyn_ftrace_total_info", 0444, d_tracer,
>                                    &ftrace_update_tot_cnt,
> @@ -3079,77 +3272,6 @@ static __init void tracer_init_debugfs(void)
>  #endif
>  }
>
> -#define TRACE_BUF_SIZE 1024
> -#define TRACE_PRINT_BUF_SIZE \
> -       (sizeof(struct trace_field) - offsetof(struct trace_field, print.buf))
> -#define TRACE_CONT_BUF_SIZE sizeof(struct trace_field)
> -
> -int __ftrace_printk(unsigned long ip, const char *fmt, ...)
> -{
> -       struct trace_array *tr = &global_trace;
> -       static DEFINE_SPINLOCK(trace_buf_lock);
> -       static char trace_buf[TRACE_BUF_SIZE];
> -       struct trace_array_cpu *data;
> -       struct trace_entry *entry;
> -       unsigned long flags;
> -       long disabled;
> -       va_list ap;
> -       int cpu, len = 0, write, written = 0;
> -
> -       if (likely(!ftrace_function_enabled))
> -               return 0;
> -
> -       local_irq_save(flags);
> -       cpu = raw_smp_processor_id();
> -       data = tr->data[cpu];
> -       disabled = atomic_inc_return(&data->disabled);
> -
> -       if (unlikely(disabled != 1 || !ftrace_function_enabled))
> -               goto out;
> -
> -       spin_lock(&trace_buf_lock);
> -       va_start(ap, fmt);
> -       len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, ap);
> -       va_end(ap);
> -
> -       len = min(len, TRACE_BUF_SIZE-1);
> -       trace_buf[len] = 0;
> -
> -       __raw_spin_lock(&data->lock);
> -       entry                           = tracing_get_trace_entry(tr, data);
> -       tracing_generic_entry_update(entry, flags);
> -       entry->type                     = TRACE_PRINT;
> -       entry->field.print.ip           = ip;
> -
> -       write = min(len, (int)(TRACE_PRINT_BUF_SIZE-1));
> -
> -       memcpy(&entry->field.print.buf, trace_buf, write);
> -       entry->field.print.buf[write] = 0;
> -       written = write;
> -
> -       if (written != len)
> -               entry->field.flags |= TRACE_FLAG_CONT;
> -
> -       while (written != len) {
> -               entry = tracing_get_trace_entry(tr, data);
> -
> -               entry->type = TRACE_CONT;
> -               write = min(len - written, (int)(TRACE_CONT_BUF_SIZE-1));
> -               memcpy(&entry->cont.buf, trace_buf+written, write);
> -               entry->cont.buf[write] = 0;
> -               written += write;
> -       }
> -       __raw_spin_unlock(&data->lock);
> -
> -       spin_unlock(&trace_buf_lock);
> -
> - out:
> -       atomic_dec(&data->disabled);
> -       local_irq_restore(flags);
> -
> -       return len;
> -}
> -EXPORT_SYMBOL_GPL(__ftrace_printk);
>
>  static int trace_panic_handler(struct notifier_block *this,
>                               unsigned long event, void *unused)
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 50b6d7a..ccc245c 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -14,6 +14,7 @@ enum trace_type {
>        TRACE_CTX,
>        TRACE_WAKE,
>        TRACE_CONT,
> +       TRACE_MARK,
>        TRACE_STACK,
>        TRACE_PRINT,
>        TRACE_SPECIAL,
> @@ -106,6 +107,10 @@ struct trace_entry {
>  };
>
>  #define TRACE_ENTRY_SIZE       sizeof(struct trace_entry)
> +#define TRACE_BUF_SIZE 1024
> +#define TRACE_PRINT_BUF_SIZE \
> +       (sizeof(struct trace_field) - offsetof(struct trace_field, print.buf))
> +#define TRACE_CONT_BUF_SIZE sizeof(struct trace_field)
>
>  /*
>  * The CPU trace array - it consists of thousands of trace entries
>

Do you think I should modify something or use a way to make it better?
(Added Pekka Paalanen in Cc since it concerns an idea from his
mmiotrace's documentation)...
