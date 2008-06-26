Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbYFZShm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbYFZShm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbYFZShc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:37:32 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:46488 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbYFZSha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:37:30 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Zhao Yakui <yakui.zhao@intel.com>
Subject: Re: [PATCH] ACPI: don't walk tables if ACPI was disabled
Date: Thu, 26 Jun 2008 10:44:01 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>
References: <20080620135639.GA5073@damson.getinternet.no> <200806250908.59315.bjorn.helgaas@hp.com> <1214449368.7055.29.camel@yakui_zhao.sh.intel.com>
In-Reply-To: <1214449368.7055.29.camel@yakui_zhao.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806261044.02285.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 June 2008 09:02:48 pm Zhao Yakui wrote:
> On Wed, 2008-06-25 at 09:08 -0600, Bjorn Helgaas wrote:
> > On Tuesday 24 June 2008 07:37:37 pm Zhao Yakui wrote:
> > > On Tue, 2008-06-24 at 13:52 +0200, Vegard Nossum wrote:
> > > > On 6/24/08, Ingo Molnar <mingo@elte.hu> wrote:
> > > > > i havent seen the warning reappear with your fix after thousands of
> > > > > bootups - so i guess we can consider it fixed.
> > > > >
> > > > > Len, please consider the patch below. (it's in tip/out-of-tree)
> > > > 
> > > > No, please don't :-)
> > > > 
> > > > It fixes your particular case (the acpi_rtc_init() hunk of the patch),
> > > > but the acpi_walk_namespace() part should be changed to a WARN(). But
> > > > that is likely to cause a lot of "spurious" reports, so the other acpi
> > > > drivers should be fixed as well.
> > > In fact this issue is related with the following factors:
> > >    a. when acpi is disabled, OS won't initialize the ACPI mutex, which
> > > is accessed by many ACPI interface functions. For example:
> > > acpi_walk_namespace, acpi_install_fixed_event_handler.
> > >    b. When acpi is disabled, some drivers will call the ACPI interface
> > > functions. For example: The acpi_walk_namespace is called in
> > > dock_init/bay_init.
> > 
> > I think most current uses of acpi_walk_namespace() are indications
> > that the ACPI or PNP core is missing something.
> I don't think so. The acpi_walk_namespace is used to enumerate the ACPI
> tree and execute some specific operations. For example: Add the device
> notification function for some type of device; call the INI method for
> all the device.

There are exceptions, and obviously acpi_walk_namespace() will be
needed some places.

One example where I think acpi_walk_namespace() should not be used
is to register notification functions for device addition/removal.
I think the ACPI core should be handling those notify events and
turning them into add()/remove() calls to the driver.

> > In dock_init() and bay_init(), it's used to bind a driver to a
> > device.  I think it would be better if we could figure out how to
> > use the usual acpi_bus_register_driver() interface.  Actually, it
> > looks like this is already 90% done: acpi_dock_match() does the
> > same thing as is_dock(), so it looks like dock_init() could easily
> > be converted to register as a driver for ACPI_DOCK_HID.
> Maybe what you said is reasonable if the dock/bay device exists and is
> added to Linux ACPI device tree. But if the status of bay/dock device
> doesn't exist , it won't be added into the Linux ACPI device tree. In
> such case the dock/bay driver won't be loaded for it. So it will be
> reasonable to enumerate the acpi tree to install the notification
> function for the dock device so that OS can receive the notification
> event when the dock device is hotplugged. 

If the bay/dock device doesn't exist, we shouldn't need a driver
for it.  The normal scenario for non-ACPI drivers is that we load
a driver when a device appears.  That doesn't work very well in
this case because the ACPI core is missing the "TBD: Handle device
insertion/removal" stuff I mentioned earlier.

I know it's not very useful for me to talk about this without
providing any patches, so I'll shut up now.

Bjorn

