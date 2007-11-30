Return-Path: <linux-kernel-owner+w=401wt.eu-S934257AbXK3IIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934257AbXK3IIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 03:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932403AbXK3IIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 03:08:04 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:60312 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355AbXK3IIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 03:08:01 -0500
Message-ID: <474FC4D9.3020506@cosmosbay.com>
Date: Fri, 30 Nov 2007 09:07:53 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Holger Hoffstaette <holger@wizards.de>
CC: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: Reproducible data corruption with sendfile+vsftp - splice regression?
References: <pan.2007.11.29.23.42.52.661624@wizards.de>
In-Reply-To: <pan.2007.11.29.23.42.52.661624@wizards.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Fri, 30 Nov 2007 09:08:00 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Holger Hoffstaette a écrit :
> Hi -
> 
> This regular Linux user and lkml lurker just noticed data corruption in
> ftp'ed files and narrowed it down to vsftpd using sendfile(). So far this
> has never caused problems in the past; I have not noticed this with
> 2.6.22.x but may have missed it. I do remember reading about some changes
> to the underlying splice stuff since .23 so that may have something to do
> with it.
> 
> The scenario:
> 
> - created a file with known bit pattern on Linux server
> - ftp-got this file to Windows client: file has bad crc (yes, binary)
> - verified with another client: same result
> 
> I have thus far eliminated (to the best of my knowledge) NICs, switches,
> cables, the Windows FTP clients, the hard disk in the server (SATA, ext3):
> nothing suspicious in any logs. Box is an AMD Sempron 2600+ with 1.5 GB
> RAM, added rt8169 card, Gentoo, vsftpd stable 2.0.5 - nothing fancy.
> Transferring the file with samba (interestingly with sendfile enabled) and
> via ftp but from /dev/shm repeatably works fine; pulling from disk creates
> bad crc, every time. The file is readable and can be copied, verified etc.
> over and over so I'm sure that I'm not falling prey to a false positive.
> ifconfig indicates no dropped or otherwise corrupted packets.
> I noticed this first with 2.6.4-rc3, but also just tried the latest stable
> 2.6.23.9 with the same config, with no change in behaviour. After setting
> vsftpd to use_sendfile=NO, gigs can be transferred without corruption.
> 
> The data corruption is sporadic, but absolutely repeatable. The file with
> the known good pattern just contains multiple lines of:
> 
> 012345678901234567890123456789012345678901234567890
> 012345678901234567890123456789012345678901234567890
> 012345678901234567890123456789012345678901234567890
> ..etc..
> 
> A corrupted file is missing random characters, so that the corrupted lines
> looks like this (line numbers added by me):
> 
> 19785: 012345678901234567890123456789012345678901234567890
> 19786: 01234567890123456789012345678901234567890123678901234567890
> 19787: 012345678901234567890123456789012345678901234567890
> 
> or:
> 
> 20074: 012345678901234567890123456789012345678901234567890
> 20075: 01234567890123456789012345678901234567890123012345678901234567890123456789012345678901234567890
> 20076: 012345678901234567890123456789012345678901234567890
> 
> Again, other network or hd traffic shows no signs of gremlins; the box is
> perfectly stable, and turning sendfile on or off triggers/untriggers the
> corruption reliably.  I will try 2.6.22.x over the weekend, and before I
> bother lkml with dmesg/.config etc. I wanted to fish for initial thoughts.
> 

CC to netdev, it might concern network guys

Could you try with a test file containing unique patterns ?

like a 80 MB file :

#include <stdio.h>
main()
{
unsigned long ul;
for (ul = 0 ; ul < 10000000 ; ul++)
    printf("%8lu", ul);
return 0;
}


Thank you

