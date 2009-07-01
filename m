Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbZGAJtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbZGAJtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbZGAJs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:48:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51139 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775AbZGAJs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:48:56 -0400
Date: Wed, 1 Jul 2009 11:48:56 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: andi@firstfloor.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired how many spinlocks to schedstat
Message-ID: <20090701094856.GO6760@one.firstfloor.org>
References: <20090701.152115.706994265076015808.mitake@dcl.info.waseda.ac.jp> <87hbxwj1k3.fsf@basil.nowhere.org> <20090701.174226.419764642024067218.mitake@dcl.info.waseda.ac.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701.174226.419764642024067218.mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 05:42:26PM +0900, Hitoshi Mitake wrote:
> From: Andi Kleen <andi@firstfloor.org>
> Subject: Re: [PATCH][RFC] Adding information of counts processes acquired how many spinlocks to schedstat
> Date: Wed, 01 Jul 2009 09:38:04 +0200
> 
> > Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> writes:
> > 
> > > Hi,
> > >
> > > I wrote a test patch which add information of counts processes acquired how many spinlocks to schedstat.
> > > After applied this patch, /proc/<PID>/sched will change like this,
> > 
> > The problem is that spinlocks are very common and schedstats is enabled commonly
> > in production kernels. You would need to demonstrate that such a change doesn't
> > have significant performance impact. For me it looks like it has.
> 
> I agree with your opinion about performance impact.
> I thought this will make no problem,
> because schedstat is categorized as "Kernel hacking" section.
> But according to you, many production kernels enable it

Yes it's used by some performance management tools.

It might be still appropiate with a separate CONFIG option,
assuming the metric is actually useful (which is somewhat
questionable)

BTW I did spinlock counter statistics in the past with systemtap
(they're quite easy to do with it without any code changes), but I didn't find
them very useful to be honest.

> > Also I'm not sure exactly what good such a metric is. Do you have 
> > a concrete use case?
> > 
> 
> I want to know about behavior of Apache.

Spinlocks are mainly interesting when they use up CPU time.
This typically happens when they bounce cache lines or are
contended. On the other hand on modern CPUs "local only"
spinlocks that are not contended are quite cheap and 
not very interesting to optimize. For useful optimization
you need to distingush all these cases, and your 
simple counter doesn't help with that.

So I would suggest you just take a look at any of the 
standard kernel profilers (oprofile etc.) or at lockstat

> And spinlocks may cause terrible performance problem when Linux is running on VM.

Assuming a modern CPU the "uncontended lock spinlock" case shouldn't
be particularly expensive in VMs either.

> 
> > The normal way to check for lock contention or lock bouncingis to
> > simply profile cycles or time and see if there is a lot of CPU time in
> > locks.
> 
> According to Ingo's advice, I'll try to add lock counter to perfcounter.

Well that would have the same problem if that perfcounter is enabled.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
