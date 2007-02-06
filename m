Return-Path: <linux-kernel-owner+w=401wt.eu-S965369AbXBFT12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965369AbXBFT12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 14:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965371AbXBFT12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 14:27:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52800 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965370AbXBFT10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 14:27:26 -0500
Message-ID: <45C8D686.7010103@torque.net>
Date: Tue, 06 Feb 2007 14:27:02 -0500
From: Douglas Gilbert <dougg@torque.net>
Reply-To: dougg@torque.net
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Bernardo Innocenti <bernie@develer.com>
CC: mpt_linux_developer@lsil.com, lkml <linux-kernel@vger.kernel.org>,
       Develer IT Infrastructure <it@lists.develer.com>,
       linux-scsi@vger.kernel.org
Subject: Re: Writing performance problem with SAS1068
References: <45C84333.709@develer.com>
In-Reply-To: <45C84333.709@develer.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernardo Innocenti wrote:
> Hello,
> 
> I've stumbled onto a strange performance problem on a new server:
> reading from disks is fast (70-80MB/s), but writing is extremely
> slow (13-15MB/s).  I've measured it like this:
> 
> dd if=/dev/zero of=/dev/sdd bs=4096 count=65536 conv=fdatasync
> 65536+0 records in
> 65536+0 records out
> 268435456 bytes (268 MB) copied, 17.7004 seconds, 15.2 MB/s

# dd if=/dev/zero of=/dev/sdj bs=4096 count=65536 conv=fdatasync
65536+0 records in
65536+0 records out
268435456 bytes (268 MB) copied, 2.24953 seconds, 119 MB/s

# dd if=/dev/zero of=/dev/sdd bs=4096 count=65536 conv=fdatasync
65536+0 records in
65536+0 records out
268435456 bytes (268 MB) copied, 2.3246 seconds, 115 MB/s

Both /dev/sdj and /dev/sdd connect via an expander to the same
SAS disk. /dev/sdj is via the LT aic94xx driver and a PCI-X HBA.
/dev/sdd is via the mptsas driver and a SAS1068 (PCIe) based HBA.
The kernel version is 2.6.20-rc5.

Looks good to me.

You may like to check that Write Cache Enable is on with:
'sdparm --get=WCE /dev/sdd'.

Doug Gilbert

> *but*: if I rebuild the kernel and change CONFIG_FUSION_MAX_SGE
> from 40 (Fedora's default) to 128 (maximum value), it suddenly
> gets much faster: 31MB/s!
> 
> Looks very much like an interrupt problem to me.  Maybe
> increasing the scatter gather mitigates the problem of
> missing completion notifications.
> 
> Evidence:
> 
> Exhibit A: custom kernel config for 2.6.18-1.2257.fc5.bernie
> http://www.codewiz.org/helium_logs/config
> 
> Exhibit B: dmesg output from said kernel
> http://www.codewiz.org/helium_logs/dmesg
> 
> Exhibit C: misc proc files, and all that
> http://www.codewiz.org/helium_logs/
> 
> Exhibit D: motherboard and chipset specification
> http://www.supermicro.com/products/motherboard/Xeon3000/3010/PDSME+.cfm
> 
> 
> Circumstantial evidence:
> 
> - Seems to affect just the LSI SAS1068 PCI-X controller.
>   The on-board AHCI controller writes very fast (>60MB/s)
> 
> - I've seen a very similar writing bottleneck with a
>   Promise TX4 SATA controller (not PCI-X) on a server with
>   a similar motherboard (Supermicro with Mukilteo 3000).
> 
> - Passing mpt_msi_enable=1 doesn't change anything
> 
> - FreeBSD 6.2 is even slower: writes at 7MB/s
> 
> - OpenSolaris is much, much slower... less than 1MB/s.
> 
> - Windows Vista (rc something) writes at 90MB/s.  Too
>   fast to believe, maybe dd from Cygwin is misbehaving.
> 

