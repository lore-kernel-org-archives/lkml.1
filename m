Return-Path: <linux-kernel-owner+w=401wt.eu-S1758178AbXEMKpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbXEMKpN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 06:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbXEMKpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 06:45:01 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754173AbXEMKpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 06:45:00 -0400
Date: Sun, 13 May 2007 03:44:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: undefined reference to `__clear_user' (was: Re: [patch 2/13]
 signal/timer/event fds v10 - signalfd core ...)
Message-Id: <20070513034442.52f81fff.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705131222410.2271@anakin>
References: <Pine.LNX.4.64.0704021555430.26489@alien.or.mcafeemobile.com>
	<Pine.LNX.4.64.0705131222410.2271@anakin>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007 12:28:23 +0200 (CEST) Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> 	Hi Davide,
> 
> On Mon, 2 Apr 2007, Davide Libenzi wrote:
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-2.6.21-rc5.fds/fs/signalfd.c	2007-04-02 15:06:29.000000000 -0700
> 
> > +/*
> > + * Copied from copy_siginfo_to_user() in kernel/signal.c
> > + */
> > +static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
> > +			     siginfo_t const *kinfo)
> > +{
> > +	long err;
> > +
> > +	BUILD_BUG_ON(sizeof(struct signalfd_siginfo) != 128);
> > +
> > +	/*
> > +	 * Unused memebers should be zero ...
> > +	 */
> > +	err = __clear_user(uinfo, sizeof(*uinfo));
>               ^^^^^^^^^^^^
> 
> Shouldn't this be `clear_user()'? I don't see any access_ok() calls
> before this call (I do see them in copy_siginfo_to_user() in
> kernel/signal.c), but of course I may miss something...
> 
> I only noticed because m68k doesn't have __clear_user(), as this routine
> was never needed by generic code before your change.
> 

The vfs does the access_ok() checking on entry to read, write, readv,
writev, pread and pwrite.

I _think_ that covers everything, in which case all the code which
implements reading and writing can use the __ functions.  We have a lot of
code which doesn't avail itself of that optimisation though: 12 zillion
sysfs and proc handlers, for a start.

(I think.  I only recently noticed this and might have missed a path).
