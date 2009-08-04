Return-Path: <linux-kernel-owner+w=401wt.eu-S932855AbZHDPlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855AbZHDPlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 11:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932355AbZHDPlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 11:41:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932347AbZHDPlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 11:41:14 -0400
Date: Tue, 4 Aug 2009 08:40:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Greg KH <greg@kroah.com>
cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: proper tty-ldisc refcounting (was Re: WARNING at:
 drivers/char/tty_ldisc.c)
In-Reply-To: <20090804072351.GA17474@kroah.com>
Message-ID: <alpine.LFD.2.01.0908040825210.3270@localhost.localdomain>
References: <alpine.LFD.2.01.0908021423490.3352@localhost.localdomain> <20090802234851.3fd1ac2c@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0908021654010.3352@localhost.localdomain> <alpine.LFD.2.01.0908031047010.3208@localhost.localdomain> <20090803181811.GA15848@kroah.com>
 <20090804003009.GA3121@localdomain.by> <alpine.LFD.2.01.0908031751270.3270@localhost.localdomain> <20090804035319.GA7248@kroah.com> <20090804040834.GA16696@kroah.com> <alpine.LFD.2.01.0908032319290.3270@localhost.localdomain>
 <20090804072351.GA17474@kroah.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 4 Aug 2009, Greg KH wrote:
> 
> Ok, but due to the lateness of the release cycle, is it worth it to add
> those 3 right now?  Or do we just take the BUG_ON() out as it's pretty
> harmless while shutting down in single user mode?
> 
> What do you think?

If the WARN_ON() happens, it's not just that we have a refcount being off, 
we'll also have memory corruption and a potential oops a bit later. 

Why? Simply because somebody will be touching that 'struct ldisc', even if 
it will be just a decrement of the word that contained the refcount. So we 
have a pretty much guaranteed use-after-free scenario.

So taking out the WARN_ON() is the wrong thing. In that case it would 
probably be better to just leave the WARN_ON(), and at least know "ok, bad 
things happened". 

So I think we have a few options:

 - leave things as-is, leave the WARN_ON(), and know that it's very rare, 
   but that bad things can happen when it triggers.

   The thing I really dislike about this one is that yes, it's rare, but 
   I could see it be user-triggerable. Users do have access to 
   /dev/console when they are logged in at the console.

 - Change the old code from

	WARN_ON(ld->refcount);
	kfree(ld);

   to

	if (!WARN_ON_ONCE(ld->refcount))
		kfree(ld);

   which at least doesn't free the ldisc if it is in use. So now you have 
   a memory leak, but at least hopefully no actual corruption and 
   use-after-free. It's still a bug, but it won't be causing other bugs 
   down the line (except for running out of memory if you can trigger it 
   really easily, but that's unlikely, and I think preferable to unknown 
   problems - even if the unknown problems are very unlikely)

 - Take the three patches now.

I suspect we should take the three now. All of the issues are due to 
totally rewritten code since 2.6.30 - I suspect the risk from new bugs 
from that refcounting series is _smaller_ that the risk of bugs from the 
original ldisc rewrite (commit c65c9bc3e), and if there are bugs, I 
suspect the three patches are more likely to help than to hurt.

			Linus
