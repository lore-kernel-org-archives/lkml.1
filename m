Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbXKDTLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbXKDTLr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 14:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbXKDTLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 14:11:39 -0500
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:28401 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752727AbXKDTLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 14:11:38 -0500
X-Belgacom-Dynamic: yes
Date: Sun, 4 Nov 2007 20:11:33 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: thomas.mingarelli@hp.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [HP ProLiant WatchDog driver] hpwdt HP WatchDog Patch <resend>
Message-ID: <20071104191133.GC2648@infomag.infomag.iguana.be>
References: <20071024134912.11227.40677.sendpatchset@tmingo.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024134912.11227.40677.sendpatchset@tmingo.cca.cpqcorp.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

I reviewed yor code and have ome remarks:
* All watchdog device drivers should work with seconds. Your driver works
with minutes. Please change to seconds.
* The misc_register function (which opens your driver towards user-space)
should be the last iregister-action you take into the pci probe function.
(So just before you do the printk where you say that the driver has been
initialized).
* The open and release functions should make sure that /dev/watchdog can
only be opened once.
* /dev/watchdog is a VFS (Virtual File System) so your open function should
return with "return nonseekable_open(inode, file);".
* please put the code to start the watchdog in a seperate function (this
will make it easier to migrate your driver to the generic watchdog model
in the future).
* If you watchdog can't be stopped then you should use a timer to make sure
that when /dev/watchdog is closed, that you continue to keepalive/ping the
watchdog device. (please see mixcomwd.c (this device has the same problem)).
* please put the code to change the timeout in a seperate function.
* the default return value for the ioctl calls should be -ENOTTY (instead of
-ENOIOCTLCMD).
* the GETSTATUS call should also have a "put_user(0, (int *)arg);".
* if possible please add sparse testing code into the ioctl handling.
* Personnaly: I would rather see the generic smbios code somewhere in the
arch/x86/ directory. We will probably need that also in other (non-watchdog)
drivers in the future.

Greetings,
Wim.

