Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab0BPIrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 03:47:05 -0500
Received: from smtp-out.google.com ([216.239.44.51]:4154 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249Ab0BPIq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 03:46:59 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Pfzb86ShxyiE2DwuafXz1dj7KRvHaTbHUwFehy+tIobf9ex3Z4dRKseJxcxK2GM60
	oGLAvdTYnMYLPhkWmjdsw==
Date: Tue, 16 Feb 2010 00:46:53 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 1/7 -mm] oom: filter tasks not sharing the same cpuset
In-Reply-To: <20100216110859.72C6.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002160043530.17122@chino.kir.corp.google.com>
References: <20100215115154.727B.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1002151401280.26927@chino.kir.corp.google.com> <20100216110859.72C6.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010, KOSAKI Motohiro wrote:

> > We now determine whether an allocation is constrained by a cpuset by 
> > iterating through the zonelist and checking 
> > cpuset_zone_allowed_softwall().  This checks for the necessary cpuset 
> > restrictions that we need to validate (the GFP_ATOMIC exception is 
> > irrelevant, we don't call into the oom killer for those).  We don't need 
> > to kill outside of its cpuset because we're not guaranteed to find any 
> > memory on those nodes, in fact it allows for needless oom killing if a 
> > task sets all of its threads to have OOM_DISABLE in its own cpuset and 
> > then runs out of memory.  The oom killer would have killed every other 
> > user task on the system even though the offending application can't 
> > allocate there.  That's certainly an undesired result and needs to be 
> > fixed in this manner.
> 
> But this explanation is irrelevant and meaningless. CPUSET can change
> restricted node dynamically. So, the tsk->mempolicy at oom time doesn't
> represent the place of task's usage memory. plus, OOM_DISABLE can 
> always makes undesirable result. it's not special in this case.
> 

It depends whether memory_migrate is set or not when changing a cpuset's 
set of mems.  The point is that we cannot penalize tasks in cpusets with a 
disjoint set of mems because another cpuset is out of memory.  Unless a 
candidate task will definitely free memory on a node that the zonelist 
allows, we should not consider it because it may needlessly kill that 
task, it would be better to kill current.  Otherwise, our badness() 
heuristic cannot possibly determine the optimal task to kill, anyway.
