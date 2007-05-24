Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbXEXXIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbXEXXIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 19:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750702AbXEXXIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 19:08:46 -0400
Received: from smtp.osdl.org ([207.189.120.12]:34829 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbXEXXIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 19:08:45 -0400
Date: Thu, 24 May 2007 16:04:40 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Houston <mikeserv@bmts.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sky2/pci issues on Gigabyte
Message-ID: <20070524160440.63667048@freepuppy>
In-Reply-To: <alpine.LFD.0.98.0705241524350.26602@woody.linux-foundation.org>
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
	<20070524150845.07d0608f@freepuppy>
	<alpine.LFD.0.98.0705241524350.26602@woody.linux-foundation.org>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 15:48:23 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Thu, 24 May 2007, Stephen Hemminger wrote:
> > 
> > Looking at the 88e8056 PCI config values:
> 
> I think you're looking at the wrong device.

I didn't expect it to work, just heading for the easy to hit difference first.

> 
> The ones that matter are likely the PCI-X bridge, not the device. The 
> device cannot reasonably screw up DMA (unless it's really scrogged, but 
> then it wouldn't work under Vista either).

PCI-E

> 
> So it's much more likely to be about device 00:1c.4, which is the bridge 
> to PCI bus #4:
> 
> 	00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 5 
> 		Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
> 
>
> 
> Which I _think_ is (I tried to be careful, but..):
> So I'd look at its config space instead ("-" is Vista, "+" is Linux):


> 	-00: 86 80 47 28 07 00 10 00 02 00 04 06 08 00 81 00
> 	+00: 86 80 47 28 07 04 10 00 02 00 04 06 08 00 81 00
                             ^--- INTX disable bit
	Vista isn't enabling MSI, Linux is.
	Try "nomsi"?
> 
> 	 10: 00 00 00 00 00 00 00 00 00 04 04 00 b0 b0 00 00
> 
> 	-20: 00 f7 f0 f8 f1 ff 01 00 00 00 00 00 00 00 00 00
> 	+20: 00 f7 f0 f8 01 80 01 80 00 00 00 00 00 00 00 00
                24:   BAR5 differnence ?      
> 
> 	-30: 00 00 00 00 40 00 00 00 00 00 00 00 10 01 04 00
> 	+30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 04 00
		3c:  Assigned IRQ value		

> 	-40: 10 80 41 01 c0 8f 00 00 00 00 10 00 11 24 11 05
> 	+40: 10 80 41 01 c0 8f 00 00 0f 00 11 00 11 24 11 05
 	     48: PCI Express device control
	            Vista: 0000
                    Linux: 000f = advanced error reports enabled
	     4c: PCI Express device status
	            Vista: 0010
		    Linux: 0011 = correctable error detected
  Driver doesn't clear error during boot, you can do it with
  setpci but it doesn't fix problem. (I do have fix bug it is
  not important for this discussion).
	
> 	 50: 40 00 11 30 60 05 a0 00 00 00 48 01 00 00 00 00
> 	 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 	 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> 	-80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 	+80: 05 90 01 00 0c 10 e0 fe d1 41 00 00 00 00 00 00
   These are the MSI setup registers which Vista isn't using.            

> 	 90: 0d a0 00 00 58 14 01 50 00 00 00 00 00 00 00 00
> 	 a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
> 	 b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

So only difference I see is MSI, and advanced error reporting
bits.



-- 
Stephen Hemminger <shemminger@linux-foundation.org>
