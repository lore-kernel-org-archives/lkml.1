Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588AbZEaRVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbZEaRVo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 13:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbZEaRVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 13:21:36 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59134 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbZEaRVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 13:21:36 -0400
Message-ID: <4A22BB99.1070104@cs.helsinki.fi>
Date: Sun, 31 May 2009 20:17:13 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Larry H." <research@subreption.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] Use kzfree in tty buffer management to enforce data 
 sanitization
References: <20090531015537.GA8941@oblivion.subreption.com> <alpine.LFD.2.01.0905301902530.3435@localhost.localdomain> <84144f020905302324r5e342f2dlfd711241ecfc8374@mail.gmail.com> <20090531112630.2c7f4f1d@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0905311002010.3435@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0905311002010.3435@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-14; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Sun, 31 May 2009, Alan Cox wrote:
>>>>        memset(buf->data, 0, N_TTY_BUF_SIZE);
>>>>        if (PAGE_SIZE != N_TTY_BUF_SIZE)
>>>>                kfree(...)
>>>>        else
>>>>                free_page(...)
>>>>
>>>>
>>>> but quite frankly, I'm not convinced about these patches at all.
>>> I wonder why the tty code has that N_TTY_BUF_SIZE special casing in
>>> the first place? I think we can probably just get rid of it and thus
>>> we can use kzfree() here if we want to.
>> Some platforms with very large page sizes override the use of page based
>> allocators (eg older ARM would go around allocating 32K). The normal path
>> is 4K or 8K page sized buffers.

Linus Torvalds wrote:
> I think Pekka meant the other way around - why don't we always just use 
> kmalloc(N_TTY_BUF_SIZE)/kfree(), and drop the whole conditional "use page 
> allocator" entirely?
> 
> I suspect the "use page allocator" is historical - ie the tty layer 
> originally always did that, and then when people wanted to suppotr smaller 
> areas than one page, they added the special case. I have this dim memory 
> of the _original_ kmalloc not handling page-sized allocations well (due to 
> embedded size/pointer overheads), but I think all current allocators are 
> perfectly happy to allocate PAGE_SIZE buffers without slop.
> 
> If I'm right, then we could just use kmalloc/kfree unconditionally. Pekka?

Yup, that's what I meant. Even SLAB moves metadata off-slab to make sure 
  we support PAGE_SIZE allocations nicely. SLUB even used to pass 
kmalloc(PAGE_SIZE) directly to the page allocator and will likely do 
that again once Mel Gorman's page allocator optimization patches hit 
mainline.

			Pekka
