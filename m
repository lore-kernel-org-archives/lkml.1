Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbZCTP5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbZCTP5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 11:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbZCTP5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 11:57:34 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60886 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbZCTP5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 11:57:34 -0400
Date: Fri, 20 Mar 2009 08:57:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Avi Kivity <avi@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Question about x86/mm/gup.c's use of disabled interrupts
Message-ID: <20090320155730.GD6698@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <49C148AF.5050601@goop.org> <200903191232.05459.nickpiggin@yahoo.com.au> <49C2818B.9060201@goop.org> <20090320044029.GD6807@linux.vnet.ibm.com> <49C3B886.8080408@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C3B886.8080408@goop.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 08:38:46AM -0700, Jeremy Fitzhardinge wrote:
> Paul E. McKenney wrote:
>>> Ah, interesting.  So disabling interrupts prevents the RCU free from 
>>> happening, and non-atomic pte fetching is a non-issue.  So it doesn't 
>>> address the PAE side of the problem.
>>
>> This would be rcu_sched, correct?
>
> I guess?  Whatever it is that ends up calling all the rcu callbacks after 
> the idle.  A cpu with disabled interrupts can't go through idle, right?  Or 
> is there an explicit way to hold off rcu?

For synchronize_rcu() and call_rcu(), the only guaranteed way to hold
off RCU is rcu_read_lock() and rcu_read_unlock().

For call_rcu_bh, the only guaranteed way to hold off RCU is
rcu_read_lock_bh() and rcu_read_unlock_bh().

For synchronize_srcu(), the only guaranteed way to hold off RCU is
srcu_read_lock() and srcu_read_unlock().

For synchronize_sched() and call_rcu_sched(), anything that disables
preemption, including disabling irqs, holds off RCU.

Although disabling irqs can indeed hold off RCU in some other cases,
the only guarantee is for synchronize_sched() and call_rcu_sched().

							Thanx, Paul
