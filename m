Return-Path: <linux-kernel-owner+w=401wt.eu-S1765671AbXGTOXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765671AbXGTOXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 10:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760565AbXGTOWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 10:22:51 -0400
Received: from ns2.suse.de ([195.135.220.15]:50281 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760319AbXGTOWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 10:22:50 -0400
Subject: Re: [PATCH - 0/2] Identify native drivers and ACPI subsystem
	accessing the same resources
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Bernhard Walle <bwalle@suse.de>,
       "Starikovskiy, Alexey Y" <aystarik@gmail.com>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
       Jean Delvare <khali@linux-fr.org>
In-Reply-To: <1184939687.15328.206.camel@queen.suse.de>
References: <1184331492.3960.100.camel@d88.suse.de>
	 <200707131056.46193.bjorn.helgaas@hp.com>
	 <1184781038.15328.109.camel@queen.suse.de>
	 <200707181610.43418.bjorn.helgaas@hp.com>
	 <1184939687.15328.206.camel@queen.suse.de>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Fri, 20 Jul 2007 16:22:04 +0200
Message-Id: <1184941324.15328.222.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-20 at 15:54 +0200, Thomas Renninger wrote:
> On Wed, 2007-07-18 at 16:10 -0600, Bjorn Helgaas wrote:
> > On Wednesday 18 July 2007 11:50:38 am Thomas Renninger wrote:
> > > On Fri, 2007-07-13 at 10:56 -0600, Bjorn Helgaas wrote:
> > > > The PNP core does not request resources for devices that are active
> > > > at boot.  Those resources currently don't get requested until a driver
> > > > claims the device.  I think this is a bug that we should fix.
> > > Yep, this is also a problem for the ACPI variables (in fact not really,
> > > as long as not overlapping like the rtc resource) and probably the
> > > reason why pnpacpi ignores addresses below 0x100?
> > 
> > By "ACPI variables," do you mean PM1a_EVT_BLK and the like?  Those
> > should be subsets of the _CRS resources for some device.
> No, I mean SystemIO OperationRegion declarations, like:
> OperationRegion (IOID, SystemIO, 0x2E, 0x02)
> Field (IOID, ByteAcc, NoLock, Preserve)
> {
>      INDX,   8, 
>      DATA,   8
> }
> It may happen that you see e.g.:
> 0080-008f : dma page reg     # statically requested early in setup.c
>   0080-0080 : ACPI DEB0      # ACPI SystemIO OperationRegion
>                              # requested at ACPI table parse time
> 
> It's not nice..., but also does not hurt, as long as those do not
> overlap. Even if these overlap the ACPI region/variable just won't be
> able to reserve the region, not perfect, but better than before when
> ACPI regions/variables were simply ignored.
> 
> > > IMO:
> > >   - Making sure ACPI claimed regions do not interfere with native
> > >     drivers is very important and will get much more important in near 
> > >     future
> > 
> > I agree with this.  I know some of these native drivers (lm-sensors, etc)
> > are pretty essential right now.  But they just aren't safe because they
> > use resources that ACPI thinks it owns.  I think the drivers should be
> > changed to explicitly override (with appropriate KERN_WARN messages)
> > any prior ACPI resource reservations.
> > 
> > > > >     The rtc driver seems to request the whole rtc space (0x70-0x77)
> > > > >     which fails because 0x72-0x73 has already been requested SHARED by
> > > > >     an ACPI SystemIO variable. At least parts of the rtc space got
> > > > >     requested (rtc0), I haven't checked whether the device was working
> > > > >     correctly...
> > > > 
> > > > I tripped over a couple of these when I changed the PNP core to request
> > > > resources for active devices.  The RTC is one; often BIOS says the RTC
> > > > is at 0x70-0x71 and 0x72-0x73, but the rtc drivers like to claim 0x8
> > > > (RTC_IO_EXTENT) ports.  However, I think the driver only *uses* two
> > > > ports, so we should change the driver to only request what it is
> > > > using.
> > 
> > > But there could be more?
> > 
> > I think the PNP core should request all the ports the device responds
> > to (as reported by the BIOS).  The driver should request only the ports
> > it uses.  If the rtc driver only uses two ports, there's no reason for
> > it to request all eight.
> > 
> > > Argggggh, normally it should be:
> > > 5000-50fe : ACPI PMIO
> > > ...
> > >   50c0-50df : pnp 00:07
> > >   50e0-50ff : pnp 00:07       # this one is missing because
> > >                               # it's bigger than the parent
> > >     50e0-50ef : amd756_smbus
> > 
> > IMO, this is backwards.  "pnp 00:07" should be the parent and should
> > be reserved by the PNP core.  A side-effect of this is that
> > drivers/pnp/system.c would not be needed at all.
> 
> This patch is about to reserve the ACPI regions/variables (see the AML
> descriptions at the beginning).
> If I interpreted the code and your comment right, only PNP0c02 and
> PNP0c01 is served (reserved) by pnpacpi layer currently (didn't see this
> first). And you want to let pnpacpi reserve all ACPI device specific
> resources (_CRS)? This should be done by removing system.c and the
> interface to identify specific PNP devices (probe, device_id,..), but
> just check for a _CRS function for all ACPI devices in
> drivers/pnp/pnpacpi/core.c and reserve the resources.
> IMO yes, this should be done and would be the first step.
> Also reserve ACPI variables/OperationRegions, this is one is for, would
> be the second step (and needs some more rework anyway).
> 
> I am off for a week, but will read and try out a bit more.
> The next iteration will take some days (please stop me if you already
> see some undoable hurdles that I may have overseen)...
> 
> Thanks a lot Bjorn, for the detailed review and all your input.
> 
>     Thomas
> 
> > > > > Summary:
> > > > > ...
> > > > >   - Not fixable (maybe someone has an idea): If ACPI IO region declares
> > > > >     a smaller IO part than the later native driver (e.g. example above
> > > > >     with rtc driver), the partially overlapping resource cannot be
> > > > >     registered and the native driver fails to load with strict and lax
> > > > >     option.
> > > > 
> > > > Assuming the BIOS describes the region correctly, I'd say a driver
> > > > that claims a larger region is buggy and should be fixed.
> > > 
> > > Yep, but a temporary solution where everything just works fine and a
> > > message: "This driver needs fixing" is needed IMO (if the code gets
> > > accepted... It's possible, but ...).
> > 
> > How about something like this:  We fix all the native drivers we know
> > about.  We make the PNP and ACPI cores request resources for all active
> > devices by default, but add a flag like "pnp=no_reservations" that turns
> > this off.  Then native drivers that request conflicting resources
> > will fail, but the user can limp along by using the boot-time option.
> 
> Yes sounds good.
> What I wanted to do is to also reserve the OperationRegions. I didn't
> realize that pnp layer only reserves resources for specific devices and
> this should be done first (reserve all).
> I am pretty sure arbitrary AML code using variables from
> OperationRegions can still be outside device specific resources and we
> need to reserve those too (or at least have a boot option to identify
> possible interference) to make sure ACPI interpreted code does not clash
> with native drivers or at least identify which drivers potentially
> interfere.
> However, this needs an ugly implementation (extension of
> kernel/resources.c) because those could partly overlap with device
> specific ACPI resources (the pnp ones):
> 
> 5000-50fe : ACPI PMIO   # ACPI variable/OperationRegion -> for ASL 
>                         # example definition, see beginning of the mail
>  ...
>   50c0-50df : pnp 00:07  # These two are device specific ACPI resources
>   50e0-50ff : pnp 00:07  # This one's end address overlaps by one byte
>                          # with its parent -> must get accepted
>      50e0-50ef : amd756_smbus
> 
> Then you'd have the pnp (pnpacpi only) and ACPI
> variables/OperationRegions that should always be the parents (where the
> variables are the parents of the pnpacpi resources) and those are
> allowed to overlap and represent/reserve all ACPI resources.

Another idea just came to my mind:
Not reserving the ACPI variables/OperationRegions at all in
kernel/resources.c. Instead store these in a list in drivers/acpi/osl.c
as I've already done and add something at the beginning of:
kernel/resources.c:request_region()
like (pseudo-code):
#ifdef ACPI
    err = check_for_acpi_operation_region_clashes(struct *resource)
    if (err)
	...
#endif
this should be the most unintrusive way, (nearly) not polluting
kernel/resources.c
and in drivers/acpi/osl.c:
check_for_acpi_operation_region_clashes(struct *resource){
   ...
   if (clash)
      if (acpi_enforce_resources == LAX)
          pr_info ("Resource %s might interfere with ACPI"
                   " Operation region %s\n", ...);
          return no_error;
      else {
          printk (KERN_ERR "Resource %s interferes with ACPI"
                   " Operation region %s\n", ...);
          return error;
      }
 ...
}

Will try a bit more..., I will still read mails next week...

Thanks,

    Thomas

