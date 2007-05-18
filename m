Return-Path: <linux-kernel-owner+w=401wt.eu-S1758960AbXERR4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960AbXERR4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 13:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384AbXERRz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 13:55:57 -0400
Received: from [207.189.120.14] ([207.189.120.14]:56752 "EHLO
	smtp2.linux-foundation.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755182AbXERRz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 13:55:56 -0400
Date: Fri, 18 May 2007 10:53:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] fix unused setup_nr_node_ids
Message-Id: <20070518105318.ae611edc.akpm@linux-foundation.org>
In-Reply-To: <E1Hozre-0003rZ-00@dorka.pomaz.szeredi.hu>
References: <E1Hozre-0003rZ-00@dorka.pomaz.szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007 12:39:14 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> This is now the only (!) compiler warning I get in my UML build :)
> 
> ----
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> mm/page_alloc.c:931: warning: 'setup_nr_node_ids' defined but not used
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
> 
> Index: linux/mm/page_alloc.c
> ===================================================================
> --- linux.orig/mm/page_alloc.c	2007-04-26 13:07:11.000000000 +0200
> +++ linux/mm/page_alloc.c	2007-04-26 13:07:12.000000000 +0200
> @@ -914,7 +914,10 @@ static int rmqueue_bulk(struct zone *zon
>  #if MAX_NUMNODES > 1
>  int nr_node_ids __read_mostly = MAX_NUMNODES;
>  EXPORT_SYMBOL(nr_node_ids);
> +#endif
>  
> +#ifdef CONFIG_ARCH_POPULATES_NODE_MAP
> +#if MAX_NUMNODES > 1
>  /*
>   * Figure out the number of possible node ids.
>   */
> @@ -930,6 +933,7 @@ static void __init setup_nr_node_ids(voi
>  #else
>  static void __init setup_nr_node_ids(void) {}
>  #endif
> +#endif
>  
>  #ifdef CONFIG_NUMA
>  /*

That doesn't do much to inprove overall readability.

I suspect the warning was only there because the stubbed version of
setup_nr_node_ids() forgot to be declared static inline, yes?

How about this?

--- a/mm/page_alloc.c~fix-unused-setup_nr_node_ids
+++ a/mm/page_alloc.c
@@ -136,6 +136,11 @@ static unsigned long __meminitdata dma_r
 #endif /* CONFIG_MEMORY_HOTPLUG_RESERVE */
 #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
 
+#if MAX_NUMNODES > 1
+int nr_node_ids __read_mostly = MAX_NUMNODES;
+EXPORT_SYMBOL(nr_node_ids);
+#endif
+
 #ifdef CONFIG_DEBUG_VM
 static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
 {
@@ -669,26 +674,6 @@ static int rmqueue_bulk(struct zone *zon
 	return i;
 }
 
-#if MAX_NUMNODES > 1
-int nr_node_ids __read_mostly = MAX_NUMNODES;
-EXPORT_SYMBOL(nr_node_ids);
-
-/*
- * Figure out the number of possible node ids.
- */
-static void __init setup_nr_node_ids(void)
-{
-	unsigned int node;
-	unsigned int highest = 0;
-
-	for_each_node_mask(node, node_possible_map)
-		highest = node;
-	nr_node_ids = highest + 1;
-}
-#else
-static void __init setup_nr_node_ids(void) {}
-#endif
-
 #ifdef CONFIG_NUMA
 /*
  * Called from the vmstat counter updater to drain pagesets of this
@@ -2733,6 +2718,26 @@ void __meminit free_area_init_node(int n
 }
 
 #ifdef CONFIG_ARCH_POPULATES_NODE_MAP
+
+#if MAX_NUMNODES > 1
+/*
+ * Figure out the number of possible node ids.
+ */
+static void __init setup_nr_node_ids(void)
+{
+	unsigned int node;
+	unsigned int highest = 0;
+
+	for_each_node_mask(node, node_possible_map)
+		highest = node;
+	nr_node_ids = highest + 1;
+}
+#else
+static inline void setup_nr_node_ids(void)
+{
+}
+#endif
+
 /**
  * add_active_range - Register a range of PFNs backed by physical memory
  * @nid: The node ID the range resides on
_

