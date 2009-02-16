Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbZBPKbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbZBPKbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 05:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbZBPKba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 05:31:30 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:47997 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbZBPKb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 05:31:29 -0500
Date: Mon, 16 Feb 2009 11:31:26 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 1/7] async: Asynchronous function calls to speed up
 kernel boot
Message-ID: <20090216113126.3e54863a@gondolin>
In-Reply-To: <20090215111636.5b6cc507@infradead.org>
References: <20090107151151.458333c1@infradead.org>
	<20090107151226.58264d07@infradead.org>
	<20090213162200.8fea7e0c.akpm@linux-foundation.org>
	<20090213205949.1ebb441d@infradead.org>
	<20090213232926.924d8740.akpm@linux-foundation.org>
	<20090215111636.5b6cc507@infradead.org>
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

On Sun, 15 Feb 2009 11:16:36 -0800,
Arjan van de Ven <arjan@infradead.org> wrote:

> * The caller needs to provide the memory
>    - solves the case of the internal implementation getting a failed
>      allocation. BUT it does not solve the caller not getting memory,
>      it shifts the complexity to there.
>    - ... or needs to cope with the call potentially failing if it
>      lets the infrastructure to do the allocation

We could provide a small wrapper that allocates memory for the simple
case - but having the caller provide the memory makes it more flexible.

> * The caller needs to wait (at some point) for the operation to
>   complete, and then take care of freeing the memory.
>   (the memory obviously could be part of some natural structure that
>    already has its own lifecycle rules)

So it's not so much freeing as giving up a reference.

> * There must be enough worker threads such that deadlocks due to all
>   threads waiting on each other will not happen. Practically this
>   probably means that if there is no progress, we need to just swallow
>   the pill and make more threads. In addition we can borrow the thread
>   context of the threads that are waiting for work to complete
>   - alternative is to have 2 (or more) classes of work with a reserved
>     thread pool for each, but I'm very not fond of this idea, because
>     then all the advantages of sharing the implementation go away again,
>     and over time we'll end up with many such classes
> * The caller is not allowed to use the same memory for scheduling
>   multiple outstanding function calls (this is fundamentally different
>   from schedule_work, which does allow this).
>   - we could make a flag that marks an item as "if the function and data
>     are the same silently allow it" but I'm not too fond of that idea,
>     it'll be fragile.

Agreed, that would be fragile. The caller should be able to take care
of it best.

> Practically: the scheduled function is not allowed to make the metadata
> memory go away. At least for those cases where we later want to wait
> for the opertation; in principle we could do away with this requirement
> if we know nobody will ever wait for the operation.

But that would artificially limit the usefulness.

> Second practical issue:
> We can have a flag in the metadata that says that the infrastructure is 
> supposed to kfree() the metadata at the end.

I tried that, but didn't like the result.

> Or we can go wild and stick
> a pointer in of the function that needs to be called to free the
> metadata.

krefs start to look attractive...
