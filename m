Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbYAAAc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbYAAAc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 19:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbYAAAcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 19:32:47 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:34217 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbYAAAcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 19:32:46 -0500
Date: Mon, 31 Dec 2007 18:32:40 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: SATA kernel-buffered read VERY slow (not raid,
 Promise TX300 card); 2.6.23.1(vanilla)
In-reply-to: <4779870E.5070507@tlinx.org>
To: Linda Walsh <lkml@tlinx.org>
Cc: LKML <linux-kernel@vger.kernel.org>, ide <linux-ide@vger.kernel.org>
Message-id: <47798A28.2010301@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.6TIOCGhBpW0r4XW9rqR+Ad8P+Js@ifi.uio.no>
 <4777E08C.4000603@shaw.ca> <4779870E.5070507@tlinx.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linda Walsh wrote:
> Robert Hancock wrote:
>>> Have you tried using a different block size to see how that effects 
>>> the results? There might be some funny interaction there.
> ----
>    There is some interaction with the large block size (but only on the 
> SATA
> disk).  Counts were adjusted to keep the read near 2G (~2x physical 
> memory).
>  From 1k-16k block sizes, I got into the low-mid 40MB/s on buffered SATA
> (compared to 50-60MB/s on ATA & SCSI).  Starting at 32k-64k, the read
> rate began falling and at 128k block-reads-at-a-time or larger, it drops 
> below
> 20MB/s (again, only on buffered SATA).   It's hard to imagine what would
> slow down buffered SATA reads but not ATA and SCSI reads of the same
> size.  I'm using the 'cfq' scheduler with everything running at default
> priorities, but again, why only SATA slowness?  It seems that at the driver
> level, using direct reads, the SATA disk has the highest read rate (near
> 80MB/s).
>    It would certainly be perverse to have faster driver & device 
> performance
> equate to lower buffered I/O.

Not too sure on that one. I suspect one might have to trace the actual 
requests being received at the driver level somehow with buffered reads 
in order to diagnose what's going on there..

>>
>>> I wanted to use the newer pata support in the SATA lib, but
>>> got frustrated "real fast" by the lack of disk-parameter support
>>> in the new pata library (hdparm is mostly broken; and the SCSI
>>> utils aren't really intended for ATA(or SATA?) disks using the
>>> SCSI interface.
>>
>> It's somewhat intentional that some of the hdparm commands (like for 
>> settting transfer modes, enable/disable DMA, etc.) don't work with 
>> libata. Most of them aren't necessary at all as correct DMA settings, 
>> etc. should always be set automatically (if not, please report as a bug).
> ---
>    The only way I could tell before was using hdparm to read the 
> parameters.
> Since that doesn't work, it's hard to tell if they are set correctly, 
> but given
> the high performance at the device driver level, I'm guessing the params
> are set correctly.

The settings in use should be reported in dmesg.

> 
>>
>>> Since SATA's use ATA-7 (or at least the Seagate disk I
>>> acquired seems to), shouldn't most of the hdparm commands
>>> be functional on the SATA hardware as much as they would
>>> be on PATA?  Or...maybe said a different way, is there
>>> an "sdparm" that is to SATA what hdparm is to PATA?
>>
>> It's the same libata code, so the same applies to some of the hdparm 
>> commands not being implemented, as above.
> ---
>    Hmm... might be nice as an "RFE" to at least have the 'read-status'
> commands work to see what the params are set to.
>    More importantly, how does one set parameters for acoustic and power
> saving parameters?  Some of my disks are used as 'backup' devices for my
> other computers.  With the ATA disks, they were kept "spun down" when not
> being used (only used, 'normally', in early AM hours).

I believe those hdparm commands for power-save and AAM are supposed to 
work (they just issue an ATA command to the disk). The ones that aren't 
implemented are the ones that actually commanded the IDE layer, like DMA 
on/off.

> 
>    Another new "problem" (not as important) -- even though SATA disks are
> called with "sdX", my ATA disks that *were* at hda-hdc are now at hde-hdg.
> Devices hda-hdd are not populated in my dev directory on bootup.  Of course
> this throws off boot-scripts that set diskparams by "hd<name>" and not
> by label (using hdparm).  Seems like the SATA disks are suffering a partial
> identity problem -- seeming to reserve hda-hdd, but using the "sd" disk 
> names.
> Is that a known problem?  If not, I'll add it to my queue for bug-filing...

Could be a udev problem, as it's what does the device naming..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

