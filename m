Return-Path: <linux-kernel-owner+w=401wt.eu-S1758912AbXELKkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbXELKkz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 06:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755783AbXELKkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 06:40:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34499 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755575AbXELKks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 06:40:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
Date: Sat, 12 May 2007 12:45:49 +0200
User-Agent: KMail/1.9.5
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200705110035.32229.rjw@sisk.pl> <alpine.LFD.0.98.0705111812270.3986@woody.linux-foundation.org> <200705121101.40795.rjw@sisk.pl>
In-Reply-To: <200705121101.40795.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705121245.50715.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 12 May 2007 11:01, Rafael J. Wysocki wrote:
> On Saturday, 12 May 2007 03:24, Linus Torvalds wrote:
> > 
> > On Sat, 12 May 2007, Oleg Nesterov wrote:
> > > 
> > > However, in my opininon THAT PATCH has nothing to do with this problem.
> > > It just improves the code that we already have.
> > 
> > Sure. 
> > 
> > However, I think it does it THE WRONG WAY, and doesn't actually fix the 
> > much deeper problems with the freezer, as shown by the fact that the lock 
> > is *still* broken for other cases.
> 
> The other cases don't lead to the specific issue this patch is meant to
> prevent.  Namely, that if a kernel thread is identified as a user space task by
> the freezer it may be frozen prematurely.
> 
> And yes, this only is a problem because we freeze kernel threads, which may be
> avoidable, but we've been doing that for more than two years and it's a big
> change to stop doing so.  We can't just say overnight that we won't be freezing
> kernel threads from now on without al least checking if that doesn't lead to
> user-visible problems.
> 
> Thus IMO it's reasonable to fix the potential issue with the current code and
> think about changing the design *later*.  Still, I'm not so attached to this
> patch and if you think that it should be dropped (which IMO is wrong), then so
> be it.

Sorry, I was wrong, because ...

> That said:
> 
> > So, here's a summary:
> > 
> >  - we should not take the lock inside the function, because taking it 
> >    there is fundamentally wrong, and leaves all the *other* races in 
> >    place.
> 
> The other races don't lead to the same (wrong) result.
> 
> >  - if you actually want to solve the other races, the lock needs to be 
> >    taken by the caller, in which case taking it in the callee is obviously 
> >    (again) wrong.
> > 
> >  - or then, we accept that the race wasn't fixed AT ALL, and you add other 
> >    code to _other_ places to handle the case where you froze the wrong 
> >    thread (or didn't freeze the right one).
> 
> There are no other cases, AFAICS, in which we can freeze a wrong thead.

... user space tasks that call deamonize() can also be frozen prematurely.
We didn't take this possibility into consideration before, which was obviously
wrong.

Rafael
