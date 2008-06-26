Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbYFZCwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbYFZCwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 22:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754186AbYFZCvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 22:51:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:11276 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbYFZCvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 22:51:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,706,1204531200"; 
   d="scan'208";a="345664746"
Subject: Re: [PATCH] ACPI: don't walk tables if ACPI was disabled
From: Zhao Yakui <yakui.zhao@intel.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>
In-Reply-To: <200806250908.59315.bjorn.helgaas@hp.com>
References: <20080620135639.GA5073@damson.getinternet.no>
	 <19f34abd0806240452w2561040uc2b1b1d35562db71@mail.gmail.com>
	 <1214357857.9800.20.camel@yakui_zhao.sh.intel.com>
	 <200806250908.59315.bjorn.helgaas@hp.com>
Content-Type: text/plain
Date: Thu, 26 Jun 2008 11:02:48 +0800
Message-Id: <1214449368.7055.29.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-25 at 09:08 -0600, Bjorn Helgaas wrote:
> On Tuesday 24 June 2008 07:37:37 pm Zhao Yakui wrote:
> > On Tue, 2008-06-24 at 13:52 +0200, Vegard Nossum wrote:
> > > On 6/24/08, Ingo Molnar <mingo@elte.hu> wrote:
> > > > i havent seen the warning reappear with your fix after thousands of
> > > > bootups - so i guess we can consider it fixed.
> > > >
> > > > Len, please consider the patch below. (it's in tip/out-of-tree)
> > > 
> > > No, please don't :-)
> > > 
> > > It fixes your particular case (the acpi_rtc_init() hunk of the patch),
> > > but the acpi_walk_namespace() part should be changed to a WARN(). But
> > > that is likely to cause a lot of "spurious" reports, so the other acpi
> > > drivers should be fixed as well.
> > In fact this issue is related with the following factors:
> >    a. when acpi is disabled, OS won't initialize the ACPI mutex, which
> > is accessed by many ACPI interface functions. For example:
> > acpi_walk_namespace, acpi_install_fixed_event_handler.
> >    b. When acpi is disabled, some drivers will call the ACPI interface
> > functions. For example: The acpi_walk_namespace is called in
> > dock_init/bay_init.
> 
> I think most current uses of acpi_walk_namespace() are indications
> that the ACPI or PNP core is missing something.
I don't think so. The acpi_walk_namespace is used to enumerate the ACPI
tree and execute some specific operations. For example: Add the device
notification function for some type of device; call the INI method for
all the device.
> In dock_init() and bay_init(), it's used to bind a driver to a
> device.  I think it would be better if we could figure out how to
> use the usual acpi_bus_register_driver() interface.  Actually, it
> looks like this is already 90% done: acpi_dock_match() does the
> same thing as is_dock(), so it looks like dock_init() could easily
> be converted to register as a driver for ACPI_DOCK_HID.
Maybe what you said is reasonable if the dock/bay device exists and is
added to Linux ACPI device tree. But if the status of bay/dock device
doesn't exist , it won't be added into the Linux ACPI device tree. In
such case the dock/bay driver won't be loaded for it. So it will be
reasonable to enumerate the acpi tree to install the notification
function for the dock device so that OS can receive the notification
event when the dock device is hotplugged. 

If acpi is disabled, it is unnecessary for OS to find the dock/bay
device again. In such case it will be reasonable to use the flag of
acpi_disabled in the function of dock_init/bay_init.

Best regards.
   Yakui.
> bay_init() looks similar, with acpi_bay_match(), is_ejectable_bay(),
> ACPI_BAY_HID, etc.
> 
> Other users of acpi_walk_namespace() are often to install notify
> handlers to deal with add/remove events.  I think these are telling
> us that we need to implement the "TBD: Handle device insertion/removal"
> pieces in acpi_bus_check_device().
> 
> > The acpi_install_fixed_event_handler is called in 
> > the acpi_rtc_init.
> 
> Yes (via rtc_wake_setup()).  I think this should be moved into the
> RTC driver itself.  I have some ideas on how to do this; I'll post
> a patch in a few days.  But for 2.6.26, I think the minimal fix of
> checking acpi_disabled in acpi_rtc_init() is better.
> 
> Bjorn
> 
> 

