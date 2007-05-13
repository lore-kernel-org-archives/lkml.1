Return-Path: <linux-kernel-owner+w=401wt.eu-S1757739AbXEMI5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739AbXEMI5W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 04:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756689AbXEMI5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 04:57:14 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:56966 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756441AbXEMI5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 04:57:12 -0400
Date: Sun, 13 May 2007 10:57:18 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Workaround for a PCI restoring bug
Message-ID: <20070513085718.GD3580@ics.muni.cz>
References: <20070512201237.GB3569@ics.muni.cz> <20070512234743.0a8a915f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070512234743.0a8a915f.akpm@linux-foundation.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@fi.muni.cz
X-Muni-Envelope-To: linux-kernel@vger.kernel.org
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sun, 13 May 2007 10:57:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, May 12, 2007 at 11:47:43PM -0700, Andrew Morton wrote:
> This change might indeed be a suitable workaround for some busted hardware,
> but we'd need to know quite a bit about the problem before we could merge
> anything like this
> 
> So, again, please send a full bug report.  An emailed one would be OK in
> this case.

I've reported this some time ago. I have been recommended to use -mm tree
instead of the mainline.

I've also noticed that someone pointed out that for some reason, PCI config
space is saved twice, the first is OK, the second saves already disabled
devices. Unfortunately, I'm unable to find this discussion in LKM.

This is not a regression, this problem has been always present in the kernel.

These devices are not saved correctly:
01:01.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev b3)
01:01.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C552 IEEE 1394 Controller (rev 08)
01:01.2 Generic system peripheral [0805]: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 17)
01:01.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 08)
01:01.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 03)

A bit strange, the devices:
01:00.0 Ethernet controller 
01:02.0 Network controller 
seem to be OK. These two devices are behind the same PCI bridge as the devices
above.

The log contains the following and similar messages for all these devices:
May 12 22:07:13 anubis kernel: PM: Writing back config space on device
0000:01:01.0 at offset f (was 800100, writing ffffffff)
May 12 22:07:13 anubis kernel: PM: Writing back config space on device
0000:01:01.0 at offset e (was d4fc, writing ffffffff)
May 12 22:07:13 anubis kernel: PM: Writing back config space on device
0000:01:01.0 at offset d (was d400, writing ffffffff)
May 12 22:07:13 anubis kernel: PM: Writing back config space on device
0000:01:01.0 at offset c (was 0, writing ffffffff)
May 12 22:07:13 anubis kernel: PM: Writing back config space on device
0000:01:01.0 at offset b (was 0, writing ffffffff)
May 12 22:07:13 anubis kernel: PM: Writing back config space on device
0000:01:01.0 at offset a (was 3bfff000, writing ffffffff)
May 12 22:07:13 anubis kernel: PM: Writing back config space on device
0000:01:01.0 at offset 9 (was 0, writing ffffffff)
May 12 22:07:13 anubis kernel: PM: Writing back config space on device
0000:01:01.0 at offset 8 (was 0, writing ffffffff)
May 12 22:07:13 anubis kernel: PM: Writing back config space on device
0000:01:01.0 at offset 7 (was 0, writing ffffffff)
May 12 22:07:13 anubis kernel: PM: Writing back config space on device
0000:01:01.0 at offset 6 (was 40020201, writing ffffffff)
May 12 22:07:13 anubis kernel: PM: Writing back config space on device
0000:01:01.0 at offset 5 (was 20000dc, writing ffffffff)
May 12 22:07:13 anubis kernel: PM: Writing back config space on device
0000:01:01.0 at offset 4 (was 0, writing ffffffff)
May 12 22:07:13 anubis kernel: PM: Writing back config space on device
0000:01:01.0 at offset 3 (was 822000, writing ffffffff)
May 12 22:07:13 anubis kernel: PM: Writing back config space on device
0000:01:01.0 at offset 2 (was 60700b3, writing ffffffff)
May 12 22:07:13 anubis kernel: PM: Writing back config space on device
0000:01:01.0 at offset 1 (was 2100107, writing ffffffff)
May 12 22:07:13 anubis kernel: PM: Writing back config space on device
0000:01:01.0 at offset 0 (was 4761180, writing ffffffff)


-- 
Luká¹ Hejtmánek
