Return-Path: <linux-kernel-owner+w=401wt.eu-S1753969AbYGCPaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbYGCPaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 11:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYGCPaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 11:30:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbYGCPaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 11:30:10 -0400
Message-ID: <486CEFDB.7070508@redhat.com>
Date: Thu, 03 Jul 2008 11:27:23 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       "'Alexey Dobriyan'" <adobriyan@gmail.com>,
       "'Peter Zijlstra'" <peterz@infradead.org>,
       "'Steven Rostedt'" <rostedt@goodmis.org>,
       "'Frank Ch. Eigler'" <fche@redhat.com>, "'Ingo Molnar'" <mingo@elte.hu>,
       "'LKML'" <linux-kernel@vger.kernel.org>,
       "'systemtap-ml'" <systemtap@sources.redhat.com>,
       "'Hideo AOKI'" <haoki@redhat.com>
Subject: Re: [RFC PATCH] Kernel Tracepoints (update)
References: <007601c8d5ca$18fa0e10$4aee2a30$@css.fujitsu.com> <48611B03.1000003@redhat.com> <20080625011951.D83E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48612879.5090809@redhat.com> <20080625235214.GA14249@Krystal> <486403F0.4020801@redhat.com> <20080627133622.GA15210@Krystal>
In-Reply-To: <20080627133622.GA15210@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

I found a bug.
Mathieu Desnoyers wrote:
[...]

> +/*
> + * Remove the tracepoint from the tracepoint hash table. Must be called with
> + * mutex_lock held.
> + */
> +static int remove_tracepoint(const char *name)
> +{
> +	struct hlist_head *head;
> +	struct hlist_node *node;
> +	struct tracepoint_entry *e;
> +	int found = 0;
> +	size_t len = strlen(name) + 1;
> +	u32 hash = jhash(name, len-1, 0);
> +
> +	head = &tracepoint_table[hash & ((1 << TRACEPOINT_HASH_BITS)-1)];
> +	hlist_for_each_entry(e, node, head, hlist) {
> +		if (!strcmp(name, e->name)) {
> +			found = 1;
> +			break;
> +		}
> +	}
> +	if (!found)
> +		return -ENOENT;

before removing, you have to ensure refcount == 0. So,
	if (e->refcount != 0)
		return -EBUSY;

> +	hlist_del(&e->hlist);
> +	/* Make sure the call_rcu has been executed */
> +	if (e->rcu_pending)
> +		rcu_barrier();
> +	kfree(e);
> +	return 0;
> +}

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

