Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbZBNAWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbZBNAWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 19:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbZBNAWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 19:22:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752182AbZBNAWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 19:22:37 -0500
Date: Fri, 13 Feb 2009 16:22:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, arjan@infradead.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 1/7] async: Asynchronous function calls to speed up
 kernel boot
Message-Id: <20090213162200.8fea7e0c.akpm@linux-foundation.org>
In-Reply-To: <20090107151226.58264d07@infradead.org>
References: <20090107151151.458333c1@infradead.org>
	<20090107151226.58264d07@infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2009 15:12:26 -0800
Arjan van de Ven <arjan@infradead.org> wrote:

> +static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct list_head *running)
> +{
> +	struct async_entry *entry;
> +	unsigned long flags;
> +	async_cookie_t newcookie;
> +	
> +
> +	/* allow irq-off callers */
> +	entry = kzalloc(sizeof(struct async_entry), GFP_ATOMIC);
> +
> +	/*
> +	 * If we're out of memory or if there's too much work
> +	 * pending already, we execute synchronously.
> +	 */
> +	if (!entry || atomic_read(&entry_count) > MAX_WORK) {
> +		kfree(entry);
> +		spin_lock_irqsave(&async_lock, flags);
> +		newcookie = next_cookie++;
> +		spin_unlock_irqrestore(&async_lock, flags);
> +
> +		/* low on memory.. run synchronously */
> +		ptr(data, newcookie);

This is quite bad.

> +		return newcookie;
> +	}
> +	entry->func = ptr;
> +	entry->data = data;
> +	entry->running = running;
> +
> +	spin_lock_irqsave(&async_lock, flags);
> +	newcookie = entry->cookie = next_cookie++;
> +	list_add_tail(&entry->list, &async_pending);
> +	atomic_inc(&entry_count);
> +	spin_unlock_irqrestore(&async_lock, flags);
> +	wake_up(&async_new);
> +	return newcookie;
> +}

It means that sometimes, very rarely, the callback function will be
called within the caller's context.

Hence this interface cannot be used to call might-sleep functions from
within atomic contexts.  Which should be a major application of this
code!

It's bad that nobody discovers this shortcoming until
__async_schedule() happens to be called when the system is out of
memory.  They will then discover it via might_sleep() warnings, or an
interrupt-context kernel panic.


Furthermore:

- If the callback function can sleep then the caller must be able to
  sleep, so the GFP_ATOMIC is unneeded and undesirable, and the comment
  is wrong.

- Regardless of whether or not the callback function can sleep: if
  the caller can sleep then the GFP_ATOMIC allocation is undesirable
  and wrong.

We can fix these two issues by adding a gfp_t to the interface (as we
almost always should).


But for the first issue we're kinda screwed.  It makes the whole
utility far less useful than it might otherwise have been.

I can't immediately think of a fix, apart from overhauling the
implementation and doing it in the proper way: caller-provided storage
rather than callee-provided (which always goes wrong).  schedule_work()
got this right.
