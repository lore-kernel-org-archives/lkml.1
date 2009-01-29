Return-Path: <linux-kernel-owner+w=401wt.eu-S1759339AbZA2PQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339AbZA2PQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 10:16:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbZA2PQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 10:16:43 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:34743 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbZA2PQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 10:16:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LRWGg4FrSaLVthbEg8en6Er95Kbt9eE+PkNSelbrCAKm7KA78+/QnM0CgB/KTyYrAb
         4dscF6fa47uMvmvyNWiyyC9q0oZtcRL/4gAm7m5gxyWPCfMXJ3hD7+i2a/gaswsPzOm2
         JoSWn3lgJYvA3cmSmIPglIR5QHlYBZjOxTnK8=
MIME-Version: 1.0
In-Reply-To: <200901291130.35434.trenn@suse.de>
References: <20090125210520.GA12963@dreamland.darkstar.lan>
	 <200901291130.35434.trenn@suse.de>
Date: Thu, 29 Jan 2009 16:16:38 +0100
Message-ID: <68676e00901290716g1aabd6c0p1e5202fbdbc659a4@mail.gmail.com>
Subject: Re: [PATCH] ACPI: add "auto" to acpi_enforce_resources
From: Luca Tettamanti <kronos.it@gmail.com>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Hans de Goede <hdegoede@redhat.com>, Len Brown <lenb@kernel.org>,
       khali@linux-fr.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 11:30 AM, Thomas Renninger <trenn@suse.de> wrote:
> On Sunday 25 January 2009 22:05:20 Luca Tettamanti wrote:
>> (This is an improved version of my earlier patch, I've reworked deviced
>> detection to simply check for the desired HID)
>>
>> The following patch adds "auto" option to "acpi_enforce_resource"; this
>> value is also the new default.
>> "auto" enforces strict resource checking - disallowing access by native
>> drivers to IO ports and memory regions claimed by ACPI firmware - when a
>> device with a known ACPI driver is found (currently only ASUS ATK0110 is
>> checked), and reverts to lax checking otherwise.
>>
>> The patch is mainly aimed to block native hwmon drivers from touching
>> monitoring chips that ACPI thinks it own.
>
> Having this in the core ACPI code is ugly.

I think we all agree :-)

> Either this should be more generic (instead of hardcoded "ATK0110" device,
> use a list to add further specific thermal ACPI drivers). Hmm, maybe it's
> only ASUS violating the spec?

ASUS it's not actually violating any spec...

> Thinkpads seem to read out extra thermal
> data from EC and shouldn't interfere with hwmon drivers.

The point is that there is only 1 physical sensor, which both ACPI and
a native driver want to drive; transaction on SMBus to read the sensor
are usually in the form "select bank" + "read" and the sequence is
*not* atomic. In ASUS case the IO ports are correctly reserved by the
firmware, but (historically) this wasn't taken into account.
Aside from ASUS the problem is generic since there are two drivers
poking at the same hardware; for example there are reports of native
drivers interfering with normal TZ polling (see [1]). The EC does not
make any difference, since a native driver would speak directly to the
monitoring chip, effectively by-passing the EC.
Now, in principle "strict" is the correct behaviour for the resource
checking code, but it would break many working setups leaving the
users without any kind of hw monitoring. The "auto" hack is meant to
force the users to migrate to the ACPI driver...

> Are there other known, model specific ACPI devices,
> accessing thermal IOs directly which could interfere with hwmon, then it
> might be worth it.

Right now "auto" is ASUS-specific because *I* know that there any many
different native drivers that works on various boards (and I wrote the
the ACPI driver...); At least eeepc and (some?) thinkpads have ACPI
hwmon capabilities but I don't know whether there are native drivers
available or not (but they could be "blacklisted"  preemptively like
ASUS ATK).


Luca
[1] http://www.lm-sensors.org/ticket/2072 and:
http://thread.gmane.org/gmane.linux.drivers.sensors/12359
