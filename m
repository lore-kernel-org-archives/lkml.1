Return-Path: <linux-kernel-owner+w=401wt.eu-S1760797AbYHDSyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760797AbYHDSyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 14:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758869AbYHDSyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 14:54:21 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:58806 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760577AbYHDSyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 14:54:19 -0400
Subject: Re: [RFC][PATCH 7/7] lockdep: spin_lock_nest_lock()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, hugh@veritas.com, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
In-Reply-To: <48974512.7000206@goop.org>
References: <20080804130317.994042639@chello.nl>
	 <20080804131012.246115111@chello.nl>  <48974512.7000206@goop.org>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 20:54:06 +0200
Message-Id: <1217876046.3589.61.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 11:06 -0700, Jeremy Fitzhardinge wrote:
> Peter Zijlstra wrote:
> > Expose the new lock protection lock.
> >
> > This can be used to annotate places where we take multiple locks of the
> > same class and avoid deadlocks by always taking another (top-level) lock
> > first.
> >   
> 
> OK, so the expected usage is:
> 
> 	spin_lock(&outer_lock);
> 	/* take in any order */
> 	spin_lock_nest_lock(&inner[0], &outer_lock);
> 	spin_lock_nest_lock(&inner[2], &outer_lock);
> 	spin_lock_nest_lock(&inner[1], &outer_lock);
> 	...
> 
> ?

Yes (there it no requirement that the outer lock is a spinlock_t, just
that it has a ->dep_map member - so: mutex, rwsem and spinlock will do).

> And it's OK to
> 
>    1. take inner locks one at a time without holding the outer lock

Yes

>    2. use plain spin_lock on inner locks when you're taking them one at
>       a time, and

Yes

>    3. release the outer lock before releasing the inner locks

Only if you then release the inner locks in the reverse order you took
them - the nested release code (releasing a lock that is not on the top
of the stack) basically pops and pushes all the locks, the push will
fail if the outer lock is released.

> but it's not OK to try to use different outer locks for a given inner lock.

It doesn't validate this part - as with most lockdep annotations you can
annotate away real deadlocks.


