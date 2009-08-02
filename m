Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbZHBRQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbZHBRQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 13:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbZHBRQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 13:16:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750716AbZHBRQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 13:16:58 -0400
Date: Sun, 2 Aug 2009 10:16:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: WARNING at: drivers/char/tty_ldisc.c
In-Reply-To: <20090802120120.GA3097@localdomain.by>
Message-ID: <alpine.LFD.2.01.0908020940530.3352@localhost.localdomain>
References: <20090802120120.GA3097@localdomain.by>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 2 Aug 2009, Sergey Senozhatsky wrote:
>
> Looks like we have one more bug in tty code:
> 'shutdown -r now' in 'single' user mode gives following trace:
> 
> WARNING at: drivers/char/tty_ldisc.c:209 tty_ldisc_put+0x95/0xa0
> ---
> warn_slowpath_common+0x78/0xa0
> warn_slowpath_null+0x21/0x40
> tty_ldisc_put+0x95/0xa0
> tty_ldisc_hangup+0xfc/0x1f0
> do_tty_hangup+0x131/0x380
> disassociate_ctty+0x50/0x210
> do_exit+0x6b8/0x700
> do_group_exit+0x45/0xb0
> get_signal_to_deliver+0x226/0x410
> do_notify_resume+0xc1+0xa90
> work_notifysig+0x13/0x19
> 
> //There is no trace in syslog, so given one is 'copy-paste' from the paper.

We have that 'refcount' counter for the ldisc, but we don't actually use 
it for memory management like we should (ie "free the ldisc when count 
goes to zero"), we just decrement it and free the thing.

And it's quite possible that another CPU is doing some tty read thing or 
other that does

	tty_ldisc_try(..) // increments ld->refcount
	...
	tty_ldisc_deref(..) // decrements it.

at the same time. 

The ldisc refcounts are simply done wrong. They are more debugging aids 
(for the case where no races occur), than actual memory management 
refcounts.

Now, when you do refcounts wrong like that, the "fix" for it is to wait 
for the count to go to zero before releasing things (the problem with that 
fix is that it tends to be complicated and prone to deadlocks etc).

And the tty layer really does try to handle this with that 

	tty_ldisc_halt() - clear TTY_LDISC so that no new refs are taken
	tty_ldisc_wait_idle()  - wait for all old refs to go away

which it did just before the call to 'tty_ldisc_reinit()' (which is 
apparently inlined) that will then call 'tty_ldisc_put()', which is what 
complains.

So we've actually just waited for the count to go down to zero, and now 
it's not zero again. Which _should_ be impossible since the TTY_LDISC bit 
is clear, of course.

But there are things that enable TTY_LDISC, like a 'tty_set_ldisc()' done 
on another CPU. Which does try to protect things with 'tty->ldisc_mutex', 
but in the case of pty's in particular, there are _two_ tty's involved, 
and it does things like

	if (o_tty)
		tty_ldisc_enable(o_tty);

to re-enable the "other" tty, without holding the lock for that tty. 

And I don't think we can just take the lock either, because that's an ABBA 
deadlock when you do it trivially.

I dunno. It might not be the above, there might be something else going 
on, I'll have to think about/look at it a bit more. 

		Linus
