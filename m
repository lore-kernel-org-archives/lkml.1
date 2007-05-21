Return-Path: <linux-kernel-owner+w=401wt.eu-S1759778AbXEUSP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759778AbXEUSP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 14:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756598AbXEUSPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 14:15:17 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:7902 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701AbXEUSPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 14:15:15 -0400
Date: Mon, 21 May 2007 12:14:58 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: something strange in libata-core.c for kernel 2.6.22-rc3
In-reply-to: <20070521121537.48dd2b2c@the-village.bc.nu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, l.genoni@oltrelinux.com
Message-id: <4651E1A2.5000703@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.MCe9nCgx+WnsHp+weZyM9LiDF0s@ifi.uio.no>
 <fa.rv8/6n3uBnAIoUHHNUW3eR7cJd8@ifi.uio.no>
 <fa.LXy58QwLlPXDhsfVUU9kEfA3QbI@ifi.uio.no>
 <fa.Ldjy2OubeKomZD0OV2gRm/wpUFo@ifi.uio.no> <46515983.6030206@shaw.ca>
 <465161AF.6030002@gmail.com> <20070521121537.48dd2b2c@the-village.bc.nu>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Yeah, that's consistent to what I've seen on my machine which is a
>> variant of A8N.  No matter what value I through at _STM, _GTM just
>> echoed the result thus always leading to 80c configuration.
>>
>>> I guess this means that what we have to do is trust that the BIOS set up
>>> a reasonable mode and base the cable detect on that (either by reading
>>> back the boot-up controller registers, or by calling GTM). I imagine
>>> this is what the Windows default IDE driver is doing (just using the
>>> boot-up mode and feeding it back using GTM/STM on suspend/resume cycles).
>> Alan, what do you think?
> 
> Interesting, sounds like it is still useful rather than just reading the
> registers as the GTM/STM seem to survive resume cycles which drive config
> may not (eg if the driver is loaded after a s2ram/resume.

I don't think that case is handled in this BIOS anyway - if you call GTM 
after resume without previously calling STM, it's just going to read 
whatever random values are in the controller and give you timings based 
on that, which presumably will be junk.

It looks like the main purpose for what it's doing with saving those 
registers in the _PTS method is to save and restore a couple of 
controller registers called ID20 (PCI config space offset 0x50, 16 bits) 
and ID22 (PCI config space offset 0x5C, 32 bits) which aren't otherwise 
used in the AML. According to pata_amd, for the AMD IDE interface the 
former is some reserved bits as well as the cable detect bits, while the 
latter is the cycle time and address setup time register. Presumably 
those aren't really the cable detect bits though, since the detection 
based on those bits in pata_amd doesn't really work..

> If it just echoes back we should also be able to detect this by using
> knowingly invalid values.

Well, this implementation doesn't purely echo back the same values, it 
echoes back values derived from what the controller was actually set to, 
so I imagine if you put in something ridiculous it would come back with 
the closest possible mode that it was set to (PIO mode 0, etc.)

I suspect the implementation we would need to use (which doesn't depend 
on anything not given in the spec) would be:

-On driver load, execute _GTM to get the timing mode the BIOS had set. 
Assume this represents the fastest modes the controller supports, and 
set cable detect based on whether it includes UDMA modes > 2.

-If we decide to set a slower mode (speed down due to errors, etc.), set 
it using _STM and then read back the actual values that were set using 
_GTM (for possible use in suspend/resume).

-On resume after suspend, re-set the last mode using _STM followed by 
executing _GTF and running those commands.

This won't handle the case where the driver is loaded after the system 
was already suspended to RAM and resumed, however I don't know exactly 
how one could handle that in this situation..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

