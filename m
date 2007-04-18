Return-Path: <linux-kernel-owner+w=401wt.eu-S2992758AbXDRPUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992758AbXDRPUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 11:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992763AbXDRPUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 11:20:07 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49661 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S2992758AbXDRPUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 11:20:06 -0400
Date: Wed, 18 Apr 2007 11:20:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Greg KH <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [Patch -mm 3/3] RFC: Introduce kobject->owner for refcounting.
In-Reply-To: <1176854134.14322.308.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0704181110510.12246-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007, Rusty Russell wrote:

> Hi Alan,
> 
> 	Your assertion is correct.  I haven't studied the driver core, so I
> might be off-base here, but you'll note that if the module references
> the core kmalloc'ed object rather than the other way around it can be
> done safely.  The core can also reference the module, but it must be
> able to live without it once it's gone (eg. by returning -ENOENT).

"Live without it once it's gone..."  Do you mean once the object is gone 
or once the module is gone?  The core in general has no way to know when 
the module is gone; all it knows about is the object.  The trouble arises 
when the module is gone (whether the core knows it or not) but the object 
is still present.

> A really poor example is below:
> 
> int register_foo(struct foo *foo)
> {
> 	struct registered_foo *r = kmalloc(...);
> 	if (!r)
> 		return -ENOMEM;
> 	r->foo = foo;
> 	atomic_set(&r->refcnt, 1);
> 	spin_lock(&foo_lock);
> 	list_add(&foos, &r->list);
> 	spin_unlock(&foo_lock);
> 	return 0;
> }
> 
> void unregister_foo(struct foo *foo)
> {
> 	struct registered_foo *i, *found = NULL;
> 	spin_lock(&foo_lock);
> 	list_for_each_entry(i, &foos, list) {
> 		if (i->foo == foo) {
> 			i->foo = NULL;
> 			if (atomic_dec_and_test(&i->refcnt))
> 				kfree(i);
> 			break;
> 		}
> 	}
> 	spin_unlock(&foo_lock);
> }
> 
> int get_foo_value(struct registered_foo *r)
> {
> 	u32 val = -ENOENT;
> 	spin_lock(&foo_lock);
> 	if (r->foo)
> 		val = r->foo->val;
> 	spin_unlock(&foo_lock);
> 	return val;
> }

The example is fine as far as it goes, but it assumes that all
interactions with the underlying r->foo object can be done under a
spinlock.  Of course this isn't true in general.

Alan Stern

