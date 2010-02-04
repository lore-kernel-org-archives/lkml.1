Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab0BDShG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 13:37:06 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:47250 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757282Ab0BDShE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 13:37:04 -0500
Date: Thu, 4 Feb 2010 13:37:03 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Zijlstra <peterz@infradead.org>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, Cong Wang <amwang@redhat.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
In-Reply-To: <1265301713.22001.128.camel@laptop>
Message-ID: <Pine.LNX.4.44L0.1002041322390.1261-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010, Peter Zijlstra wrote:

> > This doesn't address the fact that we really have multiple device trees
> > (for example, class devices are handled separately from normal
> > devices).  With the above patch installed, I still get lockdep
> > violations farther on during boot:
> 
> <snip lockdep splat>
> 
> Hmm, so you have multiple interacting trees? I had understood you only
> had a single device tree.

The real situation is kind of complicated, and I'm not familiar with
all the details.  But it's certainly true that a driver will want to
work with (and lock!) multiple struct device's that don't have a
parent-child relation in the tree.  The simplest example is regular
devices together with class devices, and another might be PCI devices
together with their "shadow" ACPI devices.

>  So how many trees are there, is that fixed?
> Does the device know what tree it is going to end up in?

The driver generally knows, but AFAIK that information is not passed 
back to the driver core.  At least, not directly -- you might say that 
it could be deduced from the parent pointer, assuming the core already 
knows all about the parent.

> If yes, then you can extend the setup_mutex_depth() function to pick a
> different class stack for each tree.

Maybe this could be done.  But for now perhaps a compromise is in
order.  We could make the switch from semaphores to mutexes while
avoiding lockdep issues by assigning the device mutexes to a
"don't-verify" class.  Is there such a thing, or could it be added?

Alan Stern

