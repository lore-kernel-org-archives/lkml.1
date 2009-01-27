Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbZA0HZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbZA0HZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 02:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbZA0HZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 02:25:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751213AbZA0HZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 02:25:41 -0500
Date: Mon, 26 Jan 2009 23:25:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-Id: <20090126232519.44f2943c.akpm@linux-foundation.org>
In-Reply-To: <200901271735.12034.rusty@rustcorp.com.au>
References: <20090116191108.135927000@polaris-admin.engr.sgi.com>
	<200901261711.43943.rusty@rustcorp.com.au>
	<20090125230130.bcdab2e5.akpm@linux-foundation.org>
	<200901271735.12034.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009 17:35:11 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Monday 26 January 2009 17:31:30 Andrew Morton wrote:
> > On Mon, 26 Jan 2009 17:11:43 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:
> > 
> > > On Saturday 24 January 2009 18:45:37 Andrew Morton wrote:
> > > > Pity the poor reader who comes along trying to work out why this exists.
> > 
> > (chirp, chirp)
> 
> I disagree.  It's simple; we create a workqueue and we use it.  There's no
> confusion here.

Reader's first and most important question is "why does this exist".

> > > None of these options are appealing...
> > 
> > Can we try harder please?  10 screenfuls of kernel threads in the ps
> > output is just irritating.
> > 
> > How about banning the use of work_on_cpu() from schedule_work()
> > handlers and then fixing that driver somehow?
> 
> Again, that's how we got here in the first place.  I didn't realize the
> twisty path by which the acpi cpufreq code could be called.  And there
> may well be others.  So I want work_on_cpu to be completely generic.

But it isn't generic.  The patch just moved the deadlock from one queue
to another.  Making work_on_cu() truly generic is quite hard!

> But it's a general comment about fixing a general issue.  The currently
> known case is not directly relevent; that it can happen and it's restricting
> the use of this otherwise-general API is.

I think we should switch acpi-cpufreq to smp_call_function(), revert
this stuff and ban the calling of work_on_cpu() under locks.

> A little confused at all this vitriol,

Well let's see.

- it was badly changelogged

- it was badly commented

- it's slow.  In many ways, including the unnecessary serialisation
  of each cross-cpu call in acpi-cpufreq.

- it consumes a tremendous amount of resources just to fix some
  acpi locking snafu

- it adds yet another zillion kernel threads

- it's still deadlockable

- it got sent to Linus while still under active discussion

- and it got merged

- Oleg is the usual workqueue developer and wasn't even cc'ed.

- I am the usual workqueue reviewer/merger (and would prefer to remain
  thus, please) and I wasn't cc'ed either.

