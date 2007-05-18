Return-Path: <linux-kernel-owner+w=401wt.eu-S1760946AbXERGGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760946AbXERGGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 02:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbXERGGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:06:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50399 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752389AbXERGGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:06:11 -0400
Date: Thu, 17 May 2007 23:04:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: BUG in mm/slab.c
Message-Id: <20070517230455.ffed5138.akpm@linux-foundation.org>
In-Reply-To: <464D3F50.3080505@garzik.org>
References: <464D3F50.3080505@garzik.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007 01:53:20 -0400 Jeff Garzik <jeff@garzik.org> wrote:

> Platform:  Fedora Core 6/x86-64 (lspci, kconfig, dmesg attached)
> 
> dmesg shows:
> > PCI: Using ACPI for IRQ routing
> > PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
> > BUG: at mm/slab.c:777 __find_general_cachep()
> > 
> > Call Trace:
> >  [<ffffffff802819b7>] __kmalloc+0xa7/0xe0
> >  [<ffffffff8021b7bd>] cache_k8_northbridges+0x9d/0x120
> >  [<ffffffff8053bb03>] gart_iommu_init+0x33/0x5b0
> >  [<ffffffff80228673>] __wake_up+0x43/0x70
> >  [<ffffffff803e01a0>] genl_rcv+0x0/0x70
> >  [<ffffffff803de768>] netlink_kernel_create+0x158/0x170
> >  [<ffffffff803dffd0>] genl_unlock+0x10/0x50
> >  [<ffffffff80535879>] pci_iommu_init+0x9/0x20
> >  [<ffffffff8052c6d4>] kernel_init+0x154/0x330
> >  [<ffffffff8020a958>] child_rip+0xa/0x12
> >  [<ffffffff803212ac>] acpi_ds_init_one_object+0x0/0x7c
> >  [<ffffffff8052c580>] kernel_init+0x0/0x330
> >  [<ffffffff8020a94e>] child_rip+0x0/0x12
> > 
> > PCI-GART: No AMD northbridge found.
> > hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> > hpet0: 3 64-bit timers, 14318180 Hz
> 
> but the machine continues to work (I'm typing on it right now).  In 
> fact, I only noticed while checking on some SATA stuff :)

Yep, it's just a WARN_ON, no other effect.

I have a cure queued up:


From: Ben Collins <ben.collins@ubuntu.com>

kmalloc for flush_words resulted in zero size allocation when no
k8_northbridges existed.  Short circuit the code path for this case.

Also remove uneeded zeroing of num_k8_northbridges just after checking if
it is zero.

Signed-off-by: Ben Collins <bcollins@ubuntu.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/k8.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/kernel/k8.c~avoid-zero-size-allocation-in-cache_k8_northbridges arch/x86_64/kernel/k8.c
--- a/arch/x86_64/kernel/k8.c~avoid-zero-size-allocation-in-cache_k8_northbridges
+++ a/arch/x86_64/kernel/k8.c
@@ -39,10 +39,10 @@ int cache_k8_northbridges(void)
 {
 	int i;
 	struct pci_dev *dev;
+
 	if (num_k8_northbridges)
 		return 0;
 
-	num_k8_northbridges = 0;
 	dev = NULL;
 	while ((dev = next_k8_northbridge(dev)) != NULL)
 		num_k8_northbridges++;
@@ -52,6 +52,11 @@ int cache_k8_northbridges(void)
 	if (!k8_northbridges)
 		return -ENOMEM;
 
+	if (!num_k8_northbridges) {
+		k8_northbridges[0] = NULL;
+		return 0;
+	}
+
 	flush_words = kmalloc(num_k8_northbridges * sizeof(u32), GFP_KERNEL);
 	if (!flush_words) {
 		kfree(k8_northbridges);
_

