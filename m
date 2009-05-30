Return-Path: <linux-kernel-owner+w=401wt.eu-S1763834AbZE3VPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763834AbZE3VPz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 17:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760394AbZE3VPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 17:15:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36742 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760090AbZE3VPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 17:15:47 -0400
Subject: Re: SCHED_EDF infos
From: Peter Zijlstra <peterz@infradead.org>
To: Henrik Austad <henrik@austad.us>
Cc: GeunSik Lim <leemgs1@gmail.com>, finarfin@dreamos.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090530204038.GA20875@alecto.austad.us>
References: <164c92d827cbee86ba2c5621716309e6@localhost>
	 <200904300939.31754.henrik@austad.us>
	 <49b7c2350905071935kbd2aa22v9d39cf41c537c24b@mail.gmail.com>
	 <20090508091052.GA10429@januz.myftp.org> <1243710957.6645.157.camel@laptop>
	 <20090530204038.GA20875@alecto.austad.us>
Content-Type: text/plain
Date: Sat, 30 May 2009 23:15:47 +0200
Message-Id: <1243718147.6645.159.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-30 at 22:40 +0200, Henrik Austad wrote:
> On Sat, May 30, 2009 at 09:15:57PM +0200, Peter Zijlstra wrote:
> > On Fri, 2009-05-08 at 11:10 +0200, Henrik Austad wrote:
> > > > In fact, I also  don't have perfect know how to solve PI in Multicore.
> > > > [...]
> > > > > deadline inversion will be a problem, in fact, whatever you chooose to 
> > > > > be the 'key' for picking tasks (priority, niceness, deadlines, wind 
> > > > > direction, <whatever>), you can pretty much take that and add a 
> > > > > -inversion after it. :)
> > > 
> > > No, PI is going to be deadly no matter what you do.
> > 
> > Right, we would need to extend the Priority Inheritance Protocol to
> > include everything the regular scheduling functions operate on.
> > 
> > That is, we can reduce scheduling to a single order operator that orders
> > all the available tasks, such that t_n < t_n+1.
> > 
> > For pure EDF that would be a comparison on deadlines (and available
> > bandwidth), for FIFO on static priority and for CFS something based on
> > the virtual runtimes of the involved tasks. For the combined set of
> > these scheduling classes the comparator uses the class hierarchy to
> > order between them.
> > 
> > Lets call the full set of data that is used to determine this order a
> > task's key.
> > 
> > If we then substitute this key for the static priority of the classic
> > PIP and use this generic comparison operator, it can be extended to
> > cover arbitrary complex scheduling functions.
> 
> I think you can do this in pick_next_task, actually.
> 
> I wonder, will it be enough to add a single task_struct *blocker to task_struct? 
> 
> Then you will end up with a list (or tree of tasks) all ending in a single task 
> that holds the required resource. Say task A,B,C,D and E holds some critical 
> resource, then you can end up with (awful ascii-art to starboard!):
> 
>    A -> B -> E
>              ^
>              |
>         C -> D
> 
> So, whenever A-D is being scheduled, E will be picked by pick_next_task as it 
> detects that it is blocked, so it follows the blocker untill it finds an 
> unblocked task. That task  must then be the holder of the resource.
> 
> Now, the 'only' thing that needs to be done, is to let the kernel update the 
> blocker with the correct task, and detect the moment it releases the resource.
> 
> Or am I missing some crazy racecondition here?

Except for the bit where you avoid multiple cpus trying to run the same
task :-)

It's tracktable, but it really complicates the matter. But yes, PEP is
very attractive.

