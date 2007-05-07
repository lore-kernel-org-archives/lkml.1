Return-Path: <linux-kernel-owner+w=401wt.eu-S934156AbXEGO2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934156AbXEGO2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 10:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934145AbXEGO2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 10:28:32 -0400
Received: from smtp-out.google.com ([216.239.45.13]:45992 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934152AbXEGO2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 10:28:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=LQcr02iOb44R3dixIsMf5ZkDycdsHvQiGR24g+4Fgurh4Wgt2hxZUpBoxAQ1qBJUv
	jU62dZVbRrvYvTZABkcDw==
Date: Mon, 7 May 2007 07:28:24 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <ak@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: [2.6.22 patch 4/4] x86_64: fix fake numa for machines with true srat
In-Reply-To: <Pine.LNX.4.64.0705061705050.27058@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0705061705300.27058@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705061703060.27058@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705061704380.27058@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705061705050.27058@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly exported disable_srat() function to disable all SRAT 
detected values before registering emulated node active regions or calling
setup_node_bootmem().  This ensures we are correctly srat_disabled() since
we never call acpi_scan_nodes() in the emulated case, even on true SRAT 
machines.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86_64/mm/numa.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/x86_64/mm/numa.c b/arch/x86_64/mm/numa.c
--- a/arch/x86_64/mm/numa.c
+++ b/arch/x86_64/mm/numa.c
@@ -463,6 +463,7 @@ done:
 		}
 	}
 out:
+	disable_srat();
 	memnode_shift = compute_hash_shift(nodes, num_nodes);
 	if (memnode_shift < 0) {
 		memnode_shift = 0;
@@ -470,12 +471,6 @@ out:
 		       "disabled.\n");
 		return -1;
 	}
-
-	/*
-	 * We need to vacate all active ranges that may have been registered by
-	 * SRAT.
-	 */
-	remove_all_active_ranges();
 	for_each_node_mask(i, node_possible_map) {
 		e820_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
 						nodes[i].end >> PAGE_SHIFT);
