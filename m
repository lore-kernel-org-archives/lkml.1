Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab0BBVps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 16:45:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46063 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756629Ab0BBVpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 16:45:47 -0500
Message-ID: <4B689CF2.7000409@zytor.com>
Date: Tue, 02 Feb 2010 13:45:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Michal Simek <michal.simek@petalogix.com>,
       LKML <linux-kernel@vger.kernel.org>,
       John Williams <john.williams@petalogix.com>
Subject: Re: Split 'flush_old_exec' into two functions - 221af7f87b97431e3ee21ce4b0e77d5411cf1549
References: <4B66DE64.8010101@petalogix.com> <alpine.LFD.2.00.1002010741560.4206@localhost.localdomain> <4B67FB74.4030409@petalogix.com> <alpine.LFD.2.00.1002020726290.3664@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002020726290.3664@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2010 07:50 AM, Linus Torvalds wrote:
> 
> Normally, that would happen, but this patch got applied early _literally_ 
> because I wanted it to hit -rc6 rather than wait any longer. So it had 
> only a day or two of discussion, and probably just a few hours from the 
> final version.
> 
> That said, I think I may have found the cause.
> 
> Peter: look at setup_new_exec(), and realize that it got moved _down_ to 
> after all the personality setting. So far, so good, that was the 
> intention, but look at what it does:
> 
> 	current->flags &= ~PF_RANDOMIZE;
> 
> and look at how fs/binfmt_elf.c does it not just after the personality 
> setting, but also after
> 
> 	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
> 		current->flags |= PF_RANDOMIZE;
> 
> so it looks like you may have moved it down too much.
> 

Yes, not entirely surprising.

> I think you did that because you wanted to do that
> 
> 	arch_pick_mmap_layout(current->mm);
> 
> in setup_new_exec(). Which makes total sense, but it all means that the 
> whole preparatory patch did way more than my initial one (which put 
> setup_new_exec() right after flush_old_exec())

Yes, that was the intention, and I did specify that I had folded in my
(previously posted as a separate patch) changes; the intent was to avoid
a bisect hole.  I didn't describe it well because of the rush, though.

> Michael, mind trying this (UNTESTED!) patch? It makes conceptual sense, 
> and moves some more of the flushing of the old process state up to 
> "flush_old_exec()" rather than doing it late in "setup_new_exec()".
>
> (I suspect we should also move the signal/fd flushing there, but I doubt 
> it matters)

Quite.

	-hpa
