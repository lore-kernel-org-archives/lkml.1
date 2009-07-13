Return-Path: <linux-kernel-owner+w=401wt.eu-S1753060AbZGMBvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbZGMBvI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 21:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbZGMBuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 21:50:50 -0400
Received: from mail-qy0-f192.google.com ([209.85.221.192]:37696 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbZGMBun convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 21:50:43 -0400
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Jul 2009 21:50:42 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Cd6ss3hr0gLu+wUEfiWxtNRzvZqcuUUMUGxRsQtHotfo6Y8sXmTMxaAkT2KwaNARUb
         meOf4N4BVQJXiICAfcZSKGpvdqJACU7/jDJ385SkSq6wrcrBXJ9SbiP2mPeOawfc007Y
         z+XQOIoKSWHSRa/Nt4knP8TM2CTWZkihz0Sdo=
MIME-Version: 1.0
In-Reply-To: <175E0F9A9EFCEA46A65F5552BB057298BB5F3EA2@bgsmsx502.gar.corp.intel.com>
References: <aec7e5c30907081952t4b88f1ccjeec6ab11b1d913b8@mail.gmail.com>
	 <Pine.LNX.4.44L0.0907090937530.5823-100000@iolanthe.rowland.org>
	 <aec7e5c30907090831y180b0972o6dcb961dd292a3c0@mail.gmail.com>
	 <175E0F9A9EFCEA46A65F5552BB057298BB5F3EA2@bgsmsx502.gar.corp.intel.com>
Date: Mon, 13 Jul 2009 10:42:31 +0900
Message-ID: <aec7e5c30907121842p57a6fe3cud3d601a15c67df4f@mail.gmail.com>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Introduce core framework for run-time 
	PM of I/O devices (rev. 8)
From: Magnus Damm <magnus.damm@gmail.com>
To: "Mahalingam, Nithish" <nithish.mahalingam@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 6:56 AM, Mahalingam,
Nithish<nithish.mahalingam@intel.com> wrote:
> On Thu, Jul 9, 2009 at 10:48 PM, Alan Stern<stern@rowland.harvard.edu> wrote:
>>> On Thu, 9 Jul 2009, Magnus Damm wrote:
>>>
>>>> Clocks should be stopped as soon as possible without any delay. The
>>>> clock stopping is very cheap performance wise. Also, the clock
>>> stopping is done on bus level without invoking any driver callbacks.
>>>> Delaying the clock stopping does not make any sense to me.
>>>
>>> In that case the device driver or bus subsystem should manage the
>>> device's clock directly.  There's no need to tie it in with the runtime
>>> PM framework.  Simply start the clock before each I/O operation and
>>> stop it afterward.
>
>> It's not that easy. The clock needs to be enabled to let the hardware
>> device perform device specific stuff. For instance, the clock for the
>> LCD controller needs to be on to redraw the screen. When the driver
>> knows that it's done with the clock it can notify the bus using
>> Runtime PM.
>
> Is there any plan to look into the "Clock Framework" that was developed as part of OMAP and extending this to make it generic for all platforms?

Do you mean vendor specific extensions to the clock framework? I'm
quite sure a bunch of architectures already support the clock
framework. Some architectures probably have extensions that would be
nice if they could be made more generic. Do you have any special
extensions in mind? =)

As for Runtime PM, clock stopping is only one part of the problem. On
SuperH we manage clock stopping through the clock framework and I'm
pretty sure other embedded architectures do that as well. That problem
is more or less already solved in my opinion.

For efficient power management on embedded systems we need more than
just clock stopping. We also want to save and restore device context
so we can turn off power to power domains during runtime. This is
somewhat tied together with clock stopping because we want to disable
clocks as soon as possible when the device gets idle but in the case
of domain power off we also need to start the clock before we can call
the ->runtime_suspend() callback provided by the driver. All this can
of course be handled by the device driver, but that would just be
duplicating too much code - I'd rather let the Runtime PM bus code
manage that.

Many runtime power management aware device drivers use clk_enable()
and clk_disable() stop and start clocks. But the clk_disable()
function is actually often used to signal that the device is idle.
Allowing device drivers to replace clk_enable()/clk_disable() with
Runtime PM callbacks to add support for context save and restore is a
logical next step from my point of view.

For SuperH we will most likely allow clock stopping through the clock
framework _or_ using Runtime PM in parallel, at least until all
drivers are converted to make use of Runtime PM.

Cheers,

/ magnus
