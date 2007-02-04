Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560AbXBDVJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbXBDVJ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 16:09:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbXBDVJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 16:09:29 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:1887 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbXBDVJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 16:09:28 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: O_NONBLOCK setting "leak" outside of a process??
Date: Sun, 4 Feb 2007 13:08:36 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKEEOJBFAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <45C63DE9.7020800@tls.msk.ru>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sun, 04 Feb 2007 13:08:57 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sun, 04 Feb 2007 13:08:58 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > *Every* blocking fd operation should be followed by a check to
> > see if the
> > operation failed, succeeded, or partially succeeded. If it partially
> > succeeded, it needs to be continued. If it failed, you need to
> > check if the
> > error is fatal or transient. If transient, you need to back off
> > and retry.
> > It has, sadly, always been this way. (Programs can get signals,
> > debuggers
> > can interrupt a system call, the unexpected happens.)

> Well, that's partly nonsense.  The only error condition which is
> always being
> checked in correctly written software is EINTR - if you've got an
> interrupt,
> continue/retry the I/O.

> Checking and retrying for EAGAIN is umm.. plain wrong.  You'll get a nice
> busywait eating 100% CPU this way, till the I/O actually happens, and will
> get another the next try.

I said back off and retry.

> Checking I/Os for every possible weird condition is just non-productive.
>
> It's like this:
>
>   if (fcntl(fd, F_SETFL, ~O_NONBLOCK) < 0)  error_out();
>   if (fcntl(fd, F_GETFL, 0) & O_NOBLOCK) ??? what to do?
>   while(do_something())
>     if (fcntl(fd, F_GETFL, 0) & O_NOBLOCK)
>       if (fcntl(fd, F_SETFL, ~O_NONBLOCK) < 0)  error_out();
>
> (don't pay attention to ~O_NONBLOCK thing - it's wrong, but it's
> used like that just to show the "idea" - which is to clear O_NONBLOCK)

I agree that checking for a condition that there's no sane way to handle is
non-productive. But here we're talking about testing for a condition that
has been proven to happen and for which a sane way to handle it is
obvious -- back off and retry.

> Which is a complete nonsense.  It's either set or cleared, and once
> set or cleared it should stay that way, period.  Until the app changes
> it again.

Until anything with access to it changes it.

> >> Worse, it cannot be worked around by dup() because duped fds
> >> are still sharing O_NONBLOCK. How can I work around this?
> >
> > If this causes your code a problem, your code is broken. What
> > does your code
>
> With dup() - maybe.  But definitely NOT with fork().

With 'fork', you either give the other process the file descriptor or you
share it. Any shared resource requires cooperation for sane results.

> > currently do if it gets a non-fatal error from a blocking
> > operation? If it
> > does anything other than back off and retry, it's mishandling
> > the condition.

> Retrying I/O in case of EAGAIN is *wrong*.  See above.

You missed the "back off" part.

DS


