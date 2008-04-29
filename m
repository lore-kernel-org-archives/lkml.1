Return-Path: <linux-kernel-owner+w=401wt.eu-S1759938AbYD2Of3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938AbYD2Of3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbYD2OfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:35:21 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:48915 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbYD2OfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:35:20 -0400
Message-ID: <48173224.6090405@bull.net>
Date: Tue, 29 Apr 2008 16:35:16 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
Cc: efault@gmx.de, manfred@colorfullife.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, peterz@infradead.org, xemul@openvz.org
Subject: Re: [PATCH 00/13] Re: Scalability requirements for sysv ipc
References: <20080411161702.460410000@bull.net> <20080419232539.GE20138@linux.vnet.ibm.com>
In-Reply-To: <20080419232539.GE20138@linux.vnet.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Fri, Apr 11, 2008 at 06:17:02PM +0200, Nadia.Derbey@bull.net wrote:
> 
>>
>>Here is finally the ipc ridr-based implementation I was talking about last
>>week (see http://lkml.org/lkml/2008/4/4/208).
>>I couldn't avoid much of the code duplication, but at least made things
>>incremental.
>>
>>Does somebody now a test suite that exists for the idr API, that I could
>>run on this new api?
>>
>>Mike, can you try to run it on your victim: I had such a hard time building
>>this patch, that I couldn't re-run the test on my 8-core with this new
>>version. So the last results I have are for 2.6.25-rc3-mm1.
>>
>>Also, I think a careful review should be done to avoid introducing yet other
>>problems :-(
>>
>>*WARNING*: this patch contains a fix for idr.c
>>           I know, I'm doing things bad, but I only saw the problem this
>>           afternoon.
>>
>>It should be applied on linux-2.6.25-rc8-mm1, in the following order:
>>
>>[ PATCH 01/13 ] : copy_idr_code.patch
>>[ PATCH 02/13 ] : change_ridr_struct.patch
>>[ PATCH 03/13 ] : ridr_pre_get.patch
>>[ PATCH 04/13 ] : ridr_alloc_layer.patch
>>[ PATCH 05/13 ] : ridr_free_layer.patch
>>[ PATCH 06/13 ] : ridr_sub_alloc.patch
>>[ PATCH 07/13 ] : ridr_get_empty_slot.patch
>>[ PATCH 08/13 ] : ridr_get_new.patch
>>[ PATCH 09/13 ] : ridr_remove.patch
>>[ PATCH 10/13 ] : ridr_find.patch
>>[ PATCH 11/13 ] : ridr_integrate.patch
>>[ PATCH 12/13 ] : ipc_use_ridr.patch
>>[ PATCH 13/13 ] : remove_ipc_lock_down.patch
> 
> 
> And some more comments on the resulting ridr.c.  Note that we might in
> fact want to keep the rcu_assign_pointer() calls that I complain about --
> see Johannes Berg's posting about making sparse smarter about RCU.
> 
> But I include them for completeness.
> 
> 							Thanx, Paul
> 
> 

<snip>

Paul,

Thanks again for your review.

I wanted to answer your questions before resending the patch series.

>>
>>static int ridr_get_new_above_int(struct ridr *idp, void *ptr, int starting_id)
>>{
>>	struct ridr_layer *pa[MAX_LEVEL];
>>	int id;
>>
>>	id = ridr_get_empty_slot(idp, starting_id, pa);
>>	if (id >= 0) {
>>		/*
>>		 * Successfully found an empty slot.  Install the user
>>		 * pointer and mark the slot full.
>>		 */
>>		rcu_assign_pointer(pa[0]->ary[id & IDR_MASK],
>>						(struct ridr_layer *)ptr);
> 
> 
> Here we are assigning to the live tree, so we -do- need rcu_assign_pointer().
> 
> 
>>		pa[0]->count++;
>>		ridr_mark_full(pa, id);
> 
> 
> Is ridr_mark_full() really safe in face of concurrent readers?  Seems like
> it should be, since it is doing a bunch of __set_bit() calls.
> 

Even if it uses set_bit(), it is doing it in a loop on the live tree, so 
might not be safe. But ridr_find() (which is the only lockless reader) 
doesn't test the bitmaps, but rather non NULL pointers. So it should be OK.

<snip>

>>/**
>> * ridr_remove - remove the given id and free it's slot
>> * @idp: ridr handle
>> * @id: unique key
>> */
>>void ridr_remove(struct ridr *idp, int id)
>>{
>>	struct ridr_layer *p, *to_free;
>>
>>	/* Mask off upper bits we don't use for the search. */
>>	id &= MAX_ID_MASK;
>>
>>	sub_remove(idp, (idp->layers - 1) * IDR_BITS, id);
>>	if (idp->top && idp->top->count == 1 && (idp->layers > 1) &&
>>	    idp->top->ary[0]) {  /* We can drop a layer */
> 
> 
> Why do we drop layers both in sub_remove() and here?
> 
> Hmmm...  For the same reason we do in idr_remove(), I guess.  Whatever
> reason that might be.  ;-)
> 
> 
Yes, it's for the same reason, and here is the reason: here we are in a 
situation where the topmost layer has a single child in the left most 
slot. Since the tree grows by adding layers above the existing ones, 
such a situation is reached when only the very first ids remain in the 
tree, after the higher ids have been removed. So the tree can be shrunk.

The new patch series follows.

Regards,
Nadia

