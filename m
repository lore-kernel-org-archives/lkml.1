Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbXEXWMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbXEXWMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbXEXWML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:12:11 -0400
Received: from smtp.osdl.org ([207.189.120.12]:34444 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbXEXWMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:12:09 -0400
Date: Thu, 24 May 2007 15:08:45 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Mike Houston <mikeserv@bmts.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: sky2/pci issues on Gigabyte
Message-ID: <20070524150845.07d0608f@freepuppy>
In-Reply-To: <20070524142644.837a26ed.mikeserv@bmts.com>
References: <alpine.LFD.0.98.0705182209030.3890@woody.linux-foundation.org>
	<20070520170506.814a38d9.mikeserv@bmts.com>
	<20070521084549.61a1aa71@freepuppy>
	<20070521131055.0017404f.mikeserv@bmts.com>
	<20070521103755.51b954e1@freepuppy>
	<20070521225806.bb18d589.mikeserv@bmts.com>
	<20070521213146.3e220a44@freepuppy>
	<20070522181444.ad932718.mikeserv@bmts.com>
	<alpine.LFD.0.98.0705221653010.3890@woody.linux-foundation.org>
	<20070523133909.a3ec171a.mikeserv@bmts.com>
	<alpine.LFD.0.98.0705231044160.3890@woody.linux-foundation.org>
	<20070524142644.837a26ed.mikeserv@bmts.com>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 14:26:44 -0400
Mike Houston <mikeserv@bmts.com> wrote:

> On Wed, 23 May 2007 10:46:05 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > 
> > On Wed, 23 May 2007, Mike Houston wrote:
> > > 
> > > I still happen to have a Windows Vista install kicking around, so
> > > to make sure we're not flogging a dead horse I booted that and
> > > let it set up the yukon2 chip and I tested it. (more to make sure
> > > that eeprom update didn't break it). I used it for a bit and
> > > successfully transferred some large files from box running Samba.
> > > MS must be using some specific workaround or something.
> > 
> > I think there is some lspci-like thing for windows too. 
> > 
> > Can you do the equivalent of "lspci -vvxxx" on that box under both
> > Linux and Windows? _If_ it's some PCI config space thing (which is
> > not at all guaranteed - it could be about setup in random MMIO
> > ranges) it might give us some clues.
> >
> 
> This is the sky2 issue with Gigabyte 88E8056 onboard LAN.
> 
> I've had no luck getting pciutils compiled for win32, but I found a
> utility that gives similar output called Craig Hart's PCI bus sniffer
> (pci32.exe).
> 
> Here is the output of pci32 with hex dump from within Windows Vista:
> http://www.mikeserv.org/files/pci32_info.txt
> 
> Here is the output of lspci -vvxxx from within Linux:
> http://www.mikeserv.org/files/lspci.txt
> 
> I hope this is helpful,
> 
> Mike Houston


Looking at the 88e8056 PCI config values:

Differences:
1. Linux use MSI (no INTx), Vista does not.

2. Vista use IRQ 16, Linux uses 219 (because of MSI)

3. Vista sets Device Control(E8) 4000h = 2K, 
   Linux uses 2000h = 1k
   This would cause larger max read requests.

4. Vista status (EA) 0010h
   Linux is 0019h
   Driver doesn't bother clearing the correctable error status on boot.

You can get the same settings on Linux without changing driver by doing:

modprobe sky2 disable_msi=1
setpci -s 04:00 e8.w=4000,19

No luck, I tried it, but it still dies..

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
