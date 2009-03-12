Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbZCLKtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbZCLKtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755875AbZCLKte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:49:34 -0400
Received: from www.tglx.de ([62.245.132.106]:59915 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859AbZCLKtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:49:33 -0400
Date: Thu, 12 Mar 2009 11:47:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Darren Hart <dvhltc@us.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 5/6] futex: unlock before returning -EFAULT
In-Reply-To: <1236852816.5090.117.camel@laptop>
Message-ID: <alpine.LFD.2.00.0903121142200.29264@localhost.localdomain>
References: <20090312075349.9856.83687.stgit@Aeon>  <20090312075606.9856.88729.stgit@Aeon> <1236852816.5090.117.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009, Peter Zijlstra wrote:

> On Thu, 2009-03-12 at 00:56 -0700, Darren Hart wrote:
> > futex_lock_pi can potentially return -EFAULT with the rt_mutex held.  This
> > seems like the wrong thing to do as userspace should assume -EFAULT means the
> > lock was not taken.  Even if it could figure this out, we'd be leaving the
> > pi_state->owner in an inconsistent state.  This patch unlocks the rt_mutex
> > prior to returning -EFAULT to userspace.
> 
> lockdep would complain, one is not to leave the kernel with locks held.

That would break pi futexes in bits and pieces.

     T1 takes F1
     T2 blocks on F1
     	-> T2 sets up rt_mutex and locks it for T1
	   T2 blocks on rt_mutex and boosts T1

     T1 calls a non futex syscall
     T1 returns from syscall with the rt_mutex still locked

Thanks,

	tglx
   
