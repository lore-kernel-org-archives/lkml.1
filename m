Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbZAXCf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbZAXCf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 21:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbZAXCfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 21:35:15 -0500
Received: from smtp.infotech.no ([82.134.31.41]:34723 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbZAXCfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 21:35:14 -0500
Message-ID: <497A7E5E.50505@interlog.com>
Date: Fri, 23 Jan 2009 21:35:10 -0500
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Grzegorz Nosek <root@localdomain.pl>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: smartctl on aic94xx causes a kernel warning in libata
References: <20090123194410.GA8639@megiteam.pl>
In-Reply-To: <20090123194410.GA8639@megiteam.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grzegorz Nosek wrote:
> Hi,
> 
> This is a trivially reproducible (in my setup at least) WARN_ON that
> triggers whenever I run smartctl on a SATA disk connected via an aic94xx
> controller (Adaptec AIC-9410W SAS (Razor ASIC RAID)=20 (rev 09)).
> 
> The kernel is (as far as device drivers are concerned) vanilla
> 2.6.27.12.
> 
> Other than the warning and the fact that smartctl requires '-T
> permissive' to show the disk status, I can't see any negative effects.
> 
> (please keep cc'd)
> 
> Best regards,
>  Grzegorz Nosek
> 
> *** smartctl -a /dev/sdb (without -T permissive) ***
> 
> smartctl version 5.37 [i686-pc-linux-gnu] Copyright (C) 2002-6 Bruce Allen
> Home page is http://smartmontools.sourceforge.net/
> 
> === START OF INFORMATION SECTION ===
> Device Model:     ST3500630NS
> Serial Number:    9QG93FV5
> Firmware Version: 3.AEK
> User Capacity:    500,107,862,016 bytes
> Device is:        Not in smartctl database [for details use: -P showall]
> ATA Version is:   7
> ATA Standard is:  Exact ATA specification draft version not indicated
> Local Time is:    Fri Jan 23 20:17:30 2009 CET
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> 
> Error SMART Status command failed
> Please get assistance from http://smartmontools.sourceforge.net/
> Values from ATA status return descriptor are:
>  00     09 0c 00 00 00 00 00 00  00 00 00 00 00 00
> A mandatory SMART command failed: exiting. To continue, add one or more '-T permissive' options.

Putting my smartmontools hat on that SAT ATA status
return descriptor for an ATA SMART RETURN STATUS
command looks broken, most likely not correctly "wired"
as the payload is zeros. Using a LSI SAS controller
(which implements SAT in firmware) here is what the
response should look like:

Values from ATA Return Descriptor are:
  00     09 0c 00 00 00 00 00 00  00 4f 00 c2 00 50

assuming the disk is healthy. [And if it was unhealthy
then 4f -> f4 and c2 -> 2c (t13 dyslexic humour ?).]

To my knowledge that usage of the ATA SMART RETURN
status command is the only occasion when smartctl
needs to read the ATA registers _after_ command completion.

Doug Gilbert



