Return-Path: <linux-kernel-owner+w=401wt.eu-S1754937AbYCMMXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbYCMMXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 08:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYCMMXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 08:23:22 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:48199 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbYCMMXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 08:23:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=diCYr/JOFK/HUFTwtt/M/pLpCfLio4lpSFyCYI0o6nneRInWPH1s2MYEsq/PBM8L3q15Pwc35UGkptkV302YKYjso6hnr8SQGbvNSro8R3rOXbih4f2nUsVdPDbXwM8B4SYTH4CEbzJu4fyFYUlvhxGfB7rmdbxg6Eqm5vcccYs=
Message-ID: <998d0e4a0803130523o7db2bf51h290429c7413740c1@mail.gmail.com>
Date: Thu, 13 Mar 2008 13:23:18 +0100
From: "J.C. Pizarro" <jcpiza@gmail.com>
To: "Al Viro" <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux+glibc memory allocator, poor performance
In-Reply-To: <20080312211219.GL27894@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <998d0e4a0803121309s125dddbao801e53e44296a4d6@mail.gmail.com>
	 <20080312211219.GL27894@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008/3/12, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Mar 12, 2008 at 09:09:04PM +0100, J.C. Pizarro wrote:
>
>  > Assume a SMP system that has 8 CPUs. The main problem of requesting
>  > pages is the BKL (Big Kernel Lock) in this SMP system used for mutual
>  > exclusion of the shared resource (the memory).
>
>
> Really?  Used _where_?

To see "Lock ordering:" in mm/filemap.c

I tell you an example of this used big kernel lock
write_lock_irq/write_unlock_irq:

     void __remove_from_page_cache(struct page *page):
      * Remove a page from the page cache and free it. Caller has to make
      * sure the page is locked and that nobody else uses it - or that usage
      * is safe.  The caller must hold a write_lock on the mapping's tree_lock.

     void remove_from_page_cache(struct page *page) {
	     struct address_space *mapping = page->mapping;

	     BUG_ON(!PageLocked(page));

	     write_lock_irq(&mapping->tree_lock);
	     __remove_from_page_cache(page);
	     write_unlock_irq(&mapping->tree_lock);
     }

     * Shared mappings 30.11.1994, 15.8.1995  Bruno.
     * 'unifying' the page and buffer cache and SMP-threaded the
        page-cache, 21.05.1999, Ingo Molnar.
     * SMP-threaded pagemap-LRU 1999, Andrea Arcangeli.

Here doesn't say multiple SMP buffers of pages for SMP.
For UP, no SMP buffer is needed.

>  > To solve this major problem, i propose you freely
>
>
> I hate to think of what you'd propose under duress...

Don't hate to me, you've not reasons to insult me or to somebody.
To think of the proposals posted by any person, not of me.

>  > to allocate 8 local caches
>  > of (e.g.) 2 MiB each CPU (total 2MiB x 8 CPUs = 16 MiB) acting as
>  > 8 producer buffers for globally many consumer tasks (e.g. >= 20).
>  >
>  > When the some producer buffer is empty then it does unfrequently BKL to
>  > allocate another 2 MiB more from the shared resource (the memory).
>
>
> Excellent advice.  One question: why the bleeding hell would we use BKL
>  in allocator, frequently or not, when we do not share the crucial resource
>  needed to come up with such ideas?  Or are you proposing to share your
>  crack pipe as well?

You're contradictory. It uses BKL or slower spinlocks/rwlocks in allocator.
It shares the crucial resource.

The physical RAM of the SMP system is a shared resource for 2 or more CPUs
(even in NUMA systems), so to avoid the race conditions, it needs to be
temporaly locked to comply the mutual exclusion of this shared resource.

I'm saying that it will try to reduce the frequency of BKLs to maximize the
OS performance in the mind of Huffman (freq.) & Amdhal (hot code).

I don't understand you saying "to share your crack pipe", what means it?
Nothing is crack. It's not an unix pipe. It's 8 local SMP buffers for 8 CPUs.

>  > In the reverse, it's simple, return back the unused pages to the local buffer
>  > of the producer, and when this full then to do BKL too to unallocate its half
>  > to the shared resource (the memory).
>
>
> I wonder...  Are you seriously implying that nobody here had ever been able
>  to come up with anything better than _that_ (e.g. with an amazingly advanced
>  idea of googling for papers on allocators for all of two minutes)?  And that
>  you are so sure of it that you couldn't be arsed to check what the hell is
>  allocator really doing, on the off-chance that somebody might have been able
>  to match your brilliant intellectual feat?

Don't point me! Don't menace me!

I know how to work internally a monolithic O.S., so i'm not googling papers from
others and i'm thinking from my brain how to work a little better some things
that i proposed.

>  And then we are told that linux-kernel regulars are mean and insulting...
>
>  FWIW, the quality of proposed "solution" is not an issue; hell, even "what
>  if that code is really so dumb that <....> would be an improvement" is not
>  a problem - the estimate is too low, but far be it from me to suggest that
>  one should apriori assume that unreviewed code is good.  What _really_
>  makes the whole thing incredibly insulting is that you had not bothered
>  to even look at the damn thing and just went on with "of course none of
>  you could have ever come up with anything better - I don't even need to
>  look at it to tell you that".

You're a distractor man that distracts to the people.

   J.C.Pizarro
