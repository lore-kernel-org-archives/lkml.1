Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbZFUHD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbZFUHD5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 03:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbZFUHDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 03:03:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33332 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbZFUHDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 03:03:50 -0400
Date: Sun, 21 Jun 2009 08:58:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: memconsole: a virtual console to record the Oops message for
	debugging purpose.
Message-ID: <20090621065844.GC1810@ucw.cz>
References: <412e6f7f0906131829y6e0abb00j85e221f92ab439d2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <412e6f7f0906131829y6e0abb00j85e221f92ab439d2@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-06-14 09:29:48, Changli Gao wrote:
> Dear Linus:
> 
> In the production environment, it is hard to find the causion of an
> Oops message if a bug causes the kernel panics. Though the Oops
> message is printed on the screen, we can't read the whole message in
> most cases due to the size of the screen, and it is hard to save the
> Oops message for debugging. I know kdump is a choice, but it needs
> more memory, and in most cases, Oops messages are enough to find out
> the bugs. The other choices are netconsole and serial line, but they
> both need extra computers.
> 
> memconsole as a virtual console, will save the messages into a block
> of boot memory reserved. Because the memory won't be cleaned(if the
> self-check on memory is disabled) between two starts, the oops
> messages as the other console messages will be saved between them, and
> you have a chance to see what happened in the last start.
> 
> In order to avoid the corruption of the memory used by memconsole, I
> find the memory from the end to the start.
> 
> Here is the code, and the code is mess currently. Am I in the right
> direction? Are my assumptions right?
> 
> the following code is appended to the file mm/bootmem.c

Generate proper patch...

> void *memconsole_mem_start = NULL;
> EXPORT_SYMBOL_GPL(memconsole_mem_start);
> unsigned int memconsole_mem_size = 0;
> EXPORT_SYMBOL_GPL(memconsole_mem_size);
> 
> static int __init memconsole_setup(char *str)
> {
>         unsigned long start;
> 
>         memconsole_mem_size = simple_strtoul(str, NULL, 10);
>         memconsole_mem_size = PAGE_ALIGN(memconsole_mem_size);
>         for (start = max_low_pfn - (memconsole_mem_size >> PAGE_SHIFT);
>              start >= min_low_pfn;
>              start -= (memconsole_mem_size >> PAGE_SHIFT)) {
>                 if (reserve_bootmem_generic(start << PAGE_SHIFT,
>                                             memconsole_mem_size,
>                                             BOOTMEM_EXCLUSIVE) >= 0)
>                         break;
>         }
>         if (start < min_low_pfn)
>                 panic("Can't reserve bootmem for memconsole\n");
>         memconsole_mem_start = phys_to_virt(start << PAGE_SHIFT);
>         printk("reserve bootmem for memconsole %u@%p\n",
>                memconsole_mem_size, memconsole_mem_start);
> 
>         return 1;
> }
> __setup("memconsole=", memconsole_setup);
> 
> An individual kernel module is used to implement the whole function.

> Certainly, I tested it on my virtual machine, and I did work.

...and test it on real hw...?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
