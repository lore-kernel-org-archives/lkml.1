Return-Path: <linux-kernel-owner+w=401wt.eu-S1760257AbYHVHGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760257AbYHVHGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 03:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755659AbYHVHGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 03:06:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:10976 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663AbYHVHGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 03:06:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=xDHx8qnE45bqXu9C6pWYMW7WWcYrB8hyh72zSzTQlU7d1tvDwTyEuK83u8d7h4LRo1
         vPKjs2SPotuCLtOq3V0LCnnSrrwzOjOKNbFTJVLd1+KpeDHHRJZE4biNZeTo/na4U4EC
         ADnjSWrhcTN8cEZsHKFjX5mdVKzHmk9Hyu064=
Message-ID: <84144f020808220006n25d684b1n9db306ddc4f58c4c@mail.gmail.com>
Date: Fri, 22 Aug 2008 10:06:02 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 2/2] smp_call_function: use rwlocks on queues rather than rcu
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       "Christoph Lameter" <cl@linux-foundation.org>
In-Reply-To: <20080822062800.GQ14110@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AE0883.6050701@goop.org> <20080822062800.GQ14110@elte.hu>
X-Google-Sender-Auth: 47a241c0048cbdc6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Fri, Aug 22, 2008 at 9:28 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>> RCU can only control the lifetime of allocated memory blocks, which
>> forces all the call structures to be allocated.  This is expensive
>> compared to allocating them on the stack, which is the common case for
>> synchronous calls.
>>
>> This patch takes a different approach.  Rather than using RCU, the
>> queues are managed under rwlocks.  Adding or removing from the queue
>> requires holding the lock for writing, but multiple CPUs can walk the
>> queues to process function calls under read locks.  In the common
>> case, where the structures are stack allocated, the calling CPU need
>> only wait for its call to be done, take the lock for writing and
>> remove the call structure.
>>
>> Lock contention - particularly write vs read - is reduced by using
>> multiple queues.
>
> hm, is there any authorative data on what is cheaper on a big box, a
> full-blown MESI cache miss that occurs for every reader in this new
> fastpath, or a local SLAB/SLUB allocation+free that occurs with the
> current RCU approach?

Christoph might have an idea about it.
