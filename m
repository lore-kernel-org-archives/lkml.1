Return-Path: <linux-kernel-owner+w=401wt.eu-S1757740AbYGBVAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740AbYGBVAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbYGBVAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:00:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:56650 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbYGBVAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:00:23 -0400
Subject: Re: [Ksummit-2008-discuss] Delayed interrupt work, thread pools
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Jeremy Kerr <jk@ozlabs.org>
In-Reply-To: <1215007896.3330.6.camel@localhost.localdomain>
References: <1214916335.20711.141.camel@pasglop>
	 <486B0298.5030508@linux.intel.com>  <1214977447.21182.33.camel@pasglop>
	 <1215007896.3330.6.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 07:00:09 +1000
Message-Id: <1215032409.21182.56.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> If you really need the full scheduling capabilities of threads, then it
> sounds like a threadpool is all you need (and we should just provide a
> unified interface).

That's my thinking nowadays.

> Initially you were implying you'd prefer some type of non blockable
> workqueue (i.e. a workqueue that shifts to the next work item when and
> earlier item blocks).

That's also something I had in mind, I was tossing ideas around and
collecting feedback :-)

>    I can see this construct being useful because it
> would have easier to use semantics and be more lightweight than a full
> thread spawn.  It strikes me we could use some of the syslets work to do
> this ... 

Precisely what I had in mind.

> all the queue needs is an "next activation head", which will be
> the next job in the queue in the absence of blocking.  When a job
> blocks, syslets informs the workqueue and it moves on to the work on the
> "next activation head".  If a prior job unblocks, syslets informs the
> queue and it moves the "next activation head" to the unblocked job.
> What this is doing is implementing a really simple scheduler within a
> single workqueue, which I'm unsure is actually a good idea since
> schedulers are complex and tricky things, but it is probably worthy of
> discussion.

The question is: is that significantly less overhead than just spawning
a new full blown kernel thread ? enough to justify the complexity ? at
the end of the day, it means allocating a stack (which on ppc64 is still
16K, I know it sucks)... 

Ben.

