Return-Path: <linux-kernel-owner+w=401wt.eu-S1030586AbXBMAZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030586AbXBMAZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 19:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030585AbXBMAZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 19:25:38 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:38709 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030582AbXBMAZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 19:25:37 -0500
Date: Mon, 12 Feb 2007 18:23:15 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: libata FUA revisited
In-reply-to: <fa.Q/csgyCHkAsD84yi+bN78H1WNNM@ifi.uio.no>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       edmudama@gmail.com, Nicolas.Mailhot@LaPoste.net
Message-id: <45D104F3.7040602@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.S80SRyQbD/hm4SxliPUKU88BaCo@ifi.uio.no>
 <fa.Q/csgyCHkAsD84yi+bN78H1WNNM@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>> -Add a new port flag ATA_FLAG_NO_FUA to indicate that a controller 
>> can't handle FUA commands, and add that flag to sata_sil. Force FUA 
>> off on any drive connected to a controller with this bit set.
>>
>> There was some talk that sata_mv might have this problem, but I 
>> believe the conclusion was that it didn't. The only controllers that 
>> would are ones that actually try to interpret the ATA command codes 
>> and don't know about WRITE DMA FUA.
> 
> I think it would be better to add ATA_FLAG_FUA instead of ATA_FLAG_NO_FUA.

I'm not sure about that, it appears that the number of controllers that 
have problems is much lower than the number that don't, so this would 
just need to be added to almost every driver. Especially since the 
non-NCQ FUA which was problematic on SiI in the past isn't being 
switched on by default.

>> -Change the fua module option to control FUA enable/disable to have a 
>> third value, "enable for NCQ-supporting drives only", which would 
>> become the new default. That case seems less likely to cause problems 
>> since FUA on NCQ is just another bit in the command whereas FUA on 
>> non-NCQ is an entirely different, potentially unsupported command.
> 
> Not enabling FUA doesn't result in huge performance hit.  I'm not sure 
> whether we should go such far.  Just supporting FUA on known good 
> controllers sounds good enough to me.

On the NCQ side, I think it's pretty safe to assume that all controllers 
will handle it. Obviously I've verified it with sata_nv (at least that 
it doesn't blow up obviously), and the other two NCQ drivers we have, 
ahci and sata_sil24 just feed raw FIS data into the controller so there 
should be no issue with not supporting it.

Assuming that we leave FUA off by default for non-NCQ for the 
foreseeable future, is there really much concern here?

> 
>> Any comments?
>>
>> As an aside, I came across a comment that the Silicon Image Windows 
>> drivers for NCQ-supporting controllers have some blacklist entries for 
>> drives with broken NCQ in their .inf files. We only seem to have one 
>> in the libata NCQ blacklist, we may want to add some more of these. 
>> The ones in the current SiI3124 and 3132 drivers' .inf files for 
>> "DisableSataQueueing" appear to be:
>>
>> Model                Firmware
>> Maxtor 7B250S0            BANC1B70
>> HTS541060G9SA00            MB3OC60D
>> HTS541080G9SA00            MB4OC60D
>> HTS541010G9SA00            MBZOC60D
>>
>> (the latter 3 being Hitachi Travelstar drives)
> 
> Yeah, I don't think we need to be too careful about blacklisting NCQ 
> considering the sorry state of many early NCQ firmwares.  Please submit 
> a patch.  It would be nice if you add a comment why the drives are added 
> for documentation.

Will do shortly. Eric, do you have any info on the blacklisting of that 
Maxtor 7B250S0 drive? I would hope that Silicon Image would have a good 
reason for blacklisting that one..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

