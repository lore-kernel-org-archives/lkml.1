Return-Path: <linux-kernel-owner+w=401wt.eu-S1751718AbZDTQNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718AbZDTQNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 12:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbZDTQNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 12:13:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:59616 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbZDTQNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 12:13:35 -0400
Date: Mon, 20 Apr 2009 16:12:38 GMT
From: tip-bot for Jack Steiner <steiner@sgi.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090420132530.GA23156@sgi.com>
References: <20090420132530.GA23156@sgi.com>
Subject: [tip:x86/urgent] x86/uv: fix for no memory at paddr 0
Message-ID: <tip-fc61e6636d13eb3a23eb29b4327eeee9de0ef3bc@git.kernel.org>
Git-Commit-ID: fc61e6636d13eb3a23eb29b4327eeee9de0ef3bc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 20 Apr 2009 16:12:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc61e6636d13eb3a23eb29b4327eeee9de0ef3bc
Gitweb:     http://git.kernel.org/tip/fc61e6636d13eb3a23eb29b4327eeee9de0ef3bc
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Mon, 20 Apr 2009 08:25:31 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 20 Apr 2009 18:09:18 +0200

x86/uv: fix for no memory at paddr 0

Fix endcase where the memory at physical address 0 does not really
exist AND one of the sockets on blade 0 has no active cpus.

The memory that _appears_ to be at physical address 0 is actually
memory that located at a different address but has been remapped by
the chipset so that it appears to be at physical address 0.

When determining the UV pnode, the algorithm for determining the pnode
incorrectly used the relocated physical address instead of the actual
(global) address.

[ Impact: boot failure on partitioned systems ]

Signed-off-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20090420132530.GA23156@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/x2apic_uv_x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index d671233..2bda693 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -652,6 +652,7 @@ void __init uv_system_init(void)
 		if (uv_node_to_blade[nid] >= 0)
 			continue;
 		paddr = node_start_pfn(nid) << PAGE_SHIFT;
+		paddr = uv_soc_phys_ram_to_gpa(paddr);
 		pnode = (paddr >> m_val) & pnode_mask;
 		blade = boot_pnode_to_blade(pnode);
 		uv_node_to_blade[nid] = blade;
