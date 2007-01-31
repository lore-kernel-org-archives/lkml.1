Return-Path: <linux-kernel-owner+w=401wt.eu-S965441AbXAaPTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965441AbXAaPTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 10:19:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965344AbXAaPSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 10:18:42 -0500
Received: from smtp-out.google.com ([216.239.45.13]:56140 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965273AbXAaPSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 10:18:36 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=K6mHUZ3N/uaKZMK3rJxzy7clj33OvLp0SvXg7vijTES6KSrtT7AFHTWXnbSugAtOy
	oo00VpkZmWH9gAlB4U/vg==
Date: Wed, 31 Jan 2007 07:18:24 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@osdl.org>
cc: Andi Kleen <ak@suse.de>, Paul Menage <menage@google.com>,
       Rohit Seth <rohitseth@google.com>, linux-kernel@vger.kernel.org
Subject: [patch -mm 6/7] x86_64: disable alien cache for fake numa
In-Reply-To: <Pine.LNX.4.64.0701302225390.23658@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0701302226040.23658@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0701302223230.23653@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0701302224300.23658@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0701302224550.23658@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0701302225200.23658@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0701302225390.23658@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Disables using alien cache for slab when NUMA emulation is being used.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Paul Menage <menage@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86_64/mm/numa.c |    2 ++
 mm/slab.c             |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86_64/mm/numa.c b/arch/x86_64/mm/numa.c
index 97b7be4..7edb1b8 100644
--- a/arch/x86_64/mm/numa.c
+++ b/arch/x86_64/mm/numa.c
@@ -280,6 +280,7 @@ void __init numa_init_array(void)
 	PAGE_SHIFT)
 
 static struct bootnode physical_node_map[MAX_NUMNODES];
+extern int use_alien_caches;
 char *cmdline __initdata;
 int numa_emu;
 
@@ -512,6 +513,7 @@ out:
 						nodes[i].end >> PAGE_SHIFT);
  		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
 	}
+	use_alien_caches = 0;
  	numa_init_array();
  	return 0;
 }
diff --git a/mm/slab.c b/mm/slab.c
index 22bad53..0e68246 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -889,7 +889,7 @@ static void __slab_error(const char *function, struct kmem_cache *cachep,
  * line
   */
 
-static int use_alien_caches __read_mostly = 1;
+int use_alien_caches __read_mostly = 1;
 static int __init noaliencache_setup(char *s)
 {
 	use_alien_caches = 0;
