Return-Path: <linux-kernel-owner+w=401wt.eu-S1757798AbYF3GlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798AbYF3GlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 02:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbYF3GlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 02:41:06 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:60769 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbYF3GlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 02:41:05 -0400
Date: Mon, 30 Jun 2008 00:41:00 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Higher than expected disk write(2) latency
In-reply-to: <fa.OZMA74BZPX46rhnjz1am4hB786M@ifi.uio.no>
To: Martin Lucina <mato@kotelna.sk>
Cc: linux-kernel@vger.kernel.org, Martin Sustrik <sustrik@fastmq.com>
Message-id: <48687FFC.4060608@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.OZMA74BZPX46rhnjz1am4hB786M@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Lucina wrote:
> Hi,
> 
> we're getting some rather high figures for write(2) latency when testing
> synchronous writing to disk.  The test I'm running writes 2000 blocks of
> contiguous data to a raw device, using O_DIRECT and various block sizes
> down to a minimum of 512 bytes.  
> 
> The disk is a Seagate ST380817AS SATA connected to an Intel ICH7
> using ata_piix.  Write caching has been explicitly disabled on the
> drive, and there is no other activity that should affect the test
> results (all system filesystems are on a separate drive).  The system is
> running Debian etch, with a 2.6.24 kernel.
> 
> Observed results:

Well, write performance on SATA with no command queueing and write cache 
disabled is always going to be pretty atrocious, since the drive has no 
opportunity to reorder the writes at all, and it also can't receive the 
next write command until the previous one completes so that it may have 
to wait for another rotation in order to perform each write. In this 
case I don't think command queueing even helps you though, as only one 
write from the app is ever outstanding at a time. I suspect the only 
thing that would really help this workload is a RAID controller with a 
battery-backed write cache (that way those tiny O_DIRECT writes don't 
all have to hit the physical disk).
