Return-Path: <linux-kernel-owner+w=401wt.eu-S1758721AbYBXQTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbYBXQTh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 11:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbYBXQT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 11:19:29 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:51963 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbYBXQT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 11:19:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ALqgxRD8PugSQpRCDeaTyzXXHZ023c8YXNgAyHZz477sVcUzt7jblPEgqrxSIdAPi5X9srSXYWRh6dXMJqcTlj2PA6nboJTj0dk6JB0CcYPgVoDtunY7wtbNRpif0CqsQx7ubU2hLhhU9kemDtPXnecDZuho9j4XVCdxBpSEVS8=
Message-ID: <9e4733910802240819w70b1846ftea776495016567fc@mail.gmail.com>
Date: Sun, 24 Feb 2008 11:19:28 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [PATCHv4 2.6.25] i2c: adds support for i2c bus on Freescale CPM1/CPM2 controllers
Cc: "Jochen Friedrich" <jochen@scram.de>, linux-kernel@vger.kernel.org,
       "linuxppc-dev list" <linuxppc-dev@ozlabs.org>, i2c@lm-sensors.org,
       "Scott Wood" <scottwood@freescale.com>
In-Reply-To: <47BEAF00.50106@scram.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47A1C4E9.4000003@scram.de>
	 <20080221130520.12b01553@hyperion.delvare> <47BEAF00.50106@scram.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/08, Jochen Friedrich <jochen@scram.de> wrote:
> Hi Jean,
>
>
>  >> +/*
>  >> + * Wait for patch from Jon Smirl
>  >> + * #include "powerpc-common.h"
>  >> + */
>  >
>  > It doesn't make sense to merge this comment upstream.
>
>
> I know you don't like the patch from Jon Smirl and you also explained your reasons.
>  Fortunately, I2c no longer uses numeric device IDs but names. So what are the alternatives?
>
>  1. modify the I2c subsystem to accept OF names additionally to I2c names (proposed by Jon smirl).

The correct statement is: modify the i2c subsystem to support the
standard kernel driver aliasing mechanism. Leaving powerpc and OF out
of the argument for the moment, i2c has a custom aliasing scheme on
the x86 too.

So as a first step, can we remove the custom i2c aliasing scheme and
change i2c to use standard module aliases on the x86? Patches for this
already exist.

On 2/23/08, Jean Delvare <khali@linux-fr.org> wrote:
> The problem I have with this is that it breaks compatibility. The chip
>  name is not only used for device/driver matching, it is also exported
>  to userspace as a sysfs attribute ("name"). Applications might rely on
>  it. At least libsensors does.

I think there is some confusion here. The OF aliases are only used by
the kernel to load the correct driver. Would doing something like this
help?

static struct i2c_device_id pcf8563_id[] = {
	{"pcf8563", 0, "sysfs_legacy_name"},
	{"rtc8564", 0, "sysfs_legacy_name"},
	OF_ID("phillips,pcf8563", &pcf8563_id[0], 0)
	OF_ID("epson,rtc8564", &pcf8563_id[1], 0)
	{},
};
MODULE_DEVICE_TABLE(i2c, pcf8563_id);

Then in the probe function you can use the pointer to find the base id
entry and i2c never has to be aware that the OF alias exists.

>  2. record the I2c name in the dts tree, either as separate tag (like linux,i2c-name="<i2c-name>")

Not really practical for the millions of machines (all PowerPC Macs)
already shipped.

>    or as additional compatible entry (like compatible="...", "linux,<i2c-name>").
>  3. use a glue layer with a translation map.

Audio codecs have exactly the same problem. There are probably other
devices that also need mapping.

This mapping table will need to contain a map from the OF names to the
kernel driver names.  It will need to stored permanently in RAM and
contain all possible mappings. This table will only grow in size.

The kernel has a widely used mechanism for mapping -- aliases in the
device drivers. Why do we want to build a new, parallel one?

What we are doing now is option 4.

4. Use kconfig to build custom kernels for each target system. Don't
load drivers automatically based on what the BIOS tells us.

-- 
Jon Smirl
jonsmirl@gmail.com
