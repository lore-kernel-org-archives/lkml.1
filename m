Return-Path: <linux-kernel-owner+w=401wt.eu-S1751777AbZA0I5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbZA0I5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 03:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbZA0I5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 03:57:44 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:9911 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbZA0I5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 03:57:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nRrgmWeA+TeXVc3itXJApZUmV+OroEtP3/q+d3cjGhpFdebPi4AXwsHIhKw03SL3ux
         cJS0/pntOILvrK3nhuCvW+ZjTVGU3b1rH+pYpMqxcWxNiAJAi3i3bbYMJRK7gTx6nMXD
         G3Tll03BpetV5I7eP60uFa8bjEizWHQ1Gwvck=
Date: Tue, 27 Jan 2009 09:57:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alasdair G Kergon <agk@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
Message-ID: <20090127085738.GB5498@nowhere>
References: <20090127001708.GA4815@nowhere> <20090127030727.GA15101@agk.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127030727.GA15101@agk.fab.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 03:07:27AM +0000, Alasdair G Kergon wrote:
> On Tue, Jan 27, 2009 at 01:17:11AM +0100, Frederic Weisbecker wrote:
> > For several reasons:
> > _ Unneeded built drivers for my system that create workqueue(s) when they init
> > _ Services which need their own workqueue, for several reasons, but who receive
> >   very rare jobs (often never)
> 
> > I hadn't any problems until now with this patch but I think it needs more testing,
> > like with cpu hotplug, and some renaming for its functions and structures...
> > And I would like to receive some comments and feelings before continuing. So this
> > is just an RFC :-)
> 
> Make sure this optimisation also works when the system's running low on memory
> if workqueues are involved in "making forward progress".  Doubtless there
> are other reasons for apparently-unused workqueues too.


That's true. But currently, each useless workqueue thread is consuming a
task_struct in memory, so this patch makes actually consuming less memory than
before.
If the system is running low on memory...well perhaps I can reschedule the thread
creation after some delays...?

 
> How about reviewing each particular workqueue that you've identified to see if
> it can be created later or even not at all, or destroyed while it's not being
> used, or if some workqueues can be shared - rather than presuming that a change
> like this would be safe globally?
> 
> Alasdair
> -- 
> agk@redhat.com


I did it with kpsmoused but there are so much workqueues:

$ git-grep create_singlethread_workqueue | wc -l
122

And lot of them are related to particular drivers for hardware I don't have.
So it wouldn't be easy for me to test and fix them.

And note that this patch only solves a part of the problem. It breaks the useless
threads creation, not the useless workqueue creation. So there is still some useless
memory used, and this problem can only be solved one by one.

