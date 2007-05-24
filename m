Return-Path: <linux-kernel-owner+w=401wt.eu-S1753570AbXEXWsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbXEXWsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750701AbXEXWs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:48:28 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751AbXEXWs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:48:27 -0400
Date: Thu, 24 May 2007 15:48:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Hemminger <shemminger@linux-foundation.org>
cc: Mike Houston <mikeserv@bmts.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sky2/pci issues on Gigabyte
In-Reply-To: <20070524150845.07d0608f@freepuppy>
Message-ID: <alpine.LFD.0.98.0705241524350.26602@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0705182209030.3890@woody.linux-foundation.org>
 <20070520170506.814a38d9.mikeserv@bmts.com> <20070521084549.61a1aa71@freepuppy>
 <20070521131055.0017404f.mikeserv@bmts.com> <20070521103755.51b954e1@freepuppy>
 <20070521225806.bb18d589.mikeserv@bmts.com> <20070521213146.3e220a44@freepuppy>
 <20070522181444.ad932718.mikeserv@bmts.com>
 <alpine.LFD.0.98.0705221653010.3890@woody.linux-foundation.org>
 <20070523133909.a3ec171a.mikeserv@bmts.com>
 <alpine.LFD.0.98.0705231044160.3890@woody.linux-foundation.org>
 <20070524142644.837a26ed.mikeserv@bmts.com>
 <20070524150845.07d0608f@freepuppy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 May 2007, Stephen Hemminger wrote:
> 
> Looking at the 88e8056 PCI config values:

I think you're looking at the wrong device.

The ones that matter are likely the PCI-X bridge, not the device. The 
device cannot reasonably screw up DMA (unless it's really scrogged, but 
then it wouldn't work under Vista either).

So it's much more likely to be about device 00:1c.4, which is the bridge 
to PCI bus #4:

	00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 5 
		Bus: primary=00, secondary=04, subordinate=04, sec-latency=0

So I'd look at its config space instead ("-" is Vista, "+" is Linux):

	-00: 86 80 47 28 07 00 10 00 02 00 04 06 08 00 81 00
	+00: 86 80 47 28 07 04 10 00 02 00 04 06 08 00 81 00

	 10: 00 00 00 00 00 00 00 00 00 04 04 00 b0 b0 00 00

	-20: 00 f7 f0 f8 f1 ff 01 00 00 00 00 00 00 00 00 00
	+20: 00 f7 f0 f8 01 80 01 80 00 00 00 00 00 00 00 00

	-30: 00 00 00 00 40 00 00 00 00 00 00 00 10 01 04 00
	+30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 04 00

	-40: 10 80 41 01 c0 8f 00 00 00 00 10 00 11 24 11 05
	+40: 10 80 41 01 c0 8f 00 00 0f 00 11 00 11 24 11 05

	 50: 40 00 11 30 60 05 a0 00 00 00 48 01 00 00 00 00
	 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

	-80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	+80: 05 90 01 00 0c 10 e0 fe d1 41 00 00 00 00 00 00

	 90: 0d a0 00 00 58 14 01 50 00 00 00 00 00 00 00 00
	 a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
	 b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

Which I _think_ is (I tried to be careful, but..):

		Vista		Linux
		
	04:	0x00100007	0x00100407
	24:	0x0001fff1	0x08018001
	3c:	0x00040110	0x0004010b
	48:	0x00100000	0x0011000f
	80:	0x00009005	0x00019005
	84:	0x00000000	0xfee0100c
	88:	0x00000000	0x000041d1

but I have not looked at what the _meaning_ of those register
differences are. 

The host bridge itself could be the problem, but that one is identical
in the PCI config space.  I guess it could also be this one:

	00:01.0 PCI bridge: Intel Corporation 82P965/G965 PCI Express Root Port (rev 02) (prog-if 00 [Normal decode])
		Bus: primary=00, secondary=01, subordinate=01, sec-latency=0

but I don't know how "port 5" (which is the bus that the ethernet
controller is behind) is related to that "root port" (which is reported
to bridge only subordinate bus 01).  The "root port" thing makes me
suspect that device 00:01.0 is somehow related to 00:1c.4 despite the
apparent lack of relationship in the bus topology itself (and the root
port does _not_ decode the IO/MEM resources that lead to the ethernet
chip).

There _are_ differences in that root port device too, but I haven't done
the diff of them yet. 

			Linus
