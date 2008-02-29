Return-Path: <linux-kernel-owner+w=401wt.eu-S933438AbYB2TzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933438AbYB2TzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 14:55:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933051AbYB2Tyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 14:54:55 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:54360 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932982AbYB2Tyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 14:54:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H5lC9KumbRApj97aB738iPjr5hF6KoOgvMXUx0cg3y9omRxqNQ/uYEIcCH3OXGZFVe7Cu7yurIT/wZUnk8YDt+zDyWIOpsGghWrHf0FwkbsdbbY/5R2kf16b4lK3QVqVIBCfXKSmElgYtj1fuDdUpgvDm17Uw54vyAty6MPNCeE=
Message-ID: <cfd18e0f0802291154j612b4238i66cb8323b72814ca@mail.gmail.com>
Date: Fri, 29 Feb 2008 20:54:53 +0100
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: epoll design problems with common fork/exec patterns
Cc: "=?ISO-8859-1?Q?Chris_\"=A5=AF\"_Heath?=" <chris@heathens.co.nz>,
       "David Schwartz" <davids@webmaster.com>, dada1@cosmosbay.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       linux-man@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0802291111320.31028@alien.or.mcafeemobile.com>
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
	 <cfd18e0f0802290746p3cb7efc9j72394cd77ff37829@mail.gmail.com>
	 <Pine.LNX.4.64.0802291111320.31028@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 8:19 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
> On Fri, 29 Feb 2008, Michael Kerrisk wrote:
>
> > As I think is clear, I've only given it very limited thought ;-).
> >
> > The point is that the existing implementation actually supports
> > "different *processes* sharing a single epoll fd and doing
> > epoll_wait() over it", but the semantics are unintuitive.  It may be
> > that the existing implementation was the best way of doing things.
> > But when I see the strange corner cases in the semantics, I can't help
> > but wonder (way too late), whether there might have been some other
> > way of implementing things that led to more intuitive semantics.
>
> Oh boy. The fact that you can have an epoll fd cross the fork boundary,
> does not mean that any indiscriminate use of it leads to sane results:

I ddidn't mean that it did.  Certainly in the current implementation
it there will insane situations ;-).

>        efd = epoll_create();
>        fork();
>                                        pipe(fds);
>                                        epoll_ctl(efd, ADD, fds[0]);
>        epoll_wait(); ????
>        ...
>        pipe(fds);
>        epoll_ctl(efd, ADD, fds[0]);
>                                        epoll_wait(); ????
>
>
> It is *NOT* a matter of semantics.

Of course -- but I don't think I suggested that I disagree on this.

> > >  If the next question is "But then why we made the epoll fd inheritable?",
> > >  the answer is, because it makes sense in many cases for a parent to hand
> > >  over an fd set to a child.
> >
> > Fair enough.
> >
> > So here's an idea about how things might alternatively have been done:
> >
> > a) The key for epoll entries could have been [file *, fd, PID]
> >
> > b) an epoll_wait() only returns events for fds where the PID maps that
> > of the caller.
> >
> > c) a close of a file descriptor removes the corresponding  [file *,
> > fd, PID] from the epoll set.
> >
> > d) when a fork() is done, then the epoll set has a new set of keys
> > added.  These are duplicates of the  [file *, fd, PID] entries for the
> > parent, but with the PID of the child substituted into the new keys.
> > Say the parent had PID 1000, and the child has PID 2000.  If the epoll
> > set initially contained:
> >
> > [X, 3, 1000]
> > [Y, 4, 1000]
> >
> > then after fork() we'd have:
> >
> > [X, 3, 1000]
> > [Y, 4, 1000]
> > [X, 3, 2000]
> > [Y, 4, 2000]
> >
> > There is of course room for debate about the efficiency of this
> > approach, I suppose.
>
> There sure is :)

Okay -- but I suspect it could have been made fairly efficient.

> > You said elsewhere:
> >
> > [[
> > That'd mean placing an eventpoll custom hook into sys_close(). Looks very
> > bad to me, and probably will look even worse to other kernel folks.
> > Is not much a performance issue (a check to see if a file* is an eventpoll
> > file is as easy as comparing the f_op pointer), but a design/style issue.
> > ]]
> >
> > But that wasn't very clear to me actually.  I note that filp_close()
> > already has special case handling for dnotify (R.I.P.) and fcntl()
> > )aka POSIX) file locks, so there was already precedent for a custom
> > hook, AFAICS, and epoll is at least as worthy of special treatment as
> > either of those cases.
>
> I guess that over the time, Al became software WRT junk going there :)

Sorry -- I don't understand that last sentence?
