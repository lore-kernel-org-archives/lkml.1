Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbYAAATi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbYAAATi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 19:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbYAAATa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 19:19:30 -0500
Received: from ishtar.tlinx.org ([64.81.245.74]:42959 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbYAAAT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 19:19:29 -0500
Message-ID: <4779870E.5070507@tlinx.org>
Date: Mon, 31 Dec 2007 16:19:26 -0800
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: SATA kernel-buffered read VERY slow (not raid, Promise TX300
 card); 2.6.23.1(vanilla)
References: <fa.6TIOCGhBpW0r4XW9rqR+Ad8P+Js@ifi.uio.no> <4777E08C.4000603@shaw.ca>
In-Reply-To: <4777E08C.4000603@shaw.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
>> Have you tried using a different block size to see how that effects 
>> the results? There might be some funny interaction there.
----
    There is some interaction with the large block size (but only on the 
SATA
disk).  Counts were adjusted to keep the read near 2G (~2x physical memory).
 From 1k-16k block sizes, I got into the low-mid 40MB/s on buffered SATA
(compared to 50-60MB/s on ATA & SCSI).  Starting at 32k-64k, the read
rate began falling and at 128k block-reads-at-a-time or larger, it drops 
below
20MB/s (again, only on buffered SATA).   It's hard to imagine what would
slow down buffered SATA reads but not ATA and SCSI reads of the same
size.  I'm using the 'cfq' scheduler with everything running at default
priorities, but again, why only SATA slowness?  It seems that at the driver
level, using direct reads, the SATA disk has the highest read rate (near
80MB/s). 

    It would certainly be perverse to have faster driver & device 
performance
equate to lower buffered I/O.
>
>> I wanted to use the newer pata support in the SATA lib, but
>> got frustrated "real fast" by the lack of disk-parameter support
>> in the new pata library (hdparm is mostly broken; and the SCSI
>> utils aren't really intended for ATA(or SATA?) disks using the
>> SCSI interface.
>
> It's somewhat intentional that some of the hdparm commands (like for 
> settting transfer modes, enable/disable DMA, etc.) don't work with 
> libata. Most of them aren't necessary at all as correct DMA settings, 
> etc. should always be set automatically (if not, please report as a bug).
---
    The only way I could tell before was using hdparm to read the 
parameters.
Since that doesn't work, it's hard to tell if they are set correctly, 
but given
the high performance at the device driver level, I'm guessing the params
are set correctly.

>
>> Since SATA's use ATA-7 (or at least the Seagate disk I
>> acquired seems to), shouldn't most of the hdparm commands
>> be functional on the SATA hardware as much as they would
>> be on PATA?  Or...maybe said a different way, is there
>> an "sdparm" that is to SATA what hdparm is to PATA?
>
> It's the same libata code, so the same applies to some of the hdparm 
> commands not being implemented, as above.
---
    Hmm... might be nice as an "RFE" to at least have the 'read-status'
commands work to see what the params are set to. 

    More importantly, how does one set parameters for acoustic and power
saving parameters?  Some of my disks are used as 'backup' devices for my
other computers.  With the ATA disks, they were kept "spun down" when not
being used (only used, 'normally', in early AM hours).

    Another new "problem" (not as important) -- even though SATA disks are
called with "sdX", my ATA disks that *were* at hda-hdc are now at hde-hdg.
Devices hda-hdd are not populated in my dev directory on bootup.  Of course
this throws off boot-scripts that set diskparams by "hd<name>" and not
by label (using hdparm).  Seems like the SATA disks are suffering a partial
identity problem -- seeming to reserve hda-hdd, but using the "sd" disk 
names.
Is that a known problem?  If not, I'll add it to my queue for bug-filing...

thanks,
Linda

  

