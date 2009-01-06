Return-Path: <linux-kernel-owner+w=401wt.eu-S1752221AbZAFAav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbZAFAav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 19:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750730AbZAFAan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 19:30:43 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:25268 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbZAFAam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 19:30:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UeOjVUuj/pYPfF2AMZqN17Ub1M/AlLp997KAzZKY5th+IOJX2IHVwzzAeDqPMjIk1e
         zrm8MGC3Bgca3sBSPoAq0O6TBqfA2QEwSpucBRkyUkmHcCo67+BzhOsAQnqrgPIAGjQO
         +FwZXGpylhWQMaMPUQs0xIKfOXgvv57i5nQzY=
Date: Tue, 6 Jan 2009 01:30:36 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH 1/2] tracing/ftrace: handle more than one stat file per
	tracer
Message-ID: <20090106003035.GD6531@nowhere>
References: <495b9305.0405560a.0ec4.29c0@mx.google.com> <alpine.DEB.1.10.0901051546450.25066@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901051546450.25066@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 03:53:38PM -0500, Steven Rostedt wrote:
> 
> On Wed, 31 Dec 2008, Frederic Weisbecker wrote:
> 
> > Impact: new API for tracers
> > 
> > Make the stat tracing API reentrant. And also provide the new directory
> > /debugfs/tracing/trace_stat which will contain all the stat files for the
> > current active tracer.
> > 
> > Now a tracer will, if desired, want to provide a zero terminated array of
> > tracer_stat structures.
> > Each one contains the callbacks necessary for one stat file.
> > It have to provide at least a name for its stat file, an iterator with
> > stat_start/start_next callback and an output callback for one stat entry.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> > diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> > index 46677ea..b093f36 100644
> > --- a/kernel/trace/trace.h
> > +++ b/kernel/trace/trace.h
> > @@ -335,6 +335,25 @@ struct tracer_flags {
> >  #define TRACER_OPT(s, b)	.name = #s, .bit = b
> >  
> >  /*
> > + * If you want to provide a stat file (one-shot statistics), fill
> > + * an iterator with stat_start/stat_next and a stat_show callbacks.
> > + * The others callbacks are optional.
> > + */
> > +struct tracer_stat {
> > +	/* The name of your stat file */
> > +	const char		*name;
> > +	/* Iteration over statistic entries */
> > +	void			*(*stat_start)(void);
> > +	void			*(*stat_next)(void *prev, int idx);
> > +	/* Compare two entries for sorting (optional) for stats */
> > +	int			(*stat_cmp)(void *p1, void *p2);
> > +	/* Print a stat entry */
> > +	int			(*stat_show)(struct seq_file *s, void *p);
> > +	/* Print the headers of your stat entries */
> > +	int			(*stat_headers)(struct seq_file *s);
> > +};
> > +
> > +/*
> >   * A specific tracer, represented by methods that operate on a trace array:
> >   */
> >  struct tracer {
> > @@ -361,21 +380,7 @@ struct tracer {
> >  	struct tracer		*next;
> >  	int			print_max;
> >  	struct tracer_flags 	*flags;
> > -
> > -	/*
> > -	 * If you change one of the following on tracing runtime, recall
> > -	 * init_tracer_stat()
> > -	 */
> > -
> > -	/* Iteration over statistic entries */
> > -	void			*(*stat_start)(void);
> > -	void			*(*stat_next)(void *prev, int idx);
> > -	/* Compare two entries for sorting (optional) for stats */
> > -	int			(*stat_cmp)(void *p1, void *p2);
> > -	/* Print a stat entry */
> > -	int			(*stat_show)(struct seq_file *s, void *p);
> > -	/* Print the headers of your stat entries */
> > -	int			(*stat_headers)(struct seq_file *s);
> > +	struct tracer_stat	*stats;
> >  };
> >  
> >  struct trace_seq {
> > diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
> > index 6f194a3..293be1c 100644
> > --- a/kernel/trace/trace_stat.c
> > +++ b/kernel/trace/trace_stat.c
> > @@ -21,31 +21,29 @@ struct trace_stat_list {
> >  	void *stat;
> >  };
> >  
> > -static struct trace_stat_list stat_list;
> > +/* A stat session is the stats output in one file */
> > +struct tracer_stat_session {
> > +	struct tracer_stat *ts;
> > +	struct trace_stat_list	stat_list;
> > +	struct mutex stat_mutex;
> > +};
> >  
> > -/*
> > - * This is a copy of the current tracer to avoid racy
> > - * and dangerous output while the current tracer is
> > - * switched.
> > - */
> > -static struct tracer current_tracer;
> > -
> > -/*
> > - * Protect both the current tracer and the global
> > - * stat list.
> > - */
> > -static DEFINE_MUTEX(stat_list_mutex);
> > +/* All of the sessions currently in use. Each stat file embeed one session */
> > +static struct tracer_stat_session **all_stat_sessions;
> > +static int nb_sessions;
> > +static struct dentry *stat_dir, **stat_files;
> >  
> >  
> > -static void reset_stat_list(void)
> > +static void reset_stat_session(struct tracer_stat_session *session)
> >  {
> > +	struct trace_stat_list *root = &session->stat_list;
> >  	struct trace_stat_list *node;
> >  	struct list_head *next;
> >  
> > -	if (list_empty(&stat_list.list))
> > +	if (list_empty(&root->list))
> >  		return;
> >  
> > -	node = list_entry(stat_list.list.next, struct trace_stat_list, list);
> > +	node = list_entry(root->list.next, struct trace_stat_list, list);
> >  	next = node->list.next;
> >  
> >  	while (&node->list != next) {
> > @@ -54,14 +52,65 @@ static void reset_stat_list(void)
> >  	}
> >  	kfree(node);
> >  
> > -	INIT_LIST_HEAD(&stat_list.list);
> > +	INIT_LIST_HEAD(&root->list);
> >  }
> >  
> > -void init_tracer_stat(struct tracer *trace)
> > +/* Called when a tracer is initialized */
> > +static int init_all_sessions(int nb, struct tracer_stat *ts)
> > +{
> > +	int i, j;
> > +	struct tracer_stat_session *session;
> > +
> > +	if (all_stat_sessions) {
> > +		for (i = 0; i < nb_sessions; i++) {
> > +			session = all_stat_sessions[i];
> > +			reset_stat_session(session);
> > +			mutex_destroy(&session->stat_mutex);
> > +			kfree(session);
> > +		}
> > +	}
> > +	all_stat_sessions = kmalloc(sizeof(struct tracer_stat_session *) * nb,
> > +				    GFP_KERNEL);
> 
> You want this to be kzalloc.
> 
> > +	if (!all_stat_sessions)
> > +		return -ENOMEM;
> > +
> > +	for (i = 0; i < nb; i++) {
> > +		session = kmalloc(sizeof(struct tracer_stat_session) * nb,
> > +				  GFP_KERNEL);
> 
> Not so important, but you probably want to do it here too.
> 
> > +		if (!session)
> > +			goto free_sessions;
> > +
> > +		INIT_LIST_HEAD(&session->stat_list.list);
> > +		mutex_init(&session->stat_mutex);
> > +		session->ts = &ts[i];
> > +		all_stat_sessions[i] = session;
> > +	}
> > +	nb_sessions = nb;
> > +	return 0;
> > +
> > +free_sessions:
> > +
> > +	for (j = 0; j < i; j++)
> > +		kfree(all_stat_sessions[i]);
> 
> With out the kzalloc above, this may crash the kernel, because
> all_stat_sessions[i] might not be NULL when they were not initialized.


I'm not sure. j will not go through indexes of rooms that weren't allocated.

 
> > +
> > +	kfree(all_stat_sessions);
> > +	all_stat_sessions = NULL;
> > +
> > +	return -ENOMEM;
> > +}
> > +
> > +static int basic_tracer_stat_checks(struct tracer_stat *ts)
> >  {
> > -	mutex_lock(&stat_list_mutex);
> > -	current_tracer = *trace;
> > -	mutex_unlock(&stat_list_mutex);
> > +	int i;
> > +
> > +	if (!ts)
> > +		return 0;
> > +
> > +	for (i = 0; ts[i].name; i++) {
> > +		if (!ts[i].stat_start || !ts[i].stat_next || !ts[i].stat_show)
> > +			return -EBUSY;
> > +	}
> > +	return i;
> >  }
> >  
> >  /*
> > @@ -79,22 +128,19 @@ static int dummy_cmp(void *p1, void *p2)
> >   * All of these copies and sorting are required on all opening
> >   * since the stats could have changed between two file sessions.
> >   */
> > -static int stat_seq_init(void)
> > +static int stat_seq_init(struct tracer_stat_session *session)
> >  {
> > -	struct trace_stat_list *iter_entry, *new_entry;
> > +	struct trace_stat_list *iter_entry, *new_entry, *root;
> > +	struct tracer_stat *ts = session->ts;
> >  	void *prev_stat;
> >  	int ret = 0;
> >  	int i;
> >  
> > -	mutex_lock(&stat_list_mutex);
> > -	reset_stat_list();
> > -
> > -	if (!current_tracer.stat_start || !current_tracer.stat_next ||
> > -					!current_tracer.stat_show)
> > -		goto exit;
> > +	mutex_lock(&session->stat_mutex);
> > +	reset_stat_session(session);
> >  
> > -	if (!current_tracer.stat_cmp)
> > -		current_tracer.stat_cmp = dummy_cmp;
> > +	if (!ts->stat_cmp)
> > +		ts->stat_cmp = dummy_cmp;
> >  
> >  	/*
> >  	 * The first entry. Actually this is the second, but the first
> > @@ -107,8 +153,9 @@ static int stat_seq_init(void)
> >  	}
> >  
> >  	INIT_LIST_HEAD(&new_entry->list);
> > -	list_add(&new_entry->list, &stat_list.list);
> > -	new_entry->stat = current_tracer.stat_start();
> > +	root = &session->stat_list;
> > +	list_add(&new_entry->list, &root->list);
> > +	new_entry->stat = ts->stat_start();
> >  
> >  	prev_stat = new_entry->stat;
> >  
> > @@ -124,15 +171,15 @@ static int stat_seq_init(void)
> >  		}
> >  
> >  		INIT_LIST_HEAD(&new_entry->list);
> > -		new_entry->stat = current_tracer.stat_next(prev_stat, i);
> > +		new_entry->stat = ts->stat_next(prev_stat, i);
> >  
> >  		/* End of insertion */
> >  		if (!new_entry->stat)
> >  			break;
> >  
> > -		list_for_each_entry(iter_entry, &stat_list.list, list) {
> > +		list_for_each_entry(iter_entry, &root->list, list) {
> >  			/* Insertion with a descendent sorting */
> > -			if (current_tracer.stat_cmp(new_entry->stat,
> > +			if (ts->stat_cmp(new_entry->stat,
> >  						iter_entry->stat) > 0) {
> >  
> >  				list_add_tail(&new_entry->list,
> > @@ -141,7 +188,7 @@ static int stat_seq_init(void)
> >  
> >  			/* The current smaller value */
> >  			} else if (list_is_last(&iter_entry->list,
> > -						&stat_list.list)) {
> > +						&root->list)) {
> >  				list_add(&new_entry->list, &iter_entry->list);
> >  				break;
> >  			}
> > @@ -150,46 +197,49 @@ static int stat_seq_init(void)
> >  		prev_stat = new_entry->stat;
> >  	}
> >  exit:
> > -	mutex_unlock(&stat_list_mutex);
> > +	mutex_unlock(&session->stat_mutex);
> >  	return ret;
> >  
> >  exit_free_list:
> > -	reset_stat_list();
> > -	mutex_unlock(&stat_list_mutex);
> > +	reset_stat_session(session);
> > +	mutex_unlock(&session->stat_mutex);
> >  	return ret;
> >  }
> >  
> >  
> >  static void *stat_seq_start(struct seq_file *s, loff_t *pos)
> >  {
> > -	struct trace_stat_list *l = (struct trace_stat_list *)s->private;
> > +	struct tracer_stat_session *session = s->private;
> >  
> >  	/* Prevent from tracer switch or stat_list modification */
> > -	mutex_lock(&stat_list_mutex);
> > +	mutex_lock(&session->stat_mutex);
> >  
> >  	/* If we are in the beginning of the file, print the headers */
> > -	if (!*pos && current_tracer.stat_headers)
> > -		current_tracer.stat_headers(s);
> > +	if (!*pos && session->ts->stat_headers)
> 
> Hmm, looks like you do need the kzalloc for both allocs above.
> 
> -- Steve


There is no check about -ENOMEM before creating the debugfs file.
So yes, I should check it before dereferencing a session, or more likely
not create the debugfs files in this case. But I don't know why kzalloc...



> 
> > +		session->ts->stat_headers(s);
> >  
> > -	return seq_list_start(&l->list, *pos);
> > +	return seq_list_start(&session->stat_list.list, *pos);
> >  }
> >  
> >  static void *stat_seq_next(struct seq_file *s, void *p, loff_t *pos)
> >  {
> > -	struct trace_stat_list *l = (struct trace_stat_list *)s->private;
> > +	struct tracer_stat_session *session = s->private;
> >  
> > -	return seq_list_next(p, &l->list, pos);
> > +	return seq_list_next(p, &session->stat_list.list, pos);
> >  }
> >  
> > -static void stat_seq_stop(struct seq_file *m, void *p)
> > +static void stat_seq_stop(struct seq_file *s, void *p)
> >  {
> > -	mutex_unlock(&stat_list_mutex);
> > +	struct tracer_stat_session *session = s->private;
> > +	mutex_unlock(&session->stat_mutex);
> >  }
> >  
> >  static int stat_seq_show(struct seq_file *s, void *v)
> >  {
> > +	struct tracer_stat_session *session = s->private;
> >  	struct trace_stat_list *l = list_entry(v, struct trace_stat_list, list);
> > -	return current_tracer.stat_show(s, l->stat);
> > +
> > +	return session->ts->stat_show(s, l->stat);
> >  }
> >  
> >  static const struct seq_operations trace_stat_seq_ops = {
> > @@ -199,15 +249,18 @@ static const struct seq_operations trace_stat_seq_ops = {
> >  	.show = stat_seq_show
> >  };
> >  
> > +/* The session stat is refilled and resorted at each stat file opening */
> >  static int tracing_stat_open(struct inode *inode, struct file *file)
> >  {
> >  	int ret;
> >  
> > +	struct tracer_stat_session *session = inode->i_private;
> > +
> >  	ret = seq_open(file, &trace_stat_seq_ops);
> >  	if (!ret) {
> >  		struct seq_file *m = file->private_data;
> > -		m->private = &stat_list;
> > -		ret = stat_seq_init();
> > +		m->private = session;
> > +		ret = stat_seq_init(session);
> >  	}
> >  
> >  	return ret;
> > @@ -219,9 +272,11 @@ static int tracing_stat_open(struct inode *inode, struct file *file)
> >   */
> >  static int tracing_stat_release(struct inode *i, struct file *f)
> >  {
> > -	mutex_lock(&stat_list_mutex);
> > -	reset_stat_list();
> > -	mutex_unlock(&stat_list_mutex);
> > +	struct tracer_stat_session *session = i->i_private;
> > +
> > +	mutex_lock(&session->stat_mutex);
> > +	reset_stat_session(session);
> > +	mutex_unlock(&session->stat_mutex);
> >  	return 0;
> >  }
> >  
> > @@ -232,18 +287,70 @@ static const struct file_operations tracing_stat_fops = {
> >  	.release	= tracing_stat_release
> >  };
> >  
> > +
> > +static void destroy_trace_stat_files(void)
> > +{
> > +	int i;
> > +
> > +	if (stat_files) {
> > +		for (i = 0; i < nb_sessions; i++)
> > +			debugfs_remove(stat_files[i]);
> > +		kfree(stat_files);
> > +		stat_files = NULL;
> > +	}
> > +}
> > +
> > +static void init_trace_stat_files(void)
> > +{
> > +	int i;
> > +
> > +	if (!stat_dir || !nb_sessions)
> > +		return;
> > +
> > +	stat_files = kmalloc(sizeof(struct dentry *) * nb_sessions, GFP_KERNEL);
> > +
> > +	if (!stat_files) {
> > +		pr_warning("trace stat: not enough memory\n");
> > +		return;
> > +	}
> > +
> > +	for (i = 0; i < nb_sessions; i++) {
> > +		struct tracer_stat_session *session = all_stat_sessions[i];
> > +		stat_files[i] = debugfs_create_file(session->ts->name, 0644,
> > +						stat_dir,
> > +						session, &tracing_stat_fops);
> > +		if (!stat_files[i])
> > +			pr_warning("cannot create %s entry\n",
> > +				   session->ts->name);
> > +	}
> > +}
> > +
> > +void init_tracer_stat(struct tracer *trace)
> > +{
> > +	int nb = basic_tracer_stat_checks(trace->stats);
> > +
> > +	destroy_trace_stat_files();
> > +
> > +	if (nb < 0) {
> > +		pr_warning("stat tracing: missing stat callback on %s\n",
> > +			   trace->name);
> > +		return;
> > +	}
> > +	if (!nb)
> > +		return;
> > +
> > +	init_all_sessions(nb, trace->stats);
> > +	init_trace_stat_files();
> > +}
> > +
> >  static int __init tracing_stat_init(void)
> >  {
> >  	struct dentry *d_tracing;
> > -	struct dentry *entry;
> >  
> > -	INIT_LIST_HEAD(&stat_list.list);
> >  	d_tracing = tracing_init_dentry();
> >  
> > -	entry = debugfs_create_file("trace_stat", 0444, d_tracing,
> > -					NULL,
> > -				    &tracing_stat_fops);
> > -	if (!entry)
> > +	stat_dir = debugfs_create_dir("trace_stat", d_tracing);
> > +	if (!stat_dir)
> >  		pr_warning("Could not create debugfs "
> >  			   "'trace_stat' entry\n");
> >  	return 0;
> > -- 
> > 1.6.0.4
> > 
> > 
> > 
> > 

