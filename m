Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbZEKJyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbZEKJyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757902AbZEKJxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:53:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:53849 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757890AbZEKJxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:53:41 -0400
Date: Mon, 11 May 2009 09:51:45 GMT
From: tip-bot for Linus Torvalds <torvalds@linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, torvalds@linux-foundation.org,
       jesse.barnes@intel.com, yannick.roehlly@free.fr,
       akpm@linux-foundation.org, ink@jurassic.park.msu.ru, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, torvalds@linux-foundation.org,
       jesse.barnes@intel.com, yannick.roehlly@free.fr,
       akpm@linux-foundation.org, ink@jurassic.park.msu.ru, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4A01A784.2050407@kernel.org>
References: <4A01A784.2050407@kernel.org>
Subject: [tip:x86/mm] x86, e820, pci: reserve extra free space near end of RAM
Message-ID: <tip-45fbe3ee01b8e463b28c2751b5dcc0cbdc142d90@git.kernel.org>
Git-Commit-ID: 45fbe3ee01b8e463b28c2751b5dcc0cbdc142d90
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 09:51:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45fbe3ee01b8e463b28c2751b5dcc0cbdc142d90
Gitweb:     http://git.kernel.org/tip/45fbe3ee01b8e463b28c2751b5dcc0cbdc142d90
Author:     Linus Torvalds <torvalds@linux-foundation.org>
AuthorDate: Wed, 6 May 2009 08:06:44 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 09:45:14 +0200

x86, e820, pci: reserve extra free space near end of RAM

The point is to take all RAM resources we have, and
_after_ we've added all the resources we've seen in
the E820 tree, we then _also_ try to add fake reserved
entries for any "round up to X" at the end of the RAM
resources.

[ Impact: improve PCI mem-resource allocation robustness, protect "stolen RAM" ]

Reported-by: Yannick Roehlly <yannick.roehlly@free.fr>
Acked-by: Jesse Barnes <jesse.barnes@intel.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: yannick.roehlly@free.fr
LKML-Reference: <4A01A784.2050407@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/e820.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 0062813..a2335d9 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1371,6 +1371,23 @@ void __init e820_reserve_resources(void)
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
@@ -1382,6 +1399,24 @@ void __init e820_reserve_resources_late(void)
 			insert_resource_expand_to_fit(&iomem_resource, res);
 		res++;
 	}
+
+	/*
+	 * Try to bump up RAM regions to reasonable boundaries to
+	 * avoid stolen RAM:
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
