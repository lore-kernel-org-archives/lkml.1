Return-Path: <linux-kernel-owner+w=401wt.eu-S1030687AbXDPOnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030687AbXDPOnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 10:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030690AbXDPOnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 10:43:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56992 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030687AbXDPOnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 10:43:04 -0400
Date: Mon, 16 Apr 2007 10:43:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Tejun Heo <htejun@gmail.com>,
       Markus Rechberger <markus.rechberger@amd.com>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: How should an exit routine wait for release() callbacks?
In-Reply-To: <20070416105316.0b91c2fd@gondolin.boeblingen.de.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0704161028330.4861-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2007, Cornelia Huck wrote:

> On Fri, 13 Apr 2007 11:24:58 -0400 (EDT),
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > I have to admit, this is a puzzler.  I'm beginning to think there should 
> > be two types of module references: Those which (like module dependency) 
> > will prevent rmmod from running, and those which (like the one here) would 
> > automatically be dropped by deregistration.  Then every kobject could have 
> > an owner and could hold a reference of the second type to its owner until 
> > its release routine returns.
> 
> This sounds like the most promising idea yet.
> 
> We could make kobject_add() bump up this second-type refcount (since

Actually it has to be done in kobject_init() since the release method can 
be called any time after that, even if the kobject is never add'ed.

> from now on it may be looked up). kobject_get()/kobject_put() wouldn't
> need to grab an extra reference (we already have refcounting for this
> object in place). kobject_cleanup() could do something like:
> 
> struct module * kobject_owner = kobj->owner;
> ...
> call_release();
> put_second_module_refcount(kobject_owner);
> 
> combined with the module unloading code waiting after calling the exit
> function until the second type refcount dropped to 0. This would make
> sure that the module is not deleted until the last release function has
> been called.
> 
> The module would stay in memory (not be unloaded) until the last
> kobject created by the module is deleted, but I think that is just what
> we want. At least this doesn't mean that the module blocks its own
> unloading.

Yes, that's what I had in mind.

It would have to apply to other things besides kobjects -- in principle,
anything with a release routine, although in many cases it wouldn't be 
needed.  But in particular, it _would_ be needed for struct device.

(In fact, perhaps kobject would not need it.  There aren't too many places
where a raw kobject is used; almost always it is embedded in some larger
object -- like struct device -- along with a release method pointer.  
This larger object would need an owner but its embedded kobject usually
would not.)

On the other hand, this proposal involves adding a fair amount of overhead
(all those .owner fields) for a rather small benefit.  And it involves
modifying a core kernel subsystem (kernel/module.c).  All to prevent
certain unlikely sorts of errors when removing a module -- something which
Linus has said repeatedly need not be supported terribly well.

So I'm uncertain whether other people will be in favor of all this.

Alan Stern

