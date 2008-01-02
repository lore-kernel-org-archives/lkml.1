Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328AbYABMzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbYABMzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 07:55:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbYABMzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 07:55:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41197 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbYABMzC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 07:55:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/4] PM: Do not destroy/create devices while suspended (rev. 2)
Date: Wed, 2 Jan 2008 13:56:58 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Greg KH <gregkh@suse.de>
References: <200801020032.45529.rjw@sisk.pl> <20080102105217.GA14731@elte.hu>
In-Reply-To: <20080102105217.GA14731@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801021356.59865.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 2 of January 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > Hi,
> > 
> > Some device drivers register CPU hotplug notifiers and use them to 
> > destroy device objects when removing the corresponding CPUs and to 
> > create these objects when adding the CPUs back.
> > 
> > Unfortunately, this is not the right thing to do during 
> > suspend/hibernation, since in that cases the CPU hotplug notifiers are 
> > called after suspending devices and before resuming them, so the 
> > operations in question are carried out on the objects representing 
> > suspended devices which shouldn't be unregistered behing the PM core's 
> > back.  Although right now it usually doesn't lead to any practical 
> > complications, it will predictably deadlock if 
> > gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch is 
> > applied.
> > 
> > The solution is to prevent drivers from removing/adding devices from 
> > within CPU hotplug notifiers during suspend/hibernation using the 
> > FROZEN bit in the notifier's action argument.  However, this has to be 
> > done with care, since the devices objects related to the nonboot CPUs 
> > that failed to go online during resume should not be present in the 
> > system.  For this reason, it seems reasonable to introduce a mechanism 
> > allowing drivers to ask the PM core to remove device objects 
> > corresponding to suspended devices on their behalf.
> > 
> > The first patch in the series introduces such a mechanism.  The 
> > remaining three patches modify the MSR, x86-64 MCE and cpuid drivers 
> > in accordance with the above approach.
> 
> btw., it would be really, really cool if there was a scriptable way i 
> could test suspend/resume functionality.

First, there are patches queued for 2.6.25 that allow you to test various
phases of suspend (specifically, patches 09-11 in the series at
http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.24-rc6/patches/).

With these patches applied you can do something like:
# echo core > /sys/power/pm_test
# echo mem > /sys/power/state
and it will run the suspend code up to, but not including, entering the sleep
state (it will busy wait for 5 sec. instead).  Then, it will run the resume
code.

There are 6 testing levels available, documented in patch 11 and in the
changelogs.

Second, there's the rtc wakealarm thing that can be used to test the real
suspend.

> Pavel has this /dev/rtc thing to set up an alarm (not sure how functional it
> is) - would it be possible to have it as a "suspend for 10 seconds then
> resume" debug functionality?

Well, we have the following test script in the userland suspend package that
is supposed to work right now:

#!/bin/bash
date
cd /sys/class/rtc/rtc0
echo $(( $(cat since_epoch) + 20 )) > wakealarm
s2ram
date

provided that the new rtc driver code is compiled (and the old one is not).

> That way any suspend breakage would be detectable (and bisectable) in
> automated testing - if the resume does not come back after 10-20 seconds then
> the test failed. 

Yes, but please note that some systems require user space manipulations of the
graphics adapter for suspend to work and to detect a breakage of such a system
you need to boot it into X and use s2ram to suspend.

Greetings,
Rafael
