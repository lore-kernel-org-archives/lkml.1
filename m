Return-Path: <linux-kernel-owner+w=401wt.eu-S1760554AbZFLDVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760554AbZFLDVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 23:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbZFLDVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 23:21:22 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:30629 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbZFLDVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 23:21:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GLWCTD0pTZm2yiLlWZzWgKJzzSX3OMoOiMtu3KSbhtgvZiKmp8oITqFcKTcVwrfpuV
         HiYRncflAqN38Y+1jrzN6wUEWtknqQSY5yXHz+BAVlt3TQKowFq6H0LPax51UZ70rKz0
         TXvjoLWDR1evqwKONav+CYQ2x5WXandTPKyJU=
MIME-Version: 1.0
In-Reply-To: <200906111108.40785.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0906082233490.19072-100000@netrider.rowland.org>
	 <200906101029.27529.rjw@sisk.pl>
	 <aec7e5c30906102218j2f8f38dbt5d05a3928ca46c15@mail.gmail.com>
	 <200906111108.40785.oliver@neukum.org>
Date: Fri, 12 Jun 2009 12:13:12 +0900
Message-ID: <aec7e5c30906112013q2d2827feh54192d518156f203@mail.gmail.com>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re: 
	[RFC][PATCH 0/2] PM: Rearrange core suspend code)
From: Magnus Damm <magnus.damm@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

On Thu, Jun 11, 2009 at 6:08 PM, Oliver Neukum<oliver@neukum.org> wrote:
> Am Donnerstag, 11. Juni 2009 07:18:46 schrieb Magnus Damm:
>> 3) When all devices in the power domain are suspended the bus code can
>> turn off the power. The reason why I'd like to only autosuspend when
>
> So you are saying that you have power dependencies independent
> of the device tree?

I can think of the following power dependencies:
- hardware bus topology
- clocks
- power domains

>> all devices are idle is simply that we don't get any power savings
>> from the per device autosuspend() callbacks, only from turning off
>> power to the entire per-domain. So bindly autosuspending and
>> autoresuming devices is just pure overhead unless we know we can do it
>> for all devices in the domain.
>
> Why can't you do this within the framework? You simply suspend when
> all a domain's devices have been autosuspended.

So you mean I should handle that in my arch/bus specific
dev->bus->pm->autosuspend() code? So instead of calling
dev->driver->pm->autosuspend() straight away I keep track of the use
count of the power domain and when the domain is unused I call
dev->driver->pm->autosuspend() for all devices in the power domain
before powering off?

I guess hooking in things in dev->bus->pm->autosuspend() is doable,
but then dev->power.runtime_status will be set to RPM_SUSPENDED even
though the actual device isn't suspended at all. And RPM_IDLE state
will be more or less unused since the drivers should pass a delay of
zero to make sure the bus code gets notified about the idle state
straight away.

Basically, for my use case it would make more sense to let the
bus_type directly decide when a device should be suspended instead of
using a timeout before calling the bus_type code. I rather let the
bus_type decide if a timeout should be used or not instead of using it
for all bus_types.

So I guess the plan is that drivers directly should invoke
pm_request_suspend() to notify the bus that they are idle? (I guess
similar to my platform_device_idle()?)

For my use case there is no point in having the delay in
pm_request_suspend(), we want to notify the bus about the per-device
idleness straight away. Using a delay in pm_request_suspend() before
calling the bus type autosuspend will just keep the current per-device
state away from the bus level and make sure we _cannot_ enter deep
sleep states. Which I believe will result in worse battery life
because we spend more time than necessary in not-so-deep sleep states.

So yes, I'd like to do things in dev->bus->pm->autosuspend(), and the
code is quite close. I can't figure out why anyone would want the
suspend delay at the current level though, but I guess other busses
want to use that?

Thanks for your comments,

/ magnus
