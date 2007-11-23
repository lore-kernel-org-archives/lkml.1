Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbXKWHc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbXKWHc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 02:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbXKWHcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 02:32:18 -0500
Received: from postfix2-g20.free.fr ([212.27.60.43]:52628 "EHLO
	postfix2-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbXKWHcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 02:32:17 -0500
Message-ID: <4746814F.80502@free.fr>
Date: Fri, 23 Nov 2007 08:29:19 +0100
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.9) Gecko/20071030 SeaMonkey/1.1.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       James Bottomley <James.Bottomley@SteelEye.com>,
       linux-scsi@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm1: I/O error, system hangs
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>	<4744A6F2.4030302@free.fr> <20071121144116.c932727b.akpm@linux-foundation.org>
In-Reply-To: <20071121144116.c932727b.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Le 21.11.2007 23:41, Andrew Morton a écrit :
> On Wed, 21 Nov 2007 22:45:22 +0100
> Laurent Riffard <laurent.riffard@free.fr> wrote:
> 
>> Le 21.11.2007 05:45, Andrew Morton a écrit :
>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc3/2.6.24-rc3-mm1/
>> Hello, 
>>
>> My system hangs shortly after I logged in Gnome desktop. SysRq-W shows
>> that a bunch of task are blocked in "D" state, they seem to wait for
>> some I/O completion. I can try to hand-copy some data if requested.
>>
>> I found these messages in dmesg:
>>
>> ~$ grep -C2 end_request dmesg-2.6.24-rc3-mm1 
>> EXT3-fs: mounted filesystem with ordered data mode.
>> sd 0:0:0:0: [sda] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
>> end_request: I/O error, dev sda, sector 16460
>> ReiserFS: sda7: found reiserfs format "3.6" with standard journal
>> ReiserFS: sda7: using ordered data mode
>> --
>> ReiserFS: sda7: Using r5 hash to sort names
>> sd 0:0:1:0: [sdb] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
>> end_request: I/O error, dev sdb, sector 19632
>> sd 0:0:1:0: [sdb] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
>> end_request: I/O error, dev sdb, sector 40037363
>> Adding 1048568k swap on /dev/mapper/vglinux1-lvswap.  Priority:-1 extents:1 across:1048568k
>> lp0: using parport0 (interrupt-driven).
>>
>> These errors occur *only* with 2.6.24-rc3-mm1, they are 100% reproducible.
>> 2.6.24-rc3 and 2.6.24-rc2-mm1 are fine.
>>
>> Maybe something is broken in pata_via driver ?
>>
> 
> Could be - libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask.patch
> and pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings.patch
> touch pata_via.c.

None of the above...

I did a bisection, it spotted git-scsi-misc.patch. 
I just run 2.6.24-rc3-mm1 + revert-git-scsi-misc.patch, and it works fine.

I guess commit 8655a546c83fc43f0a73416bbd126d02de7ad6c0 "[SCSI] Do not 
requeue requests if REQ_FAILFAST is set" is the real culprit. The other 
commits are touching documentation or drivers I don't use. I'll try 
to revert only this one this evening.

-- 
laurent


