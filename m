Return-Path: <linux-kernel-owner+w=401wt.eu-S1761570AbZANLfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761570AbZANLfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 06:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755652AbZANLfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 06:35:03 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:41828 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516AbZANLfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 06:35:00 -0500
Date: Wed, 14 Jan 2009 12:34:54 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/7] async: Asynchronous function calls to speed up
 kernel boot
Message-ID: <20090114123454.6af6ff4b@gondolin>
In-Reply-To: <20090113134859.08005199@bike.lwn.net>
References: <20090107151151.458333c1@infradead.org>
	<20090107151226.58264d07@infradead.org>
	<20090113134859.08005199@bike.lwn.net>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009 13:48:59 -0700,
Jonathan Corbet <corbet@lwn.net> wrote:

> [A somewhat belated question...]
> 
> As I read the patch, I find the async_entry structure:
> 
> > +struct async_entry {
> > +	struct list_head list;
> > +	async_cookie_t   cookie;
> > +	async_func_ptr	 *func;
> > +	void             *data;
> > +	struct list_head *running;
> > +};
> 
> The "running" field is, presumably, meant to hold a pointer to the
> "running" queue to be used when this function is actually run.  But, then,
> I see:
> 
> > +async_cookie_t async_schedule(async_func_ptr *ptr, void *data)
> > +{
> > +	return __async_schedule(ptr, data, &async_pending);
> > +}
> > +EXPORT_SYMBOL_GPL(async_schedule);
> 
> It seems to me that you wanted &async_running there, no?
> 
> However, it doesn't matter in the current form of the patch:
> 
> > +/*
> > + * pick the first pending entry and run it
> > + */
> > +static void run_one_entry(void)
> > +{
> > +	unsigned long flags;
> > +	struct async_entry *entry;
> > +	ktime_t calltime, delta, rettime;
> > +
> > +	/* 1) pick one task from the pending queue */
> > +
> > +	spin_lock_irqsave(&async_lock, flags);
> > +	if (list_empty(&async_pending))
> > +		goto out;
> > +	entry = list_first_entry(&async_pending, struct async_entry, list); 
> > +
> > +	/* 2) move it to the running queue */
> > +	list_del(&entry->list);
> > +	list_add_tail(&entry->list, &async_running);
> > +	spin_unlock_irqrestore(&async_lock, flags);
> 
> Given the way things are designed, don't you want to add the entry to
> entry->running, rather than unconditionally to async_running?  If not, I
> don't see how calls to async_synchronize_cookie_special() can work right.
> 
> Of course, I'm probably just confused...enlighten me?

No, you're not confused, the code is :)

async_schedule() should pass in async_running as the running
list, and run_one_entry() should put the entry to be run on
the provided running list instead of always on the generic one.

Reported-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 kernel/async.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.orig/kernel/async.c
+++ linux-2.6/kernel/async.c
@@ -133,7 +133,7 @@ static void run_one_entry(void)
 
 	/* 2) move it to the running queue */
 	list_del(&entry->list);
-	list_add_tail(&entry->list, &async_running);
+	list_add_tail(&entry->list, entry->running);
 	spin_unlock_irqrestore(&async_lock, flags);
 
 	/* 3) run it (and print duration)*/
@@ -207,7 +207,7 @@ static async_cookie_t __async_schedule(a
 
 async_cookie_t async_schedule(async_func_ptr *ptr, void *data)
 {
-	return __async_schedule(ptr, data, &async_pending);
+	return __async_schedule(ptr, data, &async_running);
 }
 EXPORT_SYMBOL_GPL(async_schedule);
 
