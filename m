Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbXFJEAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbXFJEAb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 00:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbXFJEAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 00:00:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41926 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbXFJEAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 00:00:22 -0400
Date: Sun, 10 Jun 2007 05:00:14 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070610040014.GD21478@ftp.linux.org.uk>
References: <20070609151521.GD4095@ftp.linux.org.uk> <466AD4BA.80407@redhat.com> <20070609165454.GE4095@ftp.linux.org.uk> <466ADEAB.7080202@redhat.com> <20070609172429.GF4095@ftp.linux.org.uk> <2E51520E-EC73-457F-809A-4749ED9A3C97@mac.com> <20070609200645.GG4095@ftp.linux.org.uk> <alpine.LFD.0.98.0706091311040.20321@woody.linux-foundation.org> <20070610031922.GC21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706092036500.20321@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706092036500.20321@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2007 at 08:48:39PM -0700, Linus Torvalds wrote:
> Agreed. That was actually part of the reason why I thought clone() was
> much better than the pthreads interface.
> 
> That said, the Linux !CLONE_FILES does have downsides:
> 
>  - it is potentially much slower to do than sharing everything (if you 
>    have lots of file descriptors, incrementing the refcounts etc is 
>    actually a real overhead)

Huh?  We _skip_ the overhead when descriptor table is not shared.  Think
for a minute - we can skip playing with refcount of fget() in the beginning
of syscall if and only if we know that nobody will touch the reference from
the descriptor table.  I.e. if descriptor table is not shared.  IOW, it's
the other way round - it's _faster_ to not share descriptors.
 
>  - it simply doesn't work, if the library wants to run in the same 
>    execution context, and just wants to open one (or more) file 
>    descriptors for some helper thing.

True, but...  That really depends on the potential uses.  Any real-world
examples (e.g. in related threads)?
