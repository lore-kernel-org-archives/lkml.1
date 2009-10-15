Return-Path: <linux-kernel-owner+w=401wt.eu-S1762300AbZJOAwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762300AbZJOAwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 20:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761723AbZJOAwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 20:52:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069AbZJOAwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 20:52:00 -0400
Date: Wed, 14 Oct 2009 20:51:31 -0400
From: Dave Jones <davej@redhat.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [X86] PCI: Use generic cacheline sizing instead of per-vendor
	tests.
Message-ID: <20091015005131.GA19155@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20091014203139.GA2336@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014203139.GA2336@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 04:31:39PM -0400, Dave Jones wrote:

 > I've been carrying a variant of this code in Fedora for a while,
 > that prints debug information.  There are a number of cases where we
 > are currently setting the PCI cacheline size to 32 bytes, when the CPU
 > cacheline size is 64 bytes.  With this patch, we set them both the same.
 
In case anyone is curious, here's the version we carried in Fedora for a while..

	Dave

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 2202b62..f371fe8 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -432,6 +432,22 @@ int __init pcibios_init(void)
 	else if (c->x86 > 6 && c->x86_vendor == X86_VENDOR_INTEL)
 		pci_cache_line_size = 128 >> 2;	/* P4 */
 
+	if (c->x86_clflush_size != (pci_cache_line_size <<2))
+		printk(KERN_DEBUG "PCI: old code would have set cacheline "
+			"size to %d bytes, but clflush_size = %d\n",
+			pci_cache_line_size << 2,
+			c->x86_clflush_size);
+
+	/* Once we know this logic works, all the above code can be deleted. */
+	if (c->x86_clflush_size > 0) {
+		pci_cache_line_size = c->x86_clflush_size >> 2;
+		printk(KERN_DEBUG "PCI: pci_cache_line_size set to %d bytes\n",
+			pci_cache_line_size << 2);
+	} else {
+		pci_cache_line_size = 32 >> 2;
+		printk(KERN_DEBUG "PCI: Unknown cacheline size. Setting to 32 bytes\n");
+	}
+
 	pcibios_resource_survey();
 
 	if (pci_bf_sort >= pci_force_bf)
