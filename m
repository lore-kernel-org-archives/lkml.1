Return-Path: <linux-kernel-owner+w=401wt.eu-S1760645AbXFIUtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760645AbXFIUtY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 16:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbXFIUtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 16:49:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36549 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbXFIUtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 16:49:17 -0400
Date: Sat, 9 Jun 2007 21:49:07 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070609204907.GH4095@ftp.linux.org.uk>
References: <20070609014140.GC4095@ftp.linux.org.uk> <466A0BFB.3070908@redhat.com> <20070609151521.GD4095@ftp.linux.org.uk> <466AD4BA.80407@redhat.com> <20070609165454.GE4095@ftp.linux.org.uk> <466ADEAB.7080202@redhat.com> <20070609172429.GF4095@ftp.linux.org.uk> <2E51520E-EC73-457F-809A-4749ED9A3C97@mac.com> <20070609200645.GG4095@ftp.linux.org.uk> <alpine.LFD.0.98.0706091311040.20321@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706091311040.20321@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2007 at 01:21:24PM -0700, Linus Torvalds wrote:
> Which is why you'd like to do the *initial* operation with a flag that 
> says "please set the FD_CLOEXEC flag on the file descriptor", so that you 
> *atomically* install the file file descriptor and set the FD_CLOEXEC bit.
> 
> It's trivial to do for open(), but there are about a million ways to get a 
> file descriptor, and open() is just about the *only* one of those that 
> actually takes a "flags" field that can be used to tell the kernel.

Eww...  Idea of pipe(2) taking flags as argument...

BTW, you also need that for recvmsg() (SCM_RIGHTS) and fsckloads of
syscalls we've got duplicating open() for no good reason (and no, "BSD
folks did it for sockets, so we'll do it for tons of new subsystems" doesn't
really qualify ;-/).

I don't know if your indirect is a good idea in that respect, actually.
AFAICS, you are suggesting per-syscall meanings of the flags, so it really
smells like YAMultiplexor, free for abuse.
 
> (And dammit, that _is_ a *real*issue*. No races necessary, no NR_OPEN 
> iterations, no even *halfway* suspect code. It's perfectly fine to do
> 
> 	close(0);
> 	close(1);
> 	close(2);
> 	.. generate filenames, whatever ..
> 	if (open(..) < 0 || open(..) < 0 || open(..) < 0)
> 		die("Couldn't redirect stdin/stdout/stderr");
> 
> and there's absolutely nothing wrong with this kind of setup, even if you 
> could obviously have done it other ways too (ie by using "dup2()" instead 
> of "close + open"),

Yeah, well - I wouldn't call that perfectly fine, but it's probably too
widespread to kill.  Just as use of 0 for NULL ;-)
