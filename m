Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab0CLAEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 19:04:43 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:8671 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab0CLAEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 19:04:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=oTacHpxWHb2N44X7g+Up4+UYGCsiDB5UMf+OTXFFffPH7oDsOcXWW1j5EdAQ35OTzr
         kHDh3my9eHp5ej9tHLPZxoPuMGq9X//WaT644WtBWblngc9bLKr6LvAa1g63mCMrx3+2
         VGXdj4000hvwsABiNjHLnTTFHH4gX3i8Z8iO4=
Message-ID: <4B998516.1000606@gmail.com>
Date: Thu, 11 Mar 2010 18:04:38 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: CaT <cat@zip.com.au>
CC: linux-kernel@vger.kernel.org
Subject: Re: Regression? 2.6.23.16 -> 2.6.32.9: ide/libata HD recognition
References: <20100310041614.GG2657@zip.com.au>
In-Reply-To: <20100310041614.GG2657@zip.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2010 10:16 PM, CaT wrote:
> Hi,
>
> Just had a strange situation with the above upgrade. It was done on an
> old server that used the serverworks ide driver. The IDE hw config under
> 2.6.23.16 was:
>
> hda:	HD
> hdb:	CDROM
> hdc:	empty
> hdd:	HD

That sounds like you had a slave with no master on the second IDE 
channel. That really isn't a wise configuration and is prone to break 
(some devices don't work in this setup, some BIOSes choke, etc.) since 
the standard doesn't really allow this (the spec says that support for 
this configuration is "host specific" and not mandatory).

There have been some reports about this breaking when moving to libata 
(not sure about newer versions of IDE). I'm not sure exactly what has 
changed to cause this, but it might not be possible to get around it 
without breaking other things (could be the 80-wire cable detection 
protocol is what changed things, but IIRC the reason it changed was the 
original code didn't follow the spec and didn't always work properly 
with some hardware).

Essentially, fixing the hardware config to set the drive for master if 
it's the only device on the channel is likely the best solution overall.

>
> After upgrade, using either IDE or libata the config changed to:
>
> hda:	HD
> hdb:	CDROM
> hdc:	empty
> hdd:	empty
>
> The BIOS recognised the disk. I went through 3 disks and it wasn't until
> I made the second HD a master that it was recognised. So now I have a
> 2.6.32.9 server, using the IDE subsystem with the following config:
>
> hda:	HD
> hdb:	CDROM
> hdc:	HD
> hdd:	empty
>
> Otherwise it does not work.
>
> I had an outage window that I already blew so I was not able to do
> any more diagnosis than what it took to get the system up.
>
> If anyone wants the full config I'll send. Otherwise:
>
> IDE subsystem (no libata subsystem configured):
>
> CONFIG_HAVE_IDE=y
> CONFIG_IDE=y
> CONFIG_IDE_XFER_MODE=y
> CONFIG_IDE_ATAPI=y
> CONFIG_IDE_GD=y
> CONFIG_IDE_GD_ATA=y
> CONFIG_BLK_DEV_IDECD=y
> CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
> CONFIG_BLK_DEV_IDEACPI=y
> CONFIG_IDE_PROC_FS=y
> CONFIG_BLK_DEV_IDEDMA_SFF=y
> CONFIG_BLK_DEV_IDEPCI=y
> CONFIG_IDEPCI_PCIBUS_ORDER=y
> CONFIG_BLK_DEV_IDEDMA_PCI=y
> CONFIG_BLK_DEV_IDEDMA=y
> CONFIG_LEDS_TRIGGER_IDE_DISK=y
>
> libata kernel (no IDE subsystem configured):
>
> CONFIG_ATA=y
> CONFIG_ATA_VERBOSE_ERROR=y
> CONFIG_ATA_ACPI=y
> CONFIG_SATA_PMP=y
> CONFIG_ATA_SFF=y
> CONFIG_PATA_SERVERWORKS=y
>

