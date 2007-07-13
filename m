Return-Path: <linux-kernel-owner+w=401wt.eu-S1758472AbXGMQ4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472AbXGMQ4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 12:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbXGMQ4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 12:56:22 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34282 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbXGMQ4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 12:56:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       <david@lang.hm>, "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       <nigel@nigel.suspend2.net>, <linux-kernel@vger.kernel.org>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
References: <Pine.LNX.4.44L0.0707131146340.2555-100000@iolanthe.rowland.org>
Date: Fri, 13 Jul 2007 10:54:42 -0600
In-Reply-To: <Pine.LNX.4.44L0.0707131146340.2555-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Fri, 13 Jul 2007 11:50:11 -0400 (EDT)")
Message-ID: <m1fy3sdz1p.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> On Fri, 13 Jul 2007, Rafael J. Wysocki wrote:
>
>> Okay, I have thought it through and I think that, as an initial step, we can
> do
>> something like this:
>> 
>> - preload the image-saving kernel before hibernation
>> - in the hibernation code path replace device_suspend() with the shutting down
> of
>> all devices without unregistering them (not very nice, but should be
> sufficient
>>   for a while)
>> - when we've called device_power_down() and save_processor_state(), jump to
>>   the image-saving kernel and let it run
>> - make the image-saving kernel set up everything, save the image without
>>   starting any user space (we may use the existing image-saving code for this
>> purpose, with some modifications) and power off the system (or make it enter
>>   S4)
>> - use the existing restoration code to load the image and jump to the
>>   hibernated kernel
>> - in the restore code patch replace device_resume() with the reprobing of all
>>   devices.
>> 
>> Comments?
>
> I doubt that re-probing devices will work.  The probe routine won't 
> expect there to be any registered children, so it will try to 
> re-register them.

So really unregister the children.  All we really need to do is disassociate
the drivers from the devices (to reuse the existing code) we don't
need to rescan for the devices.  The associating the device drivers
with devices takes human measurable amount of time.  The only thing
that takes time is waiting on hardware.  Maybe things will suck
and associating the drivers with the device tree with take a whole
second on a bad day, I don't think that is enough time to add
complicated new code paths for the drivers to maintain.

> On the other hand, post_restore methods could be written to expect 
> something like this.

Please Please Plaese do not start with the existing software suspend
to disk code and thinking.  We are not implementing suspend to ram
here or anything like it.  We already have proven code paths that
know how to quiesce hardware.  We already have proven code paths
that know how to take quite hardware and make it run.  Please let's
just use them.  At least until we can see that they are insufficient
to the task.

Eric
