Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbZAMUtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbZAMUtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 15:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbZAMUtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 15:49:04 -0500
Received: from vena.lwn.net ([206.168.112.25]:49955 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbZAMUtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 15:49:01 -0500
Date: Tue, 13 Jan 2009 13:48:59 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/7] async: Asynchronous function calls to speed up
 kernel boot
Message-ID: <20090113134859.08005199@bike.lwn.net>
In-Reply-To: <20090107151226.58264d07@infradead.org>
References: <20090107151151.458333c1@infradead.org>
	<20090107151226.58264d07@infradead.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[A somewhat belated question...]

As I read the patch, I find the async_entry structure:

> +struct async_entry {
> +	struct list_head list;
> +	async_cookie_t   cookie;
> +	async_func_ptr	 *func;
> +	void             *data;
> +	struct list_head *running;
> +};

The "running" field is, presumably, meant to hold a pointer to the
"running" queue to be used when this function is actually run.  But, then,
I see:

> +async_cookie_t async_schedule(async_func_ptr *ptr, void *data)
> +{
> +	return __async_schedule(ptr, data, &async_pending);
> +}
> +EXPORT_SYMBOL_GPL(async_schedule);

It seems to me that you wanted &async_running there, no?

However, it doesn't matter in the current form of the patch:

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
> +	spin_unlock_irqrestore(&async_lock, flags);

Given the way things are designed, don't you want to add the entry to
entry->running, rather than unconditionally to async_running?  If not, I
don't see how calls to async_synchronize_cookie_special() can work right.

Of course, I'm probably just confused...enlighten me?

Thanks,

jon
