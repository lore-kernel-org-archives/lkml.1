Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbZF1QOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbZF1QOO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbZF1QOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:14:06 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49697 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334AbZF1QOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:14:05 -0400
Date: Sun, 28 Jun 2009 09:14:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: array of pointers with rcu
Message-ID: <20090628161411.GE7070@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090628132223.GA11856@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090628132223.GA11856@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 04:22:24PM +0300, Michael S. Tsirkin wrote:
> Paul,
> I'd like to implement a static array of pointers with rcu.
> (Note that Documentation/RCU/arrayRCU.txt addresses only the case of
> static arrays where the data (rather than a pointer to the data) is
> located in each array element).
> The array is implemented today in kvm as follows:
> 
> struct kvm_io_bus {
>         int                   dev_count;
> #define NR_IOBUS_DEVS 6
>         struct kvm_io_device *devs[NR_IOBUS_DEVS];
> };
> 
> It's easy to use rcu_assign_pointer and
> rcu_dereference to access each value in the array,
> so that's fine.
> 
> However, I also have the dev_count value to handle.
> This value is usually used in loops like this
> 
> for (i = 0; i < bus->dev_count; ++i) {
> 	... uses bus->devs[i] ...
> }

So the count can vary, then.  In other words, someone might change the
value of ->dev_count from (say) 5 to (say) 2, implicitly invalidating
the last three ->devs pointers, correct?

Of course, this implicit invalidation might happen just after you
fetched the value of (say) ->devs[3].  Or just after you fetch the
value of ->dev_count, for that matter.

> I can assign the dev_count value with rcu_assign_pointer and even though
> it is not a pointer I think it should work fine.  However, to access
> dev_count I think that rcu_dereference will not do what I want:
> 
> #define rcu_dereference(p)     ({ \
>                                 typeof(p) _________p1 = ACCESS_ONCE(p);
> \
>                                 smp_read_barrier_depends(); \
>                                 (_________p1); \
>                                 })
> 
> 
> The use of dev_count is not through a dependency so
> smp_read_barrier_depends will not be enough on most architectures.
> 
> So it seems that what I really need is something like:
> #define rcu_read_value(p)     ({ \
>                                 typeof(p) _________p1 = ACCESS_ONCE(p);
> \
>                                 smp_rmb(); \
>                                 (_________p1); \
>                                 })
> 
> And maybe
> #define rcu_assign_value rcu_assign_pointer
> for symmetry.
> 
> Comments?

Hmmm...

What you would really need to do in the above scheme is to make careful
use of memory barriers to order the accesses to ->dev_count and the the
elements of the ->devs[] array.  The usual trick to avoid such memory
barriers it to dynamically allocate the array, but putting the count
into a struct that includes the array, so that readers are guaranteed
to get a value of ->dev_count that matches the ->devs[] array.

Of course, you might have other reasons for the array to be statically
allocated.  In that case, one trick is to statically allocate two
arrays, each with its own ->dev_count.  Then a size-change update will
copy from the current array to the new array, set the value of the new
->dev_count appropriately, and then use rcu_assign_pointer() to cause
new readers to see the updated array.  In short, use the approach
described for resizeable arrays in Documentation/RCU/arrayRCU.txt
even though the physical array stays the same size.

But again given that you only have six elements, why not just scan the
whole array unconditionally, using NULL pointers in the ->devs[] elements
to indicate that the corresponding element is invalid?  Then the normal
rcu_assign_pointer() and rcu_dereference() will work normally.

							Thanx, Paul
