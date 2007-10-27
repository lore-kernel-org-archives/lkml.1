Return-Path: <linux-kernel-owner+w=401wt.eu-S1752669AbXJ0HAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbXJ0HAa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 03:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbXJ0HAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 03:00:23 -0400
Received: from doom.schmorp.de ([87.139.53.102]:47747 "EHLO doom.schmorp.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbXJ0HAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 03:00:22 -0400
X-Greylist: delayed 2263 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Oct 2007 03:00:21 EDT
Date: Sat, 27 Oct 2007 08:22:36 +0200
From: Marc Lehmann <linux-kernel@tst.eu>
To: linux-kernel@vger.kernel.org
Cc: Davide Libenzi <davidel@xmailserver.org>
Subject: epoll design problems with common fork/exec patterns
Message-ID: <20071027062236.GA12476@schmorp.de>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Davide Libenzi <davidel@xmailserver.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-PGP: "1024D/DA743396 1999-01-26 Marc Alexander Lehmann <schmorp@schmorp.de>
       Key fingerprint = 475A FE9B D1D4 039E 01AC  C217 A1E8 0270 DA74 3396"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I ran into what I see as unsolvable problems that make epoll useless as a
generic event mechanism.

I recently switched to libevent as event loop, and found that my programs
work fine when it is using select or poll, but work eratically or halt
when using epoll.

The reason as I found out is the peculiar behaviour of epoll over fork.
It doesn't work as documented, and even if, it would make the use of
third-party libraries using fork usually impossible.

Here are two scenarios where it screws up:

- some library forks, explicitly closes all fd's it doesn't need, and execs
  another program (which is common behvaiour).

  In this case, the parent process works fine until the child closes fds,
  after which the fds become unarmed in the parent too. This works as
  documented, but since libraries expect this to work without affecting the
  parent, this puts a new and incompatible strain on what libraries can do,
  which in turn makes epoll unsuitable in cases where you don't control all
  your code.

- I have a library that emulates asynchronous I/O with a thread pool, and
  uses a pipe for event notification. That library registers a fork handler
  that closes the pipe in the child and recreates it, so the child could
  continue doing AIO (as could the parent).

  This, too, screws up notifications for the parent,

Now, the epoll manpage says that closing a fd will remove it from all
fd sets. This would explain the behaviour above. Unfortunately (or
fortunately?) this is not what happens: when the fds are being closed by
exec or exit, the fds do not get removed from the epoll set.

This behaviour strikes me as extremely illogical. On the one hand, one
cannot share the epoll fd between processes normally, but on fork,
you can, even though it makes no sense (the child has a different fd
"namespace" than the parent) and actually works on (then( unrelated fds in
the other process.

It also strikes as weird that the order of closing fds should make so much
of a difference: if the epoll fd is closed first in the child, the other
fds will survive in the parent, if its closed last, they don't. Makes no
sense to me.

Now, the problem I see is not that it makes no sense to me - thats clearly
my problem. The problem I see is that there is no way to avoid the
associated problems except by patching all code that would ever use fork,
even if it never has heard anything about epoll yet. This is extremely
nonlocal action at a distance, as this affects a lot of code not even the
author might be aware of (fork is rather common).

To illustrate, here are some workarounds I thought about:

- rearming all fds after fork: doesn't work, as the fds get removed
  asynchronously so I would have to wait for the child to do it.
- closing the epoll fd after fork: doesn't work unless I control
  the fork. I can install a handler to be called using pthreads, but
  that won't help as other handlers might be called first (as in the case of
  the aio library above), screwing me.
- closing and recreating the epoll fd before the fork: isn't support event
  remotely by libevent or similar event loops, and would not help either
  as I cnanot control the calls to fork.

Is epoll really designed to be so incompatible with the most commno fork
patterns? Shouldn't epoll do refcounting, as is commonly done under
Unix? As the fd space is not shared between rpocesses, why does epoll
try? Shouldn't the epoll information be copied just like the fd table
itself, memory, and other resources?

As it looks now, epoll looks useless except in the most controlled
environments, as it doesn't duplicate state on fork as is done with the
other fd-related resources (as opposed to the underlying files, which are
properly shared).

-- 
                The choice of a 
      -----==-     _GNU_              Deliantra, the free in data+content MORPG
      ----==-- _       generation
      ---==---(_)__  __ ____  __      http://www.deliantra.net/
      --==---/ / _ \/ // /\ \/ /
      -=====/_/_//_/\_,_/ /_/\_\
