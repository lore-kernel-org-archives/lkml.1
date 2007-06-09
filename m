Return-Path: <linux-kernel-owner+w=401wt.eu-S1759047AbXFIT2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759047AbXFIT2j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 15:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758673AbXFIT2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 15:28:30 -0400
Received: from smtpout.mac.com ([17.250.248.171]:56289 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758640AbXFIT23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 15:28:29 -0400
In-Reply-To: <20070609172429.GF4095@ftp.linux.org.uk>
References: <Pine.LNX.4.64.0706081211050.5795@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0706081701250.4205@woody.linux-foundation.org> <20070609003622.GB4095@ftp.linux.org.uk> <466A0020.50406@redhat.com> <20070609014140.GC4095@ftp.linux.org.uk> <466A0BFB.3070908@redhat.com> <20070609151521.GD4095@ftp.linux.org.uk> <466AD4BA.80407@redhat.com> <20070609165454.GE4095@ftp.linux.org.uk> <466ADEAB.7080202@redhat.com> <20070609172429.GF4095@ftp.linux.org.uk>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <2E51520E-EC73-457F-809A-4749ED9A3C97@mac.com>
Cc: Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Date: Sat, 9 Jun 2007 15:27:43 -0400
To: Al Viro <viro@ftp.linux.org.uk>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 09, 2007, at 13:24:29, Al Viro wrote:
> On Sat, Jun 09, 2007 at 10:08:59AM -0700, Ulrich Drepper wrote:
>> - - there are two interface to use: open + fcntl.  This is racy.   
>> And don't tell me this doesn't matter.
> Racy with respect to what?  Return-to-libc exploits from another  
> thread?

How about racy with respect to normal open or fork+exec from another  
thread?  Specifically there are cases where libc or other libraries  
want to create a backend thread dealing with file descriptors in  
response to the program's straightforward calls into that library  
(Examples include using syslets or event-based polling threads).


SCENARIO 1:

Program Thread:   Library Thread:
                   fd = socket(AF_*, SOCK_*, 0);
fork();
                   int x = FD_CLOEXEC;
                   fcntl(fd, F_SETFD, &x);

New Process:
setgroups(...);
seteuid(...);
exec(....);

Whoops!!! Suddenly the user process executed by the (theoretically)  
single-threaded program got a handle to a netlink socket affecting  
some system resource!!!


SCENARIO 2:

Program Thread:     Async libc getpwent()-cache syslet
close(0);
                     fd = open("/etc/shadow");
open("/dev/null");
code_which_insecurely_reads_from_stdin();

Here we were trying to safely call into code which reads from stdin  
and shouldn't be given privileged data, but the syslet makes the  
common paradigm 'close(0); open("/dev/null");' horribly insecure.

If you extend all the FD syscalls to all take a "flags" parameter and  
add the appropriate flags, then you can pass O_CLOEXEC|O_RANDFD to  
whatever syscall you are using and both problems vanish.

Cheers,
Kyle Moffett

