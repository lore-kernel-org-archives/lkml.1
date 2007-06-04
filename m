Return-Path: <linux-kernel-owner+w=401wt.eu-S1754179AbXFDNAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbXFDNAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 09:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbXFDM7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 08:59:54 -0400
Received: from mail.syneticon.net ([213.239.212.131]:42362 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbXFDM7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 08:59:53 -0400
Message-ID: <46640CBF.3070409@wpkg.org>
Date: Mon, 04 Jun 2007 14:59:43 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Cc: gmack@innerfire.net
Subject: Re: [2.6.21.1] SATA freeze
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fred Moyer wrote:

>> Sounds like SMART is likely disabled on that drive. You can try doing 
>> "smartctl -s on /dev/sda" and see if that will turn it on.
>> 
> 
> Sorry - that last post of mine was brain dead.  Here's the one with 
> (hopefully) useful data.
> 
> app2 ~ # smartctl  -d ata -a /dev/sda
> smartctl version 5.36 [x86_64-pc-linux-gnu] Copyright (C) 2002-6 Bruce Allen
> 

(...)

>    -- -- -- -- -- -- --
>    84 51 00 b5 c9 73 e0  Error: ICRC, ABRT at LBA = 0x0073c9b5 = 7588277
> 
>    Commands leading to the command that caused the error were:
>    CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
>    -- -- -- -- -- -- -- --  ----------------  --------------------
>    25 00 20 96 c9 73 e0 00      01:25:42.886  READ DMA EXT
>    b0 d0 01 00 4f c2 00 02      01:25:42.868  SMART READ DATA
>    35 00 08 ae b6 42 e0 00      01:25:42.456  WRITE DMA EXT
>    b0 da 00 00 4f c2 00 00      01:25:42.430  SMART RETURN STATUS
>    35 00 08 60 81 04 e0 00      01:25:42.376  WRITE DMA EXT

I was getting very similar SMART results, and kernel errors, when used 
PATA drive and SATA_VIA (no freezes or hangs though):


SCSI device sda: 390721968 512-byte hdwr sectors (200050 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata3.00: cmd b0/da:00:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 0
          res 51/04:00:0b:ff:bf/00:00:00:00:00/00 Emask 0x1 (device error)
ata3.00: configured for UDMA/100
ata3: EH complete
SCSI device sda: write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata3.00: cmd b0/d0:01:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 512 in
          res 51/04:01:00:4f:c2/00:00:00:00:00/00 Emask 0x1 (device error)
ata3.00: configured for UDMA/100
ata3: EH complete



The problem was that I started smartd with wrong parameters:

DEVICESCAN -a -o on -S on -s (S/../.././10|L/../../6/11)


It was solved when I added "-d sat" to smartd parameters:

DEVICESCAN -d sat -a -o on -S on -s (S/../.././10|L/../../6/11)


 From that time on, smartctl -a /dev/sda gives "normal" output, and no 
more strange kernel errors.

Hopefully, it'll get fixed in smartmontools soon (or is fixed already, 
but not yet mainline).


-- 
Tomasz Chmielewski
http://wpkg.org


