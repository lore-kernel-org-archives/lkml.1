Return-Path: <linux-kernel-owner+w=401wt.eu-S965250AbXBFDRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965250AbXBFDRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 22:17:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965244AbXBFDRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 22:17:05 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:45315 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965250AbXBFDRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 22:17:03 -0500
Date: Mon, 05 Feb 2007 21:16:59 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: wbsd: IRQ handler type mismatch
To: linux-kernel <linux-kernel@vger.kernel.org>, drzeus-wbsd@drzeus.cx,
       wbsd-devel@list.drzeus.cx
Message-id: <45C7F32B.1060402@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing this on bootup on my laptop with recent kernels (currently 
2.6.20-rc6-mm3):

Floppy drive(s): fd0 is 1.44M
IRQ handler type mismatch for IRQ 6
current handler: wbsd
  [<c0451fe7>] setup_irq+0x194/0x1ac
  [<e0ad7189>] floppy_hardint+0x0/0xc0 [floppy]
  [<c045207b>] request_irq+0x7c/0x98
  [<e0a5c67c>] init_module+0x546/0xe15 [floppy]
  [<c05ffe85>] _spin_unlock_irq+0x5/0x7
  [<c0442410>] __link_module+0x0/0x10
  [<c0442410>] __link_module+0x0/0x10
  [<c0443d6c>] sys_init_module+0x1781/0x18c8
  [<c04dbf10>] blk_init_queue+0x0/0x8
  [<c04734f6>] vfs_read+0xa6/0x152
  [<c0404e26>] sysenter_past_esp+0x5f/0x85
  [<c0600000>] error_code+0x68/0x84
  =======================
floppy0: Unable to grab IRQ6 for the floppy driver

It looks like wbsd is being loaded first, which being a nice PnP device 
sees that IRQ 6 is available and grabs it. Then the we try to load the 
floppy module (which is hard-coded to use IRQ 6) which fails because 
wbsd already owns IRQ6 (which is fine, there's no floppy controller 
anyway). The mismatch is occurring because wbsd passes IRQF_SHARED 
whereas floppy doesn't. I assume one of the two is likely wrong. Should 
wbsd really be passing IRQF_SHARED here? This is an LPC device which 
uses ISA-style edge triggered interrupts, is it safe to try and share an 
interrupt with this chip anyway?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

