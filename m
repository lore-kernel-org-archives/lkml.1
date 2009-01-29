Return-Path: <linux-kernel-owner+w=401wt.eu-S1758218AbZA2Q3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbZA2Q3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 11:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbZA2Q32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 11:29:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:46230 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbZA2Q31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 11:29:27 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Luca Tettamanti <kronos.it@gmail.com>
Subject: Re: [PATCH] ACPI: add "auto" to acpi_enforce_resources
Date: Thu, 29 Jan 2009 17:29:23 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.11-HEAD_20090116074536_2c57617f-default; KDE/4.1.3; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Hans de Goede <hdegoede@redhat.com>, Len Brown <lenb@kernel.org>,
       khali@linux-fr.org
References: <20090125210520.GA12963@dreamland.darkstar.lan> <200901291130.35434.trenn@suse.de> <68676e00901290716g1aabd6c0p1e5202fbdbc659a4@mail.gmail.com>
In-Reply-To: <68676e00901290716g1aabd6c0p1e5202fbdbc659a4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901291729.24859.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 January 2009 16:16:38 Luca Tettamanti wrote:
> On Thu, Jan 29, 2009 at 11:30 AM, Thomas Renninger <trenn@suse.de> wrote:
> > On Sunday 25 January 2009 22:05:20 Luca Tettamanti wrote:
> >> (This is an improved version of my earlier patch, I've reworked deviced
> >> detection to simply check for the desired HID)
> >>
> >> The following patch adds "auto" option to "acpi_enforce_resource"; this
> >> value is also the new default.
> >> "auto" enforces strict resource checking - disallowing access by native
> >> drivers to IO ports and memory regions claimed by ACPI firmware - when a
> >> device with a known ACPI driver is found (currently only ASUS ATK0110 is
> >> checked), and reverts to lax checking otherwise.
> >>
> >> The patch is mainly aimed to block native hwmon drivers from touching
> >> monitoring chips that ACPI thinks it own.
> >
> > Having this in the core ACPI code is ugly.
>
> I think we all agree :-)
>
> > Either this should be more generic (instead of hardcoded "ATK0110"
> > device, use a list to add further specific thermal ACPI drivers). Hmm,
> > maybe it's only ASUS violating the spec?
>
> ASUS it's not actually violating any spec...
They have to export the temperature through a thermal ACPI
device, not through the ASUS specific ATK0110 device. This is
what I mean whether there might be other vendor specific ACPI
devices violating the spec (by providing temperature read
functionality which should be done through the generic thermal
ACPI device).

> > Thinkpads seem to read out extra thermal
> > data from EC and shouldn't interfere with hwmon drivers.
>
> The point is that there is only 1 physical sensor, which both ACPI and
> a native driver want to drive; transaction on SMBus to read the sensor
> are usually in the form "select bank" + "read" and the sequence is
> *not* atomic. In ASUS case the IO ports are correctly reserved by the
> firmware, but (historically) this wasn't taken into account.
I know about this problem.

> Aside from ASUS the problem is generic since there are two drivers
> poking at the same hardware; for example there are reports of native
> drivers interfering with normal TZ polling (see [1])
Yes, this is even worse as the check that you want to add will not
catch it. Looking a bit through ASUS DSDTs this seem to be common
on most of them. I put some example DSDT code of a recent M2A-VM-HDMI
workstation at the end.

> The EC does not
> make any difference, since a native driver would speak directly to the
> monitoring chip, effectively by-passing the EC.
> Now, in principle "strict" is the correct behaviour for the resource
> checking code, but it would break many working setups leaving the
> users without any kind of hw monitoring. The "auto" hack is meant to
> force the users to migrate to the ACPI driver...
>
> > Are there other known, model specific ACPI devices,
> > accessing thermal IOs directly which could interfere with hwmon, then it
> > might be worth it.
>
> Right now "auto" is ASUS-specific because *I* know that there any many
> different native drivers that works on various boards (and I wrote the
> the ACPI driver...);
Hmm, grep -r ATK0110 drivers/platform/x86 in latest ACPI test tree is
empty, can you give me a pointer to a recent version of your driver.

> At least eeepc and (some?) thinkpads have ACPI
> hwmon capabilities but I don't know whether there are native drivers
> available or not (but they could be "blacklisted"  preemptively like
> ASUS ATK).
I expect that ASUS only will interfere with specific hwmon driver(s)?
So why don't you move the check into the hwmon driver and make it not
load on these systems?
It's still ugly, but IMO better than to pollute the ACPI core.

Here some thermal DSDT parts of a recent ASUS machine:

The temperature exported through the generic thermal ACPI device:

    OperationRegion (IP, SystemIO, 0x022D, 0x02)
    Field (IP, ByteAcc, NoLock, Preserve)
    {
        INDX,   8,
        DAT0,   8
    }

    Method (SBYT, 2, NotSerialized)
    {
        Store (Arg0, INDX)
        Store (Arg1, DAT0)
    }

    Method (GBYT, 1, NotSerialized)
    {
        Store (Arg0, INDX)
        Store (DAT0, Local0)
        Return (Local0)
    }

Method (_TMP, 0, NotSerialized)
    {
    /* makes use of RTMP which uses GBYT and SBYT to actually read
       the temp
    */
    }

There is another RTMP function in ATK0110 (do you use that?)
The other RTMP in ATK0110 seem to use this IO area to read out
the temperatures (MBTE and TSR1, for mainboard and CPU temp?):

                OperationRegion (HWRE, SystemIO, 0x022D, 0x02)
                Field (HWRE, ByteAcc, NoLock, Preserve)
                {
                    HIDX,   8,
                    HDAT,   8
                }

                IndexField (HIDX, HDAT, ByteAcc, NoLock, Preserve)
                {
                            Offset (0x0B),
                    FD11,   3,
                    FD12,   3,
                    FD13,   1,
                            Offset (0x0C),
                            Offset (0x0D),
                    FAN1,   8,
                    FAN2,   8,
                            Offset (0x18),
                    FEN1,   8,
                    FEN2,   8,
                            Offset (0x20),
                    VCOR,   8,
                    V33V,   8,
                            Offset (0x23),
                    V50V,   8,
                    V12V,   8,
                            Offset (0x29),
                    TSR1,   8,
                    MBTE,   8,
                            Offset (0x80),
                    FAN3,   8,
                    FEN3,   8
                }

Can the hwmon people identify which hwmon driver is used
for above devices and the ATK0110 check be inserted there.

On the M2A-VM-HDMI machine where DSDT extracts from above are,
running libsensors I get:

Driver `it87' (should be inserted):
  Detects correctly:
  * ISA bus, address 0x228
    Chip `ITE IT8716F Super IO Sensors' (confidence: 9)

Driver `to-be-written' (should be inserted):
  Detects correctly:
  * Chip `AMD K10 thermal sensors' (confidence: 9)

If this is an ASUS only problem with very specific thermal
sensors, better add the quirk at the specific sensor driver.

If this is something general, then maybe you can convince Len
to add something to the ACPI core, but this should be more
generic then.

      Thomas

PS: I just realize that in ATK0110 the same thermal device
(IO port 0x22D) is used as in the generic ACPI device (_TMP).
So it looks like your asus thermal driver will not only interfere
with the hwmon driver, but with the ACPI thermal driver itself.
