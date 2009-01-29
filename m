Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbZA2Vbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbZA2Vbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 16:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZA2Vbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 16:31:41 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:41674 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbZA2Vbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 16:31:39 -0500
Date: Thu, 29 Jan 2009 22:31:27 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Thomas Renninger <trenn@suse.de>, Luca Tettamanti <kronos.it@gmail.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] ACPI: add "auto" to acpi_enforce_resources
Message-ID: <20090129223127.27bec9c9@hyperion.delvare>
In-Reply-To: <4981FC38.205@redhat.com>
References: <20090125210520.GA12963@dreamland.darkstar.lan>
	<200901291130.35434.trenn@suse.de>
	<68676e00901290716g1aabd6c0p1e5202fbdbc659a4@mail.gmail.com>
	<200901291729.24859.trenn@suse.de>
	<4981FC38.205@redhat.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009 19:58:00 +0100, Hans de Goede wrote:
> Thomas Renninger wrote:
> >>> Either this should be more generic (instead of hardcoded "ATK0110"
> >>> device, use a list to add further specific thermal ACPI drivers). Hmm,
> >>> maybe it's only ASUS violating the spec?
> >> ASUS it's not actually violating any spec...
> > They have to export the temperature through a thermal ACPI
> > device, not through the ASUS specific ATK0110 device. This is
> > what I mean whether there might be other vendor specific ACPI
> > devices violating the spec (by providing temperature read
> > functionality which should be done through the generic thermal
> > ACPI device).
> > 
> 
> hwmon IC's monitor far more then just temperatures, ASUS is doing the right 
> thing here by providing an ACPI interface to also read voltages and fan speeds, 
> so that these can be read in a way that does not interfere with the ACPI code.
> 
> And although even their interface does not expose the full functionality of the 
> hwmon IC's, it is much much better then what the thermal ACPI code gives us.
> 
> >>> Thinkpads seem to read out extra thermal
> >>> data from EC and shouldn't interfere with hwmon drivers.
> >> The point is that there is only 1 physical sensor, which both ACPI and
> >> a native driver want to drive; transaction on SMBus to read the sensor
> >> are usually in the form "select bank" + "read" and the sequence is
> >> *not* atomic. In ASUS case the IO ports are correctly reserved by the
> >> firmware, but (historically) this wasn't taken into account.
> > I know about this problem.
> > 
> >> Aside from ASUS the problem is generic since there are two drivers
> >> poking at the same hardware; for example there are reports of native
> >> drivers interfering with normal TZ polling (see [1])
> > Yes, this is even worse as the check that you want to add will not
> > catch it.
> 
> Ack, so the proper solution would be to just make the acpi_enforce_resources 
> strict by default, but this may cause lack of functionality for some user who 
> are currently using native drivers for hwmon features. Which is why I (hwmon 
> subsytem contributor and Jean Delvare (i2c and (ex)hwmon subsystem maintainer) 
> proposed this auto setting as a compromise. I'm fine with changing the default 
> to strict, AFAIK Jean prefers the auto setting.
> 
> <snip>
> 
> >> At least eeepc and (some?) thinkpads have ACPI
> >> hwmon capabilities but I don't know whether there are native drivers
> >> available or not (but they could be "blacklisted"  preemptively like
> >> ASUS ATK).
> > I expect that ASUS only will interfere with specific hwmon driver(s)?
> 
> Yes only those used on their motherboards, and given the wide range of 
> motherboard ASUS produces and they offer the ATK0110 interface on almost all of 
> them, it pretty much comes down to "all hwmon and smbus drivers", although I'm 
> sure if we look we can find exceptions.
> 
> > So why don't you move the check into the hwmon driver and make it not
> > load on these systems?
> > It's still ugly, but IMO better than to pollute the ACPI core.
> > 
> 
> Because we do not want to do this in a zillion places when it should be done in 
> only one. The right solution is to make acpi_enforce_resources strict the 
> default, the auto setting is meant as a slow migration path to that right 
> solution, as doing that right now probably will cause lots of complaints.
> 
> Actually, the really right solution would be for the ACPI subsystem to actually 
> claim all the resources using the regular resource tracking so that drivers who 
> want to check for resource conflicts with ACPI do not have to explicitly call
> acpi_check_resource_conflict() (and friends), but instead will get an error 
> when trying to claim the resources from the regular resource system. However 
> chances are this will break things on quite a lot of systems, still it would be 
> the right thing to do in the end IMHO.
> 
> <snip>
> 
> > If this is an ASUS only problem with very specific thermal
> > sensors, better add the quirk at the specific sensor driver.
> > 
> 
> It is neither ASUS specific, not is it limited to specific hwmon IC's, these 
> are not thermal sensors, they are capable of monitoring far more then just 
> temperature, which is why the ACPI thermal device interface is insufficient.
> 
> > PS: I just realize that in ATK0110 the same thermal device
> > (IO port 0x22D) is used as in the generic ACPI device (_TMP).
> > So it looks like your asus thermal driver will not only interfere
> > with the hwmon driver, but with the ACPI thermal driver itself.
> 
> I would expect the ACPI code to take care of any conflicts between the various 
> interfaces it offers itself. And if it is unsafe to call multiple ACPI methods 
> at the same time, I would expect the ACPI core to fix this.

For the records, I second everything Hans wrote above.

> Also note that the above paragraph actually advocates in favour of making some 
> kind of change to acpi_enforce_resources. Proposal, what if we change the auto 
> setting to not only mean "strict" when an ATK0110 interface is present, but 
> also when the ACPI thermal zone interface is present ?

I expect problems if you do that without any exception. There are a
number of desktop motherboards out there with pretty broken TZ
implementations. To mention just one, my Jetway K8M8MS motherboard has a
TZ which reports 9 degrees C all the time. I disassembled the DSDT to
find out that the code is incorrect and they are reading a
configuration register instead of the temperature register. Apparently
customers didn't care at all, as this was never fixed. I reported to
Jetway but didn't get any answer.

More generally, the ACPI thermal zone doesn't provide a tenth of the
functionality of native hardware monitoring drivers on desktop and
server systems. So switching to strict when a thermal zone is found
would be as painful as switching to strict unconditionally, in that it
will cause a loss of functionality for many users out there. Whoever
does this will first have to become the i2c maintainer and the hwmon
maintainer, and then take all the flames. That won't be me for sure.

Thanks,
-- 
Jean Delvare
