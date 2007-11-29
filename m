Return-Path: <linux-kernel-owner+w=401wt.eu-S1764032AbXK2Xzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764032AbXK2Xzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 18:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763566AbXK2XzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 18:55:16 -0500
Received: from main.gmane.org ([80.91.229.2]:60569 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757664AbXK2XzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 18:55:15 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Holger Hoffstaette" <holger@wizards.de>
Subject: Reproducible data corruption with sendfile+vsftp - splice regression?
Date: Fri, 30 Nov 2007 00:42:56 +0100
Organization: The Fists of the White Lotus
Message-ID: <pan.2007.11.29.23.42.52.661624@wizards.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: port-87-234-135-174.dynamic.qsc.de
User-Agent: Pan/0.13.91 (Before we let euphoria convince us we are free)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi -

This regular Linux user and lkml lurker just noticed data corruption in
ftp'ed files and narrowed it down to vsftpd using sendfile(). So far this
has never caused problems in the past; I have not noticed this with
2.6.22.x but may have missed it. I do remember reading about some changes
to the underlying splice stuff since .23 so that may have something to do
with it.

The scenario:

- created a file with known bit pattern on Linux server
- ftp-got this file to Windows client: file has bad crc (yes, binary)
- verified with another client: same result

I have thus far eliminated (to the best of my knowledge) NICs, switches,
cables, the Windows FTP clients, the hard disk in the server (SATA, ext3):
nothing suspicious in any logs. Box is an AMD Sempron 2600+ with 1.5 GB
RAM, added rt8169 card, Gentoo, vsftpd stable 2.0.5 - nothing fancy.
Transferring the file with samba (interestingly with sendfile enabled) and
via ftp but from /dev/shm repeatably works fine; pulling from disk creates
bad crc, every time. The file is readable and can be copied, verified etc.
over and over so I'm sure that I'm not falling prey to a false positive.
ifconfig indicates no dropped or otherwise corrupted packets.
I noticed this first with 2.6.4-rc3, but also just tried the latest stable
2.6.23.9 with the same config, with no change in behaviour. After setting
vsftpd to use_sendfile=NO, gigs can be transferred without corruption.

The data corruption is sporadic, but absolutely repeatable. The file with
the known good pattern just contains multiple lines of:

012345678901234567890123456789012345678901234567890
012345678901234567890123456789012345678901234567890
012345678901234567890123456789012345678901234567890
..etc..

A corrupted file is missing random characters, so that the corrupted lines
looks like this (line numbers added by me):

19785: 012345678901234567890123456789012345678901234567890
19786: 01234567890123456789012345678901234567890123678901234567890
19787: 012345678901234567890123456789012345678901234567890

or:

20074: 012345678901234567890123456789012345678901234567890
20075: 01234567890123456789012345678901234567890123012345678901234567890123456789012345678901234567890
20076: 012345678901234567890123456789012345678901234567890

Again, other network or hd traffic shows no signs of gremlins; the box is
perfectly stable, and turning sendfile on or off triggers/untriggers the
corruption reliably.  I will try 2.6.22.x over the weekend, and before I
bother lkml with dmesg/.config etc. I wanted to fish for initial thoughts.

thanks
Holger


