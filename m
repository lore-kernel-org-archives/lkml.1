Return-Path: <linux-kernel-owner+w=401wt.eu-S2993079AbXDSArG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993079AbXDSArG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 20:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993081AbXDSArG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 20:47:06 -0400
Received: from ozlabs.org ([203.10.76.45]:36174 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993079AbXDSArF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 20:47:05 -0400
Subject: Re: [Patch -mm 3/3] RFC: Introduce kobject->owner for refcounting.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Greg KH <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>
In-Reply-To: <Pine.LNX.4.44L0.0704181110510.12246-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0704181110510.12246-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Thu, 19 Apr 2007 10:46:41 +1000
Message-Id: <1176943601.5940.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-18 at 11:20 -0400, Alan Stern wrote:
> On Wed, 18 Apr 2007, Rusty Russell wrote:
> 
> > Hi Alan,
> > 
> > 	Your assertion is correct.  I haven't studied the driver core, so I
> > might be off-base here, but you'll note that if the module references
> > the core kmalloc'ed object rather than the other way around it can be
> > done safely.  The core can also reference the module, but it must be
> > able to live without it once it's gone (eg. by returning -ENOENT).
> 
> "Live without it once it's gone..."  Do you mean once the object is gone 
> or once the module is gone?  The core in general has no way to know when 
> the module is gone; all it knows about is the object.  The trouble arises 
> when the module is gone (whether the core knows it or not) but the object 
> is still present.

Hi Alan,

	I meant that the module is gone: it has told the object (via
unregister_xxx) that it's gone.

> > A really poor example is below:
...
> The example is fine as far as it goes, but it assumes that all
> interactions with the underlying r->foo object can be done under a
> spinlock.  Of course this isn't true in general.

There are certainly other ways of doing it, such as a mutex, a refcnt &
completion (for function pointers), or disabling preemption across the
access and using stop_machine().  Of course, these add complexity.

This is the reason that I've always disliked module removal.  We have a
lot of code to deal with it and it has awkward semantics (unless --wait
is used).  OTOH, I'm not a fan of the network approach, either: I feel
that bringing up an interface should bump the refcnt of the module which
implements that interface.  Currently taking out e1000 will just kill my
eth0.

Cheers,
Rusty.







> 
> Alan Stern

