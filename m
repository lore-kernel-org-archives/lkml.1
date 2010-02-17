Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab0BQNI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:08:27 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:39561 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab0BQNIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:08:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=auFM8yhF4v6gGkvCtAwJ0+rgWUj46GlPpu9bJVogILCvvzSuwkoMLTA3GDhnrAwz9X
         A1Etl1+zzv/T9TROPC4coHToMNQBPtyrYsOyeX4ujFcTTkF4kyIhXw6JeCN9JkD7fpO3
         PJgWaSSI+k4v+BJHfuk1iVWQ6YCZZUebJQab8=
Subject: Re: [patch 4/7 -mm] oom: badness heuristic rewrite
From: Minchan Kim <minchan.kim@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1002170114300.30931@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1002100228540.8001@chino.kir.corp.google.com>
	 <4B73833D.5070008@redhat.com>
	 <alpine.DEB.2.00.1002102332200.22152@chino.kir.corp.google.com>
	 <1265982984.6207.29.camel@barrios-desktop>
	 <alpine.DEB.2.00.1002121251130.7972@chino.kir.corp.google.com>
	 <28c262361002121845w459d0fa0l55a58552c3a6081e@mail.gmail.com>
	 <alpine.DEB.2.00.1002151347470.26927@chino.kir.corp.google.com>
	 <1266326086.1709.50.camel@barrios-desktop>
	 <alpine.DEB.2.00.1002161323450.23037@chino.kir.corp.google.com>
	 <28c262361002162341m1d77509dv37d7d13b4ccd0ef9@mail.gmail.com>
	 <alpine.DEB.2.00.1002170114300.30931@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Feb 2010 22:08:11 +0900
Message-ID: <1266412091.1709.206.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-17 at 01:23 -0800, David Rientjes wrote:
> On Wed, 17 Feb 2010, Minchan Kim wrote:
> 
> > >> Okay. I can think it of slight penalization in this patch.
> > >> But in current OOM logic, we try to kill child instead of forkbomb
> > >> itself. My concern was that.
> > >
> > > We still do with my rewrite, that is handled in oom_kill_process().  The
> > > forkbomb penalization takes place in badness().
> > 
> > 
> > I thought this patch is closely related to [patch  2/7].
> > I can move this discussion to [patch 2/7] if you want.
> > Another guys already pointed out why we care child.
> > 
> 
> We have _always_ tried to kill a child of the selected task first if it 
> has a seperate address space, patch 2 doesn't change that.  It simply 
> tries to kill the child with the highest badness() score.

So I mentioned following as.  

"Of course, It's not a part of your patch[2/7] which is good.
It has been in there during long time. I hope we could solve that in
this chance."

> 
> > I said this scenario is BUGGY forkbomb process. It will fork + exec continuously
> > if it isn't killed. How does user intervene to fix the system?
> > System was almost hang due to unresponsive.
> > 
> 
> The user would need to kill the parent if it should be killed.  The 
> unresponsiveness in this example, however, is not a question of the oom 
> killer but rather the scheduler to provide interactivity to the user in 
> forkbomb scenarios.  The oom killer should not create a policy that 
> unfairly biases tasks that fork a large number of tasks, however, to 
> provide interactivity since that task may be a vital system resource.

As you said, scheduler(or something) can do it with much graceful than
OOM killer. I agreed that. 

You wrote "Forkbomb detector" in your patch description. When I saw
that, I thought we need more things to complete forkbomb detection. So I
just suggested my humble idea to fix it in this chance. 

> 
> > For extreme example,
> > User is writing some important document by OpenOffice and
> > he decided to execute hackbench 1000000 process 1000000.
> > 
> > Could user save his important office data without halt if we kill
> > child continuously?
> > I think this scenario can be happened enough if the user didn't know
> > parameter of hackbench.
> > 
> 
> So what exactly are you proposing we do in the oom killer to distinguish 
> between a user's mistake and a vital system resource?  I'm personally much 
> more concerned with protecting system daemons that provide a service under 
> heavyload than protecting against forkbombs in the oom killer.

I don't opposed that. As I said, I just wanted for OOM killer to be more
smart to catch user's mistake. If I understand your opinion, 
You said, it's not role of OOM killer but scheduler.

Okay. 


-- 
Kind regards,
Minchan Kim


