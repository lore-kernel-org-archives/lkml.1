Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534Ab0AEITJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab0AEITJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 03:19:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515Ab0AEITG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 03:19:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:35329 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab0AEITF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 03:19:05 -0500
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.1001042052210.3630@localhost.localdomain>
References: <20100104182429.833180340@chello.nl>
	 <20100104182813.753545361@chello.nl>
	 <20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com>
	 <28c262361001042029w4b95f226lf54a3ed6a4291a3b@mail.gmail.com>
	 <20100105134357.4bfb4951.kamezawa.hiroyu@jp.fujitsu.com>
	 <alpine.LFD.2.00.1001042052210.3630@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jan 2010 09:18:16 +0100
Message-ID: <1262679496.2400.14.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-04 at 21:10 -0800, Linus Torvalds wrote:
> Sounds doable. But it also sounds way more expensive than the current VM 
> fault handling, which is pretty close to optimal for single-threaded 
> cases.. That RCU lookup might be cheap, but just the refcount is generally 
> going to be as expensive as a lock. 

Right, that refcount adds two atomic ops, the only grace it has is that
its in the vma as opposed to the mm, but there are plenty workloads that
concentrate on a single vma, in which case you get an equally contended
cacheline as with the mmap_sem.

I was trying to avoid having to have that refcount, but then sorta
forgot about the actual fault handlers also poking at the vma :/

