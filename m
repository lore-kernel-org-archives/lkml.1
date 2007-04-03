Return-Path: <linux-kernel-owner+w=401wt.eu-S965663AbXDCRPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965663AbXDCRPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965714AbXDCRPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:15:18 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:35746 "EHLO
	outbound4-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965663AbXDCRPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:15:15 -0400
X-BigFish: VP
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Message-ID: <46128B84.3070303@amd.com>
Date: Tue, 03 Apr 2007 12:14:44 -0500
From: "Mark Langsdorf" <mark.langsdorf@amd.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] allocate GART/IOMMU aperture from any node
X-OriginalArrivalTime: 03 Apr 2007 17:14:58.0321 (UTC)
 FILETIME=[9B2CD010:01C77613]
X-WSS-ID: 6A0C54182EW3035609-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linux always tries to allocate the GART/IOMMU aperture from the
boot node memory.  However, it is legal to boot with no memory
attached to the boot node, in which case the system crashes with
invalid memory assignments.  Generalize the memory allocation to
support any node in the system with memory.

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>

--- linux-2.6.20/arch/x86_64/kernel/aperture.c.old	2007-04-02 
17:11:18.000000000 -0500
+++ linux-2.6.20/arch/x86_64/kernel/aperture.c	2007-04-02 
19:03:43.000000000 -0500
@@ -51,7 +51,6 @@ static void __init insert_aperture_resou

  static u32 __init allocate_aperture(void)
  {
-	pg_data_t *nd0 = NODE_DATA(0);
  	u32 aper_size;
  	void *p;

@@ -65,12 +64,12 @@ static u32 __init allocate_aperture(void
  	 * Unfortunately we cannot move it up because that would make the
  	 * IOMMU useless.
  	 */
-	p = __alloc_bootmem_node(nd0, aper_size, aper_size, 0);
+	p = __alloc_bootmem(aper_size, aper_size, 0);
  	if (!p || __pa(p)+aper_size > 0xffffffff) {
  		printk("Cannot allocate aperture memory hole (%p,%uK)\n",
  		       p, aper_size>>10);
  		if (p)
-			free_bootmem_node(nd0, __pa(p), aper_size);
+			free_bootmem(__pa(p), aper_size);
  		return 0;
  	}
  	printk("Mapping aperture over %d KB of RAM @ %lx\n",


