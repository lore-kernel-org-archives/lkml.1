Return-Path: <linux-kernel-owner+w=401wt.eu-S1752269Ab0AYVhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab0AYVhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 16:37:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563Ab0AYVhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 16:37:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52132 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab0AYVhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 16:37:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] PM: disable nonboot cpus before suspending devices
Date: Mon, 25 Jan 2010 22:37:42 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <alpine.LFD.2.00.1001221841490.2266@localhost> <201001222148.23945.rjw@sisk.pl> <alpine.LFD.2.00.1001251601440.2100@localhost>
In-Reply-To: <alpine.LFD.2.00.1001251601440.2100@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001252237.42545.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 January 2010, Sebastian Ott wrote:
> Hi.
> 
> On Fri, 22 Jan 2010, Rafael J. Wysocki wrote:
> 
> > On Friday 22 January 2010, Sebastian Ott wrote:
> > > 
> > > a possible fix would be to call disable_nonboot_cpus before suspending the
> > > devices..
> > 
> > This is going against the changes attempting to speed-up suspend and resume,
> > such as the asynchronous suspend/resume patchset, so I don't agree with it.
> 
> Isn't the main benefit for this scenario that while a driver starts io and
> waits for interrupts, the callback for the next device can be called? And
> this can be done with one cpu as well.

That's the basic idea, but the additional CPUs help quite a bit.

> > The real solution would be to remove the memory allocations from the
> > _cpu_down() call path.
> 
> So you have to also ban allocations from all registered notifiers at the
> cpu_chain. And since enable_nonboot_cpus is called before the devices are
> woken up, the same would be true for _cpu_up() which may not be done
> easily.

That's correct.  BTW, that's what the CPU_TASKS_FROZEN bit is for among other
things (perhaps it may be used to fix this particular issue).

> > BTW, this is one of the cases I and Ben are talking about where it's not
> > practical to rework the code just to avoid memory allocation problems during
> > suspend/resume.
> 
> Ok. All i'm saying is that in hibernation_snapshot/create_image memory
> allocations are directely triggered after all devices were put to sleep /
> before woken up - and this looks like a bug.

I agree, but that's because people don't remember that CPU hotplug is also
used for suspend/hibernation.  I don't know at the moment how much effort
it would take to fix all of these problems appropriately, but I _guess_ that
would be quite some work.  That, among other things, is why I sent the patch
to modify gfp_allowed_mask before suspending devices.

> For the driver case - what about using your patch to not modify the gfp
> mask but print a warning instead so that these drivers can be identified
> and fixed.

We'd get a lot of warnings and there are cases where we know they would
trigger (eg. ACPI internals).  So, I'd rather like to reduce the users' pain
(by changing gfp_allowed_mask) than add to it (by adding a warning that's
guaranteed to show up).

Rafael
