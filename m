Return-Path: <linux-kernel-owner+w=401wt.eu-S1756442AbZLKQfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbZLKQfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 11:35:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbZLKQfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 11:35:18 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38384 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbZLKQfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 11:35:17 -0500
Date: Fri, 11 Dec 2009 08:35:21 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/9] Fix various __task_cred related invalid RCU
	assumptions
Message-ID: <20091211163521.GC6803@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091210001308.247025548@linutronix.de> <13056.1260538746@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13056.1260538746@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 01:39:06PM +0000, David Howells wrote:
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > While auditing the read_lock(&tasklist_lock) sites for a possible
> > conversion to rcu-read_lock() I stumbled over an unprotected user of
> > __task_cred in kernel/sys.c
> 
> I'm sure last time I looked, spinlock primitives implied RCU read locks.
> Maybe I was mistaken or maybe it's changed.  Whatever, good catch, Thomas!

It did indeed change with the split of the old synchronize_kernel()
primitive into the synchronize_rcu() and synchronize_sched() primitives
in 2.6.12 -- after this point, synchronize_rcu() was only guaranteed
to respect "real" rcu_read_lock()-base critical sections.  But actual
failures would not show up until PREEMPT_RCU was introduced into 2.6.25.

The -rt effort rooted out a bunch of these sorts of problems, but we
clearly missed a few.

							Thanx, Paul
