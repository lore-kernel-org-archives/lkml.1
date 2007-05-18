Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbXERPgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbXERPgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 11:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbXERPgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 11:36:32 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53229 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755492AbXERPgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 11:36:31 -0400
Date: Fri, 18 May 2007 08:34:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: zilvinas@wilibox.com
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: Kernel NFS lockd freezes notebook on shutdown (Linux 2.6.22-rc1
 + CFS v12)
Message-Id: <20070518083435.7588b300.akpm@linux-foundation.org>
In-Reply-To: <1179490656.5512.3.camel@zv.wilibox.com>
References: <1179338441.4265.13.camel@zv.wilibox.com>
	<20070516121538.7b108c10.akpm@linux-foundation.org>
	<1179490656.5512.3.camel@zv.wilibox.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007 15:17:36 +0300 Zilvinas Valinskas <zilvinas@wilibox.com> wrote:

> Have found this in dmesg (well earlier because of initcall_debug) I've
> never noticed that during boot (scrolls away too fast). Anyway -
> 
> [    7.841871] NetLabel: Initializing
> [    7.841983] NetLabel:  domain hash size = 128
> [    7.842095] NetLabel:  protocols = UNLABELED CIPSOv4
> [    7.842219] NetLabel:  unlabeled traffic allowed by default
> [    7.842338] BUG: at include/linux/slub_def.h:77 kmalloc_index()
> [    7.842451] 
> [    7.842452] Call Trace:
> [    7.842677]  [<ffffffff8029215c>] get_slab+0x1cc/0x260
> [    7.842791]  [<ffffffff8029229d>] __kmalloc+0xd/0x80
> [    7.842907]  [<ffffffff802219ee>] cache_k8_northbridges+0x7e/0x100
> [    7.843024]  [<ffffffff8062bd13>] gart_iommu_init+0x33/0x5b0
> [    7.843140]  [<ffffffff8049f836>] netlbl_unlabel_acceptflg_set+0x86/0xf0
> [    7.843255]  [<ffffffff80626f49>] pci_iommu_init+0x9/0x20
> [    7.843370]  [<ffffffff806216d7>] kernel_init+0x157/0x330
> [    7.843485]  [<ffffffff8020b0f8>] child_rip+0xa/0x12
> [    7.843601]  [<ffffffff80373fd8>] acpi_ds_init_one_object+0x0/0x7c
> [    7.843715]  [<ffffffff80621580>] kernel_init+0x0/0x330
> [    7.843829]  [<ffffffff8020b0ee>] child_rip+0x0/0x12
> [    7.843941] 
> [    7.844056] PCI-GART: No AMD northbridge found.


yup, thanks - the below patch will be in this evening's batch -> Linus.



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

> Does this backtrace looks sane ? Hmm, netlabel code mixes with
> acpi_ds_init_one_object() ... Strange.

Backtraces can be pretty messy nowadays.  CONFIG_FRAME_POINTER helps
improve them.

