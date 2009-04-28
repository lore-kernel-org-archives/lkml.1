Return-Path: <linux-kernel-owner+w=401wt.eu-S1760288AbZD1NBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760288AbZD1NBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 09:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758487AbZD1NAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 09:00:48 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36510 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759970AbZD1NAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 09:00:47 -0400
Date: Tue, 28 Apr 2009 06:00:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       torvalds@osdl.org, Andrew Morton <akpm@linux-foundation.org>,
       serue@us.ibm.com, viro@zeniv.linux.org.uk,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] It may not be assumed that wake_up(), finish_wait()
	and co. imply a memory barrier
Message-ID: <20090428130014.GC6840@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com> <14561.1239873018@redhat.com> <21239.1240407420@redhat.com> <5591.1240417398@redhat.com> <21209.1240504344@redhat.com> <26028.1240573601@redhat.com> <27891.1240595286@redhat.com> <13379.1240913931@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13379.1240913931@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 11:18:51AM +0100, David Howells wrote:
> Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > But I would strongly suggest at least a note calling this out, preferably a
> > "don't do this" example.
> 
> How about I add this to the bottom of the new section:
> 
> [!] Note that the memory barriers implied by the sleeper and the waker do _not_
> order multiple stores before the wake-up with respect to loads of those stored
> values after the sleeper has called set_current_state().  For instance, if the
> sleeper does:
> 
> 	set_current_state(TASK_INTERRUPTIBLE);
> 	if (event_indicated)
> 		break;
> 	__set_current_state(TASK_RUNNING);
> 	do_something(my_data);
> 
> and the waker does:
> 
> 	my_data = value;
> 	event_indicated = 1;
> 	wake_up(&event_wait_queue);
> 
> there's no guarantee that the change to event_indicated will be perceived by
> the sleeper as coming after the change to my_data.  In such a circumstance, the
> code on both sides must interpolate its own memory barriers between the
> separate data accesses.  Thus the above sleeper ought to do:
> 
> 	set_current_state(TASK_INTERRUPTIBLE);
> 	if (event_indicated) {
> 		smp_rmb();
> 		do_something(my_data);
> 	}
> 
> and the waker should do:
> 
> 	my_data = value;
> 	smp_wmb();
> 	event_indicated = 1;
> 	wake_up(&event_wait_queue);

Looks good to me!

							Thanx, Paul
