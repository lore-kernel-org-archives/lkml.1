Return-Path: <linux-kernel-owner+w=401wt.eu-S1761417AbZLJShL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417AbZLJShL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 13:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761379AbZLJShI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 13:37:08 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:39187 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761367AbZLJShH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 13:37:07 -0500
Date: Thu, 10 Dec 2009 13:37:12 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <alpine.LFD.2.00.0912100739260.3560@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0912101321020.2680-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Dec 2009, Linus Torvalds wrote:

> 
> 
> On Thu, 10 Dec 2009, Alan Stern wrote:
> > 
> > In device_pm_remove():
> > 
> > 	mutex_lock(&dpm_list_mtx);
> > 	if (dev == dpm_next)
> > 		dpm_next = to_device(dpm_iterate_forward ?
> > 			dev->power.entry.next : dev->power.entry.prev);
> > 	list_del_init(&dev->power.entry);
> > 	mutex_unlock(&dpm_list_mtx);
> 
> I'm really not seeing the point - it's much better to hardcode the 
> ordering in the place you use it (where it is static and the compiler can 
> generate bette code) than to do some dynamic choice that depends on some 
> fake flag - especially a global one.

You probably didn't look closely at the original code in dpm_suspend()  
and dpm_resume().  It's very awkward; each device is removed from
dpm_list, operated on, and then added on to a new local list.  At the
end the new list is spliced back into dpm_list.

This approach is better because it doesn't involve changing any list 
pointers while the sleep transition is in progress.  At any rate, I 
don't recommend doing it in the same patch as the async stuff; it 
should be done separately.  Either before or after -- the two are 
independent.

> Also, quite frankly, error handling needs to be separated out of the whole 
> async patch, and needs to be thought about a lot more. And I would 
> seriously argue that if you have any async suspends, then those async 
> suspends are _not_ allowed to fail. At least not initially 
> 
> Having async failures and trying to fix them up is just a disaster. Which 
> ones actually failed, and which ones were aborted before they even really 
> got to their suspend routines? Which ones do you try to resume?

We record the status of each device; dev->power.status stores different
values depending on whether the device suspend succeeded or failed.  
The value will be correct and up-to-date after async_synchronize_full()
returns.  The value is used in dpm_resume() to decide which devices
need their resume methods called.  I don't see any problems there.

> IOW, it needs way more thought than what has clearly happened so far. And 
> once more, I will refuse to merge anything that is complicated for no 
> actual reason (where reason is "real life, and tested to make a big 
> difference", not some hand-waving)

I don't think the error handling requires more than minimal changes.

The whole atomic_t thing was overkill.  It probably stemmed from a
discussion some time back with Pavel Machek about concurrent writes to
a single variable.  I claimed that concurrent writes to a properly
aligned pointer, int, or long would never create a "mash-up"; that is,
readers would see either the original value or one of the new values
but never some weird combination of bits.

Alan Cox pointed out that while this was technically correct, there's
nothing to prevent the compiler from translating

	a = b + c;

into something like:

	load b, R1
	store R1, a
	load c, R1
	add R1, a

in which case readers might see the intermediate value.  (Okay, the
compiler would have to be pretty stupid to do this with such a simple
expression, but it could happen with more complicated expressions.)  
Pavel favored always using atomic types when there could be concurrent
writes, and apparently Rafael was following his advice.

Alan Stern

