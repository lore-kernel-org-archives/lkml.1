Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532AbYKJSpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbYKJSpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 13:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbYKJSpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 13:45:23 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37035 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836AbYKJSpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 13:45:22 -0500
Date: Mon, 10 Nov 2008 10:45:20 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcupdate: move synchronize_sched() back to rcupdate.c
	V2
Message-ID: <20081110184520.GC6685@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <49129310.5000903@cn.fujitsu.com> <20081109005159.GM6917@linux.vnet.ibm.com> <4917A8E7.8060801@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4917A8E7.8060801@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 11:22:15AM +0800, Lai Jiangshan wrote:
> Paul E. McKenney wrote:
> > On Thu, Nov 06, 2008 at 02:47:44PM +0800, Lai Jiangshan wrote:
> >> this fix remove ugly macro, and increase readability for rcupdate codes
> >>
> >> changed from v1:
> >> use HAVE_SPECIAL_RCU_BH/SCHED instead of define duplicate version of
> >> synchronize_sched().
> > 
> > Hello, Jiangshan!
> > 
> > I very much like getting rid of the ugly macro.  I of course like the
> > kernel-doc fixes.  ;-)
> > 
> > I am not yet convinced of the HAVE_SPECIAL_RCU_BH and
> > HAVE_SPECIAL_RCU_SCHED pieces.  It is not clear to me that this approach
> > is simpler than the current approach of simply providing the appropriate
> > definitions for the symbols in the implementation-specific rcuxxx.h
> > file.
> > 
> > Am I missing something?
> > 
> > 							Thanx, Paul
> > 
> 
> I think:
> 
> RCU_BH is not required, we can used RCU instead. so HAVE_SPECIAL_RCU_BH
> will help for implementation which has not RCU_BH.
> 
> HAVE_SPECIAL_RCU_SCHED is a little different, RCU and RCU_SCHED are both
> required for the kernel. But I think, in an implementation,
> if rcu_read_lock_sched() implies rcu_read_lock(), we may not need implement
> RCU_SCHED too(sometimes we may implement RCU_SCHED for performance).
> so HAVE_SPECIAL_RCU_SCHED will help.

If I understand correctly, this is the "old way":

------------------------------------------------------------------------

rcupdate.h:

#define rcu_read_lock_bh() __rcu_read_lock_bh()
#define rcu_read_unlock_bh() __rcu_read_unlock_bh()

rcupreempt.h:

#define __rcu_read_lock_bh()    { rcu_read_lock(); local_bh_disable(); }
#define __rcu_read_unlock_bh()  { local_bh_enable(); rcu_read_unlock(); }

------------------------------------------------------------------------

And then this is the "new way":

------------------------------------------------------------------------

rcupdate.h:

#ifdef HAVE_SPECIAL_RCU_BH
#define rcu_read_lock_bh() __rcu_read_lock_bh()
#define rcu_read_unlock_bh() __rcu_read_unlock_bh()
#else
#define __rcu_read_lock_bh()    { rcu_read_lock(); local_bh_disable(); }
#define __rcu_read_unlock_bh()  { local_bh_enable(); rcu_read_unlock(); }
#endif /* HAVE_SPECIAL_RCU_BH */

rcupreempt.h:

#define HAVE_SPECIAL_RCU_BH

------------------------------------------------------------------------

If we had ten different RCU implementations, then the "new way" would save
a little bit of code.  But the "old way" is a bit easier to figure out.

So I am in favor of getting rid of the ugly macro, and also in favor
of fixing the kerneldoc, but opposed to the HAVE_SPECIAL_RCU_BH and
HAVE_SPECIAL_RCU_SCHED changes.

Or am I missing something?

							Thanx, Paul
