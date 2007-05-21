Return-Path: <linux-kernel-owner+w=401wt.eu-S1759682AbXEUIeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759682AbXEUIeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 04:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbXEUIeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 04:34:23 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:61169 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbXEUIeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 04:34:22 -0400
Date: Mon, 21 May 2007 02:34:11 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: something strange in libata-core.c for kernel 2.6.22-rc3
In-reply-to: <fa.Ldjy2OubeKomZD0OV2gRm/wpUFo@ifi.uio.no>
To: Tejun Heo <htejun@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>
Cc: l.genoni@oltrelinux.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-id: <46515983.6030206@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.MCe9nCgx+WnsHp+weZyM9LiDF0s@ifi.uio.no>
 <fa.rv8/6n3uBnAIoUHHNUW3eR7cJd8@ifi.uio.no>
 <fa.LXy58QwLlPXDhsfVUU9kEfA3QbI@ifi.uio.no>
 <fa.Ldjy2OubeKomZD0OV2gRm/wpUFo@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> l.genoni@oltrelinux.com wrote:
>> Mybe I am wrong, but if you are detecting 40-wire cable to set them to
>> DMA/33, why the check includes also 80-wire cables configuring them to
>> DMA/33 too?
>>
>> With this patch my nvidia4 IDE controllers detects correctly and
>> configure correctly DMA/100 for my HD and DMA/33 for my DVD (the first
>> uses a 80-wire cable, the second a 40-wire cable).
>>
>> Am I wrong somewhere?
> 
> That's the drive side verification of 80c cable check, so if the
> condition triggers we downgrade 80c or unknown to 40c.  Cable detection
> on nvidia PATA is a disaster.  You're supposed to do some ACPI dancing
> and drive side detection is completely bogus.  Eeeek....
> 
> Alan, did you have a chance to test the ACPI cable detection?  It just
> didn't work when I tried it.  It always returned 80c on my machine.

On a whim I started poking around in the disassembled ACPI DSDT code for 
my Asus A8N-SLI Deluxe board, which is one of these chipsets. The 
original thought was that the STM/GTM trick on these chipsets is 
supposed to allow us to determine what modes we should use based on what 
modes it sets up appropriately. Unfortunately, unless I'm missing 
something in the AML (which is possible) it doesn't seem like there is 
any validation being done on the settings passed in. The settings appear 
to essentially just get programmed into the controller when STM is 
called and read back on GTM. The only complication is some logic on the 
_PTS method (Prepare to Sleep) which stores the current settings into 
some variables, and in STM, if a flag was set by the _PTS method, the 
previous settings for all registers are stored back first before writing 
the requested values into the correct places.

So in this case, obviously the approach used by pata_acpi, etc. won't 
work for cable detection. Whatever magic register on the chipset 
contains the cable detect value, the AML doesn't seem to be accessing 
it. The ACPI spec doesn't really give any guarantee that the "try STM on 
all possible modes" trick will work either, since there seems to be no 
mention of the AML being required to validate the mode and the STM 
function has no return value to indicate failure.

I guess this means that what we have to do is trust that the BIOS set up 
a reasonable mode and base the cable detect on that (either by reading 
back the boot-up controller registers, or by calling GTM). I imagine 
this is what the Windows default IDE driver is doing (just using the 
boot-up mode and feeding it back using GTM/STM on suspend/resume cycles).

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

