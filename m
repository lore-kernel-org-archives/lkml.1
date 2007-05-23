Return-Path: <linux-kernel-owner+w=401wt.eu-S1761728AbXEWRja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761728AbXEWRja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 13:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756433AbXEWRjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 13:39:22 -0400
Received: from paris.bmts.com ([216.183.128.227]:34057 "EHLO paris.bmts.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756240AbXEWRjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 13:39:21 -0400
Date: Wed, 23 May 2007 13:39:09 -0400
From: Mike Houston <mikeserv@bmts.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc2
Message-Id: <20070523133909.a3ec171a.mikeserv@bmts.com>
In-Reply-To: <alpine.LFD.0.98.0705221653010.3890@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0705182209030.3890@woody.linux-foundation.org>
	<20070520170506.814a38d9.mikeserv@bmts.com>
	<20070521084549.61a1aa71@freepuppy>
	<20070521131055.0017404f.mikeserv@bmts.com>
	<20070521103755.51b954e1@freepuppy>
	<20070521225806.bb18d589.mikeserv@bmts.com>
	<20070521213146.3e220a44@freepuppy>
	<20070522181444.ad932718.mikeserv@bmts.com>
	<alpine.LFD.0.98.0705221653010.3890@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-brucetelecom.com-MailScanner-Information: Please contact Bruce Telecom 519.368.2000 for more information
X-brucetelecom.com-MailScanner: Found to be clean
X-brucetelecom.com-MailScanner-From: mikeserv@bmts.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007 17:00:18 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> and the load off "sk->sk_prot->ioctl" oopses, because "sk->sk_prot"
> is corrupt and contains 0x8e3cad42, which is not a valid kernel
> pointer.
> 
> The other oops is even worse. 
> 
> I also think it meshes with
> 
> 	sky2 eth0: descriptor error q=0x280 get=285
> [800042375e2e5e] put=285
> 
> and I suspect your memory got corrupted by sky2 reading the wrong 
> descriptors, and overwriting kernel memory.
> 
> So it's almost certainly some DMA problem. Now, _why_ you have DMA 
> problems, I have no idea. But can you try:
>  - disable CONFIG_PREEMPT
>  - disable CONFIG_HIGHMEM if you have it on
>  - just in general see if you can disable any kernel config options
> that might be unnecessary.
> to see if it changes the situation at all..

Thanks for looking at this. After further posts in the discussion I
wasn't sure if you still wanted me to try this, but I thought it
might be useful to see if (particularly) highmem support might change
the behaviour, or the messages in any way that might lead to a clue.
There was no change to the behaviour.

I have a Core 2 duo, and 2 Gb of RAM, but I built a uniprocessor
kernel (with apic), without highmem support, with no PREEMPT and
without other unnecessary stuff. If by chance I got it working, my
plan was to enable things one at a time.

I won't get that oops on this setup though (never have, anyways...
it was just the PCLinux install on that other hard disk which has
now been returned to use elsewhere), but the messages on trying to
transfer data are the same:

First try (instant failure on trying to ssh):

May 23 12:51:14 cramit kernel: sky2 eth0: enabling interface
May 23 12:51:14 cramit kernel: sky2 eth0: ram buffer 0K
May 23 12:51:16 cramit kernel: sky2 eth0: Link is up at 100 Mbps,
full duplex, flow control both May 23 12:51:34 cramit kernel: sky2
0000:04:00.0: error interrupt status=0x1 May 23 12:51:34 cramit
kernel: sky2 eth0: descriptor error q=0x280 get=7 [0] put=7

Second try after cold boot (failure on trying to transfer file):

May 23 12:52:59 cramit kernel: sky2 eth0: enabling interface
May 23 12:52:59 cramit kernel: sky2 eth0: ram buffer 0K
May 23 12:53:01 cramit kernel: sky2 eth0: Link is up at 100 Mbps,
full duplex, flow control both
May 23 12:55:40 cramit kernel: sky2
0000:04:00.0: error interrupt status=0x80000000
May 23 12:55:40 cramit kernel: sky2 eth0: hw error interrupt status
0x8
May 23 12:55:40 cramit kernel: sky2 eth0: MAC parity error

This is exactly the behaviour I've been seeing.

I still happen to have a Windows Vista install kicking around, so to
make sure we're not flogging a dead horse I booted that and let it
set up the yukon2 chip and I tested it. (more to make sure that
eeprom update didn't break it). I used it for a bit and successfully
transferred some large files from box running Samba. MS must be using
some specific workaround or something.

Mike Houston
