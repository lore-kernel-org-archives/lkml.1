Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280Ab0ADHyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab0ADHyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 02:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234Ab0ADHyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 02:54:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:49103 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab0ADHyJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 02:54:09 -0500
Subject: Re: [RFC PATCH] asynchronous page fault.
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org, "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20100104030234.GF32568@linux.vnet.ibm.com>
References: <20091225105140.263180e8.kamezawa.hiroyu@jp.fujitsu.com>
	 <1261915391.15854.31.camel@laptop>
	 <20091228093606.9f2e666c.kamezawa.hiroyu@jp.fujitsu.com>
	 <1261989047.7135.3.camel@laptop>
	 <27db4d47e5a95e7a85942c0278892467.squirrel@webmail-b.css.fujitsu.com>
	 <1261996258.7135.67.camel@laptop> <1261996841.7135.69.camel@laptop>
	 <1262448844.6408.93.camel@laptop>
	 <20100104030234.GF32568@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 04 Jan 2010 08:53:23 +0100
Message-ID: <1262591604.4375.4075.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-03 at 19:02 -0800, Paul E. McKenney wrote:
> It would not be all that hard for me to make a call_srcu(), but...
> 
> 1.      How are you avoiding OOM by SRCU callback?  (I am sure you
>         have this worked out, but I do have to ask!)

Well, I was thinking srcu to have this force quiescent state in
call_srcu() much like you did for the preemptible rcu.

Alternatively we could actively throttle the call_srcu() call when we've
got too much pending work.

> 2.      How many srcu_struct data structures are you envisioning?
>         One globally?  One per process?  One per struct vma?
>         (Not necessary to know this for call_srcu(), but will be needed
>         as I work out how to make SRCU scale with large numbers of CPUs.)

For this patch in particular, one global one, covering all vmas.

One reason to keep the vma RCU domain separate from other RCU objects is
that these VMA thingies can have rather long quiescent periods due to
this sleep stuff. So mixing that in with other RCU users which have much
better defined periods will just degrade everything bringing that OOM
scenario much closer.
