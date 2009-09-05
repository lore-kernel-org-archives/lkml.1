Return-Path: <linux-kernel-owner+w=401wt.eu-S934550AbZIEAeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934550AbZIEAeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934436AbZIEAdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:33:45 -0400
Received: from kroah.org ([198.145.64.141]:42059 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934548AbZIEAUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:20:32 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:48 2009
Message-Id: <20090905001448.033172069@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:13:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bo Liu <bo-liu@hotmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [patch 06/71] mm: build_zonelists(): move clear node_load[] to __build_all_zonelists()
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=mm-build_zonelists-move-clear-node_load-to-__build_all_zonelists.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Bo Liu <bo-liu@hotmail.com>

commit 7f9cfb31030737a7fc9a1cbca3fd01bec184c849 upstream.

If node_load[] is cleared everytime build_zonelists() is
called,node_load[] will have no help to find the next node that should
appear in the given node's fallback list.

Because of the bug, zonelist's node_order is not calculated as expected.
This bug affects on big machine, which has asynmetric node distance.

[synmetric NUMA's node distance]
     0    1    2
0   10   12   12
1   12   10   12
2   12   12   10

[asynmetric NUMA's node distance]
     0    1    2
0   10   12   20
1   12   10   14
2   20   14   10

This (my bug) is very old but no one has reported this for a long time.
Maybe because the number of asynmetric NUMA is very small and they use
cpuset for customizing node memory allocation fallback.

[akpm@linux-foundation.org: fix CONFIG_NUMA=n build]
Signed-off-by: Bo Liu <bo-liu@hotmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2342,7 +2342,6 @@ static void build_zonelists(pg_data_t *p
 	prev_node = local_node;
 	nodes_clear(used_mask);
 
-	memset(node_load, 0, sizeof(node_load));
 	memset(node_order, 0, sizeof(node_order));
 	j = 0;
 
@@ -2451,6 +2450,9 @@ static int __build_all_zonelists(void *d
 {
 	int nid;
 
+#ifdef CONFIG_NUMA
+	memset(node_load, 0, sizeof(node_load));
+#endif
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
 


