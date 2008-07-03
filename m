Return-Path: <linux-kernel-owner+w=401wt.eu-S1753686AbYGCPr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbYGCPr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 11:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbYGCPrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 11:47:18 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:39729 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751433AbYGCPrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 11:47:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap0EABiObEhMQWVt/2dsb2JhbACBW7A4
Date: Thu, 3 Jul 2008 11:47:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       "'Alexey Dobriyan'" <adobriyan@gmail.com>,
       "'Peter Zijlstra'" <peterz@infradead.org>,
       "'Steven Rostedt'" <rostedt@goodmis.org>,
       "'Frank Ch. Eigler'" <fche@redhat.com>, "'Ingo Molnar'" <mingo@elte.hu>,
       "'LKML'" <linux-kernel@vger.kernel.org>,
       "'systemtap-ml'" <systemtap@sources.redhat.com>,
       "'Hideo AOKI'" <haoki@redhat.com>
Subject: Re: [RFC PATCH] Kernel Tracepoints (update)
Message-ID: <20080703154715.GB3102@Krystal>
References: <007601c8d5ca$18fa0e10$4aee2a30$@css.fujitsu.com> <48611B03.1000003@redhat.com> <20080625011951.D83E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48612879.5090809@redhat.com> <20080625235214.GA14249@Krystal> <486403F0.4020801@redhat.com> <20080627133622.GA15210@Krystal> <486CEFDB.7070508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <486CEFDB.7070508@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:43:16 up 28 days, 20:24,  4 users,  load average: 0.31, 0.85,
	0.96
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Hi Mathieu,
> 
> I found a bug.
> Mathieu Desnoyers wrote:
> [...]
> 
> > +/*
> > + * Remove the tracepoint from the tracepoint hash table. Must be called with
> > + * mutex_lock held.
> > + */
> > +static int remove_tracepoint(const char *name)
> > +{
> > +	struct hlist_head *head;
> > +	struct hlist_node *node;
> > +	struct tracepoint_entry *e;
> > +	int found = 0;
> > +	size_t len = strlen(name) + 1;
> > +	u32 hash = jhash(name, len-1, 0);
> > +
> > +	head = &tracepoint_table[hash & ((1 << TRACEPOINT_HASH_BITS)-1)];
> > +	hlist_for_each_entry(e, node, head, hlist) {
> > +		if (!strcmp(name, e->name)) {
> > +			found = 1;
> > +			break;
> > +		}
> > +	}
> > +	if (!found)
> > +		return -ENOENT;
> 
> before removing, you have to ensure refcount == 0. So,
> 	if (e->refcount != 0)
> 		return -EBUSY;
> 

Ah, right, I had


        if (e->single.func != __mark_empty_function)
                return -EBUSY;

in the markers to test this and did not replace this test.

Thanks,

Mathieu

> > +	hlist_del(&e->hlist);
> > +	/* Make sure the call_rcu has been executed */
> > +	if (e->rcu_pending)
> > +		rcu_barrier();
> > +	kfree(e);
> > +	return 0;
> > +}
> 
> Thank you,
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
