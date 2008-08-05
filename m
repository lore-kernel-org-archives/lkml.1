Return-Path: <linux-kernel-owner+w=401wt.eu-S1760738AbYHEIg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760738AbYHEIg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 04:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757999AbYHEIf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 04:35:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49443
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757852AbYHEIf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 04:35:56 -0400
Date: Tue, 05 Aug 2008 01:35:56 -0700 (PDT)
Message-Id: <20080805.013556.194909428.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: torvalds@linux-foundation.org, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [RFC][PATCH 3/7] lockdep: re-annotate scheduler runqueues
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080804131011.929471978@chello.nl>
References: <20080804130317.994042639@chello.nl>
	<20080804131011.929471978@chello.nl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 04 Aug 2008 15:03:20 +0200

> Instead of using a per-rq lock class, use the regular nesting operations.
> 
> However, take extra care with double_lock_balance() as it can release the
> already held rq->lock (and therefore change its nesting class).
> 
> So what can happen is:
> 
>  spin_lock(rq->lock);	// this rq subclass 0
> 
>  double_lock_balance(rq, other_rq);
>    // release rq
>    // acquire other_rq->lock subclass 0
>    // acquire rq->lock subclass 1
> 
>  spin_unlock(other_rq->lock);
> 
> leaving you with rq->lock in subclass 1
> 
> So a subsequent double_lock_balance() call can try to nest a subclass 1
> lock while already holding a subclass 1 lock.
> 
> Fix this by introducing double_unlock_balance() which releases the other
> rq's lock, but also re-sets the subclass for this rq's lock to 0.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: David S. Miller <davem@davemloft.net>

I also tested this on 64-cpu and 128-cpu systems.
