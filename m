Return-Path: <linux-kernel-owner+w=401wt.eu-S1753783AbYJ2MSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbYJ2MSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 08:18:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbYJ2MRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 08:17:52 -0400
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:33046 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbYJ2MRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 08:17:51 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4908547C.4090907@gmail.com>
Date: Wed, 29 Oct 2008 12:18:04 +0000
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: Liam Girdwood <lrg@kernel.org>
CC: felipe.balbi@nokia.com, ext Jonathan Cameron <jic23@cam.ac.uk>,
       eric miao <eric.y.miao@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@sirena.org.uk>
Subject: Re: [Regulator RFC] da903x: Where should usb charge pump support
 go?
References: <4906F500.7080100@cam.ac.uk>	 <20081028112341.GF27144@gandalf.research.nokia.com> <1225195382.28382.168.camel@dell-desktop.example.com>
In-Reply-To: <1225195382.28382.168.camel@dell-desktop.example.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Liam Girdwood wrote:
> On Tue, 2008-10-28 at 13:23 +0200, Felipe Balbi wrote:
>> On Tue, Oct 28, 2008 at 11:18:24AM +0000, ext Jonathan Cameron wrote:
>>> Dear All,
>>>
>>> The new da903x driver is proving to be a good replacement for the out
of kernel
>>> driver I've been using previously.
>>>
>>> Unfortunately there is still quite a lot of functionality to to add.
>>>
>>> The key one for me is control of the USB charge pump. So the question
is, does
>>> this fit within the regulator framework (i.e. should I add it to the
regulator
>>> driver) or should this be a seperate driver (and if so where?)
>>>
>>> Personally I'm not convinced it fits cleanly within the regulator
framework
>>> given it is probably only ever going to get called from one driver
and has
>>> somewhat odd properties!
>> I was thinking the same and even mailed Liam and Mark about it. The
>> design I was thinking was the charger chip would be done in regulator
>> framework and the battery chip (or current gauge) would be using power
>> supply fw and regulator consumer device.
>>
>> The constraints would be basically the current and/or voltage range your
>> charger chip supports.
>>
>> I still didn't have much time to hack on it, but seemed to be pretty
>> reasonable.
>>
>> If someone has better idea, I'd trully like to hear that.
>>
>
> Fwiw, we have done something similar with the wm8350 charger and exposed
> it through the kernel power supply framework. The charger is connected
> directly to the wm8350 line input and not controllable through any
> regulator hence it was not made a regulator consumer.
>
> Jonathan, since this charge pump has an 'odd' interface and one user it
> may just be easier to initially add outwith the framework. It should
> probably live in drivers/mfd with the da903x core.
That sounds a sensible option for now.
> Fwiw, we should look at supporting charge pumps in the regulator
> framework as we already support voltage and current sink regulators.
Seems like a good idea in the long run.

Anyhow, as a quick summary of what the da9030 (don't have the da9034
datasheet to hand) has that isn't currently supported (mainly with
a view to keeping things consistent)

The DC-DC Bucks.
    This is probably just a simple matter of testing the obvious additions
    to the code? (are there any known problems with this?)

USB charge pump.
    Two modes, either 100mA at 5V or 10mA source for SR pulse generation
    (from what I understand this is part of the detection of usb devices)
    There are also 4 detectors vor various voltage and device attachment
    functions.
Sim charge pump.
    Slightly unusual and if not in 5V mode routes through ldo6 and ldo17
    with controllable voltage guarantees (either 1.8V or 2.9V).  Probably
    needs to be tied into the control of these ldo's within the regulator
    driver.

Battery Charger.
    This one is complex.  Supports 40 to 1400mA and 4 to 4.35V supply
    with lots of monitoring.  Has several different operating modes
    and needs a non trivial driver.  This one will be 'interesting'
    to write (have a sand bucket ready and cross your fingers)

ADC
    Used partly for internal monitoring functionality, partly for
    auxiliary inputs.  The question on this is whether to implement
    it as a hwmon driver (somewhat unusual form, but sort of fits)
    or whether some of this is needed for feedback to the battery
    charger code etc.

Anyhow, the only one of critical importance to me is the usb charge pump,
so I'll work on that for now.  I'd  be interested in testing battery charger
code but have too many other drivers to write at the mo to be able to
code that up.

Thanks

Jonathan




