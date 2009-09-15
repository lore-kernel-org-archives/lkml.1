Return-Path: <linux-kernel-owner+w=401wt.eu-S1751490AbZIOIaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbZIOIaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 04:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbZIOIaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 04:30:15 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:38917 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbZIOIaO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 04:30:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rFsFlhUhFEKvGMCc9oBvhDUYWRllMlKd4yUkLzEgAWiMUskeUUJQ9GzNl9wRKemWFE
         RwHNmXI97ihKTHyM1/5y3Nzu02FkcMWnqcH8Hr5vKFnsd0MsnPMOoNzqPPwV0AUvbLDO
         vbuFFgbOOj8dbHvMMhYkvvHayl4Odaoyj4078=
MIME-Version: 1.0
In-Reply-To: <d760cf2d0909150121i7f6f45b9p76f8eb89ab0d5882@mail.gmail.com>
References: <200909100215.36350.ngupta@vflare.org>
	 <200909100249.26284.ngupta@vflare.org>
	 <84144f020909141310y164b2d1ak44dd6945d35e6ec@mail.gmail.com>
	 <d760cf2d0909142339i30d74a9dic7ece86e7227c2e2@mail.gmail.com>
	 <84144f020909150030h1f9d8062sc39057b55a7ba6c0@mail.gmail.com>
	 <d760cf2d0909150121i7f6f45b9p76f8eb89ab0d5882@mail.gmail.com>
Date: Tue, 15 Sep 2009 11:30:16 +0300
X-Google-Sender-Auth: b9da62972166c1f4
Message-ID: <84144f020909150130r573df1e1jfe359b88387f94ad@mail.gmail.com>
Subject: Re: [PATCH 2/4] virtual block device driver (ramzswap)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Ed Tomlinson <edt@aei.ca>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-mm-cc@laptop.org, Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 11:21 AM, Nitin Gupta <ngupta@vflare.org> wrote:
> I don't want to ponder too much about this point now. If you all are okay
> with keeping this function buried in driver, I will do so. I'm almost tired
> maintaining this compcache thing outside of mainline.

Yup, whatever makes most sense to you.

>> Then make ramzswap depend on !CONFIG_ARM. In any case, CONFIG_ARM bits
>> really don't belong into drivers/block.
>
> ARM is an extremely important user of compcache -- Its currently being
> tested (unofficially) on Android, Nokia etc.

That's not a technical argument for keeping CONFIG_ARM in the driver.

>>>>> +
>>>>> +       trace_mark(ramzswap_lock_wait, "ramzswap_lock_wait");
>>>>> +       mutex_lock(&rzs->lock);
>>>>> +       trace_mark(ramzswap_lock_acquired, "ramzswap_lock_acquired");
>>>>
>>>> Hmm? What's this? I don't think you should be doing ad hoc
>>>> trace_mark() in driver code.
>>>
>>> This is not ad hoc. It is to see contention over this lock which I believe is a
>>> major bottleneck even on dual-cores. I need to keep this to measure improvements
>>> as I gradually make this locking more fine grained (using per-cpu buffer etc).
>>
>> It is ad hoc. Talk to the ftrace folks how to do it properly. I'd keep
>> those bits out-of-tree until the issue is resolved, really.
>
> /me is speechless.

That's fine, I CC'd the ftrace folks. Hopefully they'll be able to help you.

>
>>>>> +       rzs->compress_buffer = kzalloc(2 * PAGE_SIZE, GFP_KERNEL);
>>>>
>>>> Use alloc_pages(__GFP_ZERO) here?
>>>
>>> alloc pages then map them (i.e. vmalloc). What did we gain? With
>>> vmalloc, pages might
>>> not be physically contiguous which might hurt performance as
>>> compressor runs over this buffer.
>>>
>>> So, use kzalloc().
>>
>> I don't know what you're talking about. kzalloc() calls
>> __get_free_pages() directly for your allocation. You probably should
>> use that directly.
>
> What is wrong with kzalloc? I'm wholly totally stumped.
> I respect your time reviewing the code but this really goes over my head.
> We can continue arguing about get_pages vs kzalloc but I doubt if we will
> gain anything out of it.

The slab allocator needs metadata for the allocation so you're wasting
memory. If you really want *two pages*, why don't you simply use the
page allocator for that?

Btw, Nitin, why are you targeting drivers/block and not
drivers/staging at this point? It seems obvious enough that there are
still some issues that need to be ironed out (like the CONFIG_ARM
thing) so submitting the driver for inclusion in drivers/staging and
fixing it up there incrementally would likely save you from a lot of
trouble. Greg, does ramzswap sound like something that you'd be
willing to take?

                        Pekka
