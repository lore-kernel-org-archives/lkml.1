Return-Path: <linux-kernel-owner+w=401wt.eu-S1752237AbZGXJ1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbZGXJ1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 05:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbZGXJ1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 05:27:31 -0400
Received: from smtp-out.google.com ([216.239.33.17]:35368 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbZGXJ1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 05:27:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=HnItOL+p5PcLAUaaor/jPgbD6tdf4dWUhN807375K5vCGv1PhFLXNoYm02ruO+LqQ
	mTcIkm6KTM4um6IH3yHqA==
Date: Fri, 24 Jul 2009 02:27:20 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Paul Menage <menage@google.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] copy over oom_adj value at fork time
In-Reply-To: <20090724083802.1E37.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907240227070.32622@chino.kir.corp.google.com>
References: <20090722233347.776E.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0907231624480.3476@chino.kir.corp.google.com> <20090724083802.1E37.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jul 2009, KOSAKI Motohiro wrote:

> > Simply reverting it isn't an option unless you fix the underlying livelock 
> > problem that my patches originally addressed and no viable alternative has 
> > been proposed.
> 
> I disagree.
> I agree with old behavior have one bug. but it doesn't provide any regression
> allowing reason although old behavior is totally suck.
> 

I don't understand most of this, sorry.  I think what you're saying is 
that you don't fix one bug by introducing another.

The "regression" here is that changing /proc/pid/oom_adj for a vfork'd 
child would change the oom_adj value of the parent as well.  That is 
actually the behavior that leads to the livelock where the oom killer 
would repeatedly select a child and it could not be killed because it 
shares memory with an OOM_DISABLE parent.  That would cause the oom killer 
to be called by the page allocator infinitely without ever freeing memory.

That behavior is unacceptable, so I disagree that reverting my patches is 
an option.

I suggested a workaround by introducing /proc/pid/oom_adj_child which 
applications would need to use instead of oom_adj after vfork() and prior 
to execve() (if such open source applications exist in the first place).

> Not solve. "please rewrite your application" isn't good solution.
> 

They'd need to use the new interface because the old behavior would lead 
to a kernel livelock because it allowed tasks sharing memory to be 
oom disabled and enabled at the same time.  That seems like a very good 
reason to fix the application, otherwise it may livelock the kernel if its 
ooms before exec.  The behavior you're defending is the SOURCE of the 
livelock.

> Hm...
> This is just idea, Does moving oom_adj from mm_struct to signal_struct solve
> this problem?
> I mean vfork() share mm_struct, but doesn't share signal_struct.
> 

oom_adj values are not a characteristic of signals, they are a trait of 
memory.  They specify how the oom killer should favor (or disable) amounts 
of memory in oom conditions.
