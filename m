Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbZA1SNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbZA1SNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 13:13:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZA1SMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 13:12:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34392 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbZA1SMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 13:12:54 -0500
Message-ID: <4980A03A.2030400@redhat.com>
Date: Wed, 28 Jan 2009 13:13:14 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Nick Piggin <npiggin@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [BUG][kprobes][vunmap?]: kprobes may cause memory corruption
References: <497FC3B1.7050805@redhat.com> <497FE895.1080708@redhat.com> <20090128154824.GA6025@Krystal> <49808EEF.1020700@redhat.com> <20090128171331.GA9006@Krystal> <49809CCE.40409@redhat.com>
In-Reply-To: <49809CCE.40409@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Mathieu Desnoyers wrote:
>> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
>>> Mathieu Desnoyers wrote:
> [...]
>>>> All this called in a loop. This would help isolating the "vmap" part of
>>>> the issue. If this test is not enough, then we should maybe try
>>>> something like this in a kernel module (which does what text_poke does
>>>> with vmalloc, more or less) in a loop :
>>>>
>>>> char somedata[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
>>>> char copydata[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
>>> Should both of them have PAGE_SIZE*2?
>>>
>> Yes.
>>
>>>> void test_vmap(void)
>>>> }
>>>>   struct page *pages[2];
>>>>   char *vaddr;
>>>>   int i;
>>>>
>>>>   for (i = 0; i < 2 * PAGE_SIZE; i++)
>>>>     copydata[i] = somedata[i];
>>>>   page[0] = virt_to_page(&somedata);
>>>>   BUG_ON(!page[0]);
>>>>   page[1] = virt_to_page(&somedata + PAGE_SIZE);
>>>>   BUG_ON(!page[1]);
> 
> Oops, these should be vmalloc_to_page(), shouldn't it?
> 
>>>>   vaddr = vmap(pages, 2, VM_MAP, PAGE_KERNEL);
>>>>   BUG_ON(!vaddr);
>>>>
>>>>   for (i = 0; i < 2 * PAGE_SIZE; i++)
>>>>     vaddr[i] = copydata[i] + 1;
>>>>   
>>>>   vunmap(vaddr);
>>>>   
>>>>   for (i = 0; i < 2 * PAGE_SIZE; i++)
>>>>     BUG_ON(somedata[i] != copydata[i] + 1);
>>>> }
>>> Hmm, when I ran above code, it hit the last BUG_ON().
>>> I checked that somedata[i] didn't updated.
>>>
>> Do you hit the BUG_ON after the first loop ?
> 
> At the first loop, it hit the BUG_ON.
> 
>>>> Given you don't seem to have hit the
>>>>         for (i = 0; i < len; i++)
>>>>                 BUG_ON(((char *)addr)[i] != ((char *)opcode)[i]);
>>>> test at the end of text_poke,
>>> However, when I ran kprobe-based test, it doesn't hit the BUG_ON()
>>> in text_poke().
>>>
>> The variable declarations should have been 2*PAGE_SIZE, hopefully you
>> fixed them.
> 
> Sure,
> 
>> There is also a sync_core() in text_poke. It should not matter, but
>> maybe that could help ?
> 
> Adding sync_core() could not help me... anyway, I'll try again
> with using vmalloc_to_page().

Hmm, using vmalloc_to_page() works fine... the test didn't hit any BUG_ON.

> 
>>>> I suspect the write through the vmapped
>>>> area is correctly done, but that the problem may lay in the mm layer.
>>>> Maybe it's running out of pre-allocated vmap areas or something like
>>>> this ?
>>> I haven't seen vmalloc failure message on 2.6.29-rc2.
>>>
>> It could be because the available vmalloc space is slightly higher.
>> Looking into the lazy vunmap threshold would be useful.
>>
>> You could also try with loop values higher than 400.

I also tested with 1000 loops, but nothing happened.

Thank you,

> 
> OK, Thanks,
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

