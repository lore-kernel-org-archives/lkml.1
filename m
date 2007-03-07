Return-Path: <linux-kernel-owner+w=401wt.eu-S1422757AbXCGSCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422757AbXCGSCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422750AbXCGSAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:00:12 -0500
Received: from ns.suse.de ([195.135.220.2]:43408 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422766AbXCGRNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:13:33 -0500
Message-Id: <20070307171152.798046861@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:10:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Eric Piel <Eric.Piel@tremplin-utc.net>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Wang Zhenyu <zhenyu.z.wang@intel.com>,
       Adrian Bunk <bunk@stusta.de>
Subject: [patch 011/101] AGP: intel-agp bugfix
Content-Disposition: inline; filename=agp-intel-agp-bugfix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Jones <davej@redhat.com>

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


From: Dave Jones <davej@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/agp/intel-agp.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- linux-2.6.20.1.orig/drivers/char/agp/intel-agp.c
+++ linux-2.6.20.1/drivers/char/agp/intel-agp.c
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
