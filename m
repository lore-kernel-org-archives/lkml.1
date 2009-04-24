Return-Path: <linux-kernel-owner+w=401wt.eu-S1760163AbZDXSfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760163AbZDXSfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 14:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756187AbZDXSfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 14:35:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42227 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbZDXSfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 14:35:36 -0400
Date: Fri, 24 Apr 2009 20:30:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, torvalds@osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, serue@us.ibm.com,
       viro@zeniv.linux.org.uk,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] It may not be assumed that wake_up(), finish_wait()
	and co. imply a memory barrier
Message-ID: <20090424183029.GA16717@redhat.com>
References: <32260.1239658818@redhat.com> <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com> <14561.1239873018@redhat.com> <21239.1240407420@redhat.com> <5591.1240417398@redhat.com> <21209.1240504344@redhat.com> <26028.1240573601@redhat.com> <27944.1240595625@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27944.1240595625@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Suppose that "event_indicated = 1" leaks into try_to_wake_up() after we
> > read p->state.
>
> In that case, it's entirely possible that the smp_wmb() in try_to_wake_up()
> should actually be an smp_mb(), but that on whichever arch patch:
>
> 	commit 04e2f1741d235ba599037734878d72e57cb302b5
> 	Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
> 	Date:   Sat Feb 23 18:05:03 2008 -0800
> 	Subject: Add memory barrier semantics to wake_up() & co
>
> was tested on, it made no difference.

I think that, from the correctness pov, this patch does not depend on arch.
>From the changelog:

    However, adding a smp_wmb() to before the spinlock should now order the
    writing of CONDITION wrt the lock itself, which in turn is ordered wrt
    the accesses within the spinlock (which includes the reading of the old
    state).

IOW, spin_lock() itself is STORE, and has the acquire semantics. This means
that "wmb() + spin_lock()" must correctly serialize "STOREs bfore" and
"STOREs/LOADs after". At least this is my understanding.


But does it really "equal" to mb() on all arches ? I don't know, but I guess
it is not possible to derive from documentation. So, at least in theory,
try_to_wake_up() doesn't provide rmb() afaics, and

	LOAD_1;
	try_to_wake_up();
	LOAD_2;

this can be re-ordered.


But I know nothing about how mb/lock _actually_ play with hardware, even on
x86.

Oleg.

