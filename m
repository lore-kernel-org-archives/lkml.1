Return-Path: <linux-kernel-owner+w=401wt.eu-S932949AbXBLD0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949AbXBLD0d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 22:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932948AbXBLD0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 22:26:33 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:45267 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932946AbXBLD0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 22:26:32 -0500
Date: Sun, 11 Feb 2007 21:25:27 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: libata FUA revisited
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Cc: edmudama@gmail.com, Nicolas.Mailhot@LaPoste.net,
       Tejun Heo <htejun@gmail.com>
Message-id: <45CFDE27.5030607@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've been looking at some list archives from about a year ago when there 
was a big hoohah about FUA in libata. To summarize what I've gotten from 
that discussion:

Nicolas Mailhot ran into a problem with the first kernels that supported 
libata FUA, using a Silicon Image 3114 controller and a Maxtor 6L300S0 
    drive with BANC1G10 firmware. Essentially it would quickly corrupt 
the filesystem on bootup. After that:

-A blacklist entry was added into libata disabling FUA on Maxtor drives 
with BANC1G10 firmware

-Eric Mudama from Maxtor complained that there was nothing wrong with 
FUA on those drives and the blacklist should be taken out (though it 
never was)

-It was also confirmed by Eric and others that Silicon Image 311x 
controllers go nuts if they're issued WRITE DMA FUA commands, at least 
without some driver improvements which I assume haven't happened.

-Eventually FUA was disabled by default globally in libata.

Given the above, what I'm proposing to do is:

-Remove the blacklisting of Maxtor BANC1G10 firmware for FUA. If we need 
to FUA-blacklist any drives this should likely be added to the existing 
"horkage" mechanism we now have. However, at this point I don't think 
that's needed, considering that I've seen no conclusive evidence that 
any drive has ever been established to have broken FUA.

-Add a new port flag ATA_FLAG_NO_FUA to indicate that a controller can't 
handle FUA commands, and add that flag to sata_sil. Force FUA off on any 
drive connected to a controller with this bit set.

There was some talk that sata_mv might have this problem, but I believe 
the conclusion was that it didn't. The only controllers that would are 
ones that actually try to interpret the ATA command codes and don't know 
about WRITE DMA FUA.

-Change the fua module option to control FUA enable/disable to have a 
third value, "enable for NCQ-supporting drives only", which would become 
the new default. That case seems less likely to cause problems since FUA 
on NCQ is just another bit in the command whereas FUA on non-NCQ is an 
entirely different, potentially unsupported command.

Any comments?

As an aside, I came across a comment that the Silicon Image Windows 
drivers for NCQ-supporting controllers have some blacklist entries for 
drives with broken NCQ in their .inf files. We only seem to have one in 
the libata NCQ blacklist, we may want to add some more of these. The 
ones in the current SiI3124 and 3132 drivers' .inf files for 
"DisableSataQueueing" appear to be:

Model				Firmware
Maxtor 7B250S0			BANC1B70
HTS541060G9SA00			MB3OC60D
HTS541080G9SA00			MB4OC60D
HTS541010G9SA00			MBZOC60D

(the latter 3 being Hitachi Travelstar drives)

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/
