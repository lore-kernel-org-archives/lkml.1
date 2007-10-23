Return-Path: <linux-kernel-owner+w=401wt.eu-S1753339AbXJWPLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbXJWPLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 11:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbXJWPLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 11:11:08 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:37546 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbXJWPLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:11:07 -0400
Date: Tue, 23 Oct 2007 11:10:20 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, Daniel Walker <dwalker@mvista.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC/PATCH 3/5] rt: plist_head_splice
In-Reply-To: <20071023120745.122724000@chello.nl>
Message-ID: <Pine.LNX.4.58.0710231108050.31159@gandalf.stny.rr.com>
References: <20071023120357.782284000@chello.nl> <20071023120745.122724000@chello.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Tue, 23 Oct 2007, Peter Zijlstra wrote:
> +
> +void plist_head_splice(struct plist_head *src, struct plist_head *dst)
> +{
> +	struct plist_node *src_iter_first, *src_iter_last, *dst_iter;
> +	struct plist_node *tail = container_of(dst, struct plist_node, plist);
> +
> +	dst_iter = next_prio(tail);
> +
> +	while (!plist_head_empty(src) && dst_iter != tail) {
> +		src_iter_first = plist_first(src);
> +
> +		src_iter_last = next_prio(src_iter_first);
> +		src_iter_last = prev_node(src_iter_last);
> +
> +		WARN_ON(src_iter_first->prio != src_iter_last->prio);
> +		WARN_ON(list_empty(&src_iter_first->plist.prio_list));
> +
> +		while (src_iter_first->prio > dst_iter->prio) {
> +			dst_iter = next_prio(dst_iter);
> +			if (dst_iter == tail)
> +				goto tail;
> +		}
> +
> +		list_del_init(&src_iter_first->plist.prio_list);
> +
> +		if (src_iter_first->prio < dst_iter->prio) {

I may be confused here, but shouldn't we be linking the
src_iter_first->prio_list somewhere here? Doesn't all different prios need
to be in its separate prio_list? Otherwise two splices in a row can cause
the above WARN_ON (prio != prio).

-- Steve


> +			list_add_tail(&src_iter_first->plist.node_list,
> +					&dst_iter->plist.node_list);
> +		} else if (src_iter_first->prio == dst_iter->prio) {
> +			dst_iter = next_prio(dst_iter);
> +		} else BUG();
> +
> +		list_splice2_tail(&src_iter_first->plist.node_list,
> +			       	  &src_iter_last->plist.node_list,
> +				  &dst_iter->plist.node_list);
> +	}
> +
> +tail:
> +	list_splice_tail_init(&src->prio_list, &dst->prio_list);
> +	list_splice_tail_init(&src->node_list, &dst->node_list);
> +}
>
> --
>
>
>
