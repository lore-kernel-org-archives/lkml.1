Return-Path: <linux-kernel-owner+w=401wt.eu-S932907AbYB2Pqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932907AbYB2Pqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 10:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbYB2Pqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 10:46:37 -0500
Received: from qb-out-0506.google.com ([72.14.204.224]:3663 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbYB2Pqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 10:46:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EqPoE0IXwFz+DE+Hp+D1q35gK+EL0TRSvzIW46f/5vatqr7r42lRdLyjW7eCA7numngz7jZIlB8kO4FzI3jV71jUdUpONdO8+VaL+eD7cS/3+xC2wot2lb2027aWnpmHlNSU33NAfXDQ20r4Mc1J+H64/DKG9tcTl/CXNjazpRU=
Message-ID: <cfd18e0f0802290746p3cb7efc9j72394cd77ff37829@mail.gmail.com>
Date: Fri, 29 Feb 2008 16:46:32 +0100
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: epoll design problems with common fork/exec patterns
Cc: "=?ISO-8859-1?Q?Chris_\"=A5=AF\"_Heath?=" <chris@heathens.co.nz>,
       "David Schwartz" <davids@webmaster.com>, dada1@cosmosbay.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       linux-man@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0802281106050.7660@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <MDEHLPKNGKAHNMBLJOLKAEHCHNAC.davids@webmaster.com>
	 <Pine.LNX.4.64.0710291147180.3387@alien.or.mcafeemobile.com>
	 <47C42CA7.4030607@gmail.com>
	 <Pine.LNX.4.64.0802261049040.27243@alien.or.mcafeemobile.com>
	 <1204075804.5238.7.camel@linux.heathens.co.nz>
	 <Pine.LNX.4.64.0802271131180.377@alien.or.mcafeemobile.com>
	 <cfd18e0f0802280512q43a457d0sc9a8dc83c51e8e1c@mail.gmail.com>
	 <Pine.LNX.4.64.0802281106050.7660@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

On Thu, Feb 28, 2008 at 8:23 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
> On Thu, 28 Feb 2008, Michael Kerrisk wrote:
>
>  > But it is an ugly inconsistency.  On the one hand, a child process
>  > cannot add the duplicate file descriptor to the epoll set.  (In every
>  > other case that I can think of , descriptors duplicated by fork have
>  > similar semantics to descriptors duplicated by dup() and friends.)  On
>  > the other hand, the very fact that the child has a duplicate of the
>  > descriptor means that even if the parent closes its descriptor, then
>  > epoll_wait() in the parent will continue to receive notifications for
>  > that descriptor because of the duplicated descriptor in the child.
>
>  Have you ever tried to think what it means for different *processes*
>  sharing a single epoll fd and doing epoll_wait() over it?

As I think is clear, I've only given it very limited thought ;-).

The point is that the existing implementation actually supports
"different *processes* sharing a single epoll fd and doing
epoll_wait() over it", but the semantics are unintuitive.  It may be
that the existing implementation was the best way of doing things.
But when I see the strange corner cases in the semantics, I can't help
but wonder (way too late), whether there might have been some other
way of implementing things that led to more intuitive semantics.

>  Most common case is a single event fetch thread plus dispatch. Going to
>  epoll_wait() over a single epoll fd from many *threads* is very much
>  possible, but requires care (news at 11, system software development
>  requires care too).
>  Sharing a single epoll fd (by the means of any process sharing it doing
>  add/wait) from different *processes* makes almost no sense at all.
>
> "a child process cannot add the duplicate file descriptor to the epoll
>  set" ... how do you expect the parent (that doesn't even have the new fd
>  mapped) to react to such events?

(Not sure if you missed my meaning here.  Of course the parent already
has the fd mapped; it's the fd that the child inherited.  Anyway, my
real point was that while descriptors duplicated by fork() are
normally semantically similar to other duplicated descriptors, when it
comes to epoll they are not -- and that has the potential to surprise
users.)

>  If the next question is "But then why we made the epoll fd inheritable?",
>  the answer is, because it makes sense in many cases for a parent to hand
>  over an fd set to a child.

Fair enough.

So here's an idea about how things might alternatively have been done:

a) The key for epoll entries could have been [file *, fd, PID]

b) an epoll_wait() only returns events for fds where the PID maps that
of the caller.

c) a close of a file descriptor removes the corresponding  [file *,
fd, PID] from the epoll set.

d) when a fork() is done, then the epoll set has a new set of keys
added.  These are duplicates of the  [file *, fd, PID] entries for the
parent, but with the PID of the child substituted into the new keys.
Say the parent had PID 1000, and the child has PID 2000.  If the epoll
set initially contained:

[X, 3, 1000]
[Y, 4, 1000]

then after fork() we'd have:

[X, 3, 1000]
[Y, 4, 1000]
[X, 3, 2000]
[Y, 4, 2000]

There is of course room for debate about the efficiency of this
approach, I suppose.  But it seems to me (and perhaps I've missed a
number of things) that that could have given sane semantics with
respect to fork(), duplicated descriptors, and close().  Furthermore,
it would have allowed us to sanely support "different *processes*
sharing a single epoll fd and doing epoll_wait() over it".

Of course, this is all academic now: we can't change the ABI.

>  > The choice of [file *, fd] as the key for epoll sets really does seem
>  > unfortunate.  Keying on [pid, fd] would have given saner semantics, it
>  > seems to me.  Obviously it can't be changed now though.
>
>  I think we already went over this, and I think I clearly explained you the
>  reasons of not hooking into sys_close.

You said elsewhere:

[[
That'd mean placing an eventpoll custom hook into sys_close(). Looks very
bad to me, and probably will look even worse to other kernel folks.
Is not much a performance issue (a check to see if a file* is an eventpoll
file is as easy as comparing the f_op pointer), but a design/style issue.
]]

But that wasn't very clear to me actually.  I note that filp_close()
already has special case handling for dnotify (R.I.P.) and fcntl()
)aka POSIX) file locks, so there was already precedent for a custom
hook, AFAICS, and epoll is at least as worthy of special treatment as
either of those cases.

Cheers,

Michael

-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug?  Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html
