Return-Path: <linux-kernel-owner+w=401wt.eu-S937115AbXGTRdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937115AbXGTRdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 13:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936866AbXGTRcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 13:32:50 -0400
Received: from mercury.realtime.net ([205.238.132.86]:37886 "EHLO
	ruth.realtime.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936847AbXGTRct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 13:32:49 -0400
In-Reply-To: <Pine.LNX.4.44L0.0707201216460.3811-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0707201216460.3811-100000@iolanthe.rowland.org>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <09666fe245b0fb34a5a09464250e003d@bga.com>
Content-Transfer-Encoding: 7bit
Cc: Ying Huang <ying.huang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, David Lang <david@lang.hm>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
From: Milton Miller <miltonm@bga.com>
Subject: Re: [linux-pm] Re: Hibernation considerations
Date: Fri, 20 Jul 2007 12:32:25 -0500
To: Alan Stern <stern@rowland.harvard.edu>
X-Mailer: Apple Mail (2.624)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 20, 2007, at 11:20 AM, Alan Stern wrote:
> On Fri, 20 Jul 2007, Milton Miller wrote:
>>> We can't do this unless we have frozen tasks (this way, or another)
>>> before
>>> carrying out the entire operation.
>>
>> What can't we do?   We've already worked with the drivers to quesce 
>> the
>> hardware and put any information to resume the device in ram.  Now we
>> ask them to put their device in low power mode so we can go to sleep.
>> Even if we schedule, the only thing userspace could touch is memory.
>
> Userspace can submit I/O requests.  Someone will have to audit every
> driver to make sure that such I/O requests don't cause a quiesced
> device to become active.  If the device is active, it will make the
> memory snapshot inconsistent with the on-device data.

If a driver is waking a device between the time it was told by 
hibernation "suspend all operations and save your device state to ram" 
and "resume your device" then it is a buggy driver.

I argue the process can make the io request after we write to disk, we 
just can't service it.  If we are suspended it will go to the request 
queue, and eventually the process will wait for normal throttling 
mechanisms until the driver is woken up.

It may mean the driver has to set a flag so that it knows it had an 
iorequest arrive while it was suspended and needs to wake the queue 
during its resume function.


Actually, my point was more "what kernel services do the drivers need 
to transition from quiesced to low power for acpi S4 or 
suspend-to-ram"?  We can't give them allocate-memory (but we give them 
a call "we are going to suspend" when they can), but does "run this 
tasklet" help?  What timer facilities are needed?

Do we need to differentate init (por by bios) and resume from quiesced 
(for reboot, kexec start/resume)?  I hope not.

milton

