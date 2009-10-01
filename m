Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbZJATIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbZJATIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 15:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbZJATIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 15:08:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755801AbZJATIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 15:08:36 -0400
Date: Thu, 1 Oct 2009 12:06:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tejun Heo <tj@kernel.org>, jeff@garzik.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [PATCH 03/19] scheduler: implement workqueue scheduler class
In-Reply-To: <20091001184824.GA21357@elte.hu>
Message-ID: <alpine.LFD.2.01.0910011152080.6996@localhost.localdomain>
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <1254384558-1018-4-git-send-email-tj@kernel.org> <alpine.LFD.2.01.0910010953010.6996@localhost.localdomain> <20091001184824.GA21357@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Oct 2009, Ingo Molnar wrote:
>
> > So tying this to the scheduler class seems a bit odd. But maybe I'm 
> > missing something?
> 
> We could do what Avi suggested: not use scheduler classes at all for 
> this (that brings in other limitations like lack of p->policy freedom), 
> but use the existing preempt-notifications callbacks.

I don't think that works. I think the preempt notifiers are done too early 
and too late (ie they are done at the actual context switch), which what 
Tejun's code wants is to be called so that he can actually _do_ something 
about the task before the next task is selected.

But if the preempt-notification users are ok with being called earlier, 
then yes, I guess we could share the logic (and rename it). I do agree 
that what I'd like to see is more _like_ those preempt notifications, with 
a list of things to do before/after.

> They are per task - we would simply make preempt notifiers 
> unconditional, i.e. remove CONFIG_PREEMPT_NOTIFIERS and make it all 
> unconditional scheduler logic.

I don't mind that, but see above: I think the semantics are fundamentally 
different. One wants to be called exactly when the actual context switch 
happens, the other wants to be called before the choice of the next thread 
is even done (which in turn can mean that no context switch actually 
happens at all, because maybe you end up picking the same thread after 
all - possibly _due_ to the callback doing something)

But it's possible that I'm making a semantic difference out of something 
that nobody actually cares about.

		Linus
