Return-Path: <linux-kernel-owner+w=401wt.eu-S1761179AbXFDTWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761179AbXFDTWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760322AbXFDTWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:22:13 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:48682 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760197AbXFDTWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:22:13 -0400
Date: Mon, 4 Jun 2007 15:13:49 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Zach Brown <zach.brown@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Syslets, signals, and security
Message-ID: <20070604191349.GA8903@c2.user-mode-linux.org>
References: <20070604163145.GA7144@c2.user-mode-linux.org> <20070604174542.GD29201@mami.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604174542.GD29201@mami.zabbo.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 10:45:42AM -0700, Zach Brown wrote:
> > Second, security.  What happens if a well-written server starts life
> > as root, does some (async) I/O, and setuids to a non-root uid?  There
> > will be a bunch of async threads still running as root, with the
> > result that async operations (and the main thread) will more than
> > occassionally regain root privs.

> One can imagine all sorts of crazy schemes which let us only shoot down
> waiting async threads which were cloned before state in the submitting
> task_struct was changed.  Maybe we could swallow increasing a counter in
> task_struct each time we change one of these sensitive fields (fsuid,
> etc), but I bet the maintenance burden of anything more fine grained
> than that would get pretty excessive.

How about splitting the credentials out of the task_struct and making
them sharable ala ->mm et al?  You change uid there and it changes for
everyone.  It will make fork slightly more expensive though.

> Yeah, and I'm blissfully ignorant of ptrace.  Imagine me skipping
> through a field of daisies with some ptrace wolves hiding in the bushes
> at the edge of the meadow.  La la la.

Heh, I'm somewhat less ignorant of ptrace, so I'll see if I can help
out there.

> Each execution context having its own task struct is intentional, very
> much so.  Remember, this started with the fibrils patch series which
> indeed shared a single task struct amongst a set of running stacks and
> thread infos, etc.  This approach is invasive because it changes the
> sleeping entity in the scheduler from a task struct to some new
> construct which has a many to one mapping to the task struct.  It
> touches vast amounts of code.  This approach is also risky because it
> introduces concurrent access to the task struct.  That's a pretty big
> auditing burden.

Yeah, I realize that, but have no idea how much code that requires
looking at.

> Have you looked at how the fibrils stuff did it?  It's a lot more work
> than it seems like it should be, on first glance.  You start to modify
> things and every few days you trip across another fundamental kernel
> construct which needs to be modified :/.
> 
>   http://lwn.net/Articles/219954/

Ah, I somehow missed this.  Since you seem to have explored that area
of the solution space already and found it wanting, I agree that it
makes sense to see if syslets can be made to work.

				Jeff
-- 
Work email - jdike at linux dot intel dot com
