Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbZA3WSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbZA3WSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 17:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757327AbZA3WS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 17:18:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754522AbZA3WS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 17:18:28 -0500
Date: Fri, 30 Jan 2009 14:17:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: travis@sgi.com, mingo@redhat.com, davej@redhat.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-Id: <20090130141744.007fe725.akpm@linux-foundation.org>
In-Reply-To: <200901310829.17099.rusty@rustcorp.com.au>
References: <20090116191108.135927000@polaris-admin.engr.sgi.com>
	<200901301633.54013.rusty@rustcorp.com.au>
	<20090129223042.47dc42a1.akpm@linux-foundation.org>
	<200901310829.17099.rusty@rustcorp.com.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Jan 2009 08:29:15 +1030
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Friday 30 January 2009 17:00:42 Andrew Morton wrote:
> > On Fri, 30 Jan 2009 16:33:53 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:
> > 
> > > On Thursday 29 January 2009 12:42:05 Andrew Morton wrote:
> > > > On Thu, 29 Jan 2009 12:13:32 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > > 
> > > > > On Thursday 29 January 2009 06:14:40 Andrew Morton wrote:
> > > > > > It's vulnerable to the same deadlock, I think?  Suppose we have:
> > > > > ...
> > > > > > - A calls work_on_cpu() and takes woc_mutex.
> > > > > > 
> > > > > > - Before function_which_takes_L() has started to execute, task B takes L
> > > > > >   then calls work_on_cpu() and task B blocks on woc_mutex.
> > > > > > 
> > > > > > - Now function_which_takes_L() runs, and blocks on L
> > > > > 
> > > > > Agreed, but now it's a fairly simple case.  Both sides have to take lock L, and both have to call work_on_cpu.
> > > > > 
> > > > > Workqueues are more generic and widespread, and an amazing amount of stuff gets called from them.  That's why I felt uncomfortable with removing the one known problematic caller.
> > > > > 
> > > > 
> > > > hm.  it's a bit of a timebomb.
> > > > 
> > > > y'know, the original way in which acpi-cpufreq did this is starting to
> > > > look attractive.  Migrate self to that CPU then just call the dang
> > > > function.  Slow, but no deadlocks (I think)?
> > > 
> > > Just buggy.  What random thread was it mugging?  If there's any path where
> > > it's not a kthread, what if userspace does the same thing at the same time?
> > > We risk running on the wrong cpu, *then* overriding userspace when we restore
> > > it.
> > 
> > hm, Ok, not unficable but not pleasant.
> > 
> > > In general these cpumask games are a bad idea.
> > 
> > So we still don't have any non-buggy proposal.
> 
> I disagree about the avoiding-workqueue one being buggy.
> 

I assume you're talking about the patch I looked at a couple of days ago.

It's vulnerable to the same deadlock as work_on_cpu() has always been.

Just as an example, take a look at allocate_threshold_blocks().  That
function way down in the innards of x86 has blotted out large amounts of
kernel code, so that code can now not use work_on_cpu().  Anything which
happens inside ext3 commit (the entire block layer and all drivers
underneath it).  Large lumps of networking code.  Parts of the page
allocator and the VFS which I haven't started to think about yet.

>  The same logic
> applies to any simple callback function.

Not!  The difference here is the queueing and serialisation which
introduces dependencies between unrelated subsystems which happen to
use this piece of core infrastructure.

