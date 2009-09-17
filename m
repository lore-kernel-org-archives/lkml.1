Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbZIQUmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbZIQUmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 16:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbZIQUmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 16:42:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752313AbZIQUmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 16:42:05 -0400
Date: Thu, 17 Sep 2009 13:42:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Volkov <pva@gentoo.org>
cc: gregkh@suse.de, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31 regression: system hang after pptp connection
 established
In-Reply-To: <1253217553.3271.77.camel@tablet>
Message-ID: <alpine.LFD.2.01.0909171327230.4950@localhost.localdomain>
References: <1253217553.3271.77.camel@tablet>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Sep 2009, Peter Volkov wrote:
> 
> After pptp connection is established my 2.6.31 system freezes while
> 2.6.30 works as expected. Bissecting gave me the following result:
> 
> commit ac89a9174decf343de049a06fad75681f71890eb
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sat Sep 5 13:27:10 2009 -0700
> 
>     pty: don't limit the writes to 'pty_space()' inside 'pty_write()'
> 
> and looks like reverting this patch from 2.6.31 fixes the problem.

Hmm. The only thing it should cause is that pty_write() will effectively 
allow a larger buffer for writes (limited to ~64kB rather than 8kB).

But considering how fragile ppp has been, I guess I shouldn't be surprised 
that this can cause a hang in itself.

> In hope to get any oops I've started netconsole but at hang no new ouput
> was there. I've managed to gather some information with SysRq (it's
> gzipped in attachment) but I'm not sure how useful it is.

It's interesting, but I don't know how _useful_ it is.

What's interesting about it is that it shows a problem, but the problem it 
shows would seem to have nothing at all to do with ppp or networking or 
pty's. The problem seems to be processes stuck in disk-wait:

	events/0      D ffff88007d0c7b50     0     7      2 0x00000000
	events/0      D ffff88007d0c7b50     0     7      2 0x00000000
	kacpi_notify  D ffff88007d2ffbe8     0   170      2 0x00000000
	khubd         D ffff88007d211ae8     0   260      2 0x00000000
	pdflush       D ffff88007d26bd40     0   326      2 0x00000000
	kjournald     D ffff88007b2f3df8     0  3361      2 0x00000000
	kjournald     D ffff88007c65ddf8     0  3362      2 0x00000000
	reiserfs/0    D [<ffffffff810725f7>] ? delayacct_end+0x81/0x8c
	events/0      D ffff88007d0c7b50     0     7      2 0x00000000
	kacpi_notify  D ffff88007d2ffbe8     0   170      2 0x00000000
	khubd         D ffff88007d211ae8     0   260      2 0x00000000
	pdflush       D ffff88007d26bd40     0   326      2 0x00000000
	kjournald     D ffff88007b2f3df8     0  3361      2 0x00000000
	kjournald     D ffff88007c65ddf8     0  3362      2 0x00000000

which explains your symptoms - hung X (with just cursor moving) and ssh's 
hanging.

It's just that while it all explains your symptoms, none of the above 
should have anything what-so-ever to do with pty's!

pdflush, for example, seems to be stuck waiting for &jl->j_commit_mutex in 
reiserfs. Odd. It really looks like you have something stuck waiting for 
IO.

But your CPU 1 backtrace looks relevant, and seems hung on a spinlock in 
tty_buffer_request_room() and has that pty_write() thing there. I'm not 
seeing why the 'D' states above happen, though.

> I've tried to establish pptp connection both over wireless and wired
> connections and system hanged with both, so it looks like networking
> drivers are not the reason here. BTW, I'm using networkmanager to
> establish connection.
> 
> gzipped kernel config is in attachment.
> 
> Is this problem known? Does anybody experience same problem? Do you have
> a fix? :)

Not a known problem, but it's entirely possible that there is some bug in 
the "tty buffer out of memory" handling - that nobody has ever seen 
because in practice everybody always hit other limits first.

Let me look at it a bit, and see if I can come up with test patches for 
you.

		Linus
