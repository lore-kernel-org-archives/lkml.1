Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbZFEAPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbZFEAPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 20:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbZFEAP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 20:15:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58163 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbZFEAP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 20:15:28 -0400
Date: Thu, 4 Jun 2009 20:15:10 -0400
From: Dave Jones <davej@redhat.com>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: Harald Welte <HaraldWelte@viatech.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Message-ID: <20090605001510.GA2479@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Michael S. Zick" <lkml@morethan.org>,
	Harald Welte <HaraldWelte@viatech.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Duane Griffin <duaneg@dghda.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <20090604214301.GB20822@redhat.com> <200906041700.17852.lkml@morethan.org> <200906041826.42856.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906041826.42856.lkml@morethan.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 06:26:40PM -0500, Michael S. Zick wrote:
 > On Thu June 4 2009, Michael S. Zick wrote:
 > > On Thu June 4 2009, Dave Jones wrote:
 > > > On Thu, Jun 04, 2009 at 04:38:13PM -0500, Michael S. Zick wrote:
 > >
 > 
 > I have it now, you where speaking of the "product vendor Centaur"
 > not a specific model name "Centaur".
 > 
 > Which I translate into: that statement block needs to be converted into
 > (possibly nested) switch statement(s).
 > Since there is not a "model check" in it only a "Series" and "Vendor" check.
 > 
 > Yuck.

I meant just doing something like this..

(untested)

I'm not sure if the clflush_size==0 case can happen, which is why
I left the fallback.  Maybe on ancient cpus?

	Dave

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 2202b62..a293c71 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -426,11 +426,14 @@ int __init pcibios_init(void)
 	 * and P4. It's also good for 386/486s (which actually have 16)
 	 * as quite a few PCI devices do not support smaller values.
 	 */
-	pci_cache_line_size = 32 >> 2;
-	if (c->x86 >= 6 && c->x86_vendor == X86_VENDOR_AMD)
-		pci_cache_line_size = 64 >> 2;	/* K7 & K8 */
-	else if (c->x86 > 6 && c->x86_vendor == X86_VENDOR_INTEL)
-		pci_cache_line_size = 128 >> 2;	/* P4 */
+
+	if (c->x86_clflush_size > 0)
+		pci_cache_line_size = c->x86_clflush_size >> 2;
+	else
+		pci_cache_line_size = 32 >> 2;
+
+	printk(KERN_DEBUG "PCI: pci_cache_line_size set to %d bytes\n",
+		pci_cache_line_size >> 2);
 
 	pcibios_resource_survey();
 
