Return-Path: <linux-kernel-owner+w=401wt.eu-S1763093AbZCYPn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763093AbZCYPn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 11:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758143AbZCYPns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 11:43:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40748 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055AbZCYPnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 11:43:47 -0400
Date: Wed, 25 Mar 2009 11:43:44 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/5][RFC] tracing: move function profiler data out of
 function struct
In-Reply-To: <20090325100746.GI2341@elte.hu>
Message-ID: <alpine.DEB.2.00.0903251142470.5675@gandalf.stny.rr.com>
References: <20090325035646.662994901@goodmis.org> <20090325040832.443420395@goodmis.org> <20090325100746.GI2341@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Mar 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > +/* Interrupts must be disabled calling this */
> > +static struct ftrace_profile *
> > +ftrace_profile_alloc(unsigned long ip, bool alloc_safe)
> > +{
> > +	struct ftrace_profile *rec = NULL;
> > +
> > +	/* prevent recursion */
> > +	if (atomic_inc_return(&__get_cpu_var(ftrace_profile_disable)) != 1)
> > +		goto out;
> > +
> > +	__raw_spin_lock(&ftrace_profile_rec_lock);
> > +
> > +	/* Try to always keep another page available */
> > +	if (!profile_pages->next && alloc_safe)
> > +		profile_pages->next = (void *)get_zeroed_page(GFP_ATOMIC);
> 
> this does not seem to be NMI safe.

The atomic_inc_return protects against NMIs, since this is the only place 
the lock is taken.

> 
> This all would be solved much more robustly by the function 
> attributes hash approach i suggested in the previous mail. If 
> percpu_alloc() is done for 20,000 functions the memory allocation 
> overhead is no big deal.

Later patches create a per-cpu buffers and removes the lock.

-- Steve

