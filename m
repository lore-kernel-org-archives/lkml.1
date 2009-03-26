Return-Path: <linux-kernel-owner+w=401wt.eu-S1758363AbZCZOVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363AbZCZOVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 10:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757005AbZCZOV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 10:21:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53923 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757097AbZCZOV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:21:27 -0400
Date: Thu, 26 Mar 2009 10:21:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <htejun@gmail.com>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alex Chiang <achiang@hp.com>,
       <greg@kroah.com>, <cornelia.huck@de.ibm.com>, <kay.sievers@vrfy.org>,
       <rusty@rustcorp.com.au>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] sysfs: allow suicide
In-Reply-To: <49CAF840.2030308@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0903261005530.2945-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009, Tejun Heo wrote:

> > The problem that I see is that we are missing support from the device
> > model for hotunplug.  Running the device remove method from process
> > context is required.  Typically hotplug controllers discover a
> > device has been removed or will be removed in interrupt context.
> > 
> > Therefore every hotplug driver I have looked at has it's own workqueue
> > to solve the problem of getting the notification of a hotplug event
> > from an inappropriate context.
> > 
> > So the general problem that I see is that I need a solution to trigger
> > a remove from interrupt context and that same solution will happen to
> > work just fine for sysfs.
> 
> I think the problem is more driver domain specific and not quite sure
> whether one size would fit all.  We have a lot of drivers in the tree.
> I think the best approach would be trying to move upwards from the
> bottom.  ie. Consolidate hotplug / error handling support from low
> level drivers to specific driver subsystem, from driver subsystems to
> higher layer (ie. block layer) and then see whether there can be more
> commonalities which can be factored, but the chance is that once
> things are pushed upwards enough, moving it into the kobject layer
> probably wouldn't worth the trouble.  Well, it's all speculations at
> this point tho.

It sounds like Eric's point is that sysfs_schedule_callback() is a
special-purpose interface devoted to sysfs, whereas a more generally
useful interface would allow delayed unregistration of any struct
device. (Or perhaps delayed invocation of an arbitrary function with a
struct device as the argument, but unregistration is the single most
important usage.)

The actual interface wouldn't be very different from 
sysfs_schedule_callback().  In fact, the only changes I see offhand are 
that the new routine would accept a pointer to struct device instead of 
a pointer to struct kobject and there wouldn't be any func argument.  

The idea is that this would come in useful both for suicidal sysfs 
attributes and for hot-unplug events detected by an interrupt handler.

But there's something I'm not clear on.  If hot-unplug events are
detected by an interrupt handler, then what about hot-plug events?  
Wouldn't they be detected by the same interrupt handler?  Obviously you
can't register new devices in interrupt context, so there must be a
workqueue or kernel thread involved somewhere.  Shouldn't the two types
of events be managed by the same workqueue/thread?

Alan Stern

