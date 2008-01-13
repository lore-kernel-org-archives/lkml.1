Return-Path: <linux-kernel-owner+w=401wt.eu-S1752859AbYAMOl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbYAMOl0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 09:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYAMOlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 09:41:18 -0500
Received: from smtp-100-sunday.noc.nerim.net ([62.4.17.100]:4794 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751058AbYAMOlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 09:41:17 -0500
Date: Sun, 13 Jan 2008 15:41:14 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Jon Smirl" <jonsmirl@gmail.com>
Cc: linuxppc-dev@ozlabs.org, i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [i2c] [PATCH 1/5] Implement module aliasing for i2c to
 translate from device tree names
Message-ID: <20080113154114.4a1c5166@hyperion.delvare>
In-Reply-To: <9e4733910801120826haa8905dk863ed1c8e9f420c9@mail.gmail.com>
References: <20071220044136.20091.70984.stgit@terra.home>
	<20071220044138.20091.31417.stgit@terra.home>
	<20080111202015.65c3c160@hyperion.delvare>
	<20080112094658.197acb08@hyperion.delvare>
	<9e4733910801120826haa8905dk863ed1c8e9f420c9@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

On Sat, 12 Jan 2008 11:26:34 -0500, Jon Smirl wrote:
> The common scheme used elsewhere in the kernel for handling more than
> one device in a single driver is aliases. The i2c code's existing
> driver_name/type combination is a different way of implementing the
> same feature. But there is no real need for driver_name/type on any
> platform if aliases are used. Back in version 10 or 11 I had code in
> there which replaced the two fields with aliases on all platforms but
> too many people objected so I removed it..

While I agree that aliases make i2c_client.driver_name obsolete,
i2c_client.type is still needed. Not for device/driver matching in the
kernel, granted, but for device identification from userspace. This is
a first problem your patch has: when using your aliasing mechanism, the
type string is left empty. i2c-core exports this value to user-space
via the "name" sysfs attribute, and some libraries and applications
make use of it. I know of libsensors at least, but I guess there are
more. I can't apply your patch until this problem is solved, otherwise
we would break some user-space applications.

> IMHO, driver_name/type should be removed in new style drivers and
> replaced with aliases on all platforms since aliases are the standard
> kernel mechanism.

I agree. But we can take your aliasing code now (once you have
addressed the issues I raised) and convert the users of driver_name
later; it doesn't have to be done all at once.

The second problem I have with your patch is that you make use of the
driver_name field, while I ultimately want to get rid of it. I'd rather
see you use a different field for aliases, so that the later removal of
the driver_name field and the associated mechanism is easier.

A third, related problem, is the contents of the modalias file when
using your patch. When I tested on my ADM1032 evaluation board, the
modalias contained "adm1032". This isn't a valid module alias string:
"modprobe adm1032" doesn't work. What works is "modprobe i2c:Nadm1032"
so the modalias file should contain "i2c:Nadm1032". Just take a look at
all modalias files in /sys, they all include the subsystem prefix and a
simple modprobe `cat modalias` loads the required driver. I fail to see
why the i2c subsystem would be different.

I said this is related to the second problem because right now,
i2c-core can't easily differentiate between driver names and aliases,
as both are stored in i2c_client.driver_name. Having separate fields
would make it possible (and relatively easy) to add the required prefix
before aliases but not before driver names. The only drawback is that
it will increase the size of the i2c_client structure, but I do not
care that much given that it is only temporary.

-- 
Jean Delvare
