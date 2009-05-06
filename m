Return-Path: <linux-kernel-owner+w=401wt.eu-S1760230AbZEFPJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230AbZEFPJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756696AbZEFPJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 11:09:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:35775 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756543AbZEFPJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 11:09:13 -0400
Message-ID: <4A01A784.2050407@kernel.org>
Date: Wed, 06 May 2009 08:06:44 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jesse Barnes <jesse.barnes@intel.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: [PATCH 1/2] x86: reserve range near the ram
References: <49EF9C10.6090107@kernel.org> <20090422154900.08f8f366@hobbes> <49EFBB0E.3030401@kernel.org> <20090422180505.2518e837@hobbes> <49EFCE15.3030605@kernel.org> <20090423132202.GB13984@jurassic.park.msu.ru> <49F08580.9050407@kernel.org> <20090423221936.GA24171@jurassic.park.msu.ru> <49F13690.3080902@kernel.org> <20090505115248.63d112f4@hobbes> <20090506123346.GA19541@elte.hu>
In-Reply-To: <20090506123346.GA19541@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>


The point is to take all RAM resources we have, and 
_after_ we've added all the resources we've seen in the E820 tree, we then 
_also_ try to add fake reserved entries for any "round up to X" at the end 
of the RAM resources.

[ Impact: protect stolen RAM ]

Acked-by: Jesse Barnes <jesse.barnes@intel.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/e820.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -1370,6 +1370,23 @@ void __init e820_reserve_resources(void)
 	}
 }
 
+/* How much should we pad RAM ending depending on where it is? */
+static unsigned long ram_alignment(resource_size_t pos)
+{
+	unsigned long mb = pos >> 20;
+
+	/* To 64kB in the first megabyte */
+	if (!mb)
+		return 64*1024;
+
+	/* To 1MB in the first 16MB */
+	if (mb < 16)
+		return 1024*1024;
+
+	/* To 32MB for anything above that */
+	return 32*1024*1024;
+}
+
 void __init e820_reserve_resources_late(void)
 {
 	int i;
@@ -1381,6 +1398,24 @@ void __init e820_reserve_resources_late(
 			insert_resource_expand_to_fit(&iomem_resource, res);
 		res++;
 	}
+
+	/*
+	 * Try to bump up RAM regions to reasonable boundaries to
+	 * avoid stolen RAM
+	 */
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *entry = &e820_saved.map[i];
+		resource_size_t start, end;
+
+		if (entry->type != E820_RAM)
+			continue;
+		start = entry->addr + entry->size;
+		end = round_up(start, ram_alignment(start));
+		if (start == end)
+			continue;
+		reserve_region_with_split(&iomem_resource, start,
+						  end - 1, "RAM buffer");
+	}
 }
 
 char *__init default_machine_specific_memory_setup(void)
