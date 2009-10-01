Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbZJAR5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbZJAR5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 13:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbZJAR5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 13:57:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42742 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755396AbZJAR5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 13:57:31 -0400
Date: Thu, 1 Oct 2009 10:55:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Tejun Heo <tj@kernel.org>
cc: jeff@garzik.org, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [PATCH 19/19] workqueue: implement concurrency managed
 workqueue
In-Reply-To: <4AC4E55F.6070102@kernel.org>
Message-ID: <alpine.LFD.2.01.0910011049540.6996@localhost.localdomain>
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <1254384558-1018-20-git-send-email-tj@kernel.org> <alpine.LFD.2.01.0910011008210.6996@localhost.localdomain> <4AC4E55F.6070102@kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Oct 2009, Tejun Heo wrote:
>
> Yeap, this one is pretty scary.  I tried pretty hard to at least make
> the diffs fall into relevant sections (ie. updates to certain part of
> logic shows up as diffs to the original part) but I agree this patch
> is a tad too big.  Maybe I can introduce gcwq first.  The big problem
> is the strong inter-dependency between the single global worker pool
> and the hotplug logic.  I tried to introduce the hotplug logic first
> but it basically required implementing different interim mechanism
> altogether.  One solution could be disabling or crippling cpu hotplug
> support for several commits so that the processing part and hotplug
> part can be introduced separately.  Would that be acceptable?

I would say that disabling CPU hotplug for a while is likely a good way to 
at least limit the damage, except for one thing - suspend and resume. 

That's one of the things that is hard to debug anyway, is tied to 
workqueues (with that whole freezing thing) _and_ uses CPU hotplug to 
actually get its work done. So if you effectively disable CPU hotplug for 
a part of the series, then that just means that bisection doesn't work 
over that part - and is probably one of the areas where it would be the 
most important that it works ;^/

So I dunno. I do like the series even as-is. It seems to have fairly solid 
reasoning behind it, and I absolutely hate the deadlocks we have now in 
workqueue handling and the insane things we do to work around them. At the 
same time, this code is something I get worried about - I can easily 
imaging subtle bugs that only happen under certain circumstances and with 
certain timings - and the last patch was the scariest of the lot.

So if the thing could be split up while limiting CPU hotplug only a bit 
(so that the case of suspend/resume would hopefully still be ok), that 
would be wonderful.

			Linus
