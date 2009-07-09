Return-Path: <linux-kernel-owner+w=401wt.eu-S1759457AbZGICwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457AbZGICwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 22:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756455AbZGICw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 22:52:27 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:48855 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960AbZGICw0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 22:52:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FI189KK6PsxMcoq4ip0CDBcawCdwnrzY6sWGFIVd0+mAlahPJkqA7t58qkeu4V62d2
         qJdF6Lee77fAFr3+rGA2mNAp5GIziSUAgkWk/a0WwRZWJn6tWfRaltNxg/1dznL4BBEA
         DT41tZTMcdo/fm94hqyfmEVhg7Zdpcc5Xf/cY=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0907081530120.22105-100000@iolanthe.rowland.org>
References: <200907082101.29387.rjw@sisk.pl>
	 <Pine.LNX.4.44L0.0907081530120.22105-100000@iolanthe.rowland.org>
Date: Thu, 9 Jul 2009 11:52:24 +0900
Message-ID: <aec7e5c30907081952t4b88f1ccjeec6ab11b1d913b8@mail.gmail.com>
Subject: Re: [RFC][PATCH] PM: Introduce core framework for run-time PM of I/O 
	devices (rev. 8)
From: Magnus Damm <magnus.damm@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Thu, Jul 9, 2009 at 4:42 AM, Alan Stern<stern@rowland.harvard.edu> wrote:
> On Wed, 8 Jul 2009, Rafael J. Wysocki wrote:
>
>> > So I'd like to tie in two levels of power management in our runtime PM
>> > implementation. The most simple level is clock stopping, and I can do
>> > that using the bus callbacks ->runtime_suspend() and
>> > ->runtime_resume() with v8. The driver runtime callbacks are never
>> > invoked for clock stopping.
>> >
>> > On top of the clock stopping I'd like to turn off power to the domain.
>
> I take it the devices in a single power domain don't all share a common
> parent.

It all depends on how we implement the software bus topology in the
future. Right now from the software perspective the platform bus
topology on SuperH is flat and more or less unused. It sounds sane to
map in the power domains into the bus topology. I'm not sure if it is
the best choice though, each device also has clock dependencies and
it's of course communicating through some internal hardware bus with
it's own hardware topology.

>> > So if all clocks are stopped to the devices within a domain, then I'd
>> > like to call the per-device ->runtime_suspend() callbacks provided by
>> > the drivers.
>
> Why?  That is, why not tell the driver as soon as the device's own
> clock is stopped?  What point is there in waiting for all the other
> clocks to be stopped as well?

Clocks should be stopped as soon as possible without any delay. The
clock stopping is very cheap performance wise. Also, the clock
stopping is done on bus level without invoking any driver callbacks.
Delaying the clock stopping does not make any sense to me.

For my use case the driver callbacks manage context save and restore.
This to allow turning off power domains.

The reason why I don't want to execute the driver ->runtime_suspend()
callbacks directly is performance. Basically, we only want to execute
the driver callbacks when we know that we will be able to power off
the domain. The driver callbacks need to save and restore registers,
and each uncached memory access is expensive. Executing the driver
callback does not give us any power savings at all, it's just consumes
power.

I want to avoid the situation where the driver ->runtime_suspend() and
->runtime_resume() callbacks get invoked over and over for all devices
except one in a certain power domain even though we will never be able
to power off because a single device in the power domain is active.

The situation above can be described with a practical example with an
open a serial port. The receive side of the serial port hardware needs
the clock to be enabled, so we can't turn off the clock. This leads to
that we can't runtime suspend the device driver. In my opinion it's
pure overhead to call ->runtime_suspend() and ->runtime_resume() for
all other devices in the same power domain as the serial port, this
because we already know that the open serial port is blocking the
entire power domain.

>> > I wonder how to fit these two levels of power management into the
>> > runtime PM in a nice way. My first attempts simply made use of
>> > pm_runtime_resume() and pm_runtime_suspend(), but I'd like to move to
>> > get()/put() if possible. But for that to work I need to implement
>> > ->runtime_idle() in my bus code, and I wonder if the current runtime
>> > PM idle behaviour is a good fit.
>> >
>> > Below is how I'd like to make use of the runtime PM code. I'm not sure
>> > if it's compatible with your view. =)
>> >
>> > Drivers call pm_runtime_get_sync() and pm_runtime_put() before and
>> > after using the hardware. The runtime PM code invokes the bus
>> > ->runtime_idle() callback ASAP (of course depending on put() or
>> > put_sync(), but no timer). The bus->runtime_idle() callback stops the
>> > clock and decreases the power domain usage count. If the power domain
>> > is unused, then the pm_schedule_suspend() is called for each of the
>> > devices in the power domain. This in turn will invoke the
>> > ->runtime_suspend() callback which starts the clock, calls the driver
>> > ->runtime_suspend() and stops the clock again. When all devices are
>> > runtime suspended the power domain is turned off.
>
> Instead, you should call pm_runtime_suspend from within the
> runtime_idle method.  When the runtime_suspend method runs, have it
> decrement the power domain's usage count.  Is the power domain
> represented by a single struct device?  If it is then that device's
> power.usage_count field would naturally be the thing to use; otherwise
> you'd have to set up your own counter.

Ok, calling pm_runtime_suspend() from the bus ->runtime_idle callback
sounds like a good plan. The power domain is only represented by a
simple structure at this point. I agree it would be nice to make use
of the usage_count for this purpose.

> Then depending on how things are organized, when the power-domain
> device's usage_count goes to 0 you'll get a runtime_idle callback.
> Call pm_runtime_resume for the power-domain device, and have that
> routine shut off the power.  Or if you set up your own private counter
> for the power domain, shut off the power when the counter goes to 0.

Right, I'm with you how it works. I have to think a bit more about how
to tie in both clock stopping and power domain control with
runtime_idle though.

Thanks for your suggestions,

/ magnus
