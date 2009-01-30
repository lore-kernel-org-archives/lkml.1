Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbZA3C3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbZA3C3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 21:29:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbZA3C3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 21:29:46 -0500
Received: from viefep17-int.chello.at ([62.179.121.37]:24626 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZA3C3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 21:29:45 -0500
X-SourceIP: 62.24.72.246
From: Pavel Pisa <pisa@cmp.felk.cvut.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/2] epoll fix own poll()
Date: Fri, 30 Jan 2009 03:29:35 +0100
User-Agent: KMail/1.9.9
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.DEB.1.10.0901271251310.20262@alien.or.mcafeemobile.com> <alpine.DEB.1.10.0901291030390.15448@alien.or.mcafeemobile.com> <20090129103715.2d3a8274.akpm@linux-foundation.org>
In-Reply-To: <20090129103715.2d3a8274.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901300329.35641.pisa@cmp.felk.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 January 2009 19:37:15 Andrew Morton wrote:
> On Thu, 29 Jan 2009 10:32:38 -0800 (PST) Davide Libenzi <davidel@xmailserver.org> wrote:
> > On Thu, 29 Jan 2009, Andrew Morton wrote:
> > > But which kernel version are you looking to get this merged into?
> >
> > The limit reworking one, ASAP. The epoll poll fix, dunno.
> > I'd like to see it staged in your tree for a bit. How much timeframe
> > difference are we looking at, from .29 to .30?
>
> The usual - 2.5 months(ish)
>
> What is the impact of the bug which this patch fixes?

Hello Andrew and Davide

the problem is caused by epoll used in another event waiting mechanism.
In my problem appeared only for epoll cascaded to epoll and slight
changes in code resulted in problem vanishing. It is probably timing
sensitive. Davide analyzed, that it can appear even for cascading of
epoll into other mechanisms - poll, select etc.

The situations which could result in the problem

The idea to cascade epoll into other mechanisms comes to mind
in many cases. When I have been working on my event processing
solution and finding how to live in peace with GLIB (and through it with
Qt) I have found, that others have headed same direction.
The concept to cover more corresponding sources under one FD
is promissing to sole other task too (prioritization found
in Mikhail Zabaluev's GPollSet implementation for GLIB for example).

There is my personal feeling about problem severity:

The severity is increased by fact, that epoll cascading is documented
and in fact offered as feature by epoll manpage. That there exists
more attempts to use it. The problem in typical case appears
as random stuck of userspace code in busyloop without any
error indication from system calls.

  do {
      select/poll/epoll_wait on epfd
      /* above line returns imediately because epoll->poll() indicates ready event*/
      if there is event on epfd {
         epoll_wait ( epfd, timeout = 0) /* to find which event is ready */
         /* but no ready event is reported and cycle starts again */
      }
  } while(1)

So if there exists applications using epoll, they could waste sometimes
most of CPU time without without any visible error indication. 
The most critical problem is, that even epoll_wait() on epoll set, which
reports falsely ready condition, doe not clear that state for outer
loop and event waiting mechanism. So in theory, some patch with
smaller scale and impact which only ensures, that event is not falsely
reported even after epoll_wait() call would be enough to save system
from busyloop load. The false wakeup and wasted call to epoll_wait ()
with no event returned is not so big problem.

On the other hand, most of today applications are based on GLIB (poll),
Qt (for pure Qt select) or libevent (not cascaded poll/epoll), which all are
not prone to this problem. Even for my intended use, my code can
work without cascading and if cascading is required, then standard
poll and  then moving of events triggers into GLIB loop is enough
for 10 to 100 FDs. So actual real severity is not so high.

I am happy that Davide has found fix to the problem, but even if the
fix gets into 2.6.29 there would be older kernels for years there
and use of epoll cascading would be problem. So I see as most
important, that information about problem is known and does not
surprise others. It would be great, if there is found safe way,
how to ensure even without fix to revive from ill situation
by some userspace action on older kernels.
I do not see yet, why call to epoll_wait() does not to clean
"rdllist" on unpatched kernel. 

epoll_wait() unconditionally calls  ep_poll(), the "rdllist" is not empty
(cheked by previous ep_eventpoll_poll() call), so ep_send_events()
has to be called. It moves all events from "rdllist" onto  "txlist"
and reports events confirmed by individual poll() calls to user.
There could be non signaling events in the "rdlist" left there from
previous scan for level triggering events or in case, that condition
is reset by some other intervention before  ep_eventpoll_poll().
All this is not problem yet, it would result in one abundant call to
epoll_wait() which returns 0. No problem. The EPOLLET events
are moved from "rdlist", others (level triggered events) signalling
are queued on "rdlist" again. If userspace does its duty, they would
be removed during next call. This all seems to suggests, that one
abundant epoll_wait() would get things back on the right path.
All critical processing (moving between lists) seems to be under
held of spinlock, so possibility for bugs is low. I have not yet analyzed
overflow list which complicates things.

I am not clever enough, to see, where is the problem, that situation
is not stabilized. Can you teach me Davide, please?

Thanks again much for help,

                                  Pavel












