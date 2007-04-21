Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbXDUVgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbXDUVgz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 17:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbXDUVgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 17:36:55 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4934 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753071AbXDUVgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 17:36:55 -0400
Date: Sat, 21 Apr 2007 17:36:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <greg@kroah.com>
cc: Tejun Heo <htejun@gmail.com>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
In-Reply-To: <20070421000340.GB12155@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0704211654080.12439-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, Greg KH wrote:

> > Greg, do you know of anything in particular that depends on a kobjects not 
> > being released before their children are released?
> 
> Yes, the whole driver model :)

But anything in particular?  Looking through the source code, I see 
kobj->parent gets used mainly by kobject_get_path() and not by much else.

Looking some more, kobject_get_path() is used for kobject renaming,
uevent handling, and a little bit in the input core.  None of these things 
should try to access a kobject after it has been del()ed.  After all, it's 
no longer present in the filesystem so it doesn't _have_ a path.

So I don't see any immediate problem.  A quick boot with my patch applied,
during which I installed and removed various modules and hot-pluggable
devices, didn't cause anything strange to happen.

> When adding a new device, we always grab a reference to the parent
> device so it can not go away before we do.
> 
> Look at the last kobject_put(parent); in kobject_cleanup() which ensures
> this.

Yes, I know.  The question is: What (if anything) is wrong with the parent
going away first?  So long as the parent remains present while the child
is _registered_, who will care if the parent is deallocated after the
child is unregistered but before it is released?

And if there is any code which does care, don't you think we should be
able to change it so that it doesn't?


> Ick, no, I think this used to be the way things worked, but bad things
> would end up happening, so we fixed it up to be the way things are
> today.  Read the comments for the changelog for this file for details.
> 
> Specifically, look at commit 10921a8f1305b8ec97794941db78b825db5839bc
> in the history.git repo which is almost exactly what you are proposing
> to be reverted...

Yes, it is.  I had a little trouble finding it; the search facility in the
gitweb system at git.kernel.org doesn't seem to work right.  Who should
I complain to about that?

Anyway, the patch itself is available at

	http://marc.info/?l=linux-kernel&m=107116644617624&w=2

Here's what the changelog comment says:

	It fixes a kobject bug where the parent could be deleted before the
	child object, causing all sorts of badness later when we clean up the
	child object.  It's been acked by Pat.

Not terribly explicit.  As far as I can tell, cleaning up the child object
doesn't do much except to kfree() a few items and call the ktype's
release() routine.  For a struct device, the release() routine merely
calls dev->release(), or dev->type->release(), or
dev->class->dev_release() as the case may be.  None of these should try to
access the device's parent unless they made special arrangements to
acquire a reference to it beforehand.  Which is what we're trying to
eliminate -- that's what immediate detach means.

The change was made back in December 2003, for 2.6.0-test11.  Since then
the driver-model core and its users have evolved an awful lot.  Perhaps
reverting it now won't hurt anything.

Alan Stern

