Return-Path: <linux-kernel-owner+w=401wt.eu-S1757773AbXEMJLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773AbXEMJLj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 05:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756864AbXEMJLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 05:11:32 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756822AbXEMJLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 05:11:31 -0400
Date: Sun, 13 May 2007 02:11:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Workaround for a PCI restoring bug
Message-Id: <20070513021119.c4f14bd3.akpm@linux-foundation.org>
In-Reply-To: <20070513085718.GD3580@ics.muni.cz>
References: <20070512201237.GB3569@ics.muni.cz>
	<20070512234743.0a8a915f.akpm@linux-foundation.org>
	<20070513085718.GD3580@ics.muni.cz>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007 10:57:18 +0200 Lukas Hejtmanek <xhejtman@ics.muni.cz> wrote:

> Hello,
> 
> On Sat, May 12, 2007 at 11:47:43PM -0700, Andrew Morton wrote:
> > This change might indeed be a suitable workaround for some busted hardware,
> > but we'd need to know quite a bit about the problem before we could merge
> > anything like this
> > 
> > So, again, please send a full bug report.  An emailed one would be OK in
> > this case.
> 
> I've reported this some time ago. I have been recommended to use -mm tree
> instead of the mainline.
> 
> I've also noticed that someone pointed out that for some reason, PCI config
> space is saved twice, the first is OK, the second saves already disabled
> devices. Unfortunately, I'm unable to find this discussion in LKM.

Yeah, that sounds risky.

Can you put a dump_stack() call into the PCI saving function?  That way
we'll see what the two call paths are.


> This is not a regression, this problem has been always present in the kernel.
> 
> These devices are not saved correctly:
> 01:01.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev b3)
> 01:01.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C552 IEEE 1394 Controller (rev 08)
> 01:01.2 Generic system peripheral [0805]: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 17)
> 01:01.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 08)
> 01:01.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 03)
> 
> A bit strange, the devices:
> 01:00.0 Ethernet controller 
> 01:02.0 Network controller 
> seem to be OK. These two devices are behind the same PCI bridge as the devices
> above.
> 
> The log contains the following and similar messages for all these devices:
> May 12 22:07:13 anubis kernel: PM: Writing back config space on device
> 0000:01:01.0 at offset f (was 800100, writing ffffffff)
> May 12 22:07:13 anubis kernel: PM: Writing back config space on device
> 0000:01:01.0 at offset e (was d4fc, writing ffffffff)
> May 12 22:07:13 anubis kernel: PM: Writing back config space on device
> 0000:01:01.0 at offset d (was d400, writing ffffffff)
> May 12 22:07:13 anubis kernel: PM: Writing back config space on device
> 0000:01:01.0 at offset c (was 0, writing ffffffff)
> May 12 22:07:13 anubis kernel: PM: Writing back config space on device
> 0000:01:01.0 at offset b (was 0, writing ffffffff)
> May 12 22:07:13 anubis kernel: PM: Writing back config space on device
> 0000:01:01.0 at offset a (was 3bfff000, writing ffffffff)
> May 12 22:07:13 anubis kernel: PM: Writing back config space on device
> 0000:01:01.0 at offset 9 (was 0, writing ffffffff)
> May 12 22:07:13 anubis kernel: PM: Writing back config space on device
> 0000:01:01.0 at offset 8 (was 0, writing ffffffff)
> May 12 22:07:13 anubis kernel: PM: Writing back config space on device
> 0000:01:01.0 at offset 7 (was 0, writing ffffffff)
> May 12 22:07:13 anubis kernel: PM: Writing back config space on device
> 0000:01:01.0 at offset 6 (was 40020201, writing ffffffff)
> May 12 22:07:13 anubis kernel: PM: Writing back config space on device
> 0000:01:01.0 at offset 5 (was 20000dc, writing ffffffff)
> May 12 22:07:13 anubis kernel: PM: Writing back config space on device
> 0000:01:01.0 at offset 4 (was 0, writing ffffffff)
> May 12 22:07:13 anubis kernel: PM: Writing back config space on device
> 0000:01:01.0 at offset 3 (was 822000, writing ffffffff)
> May 12 22:07:13 anubis kernel: PM: Writing back config space on device
> 0000:01:01.0 at offset 2 (was 60700b3, writing ffffffff)
> May 12 22:07:13 anubis kernel: PM: Writing back config space on device
> 0000:01:01.0 at offset 1 (was 2100107, writing ffffffff)
> May 12 22:07:13 anubis kernel: PM: Writing back config space on device
> 0000:01:01.0 at offset 0 (was 4761180, writing ffffffff)

It does seem wrong.
