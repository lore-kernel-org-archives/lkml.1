Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYFLGHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYFLGHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbYFLGHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:07:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:48767 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbYFLGHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:07:07 -0400
Subject: Re: [PATCH 5/5] futex: fix miss ordered wakeups
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20080611204917.523866467@mvista.com>
References: <20080611204916.271608740@mvista.com>
	 <20080611204917.523866467@mvista.com>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 08:07:05 +0200
Message-Id: <1213250825.31518.80.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-11 at 13:49 -0700, Daniel Walker wrote:
> plain text document attachment (blocked_on-futex.patch)

I thought everybody and his dog didn't care for this?

> +void futex_adjust_waiters(struct task_struct *p)
> +{
> +

Seemingly extra whitespace ^

> +	if (p->blocked_on) {
> +		struct futex_hash_bucket *hb;
> +		struct futex_q *q, *next;
> +		union futex_key key;
> +
> +		spin_lock_irq(&p->pi_lock);
> +		if (p->blocked_on && p->blocked_on->lock_type == FUTEX_WAITER) {
> +			key = *p->blocked_on->futex_blocked_on;
> +			spin_unlock_irq(&p->pi_lock);
> +		} else {
> +			spin_unlock_irq(&p->pi_lock);
> +			return;
> +		}
> +
> +		hb = hash_futex(&key);
> +		spin_lock(&hb->lock);
> +		plist_for_each_entry_safe(q, next, &hb->chain, list) {
> +			if (match_futex(&q->key, &key) && q->task == p) {
> +				int prio = min(p->normal_prio, MAX_RT_PRIO);
> +				plist_del(&q->list, &hb->chain);
> +				plist_node_init(&q->list, prio);
> +				plist_add(&q->list, &hb->chain);
> +				break;
> +			}
> +		}
> +		spin_unlock(&hb->lock);
> +	}
> +}

Also, if you write it like:

  if (!p->blocked_on)
    return

  do_other_stuff

you loose one nesting level - which imho looks better.

