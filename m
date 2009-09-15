Return-Path: <linux-kernel-owner+w=401wt.eu-S1758199AbZIOHaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbZIOHaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 03:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758184AbZIOHaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 03:30:22 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:56281 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758183AbZIOHaV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 03:30:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=c1U6WpeCmRl5clKQKH5PNKHLhhLnQe1OAuDaTpCVY++dffcwzNdWLHIaYWvWZ0Fbxy
         R5U085kWKRUxWbWyKo4R2+dEBk3i1MyQXzRVYXnrRCA+n1wp4W0Z1LFWwp3YN2HexLPx
         bLgqZmi78nyZN5eCgVz1Pji6hHjHXA2ndjMak=
MIME-Version: 1.0
In-Reply-To: <d760cf2d0909142339i30d74a9dic7ece86e7227c2e2@mail.gmail.com>
References: <200909100215.36350.ngupta@vflare.org>
	 <200909100249.26284.ngupta@vflare.org>
	 <84144f020909141310y164b2d1ak44dd6945d35e6ec@mail.gmail.com>
	 <d760cf2d0909142339i30d74a9dic7ece86e7227c2e2@mail.gmail.com>
Date: Tue, 15 Sep 2009 10:30:23 +0300
X-Google-Sender-Auth: d13eb6e6cdee2727
Message-ID: <84144f020909150030h1f9d8062sc39057b55a7ba6c0@mail.gmail.com>
Subject: Re: [PATCH 2/4] virtual block device driver (ramzswap)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Ed Tomlinson <edt@aei.ca>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-mm-cc@laptop.org, Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nitin,

On Tue, Sep 15, 2009 at 9:39 AM, Nitin Gupta <ngupta@vflare.org> wrote:
>> On Thu, Sep 10, 2009 at 12:19 AM, Nitin Gupta <ngupta@vflare.org> wrote:
>>> +
>>> +/* Globals */
>>> +static int RAMZSWAP_MAJOR;
>>> +static struct ramzswap *DEVICES;
>>> +
>>> +/*
>>> + * Pages that compress to larger than this size are
>>> + * forwarded to backing swap, if present or stored
>>> + * uncompressed in memory otherwise.
>>> + */
>>> +static unsigned int MAX_CPAGE_SIZE;
>>> +
>>> +/* Module params (documentation at end) */
>>> +static unsigned long NUM_DEVICES;
>>
>> These variable names should be in lower case.
>
> Global variables with lower case causes confusion.

Hmm? You are not following the kernel coding style here. It's as simple as that.

>>> +static int page_zero_filled(void *ptr)
>>> +{
>>> +       u32 pos;
>>> +       u64 *page;
>>> +
>>> +       page = (u64 *)ptr;
>>> +
>>> +       for (pos = 0; pos != PAGE_SIZE / sizeof(*page); pos++) {
>>> +               if (page[pos])
>>> +                       return 0;
>>> +       }
>>> +
>>> +       return 1;
>>> +}
>>
>> This looks like something that could be in lib/string.c.
>>
>> /me looks
>>
>> There's strspn so maybe you could introduce a memspn equivalent.
>
> Maybe this is just too specific to this driver. Who else will use it?
> So, this simple function should stay within this driver only. If it
> finds more user, we can them move it to lib/string.c.
>
> If I now move it to string.c I am sure I will get reverse argument
> from someone else:
> "currently, it has no other users so bury it with this driver only".

How can you be sure about that? If you don't want to move it to
generic code, fine, but the above argumentation doesn't really
convince me. Check the git logs to see that this is *exactly* how new
functions get added to lib/string.c. It's not always a question of two
or more users, it's also an API issue. It doesn't make sense to put
helpers in driver code where they don't belong (and won't be
discovered if they're needed somewhere else).

>>> +/*
>>> + * Given <pagenum, offset> pair, provide a dereferencable pointer.
>>> + */
>>> +static void *get_ptr_atomic(struct page *page, u16 offset, enum km_type type)
>>> +{
>>> +       unsigned char *base;
>>> +
>>> +       base = kmap_atomic(page, type);
>>> +       return base + offset;
>>> +}
>>> +
>>> +static void put_ptr_atomic(void *ptr, enum km_type type)
>>> +{
>>> +       kunmap_atomic(ptr, type);
>>> +}
>>
>> These two functions also appear in xmalloc. It's probably best to just
>> kill the wrappers and use kmap/kunmap directly.
>
> Wrapper for kmap_atomic is nice as spreading:
> kmap_atomic(page, KM_USER0,1) + offset everywhere looks worse.
> What is the problem if these little 1-liner wrappers are repeated in
> xvmalloc too?
> To me, they just add some clarity.

To me, they look like useless wrappers which we don't do in the kernel.

>>> +static void ramzswap_flush_dcache_page(struct page *page)
>>> +{
>>> +#ifdef CONFIG_ARM
>>> +       int flag = 0;
>>> +       /*
>>> +        * Ugly hack to get flush_dcache_page() work on ARM.
>>> +        * page_mapping(page) == NULL after clearing this swap cache flag.
>>> +        * Without clearing this flag, flush_dcache_page() will simply set
>>> +        * "PG_dcache_dirty" bit and return.
>>> +        */
>>> +       if (PageSwapCache(page)) {
>>> +               flag = 1;
>>> +               ClearPageSwapCache(page);
>>> +       }
>>> +#endif
>>> +       flush_dcache_page(page);
>>> +#ifdef CONFIG_ARM
>>> +       if (flag)
>>> +               SetPageSwapCache(page);
>>> +#endif
>>> +}
>>
>> The above CONFIG_ARM magic really has no place in drivers/block.
>>
>
> Please read the comment above this hack to see why its needed. Also,
> for details see this mail:
> http://www.linux-mips.org/archives/linux-mips/2008-11/msg00038.html
>
> No one replied to above mail. So, I though just to temporarily introduce this
> hack while someone makes a proper fix for ARM (I will probably ping ARM/MIPS
> folks again for this).
>
> Without this hack, ramzswap simply won't work on ARM. See:
> http://code.google.com/p/compcache/issues/detail?id=33
>
> So, its extremely difficult to wait for the _proper_ fix.

Then make ramzswap depend on !CONFIG_ARM. In any case, CONFIG_ARM bits
really don't belong into drivers/block.

>>> +
>>> +       trace_mark(ramzswap_lock_wait, "ramzswap_lock_wait");
>>> +       mutex_lock(&rzs->lock);
>>> +       trace_mark(ramzswap_lock_acquired, "ramzswap_lock_acquired");
>>
>> Hmm? What's this? I don't think you should be doing ad hoc
>> trace_mark() in driver code.
>
> This is not ad hoc. It is to see contention over this lock which I believe is a
> major bottleneck even on dual-cores. I need to keep this to measure improvements
> as I gradually make this locking more fine grained (using per-cpu buffer etc).

It is ad hoc. Talk to the ftrace folks how to do it properly. I'd keep
those bits out-of-tree until the issue is resolved, really.

>>> +       rzs->compress_buffer = kzalloc(2 * PAGE_SIZE, GFP_KERNEL);
>>
>> Use alloc_pages(__GFP_ZERO) here?
>
> alloc pages then map them (i.e. vmalloc). What did we gain? With
> vmalloc, pages might
> not be physically contiguous which might hurt performance as
> compressor runs over this buffer.
>
> So, use kzalloc().

I don't know what you're talking about. kzalloc() calls
__get_free_pages() directly for your allocation. You probably should
use that directly.

>>> +/* Debugging and Stats */
>>> +#define NOP    do { } while (0)
>>
>> Huh? Drop this.
>
> This is more of individual taste. This makes the code look cleaner to me.
> I hope its not considered 'over decoration'.

Hey, the kernel doesn't care about your or my individual taste. I'm
pointing out things that I think fall in the category of "we don't do
shit like this in the kernel", not things _I_ personally find
annoying. If you want to ignore those comments, fine, that's your
prerogative. However, people usually have better results in getting
their code merged when they listen to kernel developers who take the
time to review their code.

                        Pekka
