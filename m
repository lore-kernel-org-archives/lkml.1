Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241AbZAKM2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbZAKM2V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 07:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbZAKM2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 07:28:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:52001 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbZAKM2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 07:28:05 -0500
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
From: David Woodhouse <dwmw2@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
In-Reply-To: <20090110030216.GW26290@one.firstfloor.org>
References: <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain>
	 <20090109204103.GA17212@elte.hu>
	 <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain>
	 <20090109213442.GA20051@elte.hu> <1231537320.5726.2.camel@brick>
	 <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain>
	 <20090109231227.GA25070@elte.hu>
	 <alpine.LFD.2.00.0901091522250.6528@localhost.localdomain>
	 <20090110010125.GA31031@elte.hu>
	 <20090109174158.096dee70.akpm@linux-foundation.org>
	 <20090110030216.GW26290@one.firstfloor.org>
Content-Type: text/plain
Date: Sun, 11 Jan 2009 12:26:41 +0000
Message-Id: <1231676801.25018.150.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-2.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-10 at 04:02 +0100, Andi Kleen wrote:
> Long term that problem will hopefully disappear, as gcc learns to do cross
> source file inlining (like a lot of other compilers already do)

We've already been able to get GCC doing this for the kernel, in fact
(the --combine -fwhole-program stuff I was working on a while back).

It gives an interesting size reduction, especially in file systems and
other places where we tend to have functions with a single call site...
but in a different file.

Linus argues that we don't want that kind of inlining because it harms
debuggability, but that isn't _always_ true. Sometimes you weren't going
to get a backtrace if something goes wrong _anyway_. And even if the
size reduction doesn't necessarily give a corresponding performance
improvement, we might not care. In the embedded world, size does matter
too. And the numbers are such that you can happily keep debuginfo for
the shipped kernel builds and postprocess any backtraces you get. Just
as we can for distros.


In general, I would much prefer being able to trust the compiler, rather
than disabling its heuristics completely. We might not be able to trust
it right now, but we should be working towards that state. Not just
declaring that we know best, even though _sometimes_ we do.

I think we should:

  - Unconditionally have 'inline' meaning 'always_inline'. If we say it,
    we should mean it.

  - Resist the temptation to use -fno-inline-functions. Allow GCC to
    inline other things if it wants to.

  - Reduce the number of unnecessary 'inline' markers, and have a policy
    that the use of 'inline' should be accompanied by either a GCC PR#
    or an explanation of why we couldn't reasonably have expected GCC to
    get this particular case right.

  - Have a similar policy of PR# or explanation for 'uninline' too.

I don't think we should just give up on GCC ever getting it right. That
way lies madness. As we've often found in the past. 

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

