Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbXJVCNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbXJVCNR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 22:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbXJVCNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 22:13:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:55537 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbXJVCM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 22:12:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=OY7PmCt5utlw7yDjNj6AW7sTaPDF5V7lV0QTT3KjhanHZmE6F9r6HoikvqafqGL7j5c+wrkKiPsOLW2vTTTAo20kqNIjRZBW1xT5dQkgS3+JHFlulkjIzlV/drTXSW7g7ZxIKBsD/9SkyOVIXzG9q+an3R8q2u9r6VwRCFrVlXk=
Message-ID: <471C071C.2010202@gmail.com>
Date: Mon, 22 Oct 2007 11:12:44 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Soeren Sonnenburg <kernel@nn7.de>
CC: linux-ide@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Bernd Schubert <bs@q-leap.de>
Subject: Re: sata sil3114 vs. certain seagate drives results in filesystem
 corruptions
References: <1192863324.5720.162.camel@localhost>
In-Reply-To: <1192863324.5720.162.camel@localhost>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Helo,

Soeren Sonnenburg wrote:
> I finally managed to find a *reproducible* setup and way to trigger
> random corruptions using a sata sil 3114 controller connected to 4
> seagate drives
> 
> port 1: ST3400832AS sda
> port 2: ST3400620AS sdb
> port 3: ST3750640AS sdc
> port 4: ST3750640AS sdd
> 
> sda & sdb form md0 via a raid1 setup followed by an additional
> devicemapper layer ( root ). sdc and sdb are separate and also have an
> additional device mapper layer ( public ) and ( backups ).
> 
> Now when I write large files of zeros to root(sda&sdb) and read the file
> back in it contains a few nonzero entries:
> 
> # dd if=/dev/zero of=/foo bs=1M count=2000
> # hexdump /foo
> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
> *
> <after >1GB random parts, within large blocks of zeroes> 
> 
> I can reliably trigger this on the md0 / devmapper-root setup when I
> write about 2GB of data (note that this machine has 1.5G of memory - and
> still 1GB is often enough to see this problem). Here it does not matter
> where in the filesystem I do these writes.

Thanks.  I'll try to reproduce the problem here.  What's your motherboard?

> Now promise_sata is converted to new EH, so I simply gave it a go, i.e.
> I attached ST3400832AS and ST3400620AS to the promise controller and
> rebooted and redid the experiments from above.
> 
> No data corruptions whatsoever. I even ran the dd on all three devmapped
> mount points simultaneously with a size of 30GB each, still no
> corruption. However the error messages I've seen a year ago are back for
> the ST3400832AS and ST3400620AS attached to the promise controller (see
> below).
[--snip--]
> ata1.00: exception Emask 0x10 SAct 0x0 SErr 0x100 action 0x2
> ata1.00: port_status 0x20200000
> ata1.00: cmd 25/00:00:c0:b6:74/00:01:20:00:00/e0 tag 0 cdb 0x0 data 131072 in
>          res 51/0c:00:c0:b6:74/0c:01:20:00:00/e0 Emask 0x10 (ATA bus error)
> ata1: soft resetting port

Yeah, still the same.  Your drives don't like the way promise controller
speaks to them (e.g. promise generates signals which are ) but now that
sata_promise has proper EH.  It can recover from those errors.  As long
as nothing worse happens, it should be okay.

Thanks.

-- 
tejun
