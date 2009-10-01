Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbZJAUFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbZJAUFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 16:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbZJAUFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 16:05:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755944AbZJAUFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 16:05:15 -0400
Date: Thu, 1 Oct 2009 13:03:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tejun Heo <tj@kernel.org>, jeff@garzik.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [PATCH 03/19] scheduler: implement workqueue scheduler class
In-Reply-To: <20091001192338.GA24862@elte.hu>
Message-ID: <alpine.LFD.2.01.0910011257520.6996@localhost.localdomain>
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <1254384558-1018-4-git-send-email-tj@kernel.org> <alpine.LFD.2.01.0910010953010.6996@localhost.localdomain> <20091001184824.GA21357@elte.hu> <4AC4FC47.4010405@redhat.com>
 <alpine.LFD.2.01.0910011207180.6996@localhost.localdomain> <20091001192338.GA24862@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Oct 2009, Ingo Molnar wrote:
> 
> Yeah. That scheme was hobbled by signal semantics: it looked hard to do 
> the 'flip a reserve thread with a blocked thread' trick in the scheduler 
> while still keeping all the signal details in place.

I think we should look at David Wheeler's advice: "Any problem in computer 
science can be solved with another level of indirection".

In particular, my favourite solution to this is to split "struct 
thread_struct" into a new part, which would be "CPU state". 

In other words, all threadlets would share one single "struct 
thread_struct" (and thus local signal state), but they would then each 
have a "struct cpu_state" associated with them, which includes the kernel 
stack. And that cpu_state thing would not be preempted, it would be 
something like a round-robin cooperative scheduling that is only invoced 
when a threadlet goes to sleep.

			Linus
