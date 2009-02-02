Return-Path: <linux-kernel-owner+w=401wt.eu-S1757387AbZBBNJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbZBBNJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 08:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbZBBNJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 08:09:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:59860 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbZBBNJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 08:09:14 -0500
Subject: Re: [BUG??] Deadlock between kswapd and
 sys_inotify_add_watch(lockdep  report)
From: Peter Zijlstra <peterz@infradead.org>
To: MinChan Kim <minchan.kim@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>, linux kernel <linux-kernel@vger.kernel.org>,
       linux mm <linux-mm@kvack.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090202115627.GB13532@barrios-desktop>
References: <20090202101735.GA12757@barrios-desktop>
	 <28c262360902020225w6419089ft2dda30da9dfb32a9@mail.gmail.com>
	 <1233571202.4787.124.camel@laptop> <20090202112721.GA13532@barrios-desktop>
	 <1233575085.4787.140.camel@laptop> <20090202115627.GB13532@barrios-desktop>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 14:09:07 +0100
Message-Id: <1233580147.4787.207.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 20:56 +0900, MinChan Kim wrote:
> Thanks for kind explanation. :)
> Unfortunately, I still have a question. :(

No problem :-)

> > > I think if reclaim context which have GFP_FS already have lock A and then 
> > > do pageout, if writepage need the lock A, we have to catch such a case. 
> > > I thought Nick's patch's goal catchs such a case. 
> > 
> > Correct, it exactly does that.
> 
> But, I think such a case can be caught by lockdep of recursive detection 
> which is existed long time ago by making you.

(Ingo wrote that code)

> what's difference Nick's patch and recursive lockdep ?

Very good question indeed. Every time I started to write an answer I
realize its wrong.

The below is half the answer:

/*
 * Check whether we are holding such a class already.
 *
 * (Note that this has to be done separately, because the graph cannot
 * detect such classes of deadlocks.)
 *
 * Returns: 0 on deadlock detected, 1 on OK, 2 on recursive read
 */
static int
check_deadlock(struct task_struct *curr, struct held_lock *next,
               struct lockdep_map *next_instance, int read)

So in order for the reclaim report to trigger we have to actually hit
that code path that has the recursion in it. The reclaim context
annotation by Nick ensures we detect such cases without having to do
that.

The second half, to which I cannot seem to get a decent answer to atm,
is why the recursion case isn't detected by the graph.



