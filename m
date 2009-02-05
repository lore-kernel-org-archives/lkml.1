Return-Path: <linux-kernel-owner+w=401wt.eu-S1760852AbZBEUX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760852AbZBEUX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 15:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756923AbZBEUXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 15:23:42 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:33453 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603AbZBEUXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 15:23:41 -0500
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Date: Thu, 05 Feb 2009 12:23:39 -0800
Subject: [patch 0/6] epoll keyed wakeups v3 - introduction
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.21761.1233865419.0>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The follwing patch set introduces wakeup hints for some of the most
popular (from epoll POV) devices, so that epoll code can avoid spurious
wakeups on its waiters.
The problem with epoll is that the callback-based wakeups do not, ATM,
carry any information about the events the wakeup is related to.
So the only choice epoll has (not being able to call f_op->poll() from
inside the callback), is to add the file* to a ready-list and resolve
the real events later on, at epoll_wait() (or its own f_op->poll()) time.
This can cause spurious wakeups, since the wake_up() itself might be
for an event the caller is not interested into.
The rate of these spurious wakeup can be pretty high in case of many
network sockets being monitored.
By allowing devices to report the events the wakeups refer to (at least
the two major classes - POLLIN/POLLOUT), we are able to spare useless
wakeups by proper handling inside the epoll's poll callback.
Epoll will have in any case to call f_op->poll() on the file* later on,
since the change to be done in order to have the full event set sent
via wakeup, is too invasive for the way our f_op->poll() system works
(the full event set is calculated inside the poll function - there are
too many of them to even start thinking the change - also poll/select
would need change too).
Epoll is changed in a way that both devices which send event hints, and
the ones that don't, are correctly handled. The former will gain some
efficiency though.
As a general rule for devices, would be to add an event mask by using
poll wakeup macros, when making up poll wait queues.
I tested it (together with the epoll's poll fix patch Andrew has in -mm)
and wakeups for the supported devices are correctly filtered.
Test program available here:

http://www.xmailserver.org/epoll_test.c

ChangeLog / v3:

- wake_up_nested() was only used by epoll, so the new wake_up_nested_poll()
  has been moved into fs/eventpoll.c, and wake_up_nested() being no more
  used, has been dropped

ChangeLog / v2:

- No more kwake*() but *_poll()

- Do not add extra parameter to _locked() and _sync(), but create two
  new functions

- Actually make epoll used _poll() wakeups too for its own waiters


PS: Andrew, those are directly based over the bits you already have
    in -mm.


- Davide


