Return-Path: <linux-kernel-owner+w=401wt.eu-S1751769AbXBFI6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbXBFI6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 03:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbXBFI6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 03:58:42 -0500
Received: from 81-174-33-43.f5.ngi.it ([81.174.33.43]:57629 "EHLO develer.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbXBFI6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 03:58:41 -0500
Message-ID: <45C84333.709@develer.com>
Date: Tue, 06 Feb 2007 09:58:27 +0100
From: Bernardo Innocenti <bernie@develer.com>
Organization: Develer S.r.l. - http://www.develer.com/
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: mpt_linux_developer@lsil.com
CC: lkml <linux-kernel@vger.kernel.org>,
       Develer IT Infrastructure <it@lists.develer.com>,
       linux-scsi@vger.kernel.org
Subject: Writing performance problem with SAS1068
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've stumbled onto a strange performance problem on a new server:
reading from disks is fast (70-80MB/s), but writing is extremely
slow (13-15MB/s).  I've measured it like this:

 dd if=/dev/zero of=/dev/sdd bs=4096 count=65536 conv=fdatasync
 65536+0 records in
 65536+0 records out
 268435456 bytes (268 MB) copied, 17.7004 seconds, 15.2 MB/s

*but*: if I rebuild the kernel and change CONFIG_FUSION_MAX_SGE
from 40 (Fedora's default) to 128 (maximum value), it suddenly
gets much faster: 31MB/s!

Looks very much like an interrupt problem to me.  Maybe
increasing the scatter gather mitigates the problem of
missing completion notifications.

Evidence:

 Exhibit A: custom kernel config for 2.6.18-1.2257.fc5.bernie
 http://www.codewiz.org/helium_logs/config

 Exhibit B: dmesg output from said kernel
 http://www.codewiz.org/helium_logs/dmesg

 Exhibit C: misc proc files, and all that
 http://www.codewiz.org/helium_logs/

 Exhibit D: motherboard and chipset specification
 http://www.supermicro.com/products/motherboard/Xeon3000/3010/PDSME+.cfm


Circumstantial evidence:

 - Seems to affect just the LSI SAS1068 PCI-X controller.
   The on-board AHCI controller writes very fast (>60MB/s)

 - I've seen a very similar writing bottleneck with a
   Promise TX4 SATA controller (not PCI-X) on a server with
   a similar motherboard (Supermicro with Mukilteo 3000).

 - Passing mpt_msi_enable=1 doesn't change anything

 - FreeBSD 6.2 is even slower: writes at 7MB/s

 - OpenSolaris is much, much slower... less than 1MB/s.

 - Windows Vista (rc something) writes at 90MB/s.  Too
   fast to believe, maybe dd from Cygwin is misbehaving.

-- 
   // Bernardo Innocenti - Develer S.r.l., R&D dept.
 \X/  http://www.develer.com/

