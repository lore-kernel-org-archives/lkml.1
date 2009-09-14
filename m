Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbZINOZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbZINOZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 10:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbZINOZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 10:25:17 -0400
Received: from rtr.ca ([76.10.145.34]:60968 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbZINOZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 10:25:15 -0400
Message-ID: <4AAE524C.2030401@rtr.ca>
Date: Mon, 14 Sep 2009 10:25:16 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Tejun Heo <teheo@suse.de>
Cc: Chris Webb <chris@arachsys.com>, linux-scsi@vger.kernel.org,
       Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>,
       NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
Subject: Re: MD/RAID time out writing superblock
References: <92cb16daad8278b0aa98125b9e1d057a@localhost> <4A95573A.6090404@redhat.com> <1571f45804875514762f60c0097171e6@localhost> <d086b110526f8bac2f562850dfc70b03@localhost> <4A970154.2020507@redhat.com> <4A9B8583.9050601@kernel.org> <4A9BBC4A.6070708@redhat.com> <4A9BC023.10903@kernel.org> <20090907114442.GG18831@arachsys.com> <20090907115927.GU8710@arachsys.com> <20090909120218.GB21829@arachsys.com> <4AADF3C4.5060004@kernel.org> <4AADF471.2020801@suse.de> <4AAE3B9A.2060306@rtr.ca> <4AAE3F86.8090804@suse.de>
In-Reply-To: <4AAE3F86.8090804@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Mark Lord wrote:
>> Tejun Heo wrote:
>> ..
>>> Oooh, another possibility is the above continuous IDENTIFY tries.
>>> Doing things like that generally isn't a good idea because vendors
>>> don't expect IDENTIFY to be mixed regularly with normal IOs and
>>> firmwares aren't tested against that.  Even smart commands sometimes
>>> cause problems.  So, finding out the thing which is obsessed with the
>>> identity of the drive and stopping it might help.
>> ..
>>
>> Bullpucky.  That sort of thing, specifically with IDENTIFY,
>> has never been an issue.
> 
> With SMART it has.  I wouldn't be too surprised if some new firmware
> chokes on repeated IDENTIFY mixed with stream of NCQ commands.  It's
> just not something people (including vendors) do regularly.
..

Yeah, some drives really don't like SMART commands (hddtemp & smartctl).
That's a strange one, too.  Because the whole idea of SMART
is that it gets used to periodically monitor drive health.

IDENTIFY is much safer -- usually no media access after initial spin-up,
and lots of things exercise it quite regularly.

Pretty much any hdparm command triggers an IDENTIFY beforehand now,
hddtemp and smartctl both use it too.

I suspect we're missing some info from this specific failure.
Looking back at Chris's earlier posting, the whole thing started
with a FLUSH_CACHE_EXT failure.  Once that happens, all bets are
off on anything that follows.

> Everything will be running fine when suddenly:
> 
>   ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
>   ata1.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>           res 40/00:00:80:17:91/00:00:37:00:00/40 Emask 0x4 (timeout)
>   ata1.00: status: { DRDY }
>   ata1: hard resetting link
>   ata1: softreset failed (device not ready)
>   ata1: hard resetting link
>   ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>   ata1.00: configured for UDMA/133
>   ata1: EH complete
>   end_request: I/O error, dev sda, sector 1465147272
>   md: super_written gets error=-5, uptodate=0
>   raid10: Disk failure on sda3, disabling device.
>   raid10: Operation continuing on 5 devices.

