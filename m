Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab0BEIzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 03:55:15 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:47990 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269Ab0BEIzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 03:55:13 -0500
To: Peter Zijlstra <peterz@infradead.org>
Cc: Greg KH <gregkh@suse.de>, Cong Wang <amwang@redhat.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>, akpm@linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
References: <20100129070516.4058.77227.sendpatchset@localhost.localdomain>
	<m1eil9v0j9.fsf@fess.ebiederm.org> <4B629E7F.5020200@redhat.com>
	<m1zl3xt49k.fsf@fess.ebiederm.org> <20100129142223.GB12539@suse.de>
	<1264787848.24455.31.camel@laptop> <20100129181024.GA12934@suse.de>
	<1264788860.24455.35.camel@laptop> <20100129182114.GA13219@suse.de>
	<1264795834.24455.43.camel@laptop> <m1y6jgpsax.fsf@fess.ebiederm.org>
	<1265283496.24455.1939.camel@laptop>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 05 Feb 2010 00:55:02 -0800
In-Reply-To: <1265283496.24455.1939.camel@laptop> (Peter Zijlstra's message of "Thu\, 04 Feb 2010 12\:38\:16 +0100")
Message-ID: <m1aavojc49.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Fri, 2010-01-29 at 12:30 -0800, Eric W. Biederman wrote:
>
>> We get false positives when the code of a sysfs attribute
>> synchronously removes other sysfs attributes.  In general that is not
>> safe due to hotplug etc, but there are specific instances of static
>> sysfs entries like the pm_core where it appears to be safe.
>> 
>> I am not familiar with the device core lockdep issues.  Are they similar?
>
> The device tree had the problem that we could basically hold a device
> lock and an unspecified number of parent locks (iirc this was due to
> device probing, where we hold the bus lock while probing/adding child
> device, recursively). 
>
> If we place each dev->lock into the same class (which would naively
> happen), then this would lead to recursive lock warnings. The proposed
> solution for this is to create MAX_LOCK_DEPTH classes and assign them to
> the dev->lock depending on the depth in the device tree (Alan said that
> MAX_LOCK_DEPTH is sufficient for all practical cases).
>
> static struct lock_class_key dev_tree_classes[MAX_LOCK_DEPTH];
>
> device_add() or thereabouts would have something like:
>
> #ifdef CONFIG_PROVE_LOCKING
> 	BUG_ON(dev->depth >= MAX_LOCK_DEPTH);
> 	lockdep_set_class(dev->lock, &dev_tree_classes[dev->depth]);
> #endif
>
>
> Then there was a problem were we could lock all child devices while
> holding the parent device lock (forgot why though), this would, on
> taking the second child dev->lock, again lead to recursive lock
> warnings. 
>
> We have an annotation for that: lock_nest_lock (currently only
> spin_lock_nest_lock exists, but mutex_lock_nest_lock is easily created),
> and this would allow you to do things like:
>
> 	mutex_lock(&parent->lock);
> 	for_each_device_child(child, parent) {
> 		mutex_lock_nest_lock(&child->lock, &parent->lock);
> 		...
> 	}
>
>
> I hope this helps in figuring out the sysfs case..

Interesting.  The sysfs attributes in general don't have this problem
because the common case is effectively a reader/writer lock where we
can have all of the readers we want.

In the sysfs case the classic problem is when an attribute grabs a
lock and that lock is also held while the attribute is being deleted.
I first found this with the rtnl_lock but there are other cases
as well.

The particularly tricky case to handle in lockdep is when that
other lock also the s_active lock from another part of the tree.  There
is an entire Alice style rabbit whole there, I am trying to figure out.

Eric
