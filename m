Return-Path: <linux-kernel-owner+w=401wt.eu-S1031306AbXDQXzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031306AbXDQXzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 19:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031309AbXDQXzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 19:55:38 -0400
Received: from ozlabs.org ([203.10.76.45]:59673 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031306AbXDQXzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 19:55:37 -0400
Subject: Re: [Patch -mm 3/3] RFC: Introduce kobject->owner for refcounting.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Greg KH <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>
In-Reply-To: <Pine.LNX.4.44L0.0704171159360.20368-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0704171159360.20368-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Wed, 18 Apr 2007 09:55:34 +1000
Message-Id: <1176854134.14322.308.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-17 at 12:08 -0400, Alan Stern wrote:
> More specifically, there _is_ no way in general to ensure that a reference
> will go away when the module's cleanup routine is called, unless you are
> very careful not to pass that reference on to _anybody_.  The driver core
> certainly can't do this; it passes a device reference to anyone who
> creates a child of that device (the parent pointer) -- and it can't 
> guarantee that every one of its clients will drop their references when 
> their exit routines run.

Hi Alan,

	Your assertion is correct.  I haven't studied the driver core, so I
might be off-base here, but you'll note that if the module references
the core kmalloc'ed object rather than the other way around it can be
done safely.  The core can also reference the module, but it must be
able to live without it once it's gone (eg. by returning -ENOENT).

A really poor example is below:

int register_foo(struct foo *foo)
{
	struct registered_foo *r = kmalloc(...);
	if (!r)
		return -ENOMEM;
	r->foo = foo;
	atomic_set(&r->refcnt, 1);
	spin_lock(&foo_lock);
	list_add(&foos, &r->list);
	spin_unlock(&foo_lock);
	return 0;
}

void unregister_foo(struct foo *foo)
{
	struct registered_foo *i, *found = NULL;
	spin_lock(&foo_lock);
	list_for_each_entry(i, &foos, list) {
		if (i->foo == foo) {
			i->foo = NULL;
			if (atomic_dec_and_test(&i->refcnt))
				kfree(i);
			break;
		}
	}
	spin_unlock(&foo_lock);
}

int get_foo_value(struct registered_foo *r)
{
	u32 val = -ENOENT;
	spin_lock(&foo_lock);
	if (r->foo)
		val = r->foo->val;
	spin_unlock(&foo_lock);
	return val;
}

> I'm not so sure I fully believe that network drivers can do what Rusty
> says, at least not in every circumstance.  There simply are too many
> possible ways for references to linger on after you thought they were all
> gone.  For example, what happens when the user has mounted a filesystem on
> a USB drive running via USB-over-TCP though a network interface?

That's actually fine, it's when packets linger in the system holding
references to the interface they came from that things get tricky.
Hence the networking code tries not to do that.

Cheers,
Rusty.

