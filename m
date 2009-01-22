Return-Path: <linux-kernel-owner+w=401wt.eu-S1758003AbZAVJmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003AbZAVJmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 04:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbZAVJmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 04:42:25 -0500
Received: from smtp-out.google.com ([216.239.45.13]:63232 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbZAVJmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 04:42:24 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=LHzXl8FwXD7XyGM3ytsMst75sA3Ej36J8EM9Yb1SIpd1vK4dpOLfvfhjRHTWAj7E0
	1SbOGl3hQFXfvGZnoR12w==
Date: Thu, 22 Jan 2009 01:39:28 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nikanth Karthikesan <knikanth@suse.de>
cc: Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
In-Reply-To: <200901221453.14860.knikanth@suse.de>
Message-ID: <alpine.DEB.2.00.0901220134200.32502@chino.kir.corp.google.com>
References: <200901211638.23101.knikanth@suse.de> <200901221042.30957.knikanth@suse.de> <alpine.DEB.2.00.0901220036440.28850@chino.kir.corp.google.com> <200901221453.14860.knikanth@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.25.146.38
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2009, Nikanth Karthikesan wrote:

> > You can't specify different behavior for an oom cgroup depending on what
> > type of oom it is, which is the problem with this proposal.
> >
> 
> No. This does not disable any such special selection criteria which is used 
> without this controller.
> 

I didn't say it disabled it; the cpuset preference is actually implemented 
in the badness() score and not specifically excluded in 
select_bad_process().  That's because it's quite possible that a task has 
allocated memory in a cpuset and then either moved to a separate cpuset or 
had it's mems_allowed changed.

Please try it and you'll see.  Create two cpusets, cpuset A and cpuset B.  
Elevate cpuset A's oom.victim value and then trigger an oom in cpuset B.  
Your patch will cause a task from cpuset A to be killed for a cpuset B 
triggered oom which, more often than not, will not lead to future memory 
freeing.

It's quite possible that cpuset A would be preferred to be killed in a 
global unconstrained oom condition, however.  That's the only reason why 
one would elevate its oom.victim score to begin with.  But it doesn't work 
for cpuset-constrained ooms.

It's not going to help if it I explain it further and you don't try it out 
on your own.  Thanks.
