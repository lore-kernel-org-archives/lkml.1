Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbYDRO1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbYDRO1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 10:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYDRO1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 10:27:07 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34664 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751873AbYDRO1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 10:27:06 -0400
Date: Fri, 18 Apr 2008 10:27:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: Semphore -> mutex in the device tree
In-Reply-To: <1208500372.7115.52.camel@twins>
Message-ID: <Pine.LNX.4.44L0.0804181014170.5443-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008, Peter Zijlstra wrote:

> > Even so there is a potential for trouble.  I don't know of any concrete
> > examples like this in the kernel, but they might exist.  Suppose a
> > driver keeps a private mutex associated with each device it manages.  
> > Normally the device's lock would be acquired first and the private
> > mutex second.  But there could be places where the driver acquires a
> > child device's lock while holding the parent's mutex; this would look
> > to lockdep like a violation.
> 
> So lockdep cares about classes and the hierarchy of thereof; so given
> your example:
> 
>    parent_tree_level
>      child_tree_level
>        device_lock
> 
> Its perfectly fine to take a lock from 'parent_tree_level' and then a
> lock from 'device_lock', skipping the class in the middle - as long as
> you thereafter never acquire a lock from it.
> 
> So given a pre-determined class hierarchy, you're not required to take
> all locks in that hierarchy; as long as you always go down. If you ever
> take a lock so that moves up in the hierarchy you're in trouble.

We must be talking at cross purposes.  Are classes and subclasses all 
that lockdep looks at?

Let's take a simpler example.  Suppose driver D's probe routine 
registers a child device.  Then we have:

	Subsystem:		Register device A with driver core

	Driver core:		Lock device A with NESTING_PARENT
				Call D:probe()

	D:probe():		Register device B with driver core
				as a child of A

	Driver core:		Lock device B with NESTING_PARENT
				Call E:probe()

(where E is the appropriate driver for B).  Is this a lockdep 
violation?  Both A and B are locked with the same nesting level, 
because they are locked by the same code in the driver core, but 
one is the parent of the other in the device tree.


Or maybe I misunderstood, and you're proposing to use a node's level in
the tree as its lockdep nesting level.  In that case, consider this
example.  Suppose driver D associates a private mutex M with each of
its devices.  Suppose D is managing device A at level 4 and device B at
level 5.  Then we might have:

	D:		Lock device B at level 5
	D:		Lock B's associated M

(which tells lockdep that M comes after level 5), together with

	D:		Lock device A at level 4
	D:		Lock A's associated M
	D:		Lock A's child at level 5

Won't this then be a lockdep violation (since M is now locked before a
device at level 5)?

Alan Stern

