Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbZAJKGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbZAJKGv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 05:06:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbZAJKGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 05:06:42 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:54444 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbZAJKGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 05:06:41 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <496872E0.9030007@s5r6.in-berlin.de>
Date: Sat, 10 Jan 2009 11:05:20 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-1?Q?Kristian_?= =?ISO-8859-1?Q?H=F8gsberg?= 
	<krh@redhat.com>
CC: dcm@acm.org, Nadia Derbey <Nadia.Derbey@bull.net>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH] lib/idr.c: Zero memory properly in idr_remove_all
References: <1231571060.3538.18.camel@localhost.localdomain>	<49686465.70501@s5r6.in-berlin.de> <20090110011557.9d94e111.akpm@linux-foundation.org>
In-Reply-To: <20090110011557.9d94e111.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 10 Jan 2009 10:03:33 +0100 Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> 
>> David Moore wrote:
>>> From: David Moore <dcm@acm.org>
>>>
>>> The idr_remove_all() function returns unused slabs to the kmem cache,
>>> but needs to zero them first or else they will be uninitialized upon
>>> next use.  This fixes crashes which have been observed in the firewire
>>> subsystem.
>>>
> 
> hm.
> 
>>> ---
>>>  lib/idr.c |   16 +++++++++++++++-
>>>  1 files changed, 15 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/lib/idr.c b/lib/idr.c
>>> index 1c4f928..69c3455 100644
>>> --- a/lib/idr.c
>>> +++ b/lib/idr.c
>>> @@ -65,6 +65,20 @@ static inline void free_layer(struct idr_layer *p)
>>>  	call_rcu(&p->rcu_head, idr_layer_rcu_free);
>>>  }
>>>  
>>> +static void idr_layer_rcu_free_zero(struct rcu_head *head)
>>> +{
>>> +	struct idr_layer *layer;
>>> +
>>> +	layer = container_of(head, struct idr_layer, rcu_head);
>>> +	memset(layer, 0, sizeof(struct idr_layer));
>>> +	kmem_cache_free(idr_layer_cache, layer);
>>> +}
>>> +
>>> +static inline void free_layer_zero(struct idr_layer *p)
>>> +{
>>> +	call_rcu(&p->rcu_head, idr_layer_rcu_free_zero);
>>> +}
>>> +
>>>  /* only called when idp->lock is held */
>>>  static void __move_to_free_list(struct idr *idp, struct idr_layer *p)
>>>  {
>>> @@ -462,7 +476,7 @@ void idr_remove_all(struct idr *idp)
>>>  		id += 1 << n;
>>>  		while (n < fls(id)) {
>>>  			if (p)
>>> -				free_layer(p);
>>> +				free_layer_zero(p);
>>>  			n += IDR_BITS;
>>>  			p = *--paa;
>>>  		}
>> Nadia,
>>
>> it appears as if post-2.6.26 commit
>> cf481c20c476ad2c0febdace9ce23f5a4db19582 "idr: make idr_remove rcu-safe"
>> was buggy as it removed a memset(...0...) from idr_remove_all() without
>> any obvious replacement.  And this patch fixes it.  Is this correct?
>>
>> This was observed by David in Fedora 2.6.27.* kernels and in 2.6.28, and
>> I have it seen in vanilla 2.6.28 --- but only after I disabled some
>> debug kconfig options.  The trigger for the bug is not the existing
>> usage of idr in drivers/firewire/, but a new usage which is not yet in
>> mainline.  More details:
>> http://marc.info/?l=linux1394-devel&m=123140439522563
>>
>> The symptom is that after a few destructions of idr trees (which involve
>> idr_remove_all() of course), there appear spurious idr entries in
>> subsequently newly created idr trees.  These spurious entries then crash
>> the driver when it iterates over them.

...
> Are we sure that all the other callers of free_layer() are freeing
> zeroed objects?
> 
> It would be cleaner, safer and quite possibly faster to remove the
> constructor altogether and use kmem_cache_zalloc() to allocate new
> objects.

Yes, it sounds at least safer if the allocation path should be fixed up.

The zeroing was done in idr_remove_all() though since Kristian added it
in 2.6.23, until 2.6.26 inclusive.

Kristian, was there a deeper reason to do it at deallocation instead of
allocation, and does the reason still apply today?
-- 
Stefan Richter
-=====-==--= ---= -=-=-
http://arcgraph.de/sr/
