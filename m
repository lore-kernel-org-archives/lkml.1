Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbYGXUai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbYGXUai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 16:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbYGXUaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 16:30:30 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:35428 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751270AbYGXUa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 16:30:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EADiCiEhMRKxB/2dsb2JhbACBWrBr
Date: Thu, 24 Jul 2008 16:30:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 02/17] Kernel Tracepoints
Message-ID: <20080724203027.GB23818@Krystal>
References: <20080715222604.331269462@polymtl.ca> <20080715222746.361289615@polymtl.ca> <Pine.LNX.4.58.0807241132470.14946@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0807241132470.14946@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:28:14 up 50 days,  1:09,  4 users,  load average: 0.11, 0.35,
	0.59
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> 
> On Tue, 15 Jul 2008, Mathieu Desnoyers wrote:
> > +static void *
> > +tracepoint_entry_remove_probe(struct tracepoint_entry *entry, void *probe)
> > +{
> > +	int nr_probes = 0, nr_del = 0, i;
> > +	void **old, **new;
> > +
> > +	old = entry->funcs;
> > +
> > +	debug_print_probes(entry);
> > +	/* (N -> M), (N > 1, M >= 0) probes */
> > +	for (nr_probes = 0; old[nr_probes]; nr_probes++) {
> > +		if ((!probe || old[nr_probes] == probe))
> > +			nr_del++;
> > +	}
> > +
> > +	if (nr_probes - nr_del == 0) {
> > +		/* N -> 0, (N > 1) */
> > +		entry->funcs = NULL;
> > +		entry->refcount = 0;
> > +		debug_print_probes(entry);
> > +		return old;
> > +	} else {
> > +		int j = 0;
> > +		/* N -> M, (N > 1, M > 0) */
> > +		/* + 1 for NULL */
> > +		new = kzalloc((nr_probes - nr_del + 1)
> > +			* sizeof(void *), GFP_KERNEL);
> > +		if (new == NULL)
> > +			return ERR_PTR(-ENOMEM);
> 
> Hmm, on failure of allocating a new array, we could simply use the
> old array, and remove the one probe from it instead of just failing.
> 

Nay, because of RCU constraints. So we have the readers in the current
RCU window who need to see the old version, and readers of the following
window who need to see the next version. Both can live at the same time
on the system. We cannot reuse the same memory to perform the array
shrink without corrupting the data seen by the previous readers. We
really have to perform a copy here.

Mathieu


> -- Steve
> 
> > +		for (i = 0; old[i]; i++)
> > +			if ((probe && old[i] != probe))
> > +				new[j++] = old[i];
> > +		entry->refcount = nr_probes - nr_del;
> > +		entry->funcs = new;
> > +	}
> > +	debug_print_probes(entry);
> > +	return old;
> > +}
> > +

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
