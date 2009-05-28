Return-Path: <linux-kernel-owner+w=401wt.eu-S1758879AbZE1OOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879AbZE1OOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 10:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbZE1ONy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 10:13:54 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:35255 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbZE1ONx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 10:13:53 -0400
MIME-Version: 1.0
In-Reply-To: <gvlvcs$ub5$1@ger.gmane.org>
References: <20090527175609.GB31861@flint.arm.linux.org.uk> 
	<1243496236.3171.140.camel@pasglop> <20090528091513.GA14789@n2100.arm.linux.org.uk> 
	<20090528.025739.16559619.davem@davemloft.net> <gvlvcs$ub5$1@ger.gmane.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 28 May 2009 08:13:34 -0600
Message-ID: <fa686aa40905280713u2b3ef5fvbe3d58ccdb629b60@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@ozlabs.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 6:17 AM, Dmitry Eremin-Solenikov
<dbaryshkov@gmail.com> wrote:
> David Miller wrote:
>
>> From: Russell King - ARM Linux
>> <linux@arm.linux.org.uk> Date: Thu, 28 May 2009
>> 10:15:13 +0100
>>
>>> For example, how would an IrDA transceiver be expressed in OF?
>>
>> As a child device node of the IRDA device, with associated properties.
>>
>> You can express _ANYTHING_ using the OF device tree.  It is not even
>> something to discuss, it's flexible enough.
>
> Hmmm. How to express the following situation:
> On one of my platforms (sharp tosa) the backlight controller
> is separated into two parts: one sitting on SPI, one on the I2C.
> The tricky part is that the I2C part is only available when some
> of registers of SPI part are programmed in a specific way.

Perhaps something like this (in dts format):

spi@[someaddress] {
        #size-cells = <0>;
        #address-cells = <1>;
        compatible = "name-of-spi-bus-device";
        reg = <[someaddress] [size]>;
        backlight-spi: backlight@5 {
                compatible = "sharp,backlight-spi";
                reg = <5>;  /* CS line # 5 */
        }
}

i2c@[anotheraddress] {
        #size-cells = <0>;
        #address-cells = <1>;
        compatible = "name-of-i2c-bus-device";
        reg = <[anotheraddress] [size]>;
        backlight@30 {
                compatible = "sharp,backlight-i2c";
                reg = <30>;
                spi-interface-phandle = < &backlight-spi >;
        }
}

Two nodes are used to describe the device and a "phandle" is used to
link them.  A device driver probe could be triggered (bind) against
the i2c half of the device and follow the phandle to get the rest of
the description.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
