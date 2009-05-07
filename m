Return-Path: <linux-kernel-owner+w=401wt.eu-S1762954AbZEGWve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762954AbZEGWve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 18:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759169AbZEGWvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 18:51:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754949AbZEGWvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 18:51:07 -0400
Date: Thu, 7 May 2009 15:45:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: rjw@sisk.pl, fengguang.wu@intel.com, linux-pm@lists.linux-foundation.org,
       pavel@ucw.cz, torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Message-Id: <20090507154502.a7f51dd9.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0905071508190.2164@chino.kir.corp.google.com>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera>
	<200905072218.50782.rjw@sisk.pl>
	<alpine.DEB.2.00.0905071321440.646@chino.kir.corp.google.com>
	<200905072238.14558.rjw@sisk.pl>
	<20090507135615.e7db550d.akpm@linux-foundation.org>
	<alpine.DEB.2.00.0905071417160.24417@chino.kir.corp.google.com>
	<20090507145041.9b59f4eb.akpm@linux-foundation.org>
	<alpine.DEB.2.00.0905071508190.2164@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009 15:16:17 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Thu, 7 May 2009, Andrew Morton wrote:
> 
> > - the standard way of controlling memory allocator behaviour is via
> >   the gfp_t.  Bypassing that is an unusual step and needs a higher
> >   level of justification, which I'm not seeing here.
> > 
> 
> The standard way of controlling the oom killer behavior for a zone is via 
> the ZONE_OOM_LOCKED bit.

oop, I didn't remember/realise that ZONE_OOM_LOCKED already exists.

> > - if we do this via an unusual global, we reduce the chances that
> >   another subsytem could use the new feature.
> > 
> >   I don't know what subsytem that might be, but I bet they're out
> >   there.  checkpoint-restart, virtual machines, ballooning memory
> >   drivers, kexec loading, etc.
> > 
> 
> There's two separate issues here: the use of ZONE_OOM_LOCKED to control 
> whether or not to invoke the oom killer for a specific zone (which is 
> already its only function), and the fact that in this case we're doing it 
> for all zones.  It seems like you're concerned with the latter, but the 
> distinction in the hibernation case is that no memory freeing would be 
> possible as the result of the oom killer for _all_ zones, so it makes 
> sense to lock them all out.

OK.

> > > The fact is that _all_ allocations here are implicitly __GFP_NO_OOM_KILL 
> > > whether it specifies it or not since the oom killer would simply kill a 
> > > task in D state which can't exit or free memory and subsequent allocations 
> > > would make the oom killer a no-op because there's an eligible task with 
> > > TIF_MEMDIE set.  The only thing you're saving with __GFP_NO_OOM_KILL is 
> > > calling the oom killer in a first place and killing an unresponsive task 
> > > but that would have to happen anyway when thawed since the system is oom 
> > > (or otherwise lockup for GFP_KERNEL with order < PAGE_ALLOC_COSTLY_ORDER).
> > 
> > All the above is specific to the PM application only, when userspace
> > tasks are stopped.
> > 
> 
> I'm not arguing that the only way we can ever implement __GFP_NO_OOM_KILL 
> is for the entire system: we can set ZONE_OOM_LOCKED for only the zones in 
> the zonelist that are passed to the page allocator.  For this particular 
> purpose, that is naturally all zones; for other future use cases it may be 
> chosen only to lock out the zones we're allowed to allocate from in that 
> context.

OK.

> > It might well end up that stopping userspace (beforehand or before
> > oom-killing) is a hard requirement for reliably disabling the
> > oom-killer.
> 
> Yes, globally, but future use cases may disable only specific zones such 
> as with memory hot-remove.

<goes off to find out what ZONE_OOM_LOCKED does>

That took remarkably longer than one would have expected..

Yes, OK, I agree, globally setting ZONE_OOM_LOCKED would produce a
decent result.

The setting and clearing of that thing looks gruesomely racy..

