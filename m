Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab0BXGGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 01:06:54 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:35255 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab0BXGGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 01:06:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jyPTnmCSBldSJWtzt827905SsQgazJl9OlfZ+xPeJUqtvj65/G2rwYV7E4UOJJlmXi
         /dDMxQx0JMy44vvXSFBwm3nPSsuOdgMYa6Sden6dv3pjIkK3XiT71zAVbeiZJQ7cooLA
         iKPBSzCaRzqYsXCzVuv9INrR7qrRPRUAt7fsY=
Subject: Re: [PATCH 08/12] perf: export some syscall metadata
From: Tom Zanussi <tzanussi@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
In-Reply-To: <20100223214445.GF5357@nowhere>
References: <1264580883-15324-1-git-send-email-tzanussi@gmail.com>
	 <1264580883-15324-9-git-send-email-tzanussi@gmail.com>
	 <20100223214445.GF5357@nowhere>
Content-Type: text/plain
Date: Wed, 24 Feb 2010 00:00:43 -0600
Message-Id: <1266991243.6427.44.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-23 at 22:44 +0100, Frederic Weisbecker wrote:
> On Wed, Jan 27, 2010 at 02:27:59AM -0600, Tom Zanussi wrote:
> > Create and export a list of syscall_nr:syscall_name pairs from the
> > data in the syscalls_metadata, for use initially by perf trace.
> > 
> > Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> 
> 
> 
> I would have much more preferred we inject a kind of "syscall_map"
> event for that. Unfortunately the event injection is still
> in discussion and not yet ready.
> 
> 
> I guess we can take this temporary solution and remove that
> later in profit of injected events. It means we'll need to
> keep support for that file though.
> 
> 
> Hmm...
> 

You can skip the syscall metadata patches (7-11) and things will still
work - you'll just get syscall numbers in the output instead of the
nicer syscall names.

When the event injection stuff is ready, I can re-implement those
patches on top of it - it shouldn't be a big deal.

Re event injection - I don't know that much about it, but if it can be
used for this, could it also be applied to the rest of the trace and
header data too?  If so, that would enable 'live mode' tracing.  I
already have a working prototype that does it by converting all those
things into synthesized pseudo-events, but it would be nicer to use the
event injection framework instead, if I understand it correctly...

Tom

> 
> 
> > ---
> >  kernel/trace/trace_syscalls.c |   87 +++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 87 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> > index f6b0712..e037486 100644
> > --- a/kernel/trace/trace_syscalls.c
> > +++ b/kernel/trace/trace_syscalls.c
> > @@ -626,5 +626,92 @@ void prof_sysexit_disable(struct ftrace_event_call *call)
> >  	mutex_unlock(&syscall_trace_lock);
> >  }
> >  
> > +struct syscall_metadata **meta_skip(struct syscall_metadata **meta,
> > +				    loff_t *pos)
> > +{
> > +	struct syscall_metadata **end = syscalls_metadata + NR_syscalls;
> > +
> > +	do {
> > +		meta++;
> > +		(*pos)++;
> > +	} while (meta < end && *meta == NULL);
> > +
> > +	if (meta >= end)
> > +		meta = NULL;
> > +
> > +	return meta;
> > +}
> > +
> > +static void *syscall_map_start(struct seq_file *s, loff_t *pos)
> > +{
> > +	struct syscall_metadata **end = syscalls_metadata + NR_syscalls;
> > +	struct syscall_metadata **meta = syscalls_metadata + *pos;
> > +
> > +	if (meta >= end)
> > +		return NULL;
> > +
> > +	if (*meta == NULL)
> > +		meta = meta_skip(meta, pos);
> > +
> > +	return meta;
> > +}
> > +
> > +static void *syscall_map_next(struct seq_file *s, void *v, loff_t *pos)
> > +{
> > +	(*pos)++;
> > +
> > +	return syscall_map_start(s, pos);
> > +}
> > +
> > +static int syscall_map_show(struct seq_file *s, void *v)
> > +{
> > +	const struct syscall_metadata **meta = v;
> > +	const struct syscall_metadata *m = *meta;
> > +
> > +	seq_printf(s, "%d:", m->syscall_nr);
> > +	seq_printf(s, "%s\n", m->name);
> > +
> > +	return 0;
> > +}
> > +
> > +static void syscall_map_stop(struct seq_file *m, void *p)
> > +{
> > +}
> > +
> > +static const struct seq_operations show_syscall_map_seq_ops = {
> > +	.start = syscall_map_start,
> > +	.next = syscall_map_next,
> > +	.show = syscall_map_show,
> > +	.stop = syscall_map_stop,
> > +};
> > +
> > +static int syscall_map_open(struct inode *inode, struct file *file)
> > +{
> > +	return seq_open(file, &show_syscall_map_seq_ops);
> > +}
> > +
> > +static const struct file_operations syscall_map_fops = {
> > +	.open = syscall_map_open,
> > +	.read = seq_read,
> > +	.llseek = seq_lseek,
> > +	.release = seq_release,
> > +};
> > +
> > +static __init int init_syscall_map(void)
> > +{
> > +	struct dentry *d_tracer;
> > +
> > +	d_tracer = tracing_init_dentry();
> > +	if (!d_tracer)
> > +		return 0;
> > +
> > +	trace_create_file("syscall_map", 0444, d_tracer,
> > +			  NULL, &syscall_map_fops);
> > +
> > +	return 0;
> > +}
> > +
> > +fs_initcall(init_syscall_map);
> > +
> >  #endif /* CONFIG_PERF_EVENTS */
> >  
> > -- 
> > 1.6.4.GIT
> > 
> 

