Return-Path: <linux-kernel-owner+w=401wt.eu-S1761500AbXFJDTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761500AbXFJDTh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 23:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757544AbXFJDTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 23:19:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54006 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbXFJDTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 23:19:30 -0400
Date: Sun, 10 Jun 2007 04:19:22 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070610031922.GC21478@ftp.linux.org.uk>
References: <20070609014140.GC4095@ftp.linux.org.uk> <466A0BFB.3070908@redhat.com> <20070609151521.GD4095@ftp.linux.org.uk> <466AD4BA.80407@redhat.com> <20070609165454.GE4095@ftp.linux.org.uk> <466ADEAB.7080202@redhat.com> <20070609172429.GF4095@ftp.linux.org.uk> <2E51520E-EC73-457F-809A-4749ED9A3C97@mac.com> <20070609200645.GG4095@ftp.linux.org.uk> <alpine.LFD.0.98.0706091311040.20321@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706091311040.20321@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2007 at 01:21:24PM -0700, Linus Torvalds wrote:
 
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
> 
> And that means that libraries currently MUST NOT open their own file 
> descriptors, exactly because they mess with the "application file 
> descriptor namespace", namely the linear POSIX-defined fd allocation 
> rules!

Unless it does so in a thread that has unshared its descriptor table.
Which is certainly safer than suggested variants and which might be
natural thing to do anyway (e.g. if we do behind-the-scene getpwent()
caching, etc., we wouldn't be hurt by doing the work asynchronously
wrt the rest of program).

It sure as hell beats the "it's probably going to be safe with expected
use patterns in programs using our library" in the safety department;
that way we *know* that nothing of our stuff will leak anywhere, just as
we know that whatever other threads might be doing, they won't screw with
our descriptors in any way.

That's independent from O_CLOEXEC, etc., and for cases where such technics
is usable we get a bonus of code working with earlier kernels just fine.

Comments?
