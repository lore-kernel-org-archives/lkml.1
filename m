Return-Path: <linux-kernel-owner+w=401wt.eu-S1760659AbZBXXWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760659AbZBXXWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 18:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbZBXXWC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 18:22:02 -0500
Received: from casper.infradead.org ([85.118.1.10]:59559 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbZBXXWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 18:22:01 -0500
Subject: Re: [RFC][PATCH] rwsem: rwsem_is_{read,write}_locked
From: Peter Zijlstra <peterz@infradead.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1235512716.4645.2397.camel@laptop>
References: <1235512716.4645.2397.camel@laptop>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 25 Feb 2009 00:21:28 +0100
Message-Id: <1235517688.18955.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-24 at 22:58 +0100, Peter Zijlstra wrote:
> Christoph requested an extended is_locked interface for rwsems. I think
> the below ought to do, then again, I might have missed something.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---

> +++ b/include/linux/rwsem.h
> @@ -20,8 +20,24 @@ struct rw_semaphore;
>  #include <linux/rwsem-spinlock.h> /* use a generic implementation */
>  #else
>  #include <asm/rwsem.h> /* use an arch-specific implementation */
> +
> +static inline int rwsem_is_locked(struct rw_semaphore *sem)
> +{
> +	return (sem->count != 0);
> +}
> +
> +static inline int rwsem_is_write_locked(struct rw_semaphore *sem)
> +{
> +	return (sem->count & RWSEM_ACTIVE_MASK) == RWSEM_ACTIVE_MASK;
> +}

OK, that's not right. Concurrent down_write() calls xadd
RWSEM_ACTIVE_WRITE_BIAS, which has a 1 in that mask, so we're going to
deviate an unspecified number.

That one will make it roll over into (count & MASK) >= 0 which is the
exact range readers use too, this might be a tad harder than hoped.

Will ponder in the morning.
