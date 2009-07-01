Return-Path: <linux-kernel-owner+w=401wt.eu-S1753795AbZGAIVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbZGAIVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 04:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbZGAIU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:20:58 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:32909 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbZGAIU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:20:56 -0400
Message-ID: <737c7bd0a2f550d21d45b347d018a1ac.squirrel@www.hardeman.nu>
In-Reply-To: <200906301711.34074.bjorn.helgaas@hp.com>
References: <1246079912-17619-1-git-send-email-david@hardeman.nu>
    <1246079912-17619-2-git-send-email-david@hardeman.nu>
    <20090630141047.c8c79b0b.akpm@linux-foundation.org>
    <200906301711.34074.bjorn.helgaas@hp.com>
Date: Wed, 1 Jul 2009 10:20:59 +0200 (CEST)
Subject: Re: [PATCH 1/2] ACPI: reintroduce acpi_device_ops .shutdown method
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, linux-input@vger.kernel.org,
       jbarnes@virtuousgeek.org, "Len Brown" <lenb@kernel.org>
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, July 1, 2009 01:11, Bjorn Helgaas wrote:
> On Tuesday 30 June 2009 3:10:47 pm Andrew Morton wrote:
>> On Sat, 27 Jun 2009 07:18:31 +0200
>> David Härdeman <david@hardeman.nu> wrote:
>>>
>>> This reintroduces the .shutdown method which is used by the
>>> winbond-cir driver. A normal revert wasn't possible since there
>>> had been other changes to include/acpi/acpi_bus.h since.
>>
>> Len, Bjorn: is this OK?  Or is there some other mechanism which the
>> driver should have used?
>
> I'm on vacation and don't have time to read the new winbond driver
> right now, but maybe it could be changed so that wbcir_shutdown()
> is an internal function called by wbcir_suspend() (as it is already)
> and wbcir_remove().

I didn't want to call wbcir_shutdown from wbcir_remove since wbcir_remove
is called on rmmod and the wbcir_shutdown method programs the chip so that
wake-on-a-specific-ir-command is enabled (and I imagine that people would
expect rmmod to disable the hardware completely). I will clarify the
function names a bit in the next version of the patch...

As far as I could understand from my testing, the acpi .suspend method is
not called during shutdown which is why I needed to hook into both
.suspend and .shutdown separately.

> I hate to re-introduce .shutdown when it's only used by a single
> driver.  That makes me think either we have a bunch of drivers that
> are buggy because they *should* have .shutdown methods but don't,
> or the single user of .shutdown doesn't have a real dependency on it.

I think this single user does have a real dependency because of its
wake-from-poweroff and wake-from-suspend capability. But I could be
mistaken...

> The winbond driver does not use any ACPI-specific functionality, so
> it might be simpler to write it as a PNP driver (which would depend
> on PNPACPI, of course).

As far as I could tell from a quick look at include/linux/pnp.h, a
pnp_driver doesn't seem to have any .shutdown methods either, so I'm not
sure how it would help?

(On a related note, it seems inconsistent to me that platform_driver has a
.shutdown method while pnp_driver and acpi_driver doesn't.)

If you disagree with acpi_driver regaining the .shutdown method I guess
the only options are to use register_reboot_notifier or to rewrite the
driver as a platform_driver (Alan Cox seemed to suggest earlier that the
driver was not a good fit for a platform driver).

> Nice looking driver, by the way.  Even from a cursory glance it's
> obvious that you've taken a lot of care with it.

Thank you, and have a nice vacation.

Regards,
David


