Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab0BPHxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 02:53:45 -0500
Received: from smtp-out.google.com ([216.239.33.17]:51107 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932686Ab0BPHxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 02:53:40 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=jBfkvNTzaNdGsIlZkFLrvLPk+jS7YWGUPASsI0MqS8HxZiDP1GnV2ZOQggITcI7G1
	Gf6cuiV3Hn7L4/4pzuvqg==
Date: Mon, 15 Feb 2010 23:53:33 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nick Piggin <npiggin@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 4/9 v2] oom: remove compulsory panic_on_oom mode
In-Reply-To: <20100216072047.GH5723@laptop>
Message-ID: <alpine.DEB.2.00.1002152342120.7470@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com> <alpine.DEB.2.00.1002151418190.26927@chino.kir.corp.google.com> <20100216062035.GA5723@laptop> <alpine.DEB.2.00.1002152252310.2745@chino.kir.corp.google.com>
 <20100216072047.GH5723@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010, Nick Piggin wrote:

> > Because it is inconsistent at the user's expense, it has never panicked 
> > the machine for memory controller ooms, so why is a cpuset or mempolicy 
> > constrained oom conditions any different?
> 
> Well memory controller was added later, wasn't it? So if you think
> that's a bug then a fix to panic on memory controller ooms might
> be in order.
> 

But what about the existing memcg users who set panic_on_oom == 2 and 
don't expect the memory controller to be influenced by that?

> >  It also panics the machine even 
> > on VM_FAULT_OOM which is ridiculous,
> 
> Why?
> 

Because the oom killer was never called for VM_FAULT_OOM before, we simply 
sent a SIGKILL to current, i.e. the original panic_on_oom semantics were 
not even enforced.

> > the tunable is certainly not being 
> > used how it was documented
> 
> Why not? The documentation seems to match the implementation.
> 

It was meant to panic the machine anytime it was out of memory, regardless 
of the constraint, but that obviously doesn't match the memory controller 
case.  Just because cpusets and mempolicies decide to use the oom killer 
as a mechanism for enforcing a user-defined policy does not mean that we 
want to panic for them: mempolicies, for example, are user created and do 
not require any special capability.  Does it seem reasonable that an oom 
condition on those mempolicy nodes should panic the machine when killing 
the offender is possible (and perhaps even encouraged if the user sets a 
high /proc/pid/oom_score_adj?)  In other words, is an admin setting 
panic_on_oom == 2 really expecting that no application will use 
set_mempolicy() or do an mbind()?  This is a very error-prone interface 
that needs to be dealt with on a case-by-case basis and the perfect way to 
do that is by setting the affected tasks to be OOM_DISABLE; that 
interface, unlike panic_on_oom == 2, is very well understood by those with 
CAP_SYS_RESOURCE.
