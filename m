Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbXFURYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbXFURYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758120AbXFURXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:23:55 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:33178 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756702AbXFURXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:23:54 -0400
Date: Thu, 21 Jun 2007 23:02:32 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Paul Jackson <pj@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, clameter@sgi.com,
       linux-kernel@vger.kernel.org, dino@in.ibm.com,
       akpm@linux-foundation.org
Subject: Re: cpuset attach_task to touch per-cpu kernel threads?
Message-ID: <20070621173232.GP10980@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070621014935.GF10980@linux.vnet.ibm.com> <20070621121635.GB19811@elte.hu> <20070621100712.52a4784a.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070621100712.52a4784a.pj@sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2007 at 10:07:12AM -0700, Paul Jackson wrote:
> Ingo, responding to Srivatsa:
> > > Or maybe allow movement if it 
> > > doesn't result in changing kernel-threads's cpu affinity.
> > 
> > yeah, i'd agree ..
> 
> Good point.  I'd agree too.

Yeah .."allow movement if it doesn't result in changing kernel-threads's cpu 
affinity" sounds good, except it is hard to implement in cpuset's
context I think. For ex: we now have to take additional steps when
changing 'cpus_allowed' of a cpuset such that it doesn't violate any cpu
affinity of kernel threads bound to the cpuset. That itself makes the
implementation complex I think.

How about a simpler patch which bans movement of kernel threads from its
home cpuset (i.e top cpuset)?


Index: current/kernel/cpuset.c
===================================================================
--- current.orig/kernel/cpuset.c	2007-06-21 19:42:18.000000000 +0530
+++ current/kernel/cpuset.c	2007-06-21 22:24:38.000000000 +0530
@@ -881,6 +881,10 @@
 	if (cpus_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed))
 		return -ENOSPC;
 
+	/* Don't allow kernel threads to be moved */
+	if (!tsk->mm)
+		return -EINVAL;
+
 	return security_task_setscheduler(tsk, 0, NULL);
 }
 

This probably catches exiting user-space tasks also (whose ->mm pointer is 
null).  Hmm ..there should be a better check for kernel threads.


-- 
Regards,
vatsa
