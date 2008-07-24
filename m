Return-Path: <linux-kernel-owner+w=401wt.eu-S1751459AbYGXPfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbYGXPfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYGXPet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:34:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34565 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbYGXPes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:34:48 -0400
Date: Thu, 24 Jul 2008 11:34:46 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 02/17] Kernel Tracepoints
In-Reply-To: <20080715222746.361289615@polymtl.ca>
Message-ID: <Pine.LNX.4.58.0807241132470.14946@gandalf.stny.rr.com>
References: <20080715222604.331269462@polymtl.ca> <20080715222746.361289615@polymtl.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Mathieu Desnoyers wrote:
> +static void *
> +tracepoint_entry_remove_probe(struct tracepoint_entry *entry, void *probe)
> +{
> +	int nr_probes = 0, nr_del = 0, i;
> +	void **old, **new;
> +
> +	old = entry->funcs;
> +
> +	debug_print_probes(entry);
> +	/* (N -> M), (N > 1, M >= 0) probes */
> +	for (nr_probes = 0; old[nr_probes]; nr_probes++) {
> +		if ((!probe || old[nr_probes] == probe))
> +			nr_del++;
> +	}
> +
> +	if (nr_probes - nr_del == 0) {
> +		/* N -> 0, (N > 1) */
> +		entry->funcs = NULL;
> +		entry->refcount = 0;
> +		debug_print_probes(entry);
> +		return old;
> +	} else {
> +		int j = 0;
> +		/* N -> M, (N > 1, M > 0) */
> +		/* + 1 for NULL */
> +		new = kzalloc((nr_probes - nr_del + 1)
> +			* sizeof(void *), GFP_KERNEL);
> +		if (new == NULL)
> +			return ERR_PTR(-ENOMEM);

Hmm, on failure of allocating a new array, we could simply use the
old array, and remove the one probe from it instead of just failing.

-- Steve

> +		for (i = 0; old[i]; i++)
> +			if ((probe && old[i] != probe))
> +				new[j++] = old[i];
> +		entry->refcount = nr_probes - nr_del;
> +		entry->funcs = new;
> +	}
> +	debug_print_probes(entry);
> +	return old;
> +}
> +
