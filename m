Return-Path: <linux-kernel-owner+w=401wt.eu-S1753564Ab0ADQDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab0ADQDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 11:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552Ab0ADQDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 11:03:52 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50451 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab0ADQDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 11:03:52 -0500
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
In-Reply-To: <20100104155559.GA6748@linux.vnet.ibm.com>
References: <20091225105140.263180e8.kamezawa.hiroyu@jp.fujitsu.com>
	 <1261915391.15854.31.camel@laptop>
	 <20091228093606.9f2e666c.kamezawa.hiroyu@jp.fujitsu.com>
	 <1261989047.7135.3.camel@laptop>
	 <27db4d47e5a95e7a85942c0278892467.squirrel@webmail-b.css.fujitsu.com>
	 <1261996258.7135.67.camel@laptop> <1261996841.7135.69.camel@laptop>
	 <1262448844.6408.93.camel@laptop>
	 <20100104030234.GF32568@linux.vnet.ibm.com>
	 <1262591604.4375.4075.camel@twins>
	 <20100104155559.GA6748@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jan 2010 17:02:54 +0100
Message-ID: <1262620974.6408.169.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-04 at 07:55 -0800, Paul E. McKenney wrote:
> > Well, I was thinking srcu to have this force quiescent state in
> > call_srcu() much like you did for the preemptible rcu.
> 
> Ah, so the idea would be that you register a function with the srcu_struct
> that is invoked when some readers are stuck for too long in their SRCU
> read-side critical sections?  Presumably you also supply a time value for
> "too long" as well.  Hmmm...  What do you do, cancel the corresponding
> I/O or something? 

Hmm, I was more thinking along the lines of:

say IDX is the current counter idx.

if (pending > thresh) {
  flush(!IDX)
  force_flip_counter();
}

Since we explicitly hold a reference on IDX, we can actually wait for !
IDX to reach 0 and flush those callbacks.

We then force-flip the counter, so that even if all callbacks (or the
majority) were not for !IDX but part of IDX, we'd be able to flush them
on the next call_srcu() because that will then hold a ref on the new
counter index.


Or am I missing something obvious?

