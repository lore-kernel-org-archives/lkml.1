Return-Path: <linux-kernel-owner+w=401wt.eu-S965418AbXCARNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965418AbXCARNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 12:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965427AbXCARNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 12:13:39 -0500
Received: from smtp-out.google.com ([216.239.45.13]:14620 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965424AbXCARNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 12:13:31 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=qdFeeqRQBO6Xzpg+d3h1MGOlglfyaEezsOpu6VYa4qc5GzKFm/xrwCYPP+rUSMKY0
	i2oqE1hzLuXcyvdOMUftQ==
Date: Thu, 1 Mar 2007 09:13:13 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <ak@suse.de>, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org
Subject: [patch -mm 5/7] x86_64: disable alien cache for fake numa
In-Reply-To: <Pine.LNX.4.64.0703010129180.10045@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0703010130310.10045@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0703010127130.10045@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0703010128150.10045@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0703010128490.10045@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0703010129180.10045@chino.kir.corp.google.com>
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
