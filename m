Return-Path: <linux-kernel-owner+w=401wt.eu-S1031119AbXDQQIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031119AbXDQQIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 12:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031120AbXDQQIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 12:08:48 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33309 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1031119AbXDQQIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 12:08:47 -0400
Date: Tue, 17 Apr 2007 12:08:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Rusty Russell <rusty@rustcorp.com.au>, Greg KH <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [Patch -mm 3/3] RFC: Introduce kobject->owner for refcounting.
In-Reply-To: <20070417091624.63436fc3@gondolin.boeblingen.de.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0704171159360.20368-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007, Cornelia Huck wrote:

> On Tue, 17 Apr 2007 12:53:10 +1000,
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > On Mon, 2007-04-16 at 15:53 -0400, Alan Stern wrote:
> > > The fundamental rule is that whenever you hand out a pointer to a routine
> > > living in a module, the receiver has to increment the module's refcount.  
> > > But the driver core violates this rule all over the place.
> > 
> > Hi Alan,
> > 
> > 	Your rule is overly simplistic, unfortunately.  You have two choices:
> > take a reference count, *or* ensure that the reference will go away when
> > the module's cleanup routine is called.  Network drivers are a classic
> > example of the latter.
> 
> Hm, but that's exactly the problem we face here. There is no race-free
> way (at least, nobody could think about one yet) to make sure all
> references are freed at exit time and simultaneously to make sure that
> the release functions have finished before the module has been deleted.

More specifically, there _is_ no way in general to ensure that a reference
will go away when the module's cleanup routine is called, unless you are
very careful not to pass that reference on to _anybody_.  The driver core
certainly can't do this; it passes a device reference to anyone who
creates a child of that device (the parent pointer) -- and it can't 
guarantee that every one of its clients will drop their references when 
their exit routines run.

I'm not so sure I fully believe that network drivers can do what Rusty
says, at least not in every circumstance.  There simply are too many
possible ways for references to linger on after you thought they were all
gone.  For example, what happens when the user has mounted a filesystem on
a USB drive running via USB-over-TCP though a network interface?

Alan Stern

