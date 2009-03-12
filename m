Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbZCLLH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbZCLLH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 07:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbZCLLHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 07:07:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:35479 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbZCLLHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 07:07:14 -0400
Subject: Re: [PATCH 5/6] futex: unlock before returning -EFAULT
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Darren Hart <dvhltc@us.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <alpine.LFD.2.00.0903121142200.29264@localhost.localdomain>
References: <20090312075349.9856.83687.stgit@Aeon>
	 <20090312075606.9856.88729.stgit@Aeon> <1236852816.5090.117.camel@laptop>
	 <alpine.LFD.2.00.0903121142200.29264@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 12:06:57 +0100
Message-Id: <1236856017.5090.235.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-12 at 11:47 +0100, Thomas Gleixner wrote:
> On Thu, 12 Mar 2009, Peter Zijlstra wrote:
> 
> > On Thu, 2009-03-12 at 00:56 -0700, Darren Hart wrote:
> > > futex_lock_pi can potentially return -EFAULT with the rt_mutex held.  This
> > > seems like the wrong thing to do as userspace should assume -EFAULT means the
> > > lock was not taken.  Even if it could figure this out, we'd be leaving the
> > > pi_state->owner in an inconsistent state.  This patch unlocks the rt_mutex
> > > prior to returning -EFAULT to userspace.
> > 
> > lockdep would complain, one is not to leave the kernel with locks held.
> 
> That would break pi futexes in bits and pieces.
> 
>      T1 takes F1
>      T2 blocks on F1
>      	-> T2 sets up rt_mutex and locks it for T1
> 	   T2 blocks on rt_mutex and boosts T1
> 
>      T1 calls a non futex syscall
>      T1 returns from syscall with the rt_mutex still locked
> 
> Thanks,

Oh right, raw rt_mutex stuff isn't lockdep annotated, and you use the
robust futex infrastructure to ensure stuff gets unlocked when holder
dies. That should work out.

