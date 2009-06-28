Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbZF1NXC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbZF1NXC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 09:23:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbZF1NWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 09:22:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41380 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbZF1NWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 09:22:52 -0400
Date: Sun, 28 Jun 2009 16:22:24 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: array of pointers with rcu
Message-ID: <20090628132223.GA11856@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,
I'd like to implement a static array of pointers with rcu.
(Note that Documentation/RCU/arrayRCU.txt addresses only the case of
static arrays where the data (rather than a pointer to the data) is
located in each array element).
The array is implemented today in kvm as follows:

struct kvm_io_bus {
        int                   dev_count;
#define NR_IOBUS_DEVS 6
        struct kvm_io_device *devs[NR_IOBUS_DEVS];
};

It's easy to use rcu_assign_pointer and
rcu_dereference to access each value in the array,
so that's fine.

However, I also have the dev_count value to handle.
This value is usually used in loops like this

for (i = 0; i < bus->dev_count; ++i) {
	... uses bus->devs[i] ...
}

I can assign the dev_count value with rcu_assign_pointer and even though
it is not a pointer I think it should work fine.  However, to access
dev_count I think that rcu_dereference will not do what I want:

#define rcu_dereference(p)     ({ \
                                typeof(p) _________p1 = ACCESS_ONCE(p);
\
                                smp_read_barrier_depends(); \
                                (_________p1); \
                                })


The use of dev_count is not through a dependency so
smp_read_barrier_depends will not be enough on most architectures.

So it seems that what I really need is something like:
#define rcu_read_value(p)     ({ \
                                typeof(p) _________p1 = ACCESS_ONCE(p);
\
                                smp_rmb(); \
                                (_________p1); \
                                })

And maybe
#define rcu_assign_value rcu_assign_pointer
for symmetry.

Comments?

-- 
MST
