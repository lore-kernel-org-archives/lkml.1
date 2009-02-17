Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbZBQSyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbZBQSyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 13:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbZBQSyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 13:54:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63641 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbZBQSyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:54:00 -0500
Date: Tue, 17 Feb 2009 13:53:58 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 10/15] ftrace: trace different functions with a different
 tracer
In-Reply-To: <20090217184554.GH6761@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.1.10.0902171353180.14430@gandalf.stny.rr.com>
References: <20090217051227.957864159@goodmis.org> <20090217051407.035764950@goodmis.org> <20090217184554.GH6761@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 17 Feb 2009, Paul E. McKenney wrote:
> > This will unregister all functions matching glob that has an entry
> > pointing to ops.
> > 
> >   void unregister_ftrace_function_hook_all(char *glob)
> > 
> > This simply unregisters all funcs.
> 
> Looks like a nice addition!
> 
> One RCU type mismatch called out below.
> 
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> > ---
> >  include/linux/ftrace.h |   18 ++++
> >  kernel/trace/ftrace.c  |  247 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 265 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> > index f0a0ecc..13918c4 100644
> > --- a/include/linux/ftrace.h
> > +++ b/include/linux/ftrace.h
> > @@ -106,6 +106,24 @@ struct ftrace_func_command {
> >  /* asm/ftrace.h must be defined for archs supporting dynamic ftrace */
> >  #include <asm/ftrace.h>
> 
> [ . . . ]
> 
> > +
> > +static void
> > +__unregister_ftrace_function_hook(char *glob, struct ftrace_hook_ops *ops,
> > +				  void *data, int flags)
> > +{
> > +	struct ftrace_func_hook *entry;
> > +	struct hlist_node *n, *tmp;
> > +	char str[KSYM_SYMBOL_LEN];
> > +	int type = MATCH_FULL;
> > +	int i, len = 0;
> > +	char *search;
> > +
> > +	if (glob && (strcmp(glob, "*") || !strlen(glob)))
> > +		glob = NULL;
> > +	else {
> > +		int not;
> > +
> > +		type = ftrace_setup_glob(glob, strlen(glob), &search, &not);
> > +		len = strlen(search);
> > +
> > +		/* we do not support '!' for function hooks */
> > +		if (WARN_ON(not))
> > +			return;
> > +	}
> > +
> > +	mutex_lock(&ftrace_lock);
> > +	for (i = 0; i < FTRACE_FUNC_HASHSIZE; i++) {
> > +		struct hlist_head *hhd = &ftrace_func_hash[i];
> > +
> > +		hlist_for_each_entry_safe(entry, n, tmp, hhd, node) {
> > +
> > +			/* break up if statements for readability */
> > +			if ((flags & HOOK_TEST_FUNC) && entry->ops != ops)
> > +				continue;
> > +
> > +			if ((flags & HOOK_TEST_DATA) && entry->data != data)
> > +				continue;
> > +
> > +			/* do this last, since it is the most expensive */
> > +			if (glob) {
> > +				kallsyms_lookup(entry->ip, NULL, NULL,
> > +						NULL, str);
> > +				if (!ftrace_match(str, glob, len, type))
> > +					continue;
> > +			}
> > +
> > +			hlist_del(&entry->node);
> > +			call_rcu(&entry->rcu, ftrace_free_entry_rcu);
> 
> This should be call_rcu_sched() to match the preemption disabling.

Thanks! I should have CC'd you on that. I thought that was not right.
Will fix.

-- Steve

> 
> > +		}
> > +	}
> > +	__disable_ftrace_function_hook();
> > +	mutex_unlock(&ftrace_lock);
> > +}
> 
> 
