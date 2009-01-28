Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbZA1Q7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbZA1Q7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 11:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbZA1Q7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 11:59:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40367 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbZA1Q7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 11:59:08 -0500
Message-ID: <49808EEF.1020700@redhat.com>
Date: Wed, 28 Jan 2009 11:59:27 -0500
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
References: <497FC3B1.7050805@redhat.com> <497FE895.1080708@redhat.com> <20090128154824.GA6025@Krystal>
In-Reply-To: <20090128154824.GA6025@Krystal>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
>> Masami Hiramatsu wrote:
> Hi Masami,
> 
> This would not surprise me if it came from bug in the new vmap()
> implementation done in this commit :
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=db64fe02258f1507e13fe5212a989922323685ce
> 
> Especially because going from vmap -> vm_map_ram makes this behavior
> disappear.
> 
> Looking at the commit, I notice that it delays vunmap so it's done in
> batch to minimize locking effect. I think it would be good to create a
> test case to try to isolate this, without any kprobes/text_poke
> involved, which does something like this :
> 
> load module (this is also doing vmalloc, so it might be part of the
>              problem)
>   for i (i=0; i < 400; i++) {
>     vmap()
>     vfree()
      ^^^^^ vunmap?
>   }
> unload module
> 
> Another interesting test would be :
> 
>   for i (i=0; i < 400; i++) {
>     vmalloc()
>     vfree()
>   }

Hi Mathieu,

Thank you for test ideas.
I made both of above two tests and run it. Both test modules
do NOT cause memory corruption...

> All this called in a loop. This would help isolating the "vmap" part of
> the issue. If this test is not enough, then we should maybe try
> something like this in a kernel module (which does what text_poke does
> with vmalloc, more or less) in a loop :
> 
> char somedata[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
> char copydata[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));

Should both of them have PAGE_SIZE*2?

> 
> void test_vmap(void)
> }
>   struct page *pages[2];
>   char *vaddr;
>   int i;
> 
>   for (i = 0; i < 2 * PAGE_SIZE; i++)
>     copydata[i] = somedata[i];
>   page[0] = virt_to_page(&somedata);
>   BUG_ON(!page[0]);
>   page[1] = virt_to_page(&somedata + PAGE_SIZE);
>   BUG_ON(!page[1]);
>   vaddr = vmap(pages, 2, VM_MAP, PAGE_KERNEL);
>   BUG_ON(!vaddr);
> 
>   for (i = 0; i < 2 * PAGE_SIZE; i++)
>     vaddr[i] = copydata[i] + 1;
>   
>   vunmap(vaddr);
>   
>   for (i = 0; i < 2 * PAGE_SIZE; i++)
>     BUG_ON(somedata[i] != copydata[i] + 1);
> }

Hmm, when I ran above code, it hit the last BUG_ON().
I checked that somedata[i] didn't updated.

> Given you don't seem to have hit the
>         for (i = 0; i < len; i++)
>                 BUG_ON(((char *)addr)[i] != ((char *)opcode)[i]);
> test at the end of text_poke,

However, when I ran kprobe-based test, it doesn't hit the BUG_ON()
in text_poke().

> I suspect the write through the vmapped
> area is correctly done, but that the problem may lay in the mm layer.
> Maybe it's running out of pre-allocated vmap areas or something like
> this ?

I haven't seen vmalloc failure message on 2.6.29-rc2.

Thank you again,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

