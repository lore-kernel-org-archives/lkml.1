Return-Path: <linux-kernel-owner+w=401wt.eu-S1760737AbZGINsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760737AbZGINsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 09:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760131AbZGINsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 09:48:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42376 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759143AbZGINsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 09:48:05 -0400
Date: Thu, 9 Jul 2009 09:48:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Magnus Damm <magnus.damm@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC][PATCH] PM: Introduce core framework for run-time PM of
 I/O  devices (rev. 8)
In-Reply-To: <aec7e5c30907081952t4b88f1ccjeec6ab11b1d913b8@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0907090937530.5823-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jul 2009, Magnus Damm wrote:

> Clocks should be stopped as soon as possible without any delay. The
> clock stopping is very cheap performance wise. Also, the clock
> stopping is done on bus level without invoking any driver callbacks.
> Delaying the clock stopping does not make any sense to me.

In that case the device driver or bus subsystem should manage the
device's clock directly.  There's no need to tie it in with the runtime
PM framework.  Simply start the clock before each I/O operation and
stop it afterward.

> For my use case the driver callbacks manage context save and restore.
> This to allow turning off power domains.
> 
> The reason why I don't want to execute the driver ->runtime_suspend()
> callbacks directly is performance. Basically, we only want to execute
> the driver callbacks when we know that we will be able to power off
> the domain. The driver callbacks need to save and restore registers,
> and each uncached memory access is expensive. Executing the driver
> callback does not give us any power savings at all, it's just consumes
> power.
> 
> I want to avoid the situation where the driver ->runtime_suspend() and
> ->runtime_resume() callbacks get invoked over and over for all devices
> except one in a certain power domain even though we will never be able
> to power off because a single device in the power domain is active.

Okay, I get the picture.  So what you want is something like this: Each 
time a driver starts a clock, it does a pm_runtime_get on the 
power-domain device.  Each time it stops the clock, it does a 
pm_runtime_put on the power-domain device.

When the power-domain device's runtime_idle callback runs, it should
call pm_schedule_suspend.  The runtime_suspend callback should call
pm_runtime_suspend for each of the devices in the power domain before
turning off the power supply.  Conversely, the runtime_resume callback
for the power-domain device should turn on the power supply and then
call pm_runtime_resume for each of the devices in the domain.

This will have to get more complicated if the individual device drivers
want to maintain their own usage counters -- especially if they want to
turn off the clock while leaving the counter positive.

Alan Stern

