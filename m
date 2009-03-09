Return-Path: <linux-kernel-owner+w=401wt.eu-S1752718AbZCITqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbZCITqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 15:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbZCITqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 15:46:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46449 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbZCITqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 15:46:08 -0400
Message-ID: <49B571C7.3010005@redhat.com>
Date: Mon, 09 Mar 2009 21:45:11 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-aio <linux-aio@kvack.org>, zach.brown@oracle.com, bcrl@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] aio: remove aio-max-nr and instead use the memlock rlimit
 to limit the number of pages pinned for the aio completion ring
References: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com>	<49B54143.1010607@redhat.com> <x49sklmd1fo.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49sklmd1fo.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer wrote:
>> Is it not possible to get rid of the pinning entirely?  Pinning
>> interferes with page migration which is important for NUMA, among
>> other issues.
>>     
>
> aio_complete is called from interrupt handlers, so can't block faulting
> in a page.  Zach mentions there is a possibility of handing completions
> off to a kernel thread, with all of the performance worries and extra
> bookkeeping that go along with such a scheme (to help frame my concerns,
> I often get lambasted over .5% performance regressions).
>   

Or you could queue the completions somewhere, and only copy them to user 
memory when io_getevents() is called.  I think the plan was once to 
allow events to be consumed opportunistically even without 
io_getevents(), though.


> I'm happy to look into such a scheme, should anyone show me data that
> points to this NUMA issue as an actual performance problem today.  In
> the absence of such data, I simply can't justify the work at the moment.
>   

Right now page migration is a dead duck.  Outside HPC, there is now 
support for triggering it or for getting the scheduler to prefer a 
process's memory node.  Only a minority of hosts are NUMA.

I think that will/should change in the near future.  Nehalem-based 
servers mean that NUMA will be commonplace.  The larger core counts will 
mean that hosts will run several unrelated applications (often through 
virtualization); such partitioning can easily benefit from page migration.

> Thanks for taking a look!
>   

Sorry, I didn't actually take a look at the patches.  I only reacted to 
the description - I am allergic to pinned memory.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

