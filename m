Return-Path: <linux-kernel-owner+w=401wt.eu-S1032616AbXFIAgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032616AbXFIAgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 20:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969852AbXFIAgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 20:36:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40226 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762946AbXFIAgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 20:36:32 -0400
Date: Sat, 9 Jun 2007 01:36:22 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070609003622.GB4095@ftp.linux.org.uk>
References: <20070608120746.GD12687@thunk.org> <20070608140150.6f31672f@the-village.bc.nu> <Pine.LNX.4.64.0706081108130.5519@alien.or.mcafeemobile.com> <20070608192652.4a291901@the-village.bc.nu> <4669A351.4010403@redhat.com> <20070608184650.GA4095@ftp.linux.org.uk> <4669A674.4080309@redhat.com> <alpine.LFD.0.98.0706081206430.4205@woody.linux-foundation.org> <Pine.LNX.4.64.0706081211050.5795@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0706081701250.4205@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706081701250.4205@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 05:03:57PM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 8 Jun 2007, Davide Libenzi wrote:
> >
> > On Fri, 8 Jun 2007, Linus Torvalds wrote:
> > > 
> > > You need things to be *repeatable* for debugging. No ifs, buts, or maybes 
> > > about it.
> > 
> > It all depends on how you use the file descriptor.
> 
> Read what I wrote. "for debugging".
> 
> If your code is bug-free, and does what you intend it to do, everything is 
> fine. But you wouldn't be doing debugging then, would you?
> 
> For debugging, it does _not_ depend on "how you use the file descriptor". 
> The whole _point_ is that something does something wrong. Maybe you 
> _intended_ to use the file descriptor some way, and the bug was that you 
> didn't.

Exactly.  Put it another way, randomizer is a stress-tester.  Which is
a damn useful debugging tool in its own right.  *However*, the main thing
about debugging tools is that you need to be able to turn them on and off
individually; then you get a useful information narrowing the diagnosis
down.  If you can't do that, you lose.

	Folks, the real question is whether we consider the loops blindly
shooting down the file descriptors as a supportable thing.  Correction:
whether the code written in that style *and* *correct* *with* *current*
*semantics* is sufficiently numerous and hard to notice that we need that
sort of kludges.  Because what Uli's suggesting is certainly that - a kludge
sufficient for glibc internal needs.

Note that
#define NR_FILES <some constant>

for (i = 0; i < NR_FILES; i++)
	close(i);

is simply broken.  No ifs, no buts, it's broken on the current kernel.  So
that kind of stuff needs fixing anyway; do we have enough left to make it
worth preserving?

I don't know the answer; some data would be much appreciated.  If the broken
stuff like above outnumbers the valid uses, we probably need think of some
way to catch that kind of crap anyway...  Randomizer for open() et.al.
switchable on per-process basis would be a nice tool to catch some of those,
along with instrumenting the kernel to notice massive close() on files that
hadn't been opened, etc.

As long as all we have is a handwaving about widespread and unspecified
code doing this, this and that, but not that...
