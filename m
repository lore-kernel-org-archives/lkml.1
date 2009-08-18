Return-Path: <linux-kernel-owner+w=401wt.eu-S1751877AbZHRUWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbZHRUWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 16:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbZHRUWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 16:22:08 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53083 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751616AbZHRUWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 16:22:06 -0400
Date: Tue, 18 Aug 2009 16:22:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Greg KH <gregkh@suse.de>
Subject: Re: [RFC][PATCH 0/7] PM: Asynchronous suspend and resume (updated)
In-Reply-To: <200908182156.30320.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908181606520.2653-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Aug 2009, Rafael J. Wysocki wrote:

> > Also, I think a better approach to the async execution would not
> > require adding a struct completion to each device and making each async
> > thread wait for the completion to be signalled.  Instead, have a single
> > master thread (i.e., the thread doing the suspend) monitor the
> > dependencies and have it farm the devices out to async threads as they
> > become ready to be suspended or resumed.
> 
> Do you mean that the master thread should check the dependencies
> _before_ executing, for example, __device_resume() and execute it
> asynchronously only if they are already satisfied?  In that case we might lose
> the opportunity to save some time.

That's almost what I mean.  The master thread should keep track of the 
state of all the devices.  Each time a suspend or resume completes, the 
master thread should determine which devices now have all their 
dependencies satisfied as a result, and should asynchronously execute 
__device_resume() for each one of them.

> For example, assume devices A and B depend on C. Say that normally, A would be
> handled before B, so if C hasn't finished yet, the A's callback will be
> executed synchronously.  Now, if both A and B take time T to complete the
> callback and C finishes dT after we've called A synchronously, we'll lose the
> chance to save T - dT by handling A and B in parallel.

No, that's not what I mean.  Until C is finished, the master thread
will sleep.  When C finishes the master thread will wake up, note that
A and B can now be resumed, fire off two async threads to resume them, 
and go back to sleep.

> The master thread might chose another device for asynchronous execution, but
> then it should revisit A and B and that still is going to be suboptimal
> time-wise in some specific situations (eg. A and B are the last two devices to
> handle).
> 
> > Finally, devices that don't have async_suspend set should implicitly 
> > depend on everything that comes after them (for suspend) or before them 
> > (for resume) in the device list.
> 
> They do, through dpm_list.

Do they?  I didn't read the code closely enough to tell.  This
requirement should of course be met by whichever scheme we end up
using.  I mentioned it because it provides a simple way of including 
synchronous operations in an async framework.

Alan Stern

