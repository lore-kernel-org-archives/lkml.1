Return-Path: <linux-kernel-owner+w=401wt.eu-S1752993Ab0AGQcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab0AGQcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 11:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096Ab0AGQck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 11:32:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750783Ab0AGQcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 11:32:39 -0500
Date: Thu, 7 Jan 2010 08:31:55 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Christoph Lameter <cl@linux-foundation.org>
cc: Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
In-Reply-To: <alpine.LFD.2.00.1001070814080.7821@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1001070826410.7821@localhost.localdomain>
References: <20100104182429.833180340@chello.nl> <20100104182813.753545361@chello.nl> <20100105054536.44bf8002@infradead.org> <alpine.DEB.2.00.1001050916300.1074@router.home> <20100105192243.1d6b2213@infradead.org> <alpine.DEB.2.00.1001071007210.901@router.home>
 <alpine.LFD.2.00.1001070814080.7821@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Jan 2010, Linus Torvalds wrote:
> 
> (Side note: I wonder if we should wake up _all_ readers when we wake up 
> any. Right now, we wake up all readers - but only until we hit a writer. 
> Which is the _fair_ thing to do, but it does mean that we can end up in 
> horrible patterns of alternating readers/writers, when it could be much 
> better to just say "release the hounds" and let all pending readers go 
> after a writer has had its turn).

Btw, this would still be "mostly fair" in the sense that you couldn't 
starve writers. Any writer on the list is still guaranteed to be woken up 
next, because now it will be at the front of the queue.

So it would be starvation-proof - new readers that come in _after_ we've 
woken up all the old ones would not get to pass the writers. It might be 
interesting to test, if somebody has a problematic threaded workload with 
lots of page faults and allocations mixxed.

			Linus
