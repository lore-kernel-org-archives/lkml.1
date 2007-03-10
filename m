Return-Path: <linux-kernel-owner+w=401wt.eu-S1767847AbXCJPvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767847AbXCJPvy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 10:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767850AbXCJPvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 10:51:54 -0500
Received: from sceptre.pobox.com ([207.106.133.20]:54628 "EHLO
	sceptre.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767847AbXCJPvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 10:51:53 -0500
X-Greylist: delayed 57591 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Mar 2007 10:51:53 EST
Date: Sat, 10 Mar 2007 09:51:49 -0600
From: Nathan Lynch <ntl@pobox.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Cliff Wickman <cpw@sgi.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] hotplug cpu: migrate a task within its cpuset
Message-ID: <20070310155149.GA18478@localdomain>
References: <20070309193925.B60891B8028@attica.americas.sgi.com> <20070310091942.GC18250@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070310091942.GC18250@elte.hu>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi-

Ingo Molnar wrote:
> 
> * Cliff Wickman <cpw@sgi.com> wrote:
> 
> > With this patch, migrate the task to:
> >  1) to any cpu on the same node as the disabled cpu, which is both online
> >     and among that task's cpus_allowed
> >  2) to any online cpu within the task's cpuset
> >  3) to any cpu which is both online and among that task's cpus_allowed
> > 
> > Diffed against 2.6.21-rc3 (Andrew's current top of tree)
> 
> looks good to me.
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>
> 
> > +	/* try to stay on the same cpuset */
> > +	if (dest_cpu == NR_CPUS) {
> > +		p->cpus_allowed = cpuset_cpus_allowed(p);
> > +		dest_cpu = any_online_cpu(p->cpus_allowed);
> > +	}
> 
> what's the practical effect of this - when moving the last CPU offline 
> from a node you got jobs migrated to really alien nodes? Thus i think we 
> should queue this up for v2.6.21 too, correct? It's a NOP on systems 
> that do not set up cpusets, so it's low-risk.

See my earlier reply to this patch.  Calling cpuset_cpus_allowed
(which takes a mutex) here is a bug, since move_task_off_dead_cpu must
be called with interrupts disabled.


> btw., unrelated to your patch, there's this bit right after the code 
> above:
> 
>         /* No more Mr. Nice Guy. */
>         if (dest_cpu == NR_CPUS) {
>                 rq = task_rq_lock(p, &flags);
>                 cpus_setall(p->cpus_allowed);
>                 dest_cpu = any_online_cpu(p->cpus_allowed);
> 
> out of consistency, shouldnt the cpus_setall() rather be:
> 
> 		p->cpus_allowed = cpu_possible_map;
> 
> ? It shouldnt make any real difference but it looks more consistent.

The default value of cpus_allowed is CPU_MASK_ALL, I thought -- at
least that's what we set init's to early on.  Though, as you say, it
shouldn't make any difference.

