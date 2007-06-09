Return-Path: <linux-kernel-owner+w=401wt.eu-S1760052AbXFIUHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052AbXFIUHI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 16:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758991AbXFIUG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 16:06:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35051 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758888AbXFIUG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 16:06:56 -0400
Date: Sat, 9 Jun 2007 21:06:45 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070609200645.GG4095@ftp.linux.org.uk>
References: <20070609003622.GB4095@ftp.linux.org.uk> <466A0020.50406@redhat.com> <20070609014140.GC4095@ftp.linux.org.uk> <466A0BFB.3070908@redhat.com> <20070609151521.GD4095@ftp.linux.org.uk> <466AD4BA.80407@redhat.com> <20070609165454.GE4095@ftp.linux.org.uk> <466ADEAB.7080202@redhat.com> <20070609172429.GF4095@ftp.linux.org.uk> <2E51520E-EC73-457F-809A-4749ED9A3C97@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2E51520E-EC73-457F-809A-4749ED9A3C97@mac.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2007 at 03:27:43PM -0400, Kyle Moffett wrote:
> On Jun 09, 2007, at 13:24:29, Al Viro wrote:
> >On Sat, Jun 09, 2007 at 10:08:59AM -0700, Ulrich Drepper wrote:
> >>- - there are two interface to use: open + fcntl.  This is racy.   
> >>And don't tell me this doesn't matter.
> >Racy with respect to what?  Return-to-libc exploits from another  
> >thread?
> 
> How about racy with respect to normal open

How the hell can it be racy wrt normal open()?  F_DUPFD is not dup2(),
it's non-overriding.

> or fork+exec from another  
> thread?  Specifically there are cases where libc or other libraries  
> want to create a backend thread dealing with file descriptors in  
> response to the program's straightforward calls into that library  
> (Examples include using syslets or event-based polling threads).
> 
> 
> SCENARIO 1:
> 
> Program Thread:   Library Thread:
>                   fd = socket(AF_*, SOCK_*, 0);
> fork();
>                   int x = FD_CLOEXEC;
>                   fcntl(fd, F_SETFD, &x);
> 
> New Process:
> setgroups(...);
> seteuid(...);
> exec(....);
>
> Whoops!!! Suddenly the user process executed by the (theoretically)  
> single-threaded program got a handle to a netlink socket affecting  
> some system resource!!!
 
Give me a break.  fork(3) is nowhere near plain fork(2); read the nptl
code for details.  Getting a low-overhead exclusion into that scheme is not
a rocket science.  And lose the bangs, please...

> SCENARIO 2:
> 
> Program Thread:     Async libc getpwent()-cache syslet
> close(0);
>                     fd = open("/etc/shadow");
> open("/dev/null");
> code_which_insecurely_reads_from_stdin();

>From what, again?  Use of stdio after that is deep in nasal demon land...
