Return-Path: <linux-kernel-owner+w=401wt.eu-S933498AbXEJWrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933498AbXEJWrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 18:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760004AbXEJWr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 18:47:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:46533 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756829AbXEJWr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 18:47:26 -0400
Date: Fri, 11 May 2007 01:44:46 +0200
From: Andi Kleen <ak@suse.de>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Andi Kleen <ak@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: getcpu after sched_setaffinity
Message-ID: <20070510234446.GC2012@bingen.suse.de>
References: <46439BBA.2070705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46439BBA.2070705@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 03:24:58PM -0700, Ulrich Drepper wrote:
> The attached test program fails on a dual core (and probably SMP) 
> machine on x86-64.  Depending on where the thread starts, in one of the 
> iterations the sched_setffinity() call succeeds but then sched_getcpu() 
> fails to report the correct CPU.
> 
> In set_cpus_allowed migrate_task() is called if the new CPU set does not 
> include the current CPU.  I hope that migrate_task() also works for 
> p==current.
> 
> This leaves the x86-64 vgetcpu() implementation as the weak point.  Is 
> the caching causing problems?  

Probably. In principle getcpu() (where does the sched_ come from btw?)
is only designed for the case where you don't set the affinity explicitely;
otherwise you should already know where you are and don't need it.

The cache is optimized for the case when you run without affinity
and change CPUs only rarely (which is normal) so it is kept valid for a 
jiffie. And you always need to handle an outdated result from getcpu
anyways because you can't disable preemption from user space and could
switch any time.

In short your test case has a broken design.

> is reset?

The vsyscall/kernel can't reset the cache because it is managed by the
application.

Hmm ok one could probably define memset(..., 0) as a invalidation
interface, but because of the considerations above i don't think
it is really needed.

-Andi
