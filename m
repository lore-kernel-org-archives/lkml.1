Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbXJ2JMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbXJ2JMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 05:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbXJ2JMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 05:12:13 -0400
Received: from twin.jikos.cz ([213.151.79.26]:37848 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbXJ2JML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 05:12:11 -0400
Date: Mon, 29 Oct 2007 10:11:13 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Matthew Wilcox <matthew@wil.cx>
cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "George G. Davis" <gdavis@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC, PATCH] locks: remove posix deadlock detection
In-Reply-To: <20071028233119.GE32359@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0710291002280.18815@twin.jikos.cz>
References: <20071026170750.GC13033@fieldses.org> <20071026224707.GO13033@fieldses.org>
 <20071028173136.GA16905@fieldses.org> <20071028174321.GB16905@fieldses.org>
 <20071028182732.GK27248@parisc-linux.org> <20071028184052.49abd092@the-village.bc.nu>
 <20071028201101.GA32359@parisc-linux.org> <1193608230.7561.11.camel@heimdal.trondhjem.org>
 <20071028224157.GC32359@parisc-linux.org> <Pine.LNX.4.64.0710282349470.18815@twin.jikos.cz>
 <20071028233119.GE32359@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007, Matthew Wilcox wrote:

> > 	A potential for deadlock occurs if a process controlling a locked 
> > 	region is put to sleep by attempting to lock another process' 
> > 	locked region. If the system detects that sleeping until a locked 
> > 	region is unlocked would cause a deadlock, fcntl() shall fail with 
> > 	an [EDEADLK] error.
> > This is what POSIX says [1], even after being modified with respect to 
> > POSIX Threads Extension, right? So it doesn't deal with threads at 
> > all, just processess are taken into account. Probably for a reason :)
> Did you have a concrete suggestion, or are you just quoting the spec?

I was quoting the spec and I thought that the suggestion is implicit -- 
the specification defines what happens only when processess are in place. 
If the application uses POSIX threads in combination with locks, it is 
going to receive undefined behavior.

> The problem is that it's nonsense -- processes don't sleep, threads do. 
> I think the key is "would deadlock", not "might deadlock".  Our current 
> behaviour is clearly in violation of SuSv3.

- either we can add a special fcntl() Linux-specific flag, that will ask 
  the kernel not to perform deadlock detection. Any application that is 
  combining threads and posix locks (and thus IMHO asking for undefined 
  behavior) could use this flag and not receive EDEADLK any more

- or we can add some heuristics here-and-there to track which 
  current->files are shared and which are not, and do not return EDEADLK 
  in the case of shared ->files (could be a little bit tricky)

-- 
Jiri Kosina
