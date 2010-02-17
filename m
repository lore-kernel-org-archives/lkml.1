Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab0BQJXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 04:23:44 -0500
Received: from smtp-out.google.com ([216.239.44.51]:24594 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab0BQJXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 04:23:41 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=CHrDgkmy2/aHIf6MWYMzG9MOvbu+I2I608Bnlz5YrlZw7XxBk4vtphdTBeKzaAEjN
	78R23BvvfTSpwqvUk+25w==
Date: Wed, 17 Feb 2010 01:23:35 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan.kim@gmail.com>
cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 4/7 -mm] oom: badness heuristic rewrite
In-Reply-To: <28c262361002162341m1d77509dv37d7d13b4ccd0ef9@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1002170114300.30931@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com> <alpine.DEB.2.00.1002100228540.8001@chino.kir.corp.google.com> <4B73833D.5070008@redhat.com> <alpine.DEB.2.00.1002102332200.22152@chino.kir.corp.google.com> <1265982984.6207.29.camel@barrios-desktop>
 <alpine.DEB.2.00.1002121251130.7972@chino.kir.corp.google.com> <28c262361002121845w459d0fa0l55a58552c3a6081e@mail.gmail.com> <alpine.DEB.2.00.1002151347470.26927@chino.kir.corp.google.com> <1266326086.1709.50.camel@barrios-desktop>
 <alpine.DEB.2.00.1002161323450.23037@chino.kir.corp.google.com> <28c262361002162341m1d77509dv37d7d13b4ccd0ef9@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381004-354184966-1266398616=:30931"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381004-354184966-1266398616=:30931
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 17 Feb 2010, Minchan Kim wrote:

> >> Okay. I can think it of slight penalization in this patch.
> >> But in current OOM logic, we try to kill child instead of forkbomb
> >> itself. My concern was that.
> >
> > We still do with my rewrite, that is handled in oom_kill_process().  The
> > forkbomb penalization takes place in badness().
> 
> 
> I thought this patch is closely related to [patch  2/7].
> I can move this discussion to [patch 2/7] if you want.
> Another guys already pointed out why we care child.
> 

We have _always_ tried to kill a child of the selected task first if it 
has a seperate address space, patch 2 doesn't change that.  It simply 
tries to kill the child with the highest badness() score.

> I said this scenario is BUGGY forkbomb process. It will fork + exec continuously
> if it isn't killed. How does user intervene to fix the system?
> System was almost hang due to unresponsive.
> 

The user would need to kill the parent if it should be killed.  The 
unresponsiveness in this example, however, is not a question of the oom 
killer but rather the scheduler to provide interactivity to the user in 
forkbomb scenarios.  The oom killer should not create a policy that 
unfairly biases tasks that fork a large number of tasks, however, to 
provide interactivity since that task may be a vital system resource.

> For extreme example,
> User is writing some important document by OpenOffice and
> he decided to execute hackbench 1000000 process 1000000.
> 
> Could user save his important office data without halt if we kill
> child continuously?
> I think this scenario can be happened enough if the user didn't know
> parameter of hackbench.
> 

So what exactly are you proposing we do in the oom killer to distinguish 
between a user's mistake and a vital system resource?  I'm personally much 
more concerned with protecting system daemons that provide a service under 
heavyload than protecting against forkbombs in the oom killer.
--531381004-354184966-1266398616=:30931--
