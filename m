Return-Path: <linux-kernel-owner+w=401wt.eu-S1757394AbZAVKMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbZAVKMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 05:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbZAVKMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 05:12:40 -0500
Received: from mail.suse.de ([195.135.220.2]:48144 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbZAVKMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 05:12:40 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: David Rientjes <rientjes@google.com>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Date: Thu, 22 Jan 2009 15:40:07 +0530
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org
References: <200901211638.23101.knikanth@suse.de> <200901221453.14860.knikanth@suse.de> <alpine.DEB.2.00.0901220134200.32502@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0901220134200.32502@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901221540.08108.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 January 2009 15:09:28 David Rientjes wrote:
> On Thu, 22 Jan 2009, Nikanth Karthikesan wrote:
> > > You can't specify different behavior for an oom cgroup depending on
> > > what type of oom it is, which is the problem with this proposal.
> >
> > No. This does not disable any such special selection criteria which is
> > used without this controller.
>
> I didn't say it disabled it; the cpuset preference is actually implemented
> in the badness() score and not specifically excluded in
> select_bad_process().  That's because it's quite possible that a task has
> allocated memory in a cpuset and then either moved to a separate cpuset or
> had it's mems_allowed changed.
>
> Please try it and you'll see.  Create two cpusets, cpuset A and cpuset B.
> Elevate cpuset A's oom.victim value and then trigger an oom in cpuset B.
> Your patch will cause a task from cpuset A to be killed for a cpuset B
> triggered oom which, more often than not, will not lead to future memory
> freeing.
>
> It's quite possible that cpuset A would be preferred to be killed in a
> global unconstrained oom condition, however.  That's the only reason why
> one would elevate its oom.victim score to begin with.  But it doesn't work
> for cpuset-constrained ooms.
>
> It's not going to help if it I explain it further and you don't try it out
> on your own.  Thanks.

Thanks for the clear explanation. Cpuset does it by reducing the badness to 
1/8th for tasks. So using oom-controller could kill some innocent processes on 
some other cpuset! 

But it is possible to have the same effect with oom_adj, having oom_adj=4 for 
a task on a diff cpuset will do the same(assuming they have similar badness).

I think cpusets preference could be improved, not to depend on badness, with 
something similar to what memcg does. With or without adding overhead of 
tracking processes that has memory from a node.

Thanks
Nikanth
