Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbZANKfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbZANKfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbZANKfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:35:04 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:50898 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbZANKfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:35:03 -0500
Date: Wed, 14 Jan 2009 11:34:50 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] async: Handle kthread_run() return codes.
Message-ID: <20090114113450.66769432@gondolin>
In-Reply-To: <20090113203434.7094dd60@infradead.org>
References: <20090113174304.2186532c@gondolin>
	<20090113203434.7094dd60@infradead.org>
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

On Tue, 13 Jan 2009 20:34:34 +0000,
Arjan van de Ven <arjan@infradead.org> wrote:

> >  		ec = atomic_read(&entry_count);
> >  
> >  		while (tc < ec && tc < MAX_THREADS) {
> > -			kthread_run(async_thread, NULL, "async/%i",
> > tc);
> > +			if (IS_ERR(kthread_run(async_thread, NULL,
> > "async/%i",
> > +					       tc)))
> > +				/* Try again later. */
> > +				goto schedule;
> 
> I do not like this recovery to be honest. an msleep() followed by a
> "continue" is probably much better.

Will change.

> 
> 
> > @@ -330,7 +333,9 @@ static int async_manager_thread(void *un
> >  static int __init async_init(void)
> >  {
> >  	if (async_enabled)
> > -		kthread_run(async_manager_thread, NULL, "async/mgr");
> > +		if (IS_ERR(kthread_run(async_manager_thread, NULL,
> > +				       "async/mgr")))
> > +			async_enabled = 0;
> 
> hmm maybe; it might make more sense to set it to 0 here, and have the
> thread itself set the variable to 1..... that way we KNOW the thread is
> running for sure..

That would look a bit strange to me.

setup_async sets async_enabled -> async_init unsets it again ->
async_manager_thread sets it again

If anything, we could use two variables (use_async and async_enabled),
but that smells of overengeneering to me...
