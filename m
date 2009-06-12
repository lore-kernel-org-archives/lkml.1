Return-Path: <linux-kernel-owner+w=401wt.eu-S1762846AbZFLIKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762846AbZFLIKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757078AbZFLIK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:10:28 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:53408 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbZFLIKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:10:25 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Fri, 12 Jun 2009 10:11:13 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.30-rc7-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906082233490.19072-100000@netrider.rowland.org> <200906111108.40785.oliver@neukum.org> <aec7e5c30906112013q2d2827feh54192d518156f203@mail.gmail.com>
In-Reply-To: <aec7e5c30906112013q2d2827feh54192d518156f203@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906121011.13592.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 12. Juni 2009 05:13:12 schrieb Magnus Damm:
> Hi Oliver,
>
> On Thu, Jun 11, 2009 at 6:08 PM, Oliver Neukum<oliver@neukum.org> wrote:
> > Am Donnerstag, 11. Juni 2009 07:18:46 schrieb Magnus Damm:
> >> 3) When all devices in the power domain are suspended the bus code can
> >> turn off the power. The reason why I'd like to only autosuspend when
> >
> > So you are saying that you have power dependencies independent
> > of the device tree?
>
> I can think of the following power dependencies:
> - hardware bus topology
> - clocks
> - power domains

That means that some devices otherwise unrelated have a common power
switch, doesn't it?

> >> all devices are idle is simply that we don't get any power savings
> >> from the per device autosuspend() callbacks, only from turning off
> >> power to the entire per-domain. So bindly autosuspending and
> >> autoresuming devices is just pure overhead unless we know we can do it
> >> for all devices in the domain.
> >
> > Why can't you do this within the framework? You simply suspend when
> > all a domain's devices have been autosuspended.
>
> So you mean I should handle that in my arch/bus specific
> dev->bus->pm->autosuspend() code? So instead of calling
> dev->driver->pm->autosuspend() straight away I keep track of the use
> count of the power domain and when the domain is unused I call
> dev->driver->pm->autosuspend() for all devices in the power domain
> before powering off?

How much overhead do you have in autosuspend() if it actually powers
down the devices? If it is small, I suggest you really run the autosuspend
methods in the drivers but use a counter for the actual power switching
on a bus level.

> I guess hooking in things in dev->bus->pm->autosuspend() is doable,
> but then dev->power.runtime_status will be set to RPM_SUSPENDED even
> though the actual device isn't suspended at all. And RPM_IDLE state

Why do you care about a device being in RPM_SUSPENDED while
active. The inverse is a bug, but this seems harmless.

> will be more or less unused since the drivers should pass a delay of
> zero to make sure the bus code gets notified about the idle state
> straight away.

So? You are not getting a common code without a little overhead
for some cases.

> Basically, for my use case it would make more sense to let the
> bus_type directly decide when a device should be suspended instead of
> using a timeout before calling the bus_type code. I rather let the
> bus_type decide if a timeout should be used or not instead of using it
> for all bus_types.

So call with a delay of 0.

> So I guess the plan is that drivers directly should invoke
> pm_request_suspend() to notify the bus that they are idle? (I guess
> similar to my platform_device_idle()?)

Yes.

> So yes, I'd like to do things in dev->bus->pm->autosuspend(), and the
> code is quite close. I can't figure out why anyone would want the
> suspend delay at the current level though, but I guess other busses
> want to use that?

In your case resumption seems to cost almost no energy. In other
cases you must avoid short sleeps, as you conserve less energy
sleeping than it takes to resume.

	Regards
		Oliver

