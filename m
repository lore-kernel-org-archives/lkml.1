Return-Path: <linux-kernel-owner+w=401wt.eu-S933315AbXCHVEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315AbXCHVEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 16:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933322AbXCHVEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 16:04:00 -0500
Received: from mail.gmx.net ([213.165.64.20]:49336 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933315AbXCHVD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 16:03:59 -0500
X-Authenticated: #420190
X-Provags-ID: V01U2FsdGVkX1+YgwZNAGGY4x8pNVXzhRopNLCRbKL5q1oKPCOJsF
	pxpQHabKRmjxxb
Message-ID: <45F07A3C.4090600@gmx.net>
Date: Thu, 08 Mar 2007 22:03:56 +0100
From: Marko Macek <marko.macek@gmx.net>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Davide Libenzi <davidel@xmailserver.org>,
       "David M. Lloyd" <dmlloyd@flurg.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/5] signalfd v2 - signalfd core ...
References: <Pine.LNX.4.64.0703071712210.3672@alien.or.mcafeemobile.com> <1173364264.6891.3.camel@localhost> <Pine.LNX.4.64.0703080742220.7015@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0703080812290.10832@woody.linux-foundation.org> <Pine.LNX.4.64.0703080825420.7015@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0703080852170.10832@woody.linux-foundation.org> <Pine.LNX.4.64.0703081113060.7515@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0703081123210.10832@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703081123210.10832@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 8 Mar 2007, Davide Libenzi wrote:
>> So, to cut it short, I can do the pseudo-siginfo read(2), but I don't 
>> like it too much (little, actually). The siginfo, as bad as it is, is a 
>> standard used in many POSIX APIs (hence even in kernel), and IMO if we 
>> want to send that back, a struct siginfo should be.
>> No?
> 
> I think it's perfectly fine if you make it "struct siginfo" (even though I 
> think it's a singularly ugly struct). It's just that then you'd have to 
> make your read() know whether it's a compat-read or not, which you really 
> can't.
> 
> Which is why you introduced a new system call, but that leads to all the 
> problems with the file descriptor no longer being *usable*.
> 
> Think scripts. It's easy to do reads in perl scripts, and parse the 
> output. In contrast, making perl use a new system call is quite 
> challenging.

Probably, but someone will have to add the 'signalfd' system call anyway.

> And *that* is why "everything is a stream of bytes" is so important. You 
> don't know where the file descriptor has been, or who uses it. Special 
> system calls for special file descriptors are just *wrong*.
> 
> After all, that's why we'd have a signalfd() in the first place: exactly 
> so that you do *not* have to use special system calls, but can just pass 
> it on to any event waiting mechanism like select, poll, epoll. The same is 
> just *even*more*true* when it comes to reading the data!

The problem with read() returning arbitrary unstructured data is that 
there is hard to do versioning/extensibility, since the userspace can't 
specify the requested/expected format. The only way it could be done is 
by the (nbytes) parameter to read() which is not very nice (and useless 
for scripts).

This is the same problem that makes sysfs/procfs fragile unless the
file format is very well specified for extensibility (and it's easy to
f-it up, since there seems to be little consistency there... using
the XML horror would actually be an improvement). Breaking sysfs/procfs
might be acceptable once every few years, but signal handling will be
part of every application event loop and there is no room for breaking 
anything.

(although, one could to the versioning the ugly way by creating the new 
'signalfd' syscall instead).

I'd say: make read() return the signal number (probably as 4-byte int, 
in network byte order), but for everything else, use the system call.

Mark

P.S. I'm currently worried if the fact that FUTEX_FD is being deprecated 
is a problem :)

