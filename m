Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbYKYV0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbYKYV0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbYKYV0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:26:39 -0500
Received: from gw.goop.org ([64.81.55.164]:43687 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbYKYV0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:26:39 -0500
Message-ID: <492C6D8D.3040600@goop.org>
Date: Tue, 25 Nov 2008 13:26:37 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Stable Kernel <stable@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?B?RGFuaWVsIFNjaHLDtmRlcg==?= <mail@dschroeder.info>,
       Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Change 5c371b31be3203 in stable breaks Xen
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a report of Xen breaking between 2.6.27.5 and .6.  I bisected it 
down to change:

commit 5c371b31be32033b0a4a993431484da8a2305369
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Mon Sep 22 02:52:26 2008 -0700

    x86: fix CONFIG_X86_RESERVE_LOW_64K=y
   
    commit 2216d199b1430d1c0affb1498a9ebdbd9c0de439 upstream
   
    The bad_bios_dmi_table() quirk never triggered because we do DMI setup
    too late. Move it a bit earlier.
   
    Also change the CONFIG_X86_RESERVE_LOW_64K quirk to operate on the e820
    table directly instead of messing with early reservations - this handles
    overlaps (which do occur in this low range of RAM) more gracefully.
   
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

I haven't completely root-caused why this is OK in mainline but failing 
in stable, but this patch works around the problem.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 455575b..abed1dd 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -7,6 +7,7 @@
 #include <linux/bootmem.h>
 #include <linux/slab.h>
 #include <asm/dmi.h>
+#include <asm/xen/hypervisor.h>
 
 /*
  * DMI stands for "Desktop Management Interface".  It is part
@@ -364,6 +365,11 @@ void __init dmi_scan_machine(void)
        char __iomem *p, *q;
        int rc;
 
+#ifdef CONFIG_XEN
+       if (is_running_on_xen())
+               return;
+#endif
+
        if (efi_enabled) {
                if (efi.smbios == EFI_INVALID_TABLE_ADDR)
                        goto out;


