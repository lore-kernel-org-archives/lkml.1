Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbZDVMSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbZDVMSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 08:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbZDVMRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 08:17:52 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:2348 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752315AbZDVMRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 08:17:51 -0400
Message-ID: <49EF0A92.1070400@panasas.com>
Date: Wed, 22 Apr 2009 15:16:18 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] libata: rewrite SCSI host scheme to be one per ATA host
References: <20090422090929.GA14928@havoc.gtf.org> <49EEE225.3010700@garzik.org>
In-Reply-To: <49EEE225.3010700@garzik.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Apr 2009 12:16:29.0504 (UTC) FILETIME=[2A80B400:01C9C344]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2009 12:23 PM, Jeff Garzik wrote:
> Jeff Garzik wrote:
>> Currently, libata creates a Scsi_Host per port.  This was originally
>> done to leverage SCSI's infrastructure to arbitrate among master/slave
>> devices, but is not needed for most modern SATA controllers.   And I
>> _think_ it is not needed for master/slave if done properly, either.
> 
> BTW note the above, with regards to the libata SCSI->block conversion. 
> libata currently relies on SCSI for some amount of generic device 
> arbitration, in several situations (see ->qc_defer, 
> SCSI_MLQUEUE_.*_BUSY).  libata expects SCSI to be intelligent and not 
> starve devices, etc.
> 
> 
>> I was able to successfully boot the following patch on
>> AHCI/x86-64/Fedora.
>>
>> It may work with other controllers -- TRY AT YOUR OWN RISK.  It will
>> probably fail for master/slave configurations, and SAS & PMP also
>> need looking at.  It yielded this lsscsi output on my AHCI box:
>>
>> [0:0:0:0]    disk    ATA      ST3500320AS      SD15  /dev/sda
>> [0:2:0:0]    disk    ATA      G.SKILL 128GB SS 02.1  /dev/sdb
>> [0:5:0:0]    cd/dvd  PIONEER  BD-ROM  BDC-202  1.04  /dev/sr0
> 
> For comparison, here is unmodified 2.6.30-rc3:
> 
> [jgarzik@bd ~]$ lsscsi
> [0:0:0:0]    disk    ATA      ST3500320AS      SD15  /dev/sda
> [2:0:0:0]    disk    ATA      G.SKILL 128GB SS 02.1  /dev/sdb
> [5:0:0:0]    cd/dvd  PIONEER  BD-ROM  BDC-202  1.04  /dev/sr0
> 

Could the master/slave be simply solved by emulating a SCSI LUN
for example below is my machine today:
[]$ lsscsi
[0:0:0:0]    disk    ATA      ST3160023A       3.01  /dev/sda
[1:0:0:0]    cd/dvd  _NEC     DVD_RW ND-3550A  1.05  /dev/sr0
[4:0:0:0]    disk    ATA      WDC WD1600JS-60M 10.0  /dev/sdb

the /dev/sda and /dev/sr0 share a master/slave wide cable (sdb is sata)

it could be made to scan as:
[]$ lsscsi
[0:0:0:0]    disk    ATA      ST3160023A       3.01  /dev/sda
[0:0:0:1]    cd/dvd  _NEC     DVD_RW ND-3550A  1.05  /dev/sr0
[1:0:0:0]    disk    ATA      WDC WD1600JS-60M 10.0  /dev/sdb

So we need to emulate the REPORT_LUN (or what ever else) to return
two LUNs. Or do you want to report a separate target for the master/slave?

Thanks
Boaz
