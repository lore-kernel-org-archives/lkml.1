Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab0BAIak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 03:30:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58028 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754242Ab0BAIab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 03:30:31 -0500
Date: Mon, 1 Feb 2010 18:25:06 +1100
From: Nick Piggin <npiggin@suse.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [patch 1/3] Create spin lock/spin unlock with distinct memory
 barrier
Message-ID: <20100201072506.GF9085@laptop>
References: <20100131205254.407214951@polymtl.ca>
 <20100131210013.265317204@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100131210013.265317204@polymtl.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 31, 2010 at 03:52:55PM -0500, Mathieu Desnoyers wrote:
> Create the primitive family:
> 
> spin_lock__no_acquire
> spin_unlock__no_release
> spin_lock_irq__no_acquire
> spin_unlock_irq__no_release
> 
> raw_spin_lock__no_acquire
> raw_spin_unlock__no_release
> raw_spin_lock_irq__no_acquire
> raw_spin_unlock_irq__no_release
> 
> smp_acquire__after_spin_lock()
> smp_release__before_spin_unlock()
> smp_mb__after_spin_lock()
> smp_mb__before_spin_unlock()

Wow, someone who likes micro optimising things as much as I do.
However, these have the wrong names.

smp_mb__after_x() means that calling that function after calling x()
will give a smp_mb(), right?

With your functions, this is giving a smp_mb() after calling
x__no_acquire().

I would suggest maybe just don't bother with the __no_acquire
__no_release variants of spin locks, and stick with the expected
semantics for the new smb_mb__xxx functions. x86 still gets the
full benefit.

But, I don't know if this is even worthwhile, given where you are
using it.

