Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbYAGOSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbYAGOSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 09:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbYAGOSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 09:18:11 -0500
Received: from hpsmtp-eml17.kpnxchange.com ([213.75.38.117]:33249 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753121AbYAGOSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 09:18:09 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: pnpacpi: exceeded the max number of IO resources: 24
Date: Mon, 7 Jan 2008 15:18:06 +0100
User-Agent: KMail/1.9.7
References: <200712240612.46786.elendil@planet.nl> <200801070048.19468.elendil@planet.nl> <1199682448.2379.12.camel@yakui_zhao.sh.intel.com>
In-Reply-To: <1199682448.2379.12.camel@yakui_zhao.sh.intel.com>
Cc: linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801071518.07039.elendil@planet.nl>
X-OriginalArrivalTime: 07 Jan 2008 14:18:07.0568 (UTC) FILETIME=[1FECA500:01C85138]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Mail below was sent to me privately, forwarding to the lists.)

On Mon, 2008-01-07 at 00:48 +0100, Frans Pop wrote:
> (Adding the kernel list back. Any reason you did not send the reply
> there?)
>
> Sorry for the late reply: Christmas, New Year, the flue, etc.

> Thank you for caring this problem.

> On Friday 28 December 2007, Zhao Yakui wrote:
> > On Mon, 2007-12-24 at 06:12 +0100, Frans Pop wrote:
> > > During boot with v2.6.24-rc6-125-g5356f66 on my Toshiba Satellite
> > > A40 laptop, I suddenly get the following message (repeated 22
> > > times!): pnpacpi: exceeded the max number of IO resources: 24
> > >
> > > Last time I tested 2.6.24 on that box was after the initial merge,
> > > but before -rc1. Then those lines were not present.
> > >
> > > Looks like the messages originate from a7839e96 by Zhao Yakui and
> > > that patch just adds the kernel messages so it was probably a
> > > hidden issue before, but I cannot determine if I should be worried
> > > or not.
> >
> > Thanks for caring this problem.
>
> And thank you for the reply, although I must admit that I'm still
> confused.
>
> > In the patch of a7839e96 the predefined PNP constant is changed. For
> > example: IO is changed from 8 to 24, Mem is changed from 4 to 12.
> > That means that more resources will be obtained from the PNP device
> > defined in ACPI table. So the system will print more message.
>
> OK. The change for Mem from 4 to 12 could explain the extra "iomem
> range" messages (although I don't quite understand why resources that
> "could not be reserved" still use a slot).

The resources of PNP device are obtained by calling the _CRS method.
Maybe some resources has been reserved. For example: Some system will
reserve the following resources.
   BIOS-e820: 00000000fec00000 - 00000000fed40000 (reserved)
   BIOS-e820: 00000000fed45000 - 0000000100000000 (reserved)
So the system will report that some resources can't be reserved.

> I do not yet see how the "ioport range" messages increased from 0 to 16
> is explained, but I'm not too worried about that.
>
> > At the same time another problem maybe happens. If the number of
> > resources defined in BIOS still exceeds the predefined PNP constant,
> > it will report that pnpacpi: exceeded the max number of IO resources:
> > 24. Although it can be fixed by changed the pnp constant bigger, it
> > is inappropriate because it will waste a lot of memory in most cases.
> >
> > Of course the above error message is harmless.
>
> Are the _errors_ really harmless?

The error message is harmless. It only tells us that the resource
definition of PNP device exceeds the predefined PNP constant and maybe
there will be potential problem if some important resources can't be
reserved. For example about 90 IOPORT resources are defined in some PNP
device. So it will print the message. Of course it is more appropriate
to change the message level from ERR to DEBUG.

> Your commit message was:
> "It brings that some resources can't be reserved and resource
> confilicts. This will cause PCI resources are assigned wrongly in some
> systems, and cause hang. This is a regression since we deleted ACPI
> motherboard driver and use PNP system driver."
>
> That text seems to indicate that not reserving the remaining resources
> _can_ cause real problems. Do we know what PCI resources are now not
> being correctly reserved on my laptop (and other machines)? The fact
> that the message is repeated 22 times seems to indicate that in my case
> quite a lot of resources are being ignored.
>
> Should the memory allocation maybe be made dynamic instead of static if
> the memory waste is really such a problem? Apparently the number of PCI
> resources can vary wildly from one machine to another.

It is more appropriate to use dynamic memory allocation for Pnp device
than to increase the PNP constant bigger. Now Thomas is working on it.
Maybe he will submit the patch very soon.

> If the error messages really are harmless, shouldn't they be changed
> from ERR to DEBUG? As it is, the messages are extremely ugly and will
> probably cause a lot of people to file bug reports as it _looks_ like
> there is an error.
