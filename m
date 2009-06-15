Return-Path: <linux-kernel-owner+w=401wt.eu-S933049AbZFOTMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933049AbZFOTMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 15:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761282AbZFOTMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 15:12:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755024AbZFOTMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 15:12:33 -0400
Date: Mon, 15 Jun 2009 15:12:23 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: npiggin@suse.de, jblunck@suse.de, linux-kernel@vger.kernel.org,
       paulmck@us.ibm.com
Subject: Re: [PATCH] atomic: Fix _atomic_dec_and_lock() deadlock on UP
Message-ID: <20090615191223.GE352@shell>
References: <20090615181113.GD352@shell> <20090615114543.80c420b3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615114543.80c420b3.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 11:45:43AM -0700, Andrew Morton wrote:
> On Mon, 15 Jun 2009 14:11:13 -0400
> Valerie Aurora <vaurora@redhat.com> wrote:
> 
> > _atomic_dec_and_lock() can deadlock on UP with spinlock debugging
> > enabled.  Currently, on UP we unconditionally spin_lock() first, which
> > calls __spin_lock_debug(), which takes the lock unconditionally even
> > on UP.  This will deadlock in situations in which we call
> > atomic_dec_and_lock() knowing that the counter won't go to zero
> > (because we hold another reference) and that we already hold the lock.
> > Instead, we should use the SMP code path which only takes the lock if
> > necessary.
> 
> Yup, I have this queued for 2.6.31 as
> atomic-only-take-lock-when-the-counter-drops-to-zero-on-up-as-well.patch,
> with a different changelog:
> 
>   _atomic_dec_and_lock() should not unconditionally take the lock before
>   calling atomic_dec_and_test() in the UP case.  For consistency reasons it
>   should behave exactly like in the SMP case.
> 
>   Besides that this works around the problem that with CONFIG_DEBUG_SPINLOCK
>   this spins in __spin_lock_debug() if the lock is already taken even if the
>   counter doesn't drop to 0.
> 
>   Signed-off-by: Jan Blunck <jblunck@suse.de>
>   Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>   Acked-by: Nick Piggin <npiggin@suse.de>
>   Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> 
> I can't remember why we decided that 2.6.30 doesn't need this.

Great, last I heard the changelog was still a problem.  Thanks,

-VAL
