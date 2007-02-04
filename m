Return-Path: <linux-kernel-owner+w=401wt.eu-S1752532AbXBDUL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbXBDUL2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 15:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbXBDUL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 15:11:28 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:21777 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbXBDUL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 15:11:27 -0500
Message-ID: <45C63DE9.7020800@tls.msk.ru>
Date: Sun, 04 Feb 2007 23:11:21 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: davids@webmaster.com
CC: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: O_NONBLOCK setting "leak" outside of a process??
References: <MDEHLPKNGKAHNMBLJOLKEELOBFAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKEELOBFAC.davids@webmaster.com>
X-Enigmail-Version: 0.94.1.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz wrote:
[]
>> Currently changing O_NONBLOCK on stdin/out/err affects other,
>> possibly unrelated processes - they don't expect that *their*
>> reads/writes will start returning EAGAIN!
> 
> Then they're broken. Sorry, that's just the way it is. Code should always
> correctly handle defined error codes. I agree that it's unexpected and
> unfortunate, but you have to code defensively.
> 
> *Every* blocking fd operation should be followed by a check to see if the
> operation failed, succeeded, or partially succeeded. If it partially
> succeeded, it needs to be continued. If it failed, you need to check if the
> error is fatal or transient. If transient, you need to back off and retry.
> It has, sadly, always been this way. (Programs can get signals, debuggers
> can interrupt a system call, the unexpected happens.)

Well, that's partly nonsense.  The only error condition which is always being
checked in correctly written software is EINTR - if you've got an interrupt,
continue/retry the I/O.

Checking and retrying for EAGAIN is umm.. plain wrong.  You'll get a nice
busywait eating 100% CPU this way, till the I/O actually happens, and will
get another the next try.

Checking I/Os for every possible weird condition is just non-productive.

It's like this:

  if (fcntl(fd, F_SETFL, ~O_NONBLOCK) < 0)  error_out();
  if (fcntl(fd, F_GETFL, 0) & O_NOBLOCK) ??? what to do?
  while(do_something())
    if (fcntl(fd, F_GETFL, 0) & O_NOBLOCK)
      if (fcntl(fd, F_SETFL, ~O_NONBLOCK) < 0)  error_out();

(don't pay attention to ~O_NONBLOCK thing - it's wrong, but it's
used like that just to show the "idea" - which is to clear O_NONBLOCK)

Which is a complete nonsense.  It's either set or cleared, and once
set or cleared it should stay that way, period.  Until the app changes
it again.

>> Worse, it cannot be worked around by dup() because duped fds
>> are still sharing O_NONBLOCK. How can I work around this?
> 
> If this causes your code a problem, your code is broken. What does your code

With dup() - maybe.  But definitely NOT with fork().

> currently do if it gets a non-fatal error from a blocking operation? If it
> does anything other than back off and retry, it's mishandling the condition.

Retrying I/O in case of EAGAIN is *wrong*.  See above.
But sure, in case of dup() an app should be prepared to set up all the flags
properly.

/mjt

> I agree that the world might have been a better place had this been thought
> about from the beginning.

