Return-Path: <linux-kernel-owner+w=401wt.eu-S1760584AbYFIKfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760584AbYFIKfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 06:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760270AbYFIKfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 06:35:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:25394 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760254AbYFIKfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 06:35:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JlwwW2V0ThJBy9xUkIDZf2MOCJ/jYh2cjmaHZ+hoOTLd+FpuAEc6ufW37gdz6k7NMB
         OklVxxoVtwGzKoIDyZvS6WzR6XCs4RwDImRVz3Kc9Di4x2YuGXFVwvVwGVKy1QwkCmy6
         wR8E7KRAEUuRZM1pNO4JM7Hh2NWILLiESM1Vo=
Message-ID: <19f34abd0806090335p36e3e8a1kf180dda236356754@mail.gmail.com>
Date: Mon, 9 Jun 2008 12:35:05 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [bug, 2.6.26-rc4/rc5] sporadic bootup crashes in blk_lookup_devt()/prepare_namespace()
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <19f34abd0806090209l541d93c6jaba2704314b34418@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080609080312.GA32458@elte.hu>
	 <20080609020623.b6727f2b.akpm@linux-foundation.org>
	 <19f34abd0806090209l541d93c6jaba2704314b34418@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2008 at 11:09 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Mon, Jun 9, 2008 at 11:06 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> On Mon, 9 Jun 2008 10:03:12 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>>
>>> -tip testing has started triggering a new type of sporadic bootup crash
>>> a few days ago. Find below a collection of 14 crashes i've managed to
>>> capture so far, which are all similar to this crash pattern:
>>>
>>>  BUG: unable to handle kernel paging request at ffff81003b984fb8
>>>  IP: [<ffffffff803fafd4>] blk_lookup_devt+0x42/0xa0
>>>  PGD 8063 PUD 9063 PMD 3be2d163 PTE 800000003b984160
>>>  Oops: 0000 [1] SMP DEBUG_PAGEALLOC
>>>
>>>  Call Trace:
>>>   [<ffffffff80bac17b>] ? ip_auto_config+0x0/0xd94
>>>   [<ffffffff80209259>] name_to_dev_t+0x145/0xeec
>>>   [<ffffffff803ff2be>] ? __next_cpu_nr+0x22/0x2b
>>>   [<ffffffff80b7f372>] prepare_namespace+0x91/0x14c
>>>   [<ffffffff80b7eb70>] kernel_init+0x2fe/0x314
>>>   [<ffffffff80251f3d>] ? trace_hardirqs_on_caller+0xca/0xee
>>>   [<ffffffff80741bbb>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>>>   [<ffffffff80251f3d>] ? trace_hardirqs_on_caller+0xca/0xee
>>>   [<ffffffff8020d3f8>] child_rip+0xa/0x12
>>>   [<ffffffff8020c90c>] ? restore_args+0x0/0x30
>>>   [<ffffffff8025068d>] ? trace_hardirqs_off+0xd/0xf
>>>   [<ffffffff80b7e872>] ? kernel_init+0x0/0x314
>>>   [<ffffffff8020d3ee>] ? child_rip+0x0/0x12
>>
>> Did you work out where it's dying?  Deref of `dev' I assume?
>
>                        struct gendisk *disk = dev_to_disk(dev);
>

I'm sorry, this is slightly misleading. The dev_to_disk() doesn't contain any dereferences, so therefore that can obviously not be the source of the page fault. It is just simple pointer arithmetic.

The actual dereference happens on the next line, but it appears that this dereference and the pointer magic above is collapsed by gcc into a single instruction, cmp -0x44(%ebx), %esi. I assume the -0x44 would be = 0 - offsetof(device in gendisk) + offsetof(minors in gendisk).

So the error seems to be in dereferencing disk->minors, not dev.

And the fact that this causes a page fault seems to be pure luck; if the struct device object is placed higher than 0x44 in a page, it won't give the page fault (but simply access some valid, random memory). There seems to be a pretty good chance of an address being offset more than 0x44 bytes within a page given that a whole page is 0x1000 bytes :-)

The other condition that must be present for this fault to trigger is that the previous page must not have been mapped. Ouch. That sounds like two rare conditions!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while the programmer was not looking is intellectually dishonest as it disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
