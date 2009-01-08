Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbZAHAcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbZAHAcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 19:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756022AbZAHAbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 19:31:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:37282 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862AbZAHAbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 19:31:52 -0500
Date: Wed, 7 Jan 2009 22:31:41 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/7] async: Asynchronous function calls to speed up
	kernel boot
Message-ID: <20090108003141.GN23891@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@infradead.org>,
	Arjan van de Ven <arjan@infradead.org>,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org
References: <20090107151151.458333c1@infradead.org> <20090107151226.58264d07@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107151226.58264d07@infradead.org>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 07, 2009 at 03:12:26PM -0800, Arjan van de Ven escreveu:

<SNIP>

> +/*
> + * MUST be called with the lock held!
> + */
> +static async_cookie_t  __lowest_in_progress(struct list_head *running)
> +{
> +	struct async_entry *entry;
> +	if (!list_empty(&async_pending)) {
> +		entry = list_first_entry(&async_pending,
> +			struct async_entry, list);

Small nitpick:

- > +		return entry->cookie;
> +	} else if (!list_empty(running)) {
> +		entry = list_first_entry(running,
> +			struct async_entry, list);
- > +		return entry->cookie;
> +	} else {
> +		/* nothing in progress... next_cookie is "infinity" */
> +		return next_cookie;
> +	}

+ 	return entry->cookie;

> +/*
> + * pick the first pending entry and run it
> + */
> +static void run_one_entry(void)
> +{
> +	unsigned long flags;
> +	struct async_entry *entry;
> +	ktime_t calltime, delta, rettime;
> +
> +	/* 1) pick one task from the pending queue */
> +
> +	spin_lock_irqsave(&async_lock, flags);
> +	if (list_empty(&async_pending))
> +		goto out;
> +	entry = list_first_entry(&async_pending, struct async_entry, list);
> +
> +	/* 2) move it to the running queue */
> +	list_del(&entry->list);
> +	list_add_tail(&entry->list, &async_running);

We have list_move_tail()

> +	spin_unlock_irqrestore(&async_lock, flags);
> +
> +	/* 3) run it (and print duration)*/
> +	if (initcall_debug) {
> +		printk("calling  %lli_%pF @ %i\n", entry->cookie, entry->func, task_pid_nr(current));
> +		calltime = ktime_get();

- Arnaldo
