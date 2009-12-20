Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbZLTDss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbZLTDss (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 22:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753542AbZLTDsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 22:48:47 -0500
Received: from netrider.rowland.org ([192.131.102.5]:39047 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753079AbZLTDsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 22:48:46 -0500
Date: Sat, 19 Dec 2009 22:48:44 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <200912192241.03991.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0912192232360.6618-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Dec 2009, Rafael J. Wysocki wrote:

> On Friday 18 December 2009, Alan Stern wrote:
> > On Fri, 18 Dec 2009, Rafael J. Wysocki wrote:
> > 
> > > I didn't manage to do that, but I was able to mark sd and i8042 as async and
> > > see the impact of this.
> > 
> > Apparently this didn't do what you wanted.  In the nx6325
> > sd+i8042+async+extra log, the 0:0:0:0 device (which is a SCSI disk) was

To be precise, the device is an ATA or SATA disk but it is managed by 
the sd driver.

> > suspended by the main thread instead of an async thread.
> 
> Hm, that's odd, because there's a noticeable time difference between the
> two cases in which the sd is sync and async.  I'll look into it further.

I don't know what the whole story is, but the PID number tells the 
tale.

> > There's an important point I neglected to mention before.  Your logs 
> > don't show anything for devices with no suspend callbacks at all.  
> > Nevertheless, these devices sit on the device list and prevent other
> > devices from suspending or resuming as soon as they could.
> 
> Unless they are async, that is.

Yes.  It would be simpler to make them async.  But first we ought to
know what they are.  Can you add an extra line to the log for such
devices?

What I'm afraid of is that there might be a "normal" device with a
"normal" ancestor but with "abnormal" devices in between (where
"normal" means there is a suspend or resume routine and "abnormal"  
means all the method pointers are NULL).  I know that this happens when
there's a USB mass-storage device, for example.  If we complete the
intermediate devices immediately, then there won't be anything to
prevent the ancestor from suspending before the device or the device
from resuming before the ancestor.  Forcing the "abnormal" devices to
be async, even if they aren't marked that way, would avoid these
problems.

> > For example, the fingerprint sensor (3-1) took the most time to resume.  
> > But other devices were delayed until after it finished because it had
> > children with no callbacks, and they delayed the devices following
> > them in the list.
> > 
> > What would happen if you completed these devices immediately, as part 
> > of the first pass?
> 
> OK.  How do the PM core is supposed to check if a device has null suspend
> and resume?  Check all of the function pointers in the first pass?

All the relevant pointers (including the legacy pointers).  That is, 
you check only the suspend pointers during the first suspend pass, and 
likewise for resume.

Alan Stern

