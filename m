Return-Path: <linux-kernel-owner+w=401wt.eu-S1758978AbYB2BMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978AbYB2BMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:12:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbYB2BGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 20:06:10 -0500
Received: from smtp-out.google.com ([216.239.45.13]:38421 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858AbYB2BGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 20:06:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=YsLAhZZ8ue515MwIzCs6xuhrw2PHULsHLX8sb9k7rVP/KN/Vb8ZSQWv3Wh0lmnXQe
	qVE/xHVDaaNuAAJ6yvZCA==
Date: Thu, 28 Feb 2008 17:05:21 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, maxk@qualcomm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
In-Reply-To: <20080228181611.49671331.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802281659460.3158@chino.kir.corp.google.com>
References: <20080227222103.673194000@chello.nl> <20080228075010.GA28781@elte.hu> <20080228020808.3fd22f77.pj@sgi.com> <20080228090847.GA1133@elte.hu> <20080228031710.3405e405.pj@sgi.com> <alpine.DEB.1.00.0802280129580.15900@chino.kir.corp.google.com>
 <alpine.DEB.1.00.0802280212070.23040@chino.kir.corp.google.com> <20080228113728.7b8e5811.pj@sgi.com> <alpine.DEB.1.00.0802281309480.24402@chino.kir.corp.google.com> <20080228164637.114fb19d.pj@sgi.com> <alpine.DEB.1.00.0802281452340.13082@chino.kir.corp.google.com>
 <20080228181611.49671331.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Paul Jackson wrote:

> > Move the watchdog/0 thread to a cpuset that doesn't have access to cpu 0.  
> 
> I still don't understand ... you must have some context in mind that
> I've spaced out ... I can't even tell if that is a statement or a
> question.
> 

You said that you weren't aware of any problems that could arise that are 
fixed with this added check in set_cpus_allowed(), so I asked that you 
setup a cpuset that doesn't have access to cpu 0 and move the watchdog/0 
thread to it.

> Backing up, hopefully unwrapping, you seemed to allow moving bound tasks
> only to cpusets with the same cpus (how come you didn't check for the
> same memory nodes too?).  If you really needed to move bound tasks at all,
> then that seemed like an unnecessarily tight constraint.  It wouldn't hurt
> the bound task to move to another cpuset that still allowed the CPUs it was
> bound to.
> 
> ... but after an another iteration of that subthread ... I'm wondering
> why you have to move bound tasks at all.  How about PF_THREAD_BIND just
> meaning (1) "can't be moved to any other cpuset", and (2) "always
> placed in the top cpuset," so we don't have to worry about being unable
> to move threads out of child cpusets.
> 
> Do you have any situation in which pinned threads have to be moved?
> 
> I don't.  Can we just prohibit it?
> 

The fix is more general than just the cpusets case, even though it is 
probably the only user in the kernel of set_cpus_allowed() that allows 
bound kthreads to be moved.

The idea is to expressly deny kthreads that have called kthread_bind() 
from changing their cpus_allowed via set_cpus_allowed().  Cpusets should 
handle that gracefully, but my fix is more general: it adds the check to 
set_cpus_allowed() instead of in the cpusets code.

This is a little difficult with the current way that cpusets calls 
set_cpus_allowed() since its attach function is void and does not return 
error or success to the cgroup interface, yet my patch prevents the soft 
lockups and kernel crashes that can occur when cpusets changes the 
cpus_allowed of watchdog or migration threads that is obviously in error.

		David
