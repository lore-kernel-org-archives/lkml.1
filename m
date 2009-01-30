Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbZA3O33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbZA3O33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 09:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbZA3O3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 09:29:18 -0500
Received: from ns2.suse.de ([195.135.220.15]:47813 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255AbZA3O3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 09:29:17 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] ACPI: add "auto" to acpi_enforce_resources
Date: Fri, 30 Jan 2009 15:29:13 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.13-HEAD_20090130075504_71baee03-default; KDE/4.1.3; x86_64; ; )
Cc: Luca Tettamanti <kronos.it@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       khali@linux-fr.org
References: <20090125210520.GA12963@dreamland.darkstar.lan> <200901291729.24859.trenn@suse.de> <4981FC38.205@redhat.com>
In-Reply-To: <4981FC38.205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901301529.14810.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 January 2009 19:58:00 Hans de Goede wrote:
> Thomas Renninger wrote:
> >>> Either this should be more generic (instead of hardcoded "ATK0110"
> >>> device, use a list to add further specific thermal ACPI drivers). Hmm,
> >>> maybe it's only ASUS violating the spec?
> >>
> >> ASUS it's not actually violating any spec...
> >
> > They have to export the temperature through a thermal ACPI
> > device, not through the ASUS specific ATK0110 device. This is
> > what I mean whether there might be other vendor specific ACPI
> > devices violating the spec (by providing temperature read
> > functionality which should be done through the generic thermal
> > ACPI device).
>
> hwmon IC's monitor far more then just temperatures, ASUS is doing the right
> thing here by providing an ACPI interface to also read voltages and fan
> speeds, so that these can be read in a way that does not interfere with the
> ACPI code.
>
> And although even their interface does not expose the full functionality of
> the hwmon IC's, it is much much better then what the thermal ACPI code
> gives us.
>
> >>> Thinkpads seem to read out extra thermal
> >>> data from EC and shouldn't interfere with hwmon drivers.
> >>
> >> The point is that there is only 1 physical sensor, which both ACPI and
> >> a native driver want to drive; transaction on SMBus to read the sensor
> >> are usually in the form "select bank" + "read" and the sequence is
> >> *not* atomic. In ASUS case the IO ports are correctly reserved by the
> >> firmware, but (historically) this wasn't taken into account.
> >
> > I know about this problem.
> >
> >> Aside from ASUS the problem is generic since there are two drivers
> >> poking at the same hardware; for example there are reports of native
> >> drivers interfering with normal TZ polling (see [1])
> >
> > Yes, this is even worse as the check that you want to add will not
> > catch it.
>
> Ack, so the proper solution would be to just make the
> acpi_enforce_resources strict by default, but this may cause lack of
> functionality for some user who are currently using native drivers for
> hwmon features. Which is why I (hwmon subsytem contributor and Jean Delvare
> (i2c and (ex)hwmon subsystem maintainer) proposed this auto setting as a
> compromise. I'm fine with changing the default to strict, AFAIK Jean
> prefers the auto setting.
>
> <snip>
>
> >> At least eeepc and (some?) thinkpads have ACPI
> >> hwmon capabilities but I don't know whether there are native drivers
> >> available or not (but they could be "blacklisted"  preemptively like
> >> ASUS ATK).
> >
> > I expect that ASUS only will interfere with specific hwmon driver(s)?
>
> Yes only those used on their motherboards, and given the wide range of
> motherboard ASUS produces and they offer the ATK0110 interface on almost
> all of them, it pretty much comes down to "all hwmon and smbus drivers",
> although I'm sure if we look we can find exceptions.
I thought it may only be one specific hwmon driver which could
interfere on ASUS boards with the ATK0110 device. I agree that
it would not make sense to cluster all hwmon drivers.

The problem is similar to the video backlight switching problem
(legacy drivers vs preferred generic ACPI video driver) where
you also must know which driver to take before module loading time.

I hoped to be able to come up with something more clever or say a nicer
solution or at least a short discussion. But I also have no better idea.
Maybe all such code should end up in a drivers/acpi/quirks.c file
at some time, similar to other places in the kernel.

I think it's time for Len looking at this. I wonder whether he will take
this patch or why he won't.
This is an ugly problem which unfortunately needs an ugly fix/check.

This code snippet should be part of your ATK0110 driver then and
not submitted/committed standalone?

Please take me into CC the next time you submit your asus-laptop/acpi driver, 
I like to have a look at it and can also give it a test.

> > So why don't you move the check into the hwmon driver and make it not
> > load on these systems?
> > It's still ugly, but IMO better than to pollute the ACPI core.
>
> Because we do not want to do this in a zillion places when it should be
> done in only one. The right solution is to make acpi_enforce_resources
> strict the default, the auto setting is meant as a slow migration path to
> that right solution, as doing that right now probably will cause lots of
> complaints.


> Actually, the really right solution would be for the ACPI subsystem to
> actually claim all the resources using the regular resource tracking so
> that drivers who want to check for resource conflicts with ACPI do not have
> to explicitly call acpi_check_resource_conflict() (and friends), but
> instead will get an error when trying to claim the resources from the
> regular resource system. However chances are this will break things on
> quite a lot of systems, still it would be the right thing to do in the end
> IMHO.
>
> <snip>
>
> > If this is an ASUS only problem with very specific thermal
> > sensors, better add the quirk at the specific sensor driver.
>
> It is neither ASUS specific, not is it limited to specific hwmon IC's,
> these are not thermal sensors, they are capable of monitoring far more then
> just temperature, which is why the ACPI thermal device interface is
> insufficient.
>
> > PS: I just realize that in ATK0110 the same thermal device
> > (IO port 0x22D) is used as in the generic ACPI device (_TMP).
> > So it looks like your asus thermal driver will not only interfere
> > with the hwmon driver, but with the ACPI thermal driver itself.
>
> I would expect the ACPI code to take care of any conflicts between the
> various interfaces it offers itself. And if it is unsafe to call multiple
> ACPI methods at the same time, I would expect the ACPI core to fix this.
Yes. ACPI can easily make sure that not several resources are accessed at
the same time. It's the ACPI vs native OS code where this is so hard.

    Thomas

> Also note that the above paragraph actually advocates in favour of making
> some kind of change to acpi_enforce_resources. Proposal, what if we change
> the auto setting to not only mean "strict" when an ATK0110 interface is
> present, but also when the ACPI thermal zone interface is present ?
