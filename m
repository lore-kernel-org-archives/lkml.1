Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbZLSVi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbZLSVi0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 16:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbZLSViZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 16:38:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:60828 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbZLSViZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 16:38:25 -0500
Message-ID: <4B2D4781.20907@kernel.org>
Date: Sat, 19 Dec 2009 13:37:05 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Vincent ETIENNE <ve@vetienne.net>
CC: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: Re: Kernel 2.66.33-rC1 boot problem bisected to commit 99935a7a59eaca0292c1a5880e10bae03f4a5e3d
References: <200912191707.16648.ve@vetienne.net>
In-Reply-To: <200912191707.16648.ve@vetienne.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vincent ETIENNE wrote:
> 
> I am experiencing boot problem with kernel 2.6.33-rc1.  Bisection points to
> 
> commit 99935a7a59eaca0292c1a5880e10bae03f4a5e3d
> Author: Yinghai Lu <yinghai@kernel.org>
> Date:   Sun Oct 4 21:54:24 2009 -0700
> 
>     x86/PCI: read root resources from IOH on Intel
> 
>     For intel systems with multi IOH, we should read peer root resources
>     directly from PCI config space, and don't trust _CRS.
> 
>     Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
>     Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> 
> 
> 
> V2.6.32 is OK
> 
> V2.6.33 is bad. A brief summary of the problem  is that very quickly kernel ( 
> less than 1.5 seconds) try to mount the root device without doing any probing 
> on disk leading to a kernel panic ( could not mount root devices).  Alsa 
> devices and usb devices is also not detected / not probed. Maybe other devices 
> is also not detected but that just from the message seen on the monitor before 
> the panic so it's not very accurate (no log as it doesn't boot and only one 
> computer so no serial console). Sounds like the kernel didn't see any devices 
> (disk, usb, sounds). 
> 
> I have a intel system so the commit log seems possibly relevant for the my 
> computer (Not sure of what is IOH, i have take it for I/O Hub in the lspci out 
> output and i have 3 of these according to lspci).
> 
> Have try to revert the commit on a 2.6.33_rc1 base but this lead to some 
> compilation problem (symbol not defined and so on).  So I'm not completely sure 
> of my bisection (also note that it's the first time i use git so an error is 
> very possible).
> 
> Attached a dmesg log with kernel 2.6.32-rc8 and lspci -vvv output.
> 
> If you need further information/testing, i will my best to provide these.

please check

Subject: [PATCH 1/7] x86/pci: intel ioh bus num reg accessing fix

it is above 0x100, so if mmconf is not enable, need to skip it

Reported-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/intel_bus.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/arch/x86/pci/intel_bus.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/intel_bus.c
+++ linux-2.6/arch/x86/pci/intel_bus.c
@@ -49,6 +49,10 @@ static void __devinit pci_root_bus_res(s
 	u64 mmioh_base, mmioh_end;
 	int bus_base, bus_end;
 
+	/* some sys doesn't get mmconf enabled */
+	if (dev->cfg_size < 0x200)
+		return;
+
 	if (pci_root_num >= PCI_ROOT_NR) {
 		printk(KERN_DEBUG "intel_bus.c: PCI_ROOT_NR is too small\n");
 		return;

