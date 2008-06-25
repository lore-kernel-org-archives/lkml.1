Return-Path: <linux-kernel-owner+w=401wt.eu-S1758190AbYFYPJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbYFYPJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 11:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYFYPJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 11:09:23 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:39307 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbYFYPJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 11:09:22 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Zhao Yakui <yakui.zhao@intel.com>
Subject: Re: [PATCH] ACPI: don't walk tables if ACPI was disabled
Date: Wed, 25 Jun 2008 09:08:58 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>
References: <20080620135639.GA5073@damson.getinternet.no> <19f34abd0806240452w2561040uc2b1b1d35562db71@mail.gmail.com> <1214357857.9800.20.camel@yakui_zhao.sh.intel.com>
In-Reply-To: <1214357857.9800.20.camel@yakui_zhao.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806250908.59315.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 June 2008 07:37:37 pm Zhao Yakui wrote:
> On Tue, 2008-06-24 at 13:52 +0200, Vegard Nossum wrote:
> > On 6/24/08, Ingo Molnar <mingo@elte.hu> wrote:
> > > i havent seen the warning reappear with your fix after thousands of
> > > bootups - so i guess we can consider it fixed.
> > >
> > > Len, please consider the patch below. (it's in tip/out-of-tree)
> > 
> > No, please don't :-)
> > 
> > It fixes your particular case (the acpi_rtc_init() hunk of the patch),
> > but the acpi_walk_namespace() part should be changed to a WARN(). But
> > that is likely to cause a lot of "spurious" reports, so the other acpi
> > drivers should be fixed as well.
> In fact this issue is related with the following factors:
>    a. when acpi is disabled, OS won't initialize the ACPI mutex, which
> is accessed by many ACPI interface functions. For example:
> acpi_walk_namespace, acpi_install_fixed_event_handler.
>    b. When acpi is disabled, some drivers will call the ACPI interface
> functions. For example: The acpi_walk_namespace is called in
> dock_init/bay_init.

I think most current uses of acpi_walk_namespace() are indications
that the ACPI or PNP core is missing something.

In dock_init() and bay_init(), it's used to bind a driver to a
device.  I think it would be better if we could figure out how to
use the usual acpi_bus_register_driver() interface.  Actually, it
looks like this is already 90% done: acpi_dock_match() does the
same thing as is_dock(), so it looks like dock_init() could easily
be converted to register as a driver for ACPI_DOCK_HID.

bay_init() looks similar, with acpi_bay_match(), is_ejectable_bay(),
ACPI_BAY_HID, etc.

Other users of acpi_walk_namespace() are often to install notify
handlers to deal with add/remove events.  I think these are telling
us that we need to implement the "TBD: Handle device insertion/removal"
pieces in acpi_bus_check_device().

> The acpi_install_fixed_event_handler is called in 
> the acpi_rtc_init.

Yes (via rtc_wake_setup()).  I think this should be moved into the
RTC driver itself.  I have some ideas on how to do this; I'll post
a patch in a few days.  But for 2.6.26, I think the minimal fix of
checking acpi_disabled in acpi_rtc_init() is better.

Bjorn


