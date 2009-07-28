Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124AbZG1GJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbZG1GJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 02:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbZG1GJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 02:09:28 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57661 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbZG1GJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 02:09:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] copy over oom_adj value at fork time
Cc: kosaki.motohiro@jp.fujitsu.com, Paul Menage <menage@google.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <alpine.DEB.2.00.0907240227070.32622@chino.kir.corp.google.com>
References: <20090724083802.1E37.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0907240227070.32622@chino.kir.corp.google.com>
Message-Id: <20090728120822.D80C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 28 Jul 2009 15:09:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 24 Jul 2009, KOSAKI Motohiro wrote:
> 
> > > Simply reverting it isn't an option unless you fix the underlying livelock 
> > > problem that my patches originally addressed and no viable alternative has 
> > > been proposed.
> > 
> > I disagree.
> > I agree with old behavior have one bug. but it doesn't provide any regression
> > allowing reason although old behavior is totally suck.
> > 
> 
> I don't understand most of this, sorry.  I think what you're saying is 
> that you don't fix one bug by introducing another.
> 
> The "regression" here is that changing /proc/pid/oom_adj for a vfork'd 
> child would change the oom_adj value of the parent as well.  That is 
> actually the behavior that leads to the livelock where the oom killer 
> would repeatedly select a child and it could not be killed because it 
> shares memory with an OOM_DISABLE parent.  That would cause the oom killer 
> to be called by the page allocator infinitely without ever freeing memory.

Actually, if we assume the administrator is really stupid, he can mark
all processes as OOM_DISABLE. it makes livelock anyway.
ITOH, we never seen this livelock on vfork()ed application.

More important thing is: Documentation/filesysmtem/proc/txt says
oom_adj is process property and vfork()ed parent and child are definitelly
another process.





> That behavior is unacceptable, so I disagree that reverting my patches is 
> an option.
> 
> I suggested a workaround by introducing /proc/pid/oom_adj_child which 
> applications would need to use instead of oom_adj after vfork() and prior 
> to execve() (if such open source applications exist in the first place).
> 
> > Not solve. "please rewrite your application" isn't good solution.
> > 
> 
> They'd need to use the new interface because the old behavior would lead 
> to a kernel livelock because it allowed tasks sharing memory to be 
> oom disabled and enabled at the same time.  That seems like a very good 
> reason to fix the application, otherwise it may livelock the kernel if its 
> ooms before exec.  The behavior you're defending is the SOURCE of the 
> livelock.
> 
> > Hm...
> > This is just idea, Does moving oom_adj from mm_struct to signal_struct solve
> > this problem?
> > I mean vfork() share mm_struct, but doesn't share signal_struct.
> > 
> 
> oom_adj values are not a characteristic of signals, they are a trait of 
> memory.  They specify how the oom killer should favor (or disable) amounts 
> of memory in oom conditions.

That's ok. nobody think struct signal is signal related structure. almost member are
signal unrelated already.



