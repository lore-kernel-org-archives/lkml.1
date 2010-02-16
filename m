Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab0BPItW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 03:49:22 -0500
Received: from smtp-out.google.com ([216.239.33.17]:5782 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909Ab0BPItU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 03:49:20 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=dVyHa8eY70lK1ogEAQHVqI5J1VlJM7HznCsKMKVZ9JyefBhNr0fmN4C2W7URCPiIC
	c6iqWaFEqDj1We+yqYeQA==
Date: Tue, 16 Feb 2010 00:49:14 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nick Piggin <npiggin@suse.de>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 1/7 -mm] oom: filter tasks not sharing the same cpuset
In-Reply-To: <20100216070344.GF5723@laptop>
Message-ID: <alpine.DEB.2.00.1002160047340.17122@chino.kir.corp.google.com>
References: <20100215115154.727B.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1002151401280.26927@chino.kir.corp.google.com> <20100216110859.72C6.A69D9226@jp.fujitsu.com> <20100216070344.GF5723@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010, Nick Piggin wrote:

> Yes we do need to explain the downside of the patch. It is a
> heuristic and we can't call either approach perfect.
> 
> The fact is that even if 2 tasks are on completely disjoint
> memory policies and never _allocate_ from one another's nodes,
> you can still have one task pinning memory of the other task's
> node.
> 
> Most shared and userspace-pinnable resources (pagecache, vfs
> caches and fds files sockes etc) are allocated by first-touch
> basically.
> 
> I don't see much usage of cpusets and oom killer first hand in
> my experience, so I am happy to defer to others when it comes
> to heuristics. Just so long as we are all aware of the full
> story :)
> 

Unless you can present a heuristic that will determine how much memory 
usage a given task has allocated on nodes in current's zonelist, we must 
exclude tasks from cpusets with a disjoint set of nodes, otherwise we 
cannot determine the optimal task to kill.  There's a strong possibility 
that killing a task on a disjoint set of mems will never free memory for 
current, making it a needless kill.  That's a much more serious 
consequence than not having the patch, in my opinion, than rather simply 
killing current.
