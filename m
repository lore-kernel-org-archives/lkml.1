Return-Path: <linux-kernel-owner+w=401wt.eu-S1752446AbXBDRVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbXBDRVE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 12:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbXBDRVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 12:21:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446AbXBDRVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 12:21:03 -0500
Date: Sun, 4 Feb 2007 12:18:50 -0500
From: Dave Jones <davej@redhat.com>
To: Eric Piel <Eric.Piel@tremplin-utc.net>
Cc: Wang Zhenyu <zhenyu.z.wang@intel.com>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.20-rc7 regression on intel-agp
Message-ID: <20070204171850.GA17171@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Eric Piel <Eric.Piel@tremplin-utc.net>,
	Wang Zhenyu <zhenyu.z.wang@intel.com>, linux-kernel@vger.kernel.org,
	Adrian Bunk <bunk@stusta.de>
References: <45C6010A.9010902@tremplin-utc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C6010A.9010902@tremplin-utc.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 04, 2007 at 04:51:38PM +0100, Eric Piel wrote:
 > Hello,
 > 
 > I've got a regression in 2.6.20-rc7 (-rc6 was fine) due to commit 
 > 4b95320fc4d21b0ff2f8604305dd6c851aff6096 ([AGPGART] intel_agp: restore 
 > graphics device's pci space early in resume).

I think the key to this failure is the last line here ..

 > agpgart-intel 0000:00:00.0: resuming
 > PM: Writing back config space on device 0000:00:02.0 at offset f (was 10b, writing 0)
 > PM: Writing back config space on device 0000:00:02.0 at offset d (was dc, writing 0)
 > PM: Writing back config space on device 0000:00:02.0 at offset b (was 10161025, writing 0)
 > PM: Writing back config space on device 0000:00:02.0 at offset 5 (was f4000000, writing 0)
 > PM: Writing back config space on device 0000:00:02.0 at offset 4 (was f8000008, writing 0)
 > PM: Writing back config space on device 0000:00:02.0 at offset 2 (was 3000011, writing 0)
 > PM: Writing back config space on device 0000:00:02.0 at offset 1 (was 2b00007, writing 0)
 > PM: Writing back config space on device 0000:00:02.0 at offset 0 (was 11328086, writing 0)
 > agpgart: Unable to remap memory.

This then blows up the next access to intel_i810_private.registers, which happens to
be intel_i810_insert_entries.

Either we need .suspend methods which unmap these regions, or we need
to skip trying to map them a second time on resume.

There's an ugly patch below which does the latter. Give it a try?

The intel-agp suspend/resume code has really grown into something
of a monster, and could use some refactoring in a big way.

		Dave

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index a3011de..84787ce 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -117,13 +117,15 @@ static int intel_i810_configure(void)
 
 	current_size = A_SIZE_FIX(agp_bridge->current_size);
 
-	pci_read_config_dword(intel_i810_private.i810_dev, I810_MMADDR, &temp);
-	temp &= 0xfff80000;
-
-	intel_i810_private.registers = ioremap(temp, 128 * 4096);
 	if (!intel_i810_private.registers) {
-		printk(KERN_ERR PFX "Unable to remap memory.\n");
-		return -ENOMEM;
+		pci_read_config_dword(intel_i810_private.i810_dev, I810_MMADDR, &temp);
+		temp &= 0xfff80000;
+
+		intel_i810_private.registers = ioremap(temp, 128 * 4096);
+		if (!intel_i810_private.registers) {
+			printk(KERN_ERR PFX "Unable to remap memory.\n");
+			return -ENOMEM;
+		}
 	}
 
 	if ((readl(intel_i810_private.registers+I810_DRAM_CTL)
-- 
http://www.codemonkey.org.uk
