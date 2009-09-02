Return-Path: <linux-kernel-owner+w=401wt.eu-S1752341AbZIBOWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbZIBOWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 10:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbZIBOWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 10:22:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43809 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751405AbZIBOWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 10:22:37 -0400
Date: Wed, 2 Sep 2009 10:22:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Jan Blunck <jblunck@suse.de>, Kay Sievers <kay.sievers@suse.de>,
       <gregkh@suse.de>, <kasievers@suse.de>,
       USB list <linux-usb@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: driver/base/dd.c lockdep warning
In-Reply-To: <1251887933.7547.141.camel@twins>
Message-ID: <Pine.LNX.4.44L0.0909021016550.2971-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Sep 2009, Peter Zijlstra wrote:

> There's a number of lockdep annotations to help out.
...

Thanks for the detailed explanation; I appreciate it.

> Now the particular issue at hand is that the device tree is a free form
> tree with (afaiu) unlimited lock nesting depth -- if you were to plug in
> an already daisy chained usb hub with actual devices on the 7th deep hub
> device discovery will hold the device locks for the root hub, all 7
> intermediate hubs and the child device, leading to a total of 9 locks.

That's true in principle but not in practice because of the way the USB 
hub driver is designed.  Children aren't discovered and registered when 
the parent is probed; they are handled later.

Of course, this kind of scenario absolutely could occur with other 
device types.

> And there is nothing fundamental -- other than the usb chain depth --
> that limits this scenario, imagine the device to be an i2c bus with yet
> more devices ;-)
> 
> [ There used to be the additional complexity that on suspend/resume
>   we would hold _ALL_ device locks, which would exceed the max we can
>   track for any one task, this however has long been fixed. ]
> 
> 
> So the proposal I currently have to solve this is to allocate 48 lock
> classes:
> 
> struct lock_class_key device_tree_depth[MAX_LOCK_DEPTH];
> 
> and when creating a new device node, set the lock class corresponding
> the depth in the tree:
> 
>   mutex_lock_init(&device->lock);
>   BUG_ON(device->depth >= MAX_LOCK_DEPTH); // surely we're not that deep
>   lockdep_set_class(&device->lock, device_tree_depth + device->depth);
>   ...
>   mutex_lock(&device->lock); /* already have parent locked */
>   device_attach(device, parent);
> 
> and take multiple child locks using:
> 
>   mutex_lock_nest_lock(&device->lock, &device->parent->lock);
> 
> Which, I think should work for most cases out there.

I agree.  It would be rather surprising to find a chain of devices 
nested more than 48 deep.

> Alan had some funny corner cases, but I think he wasn't sure whether
> those would indeed show up in reality.

Yes; there's no point worrying about them now.  This sounds like a good 
approach.

Alan Stern

