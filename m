Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbZGHQwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbZGHQwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756129AbZGHQwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:52:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:57867 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757116AbZGHQwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:52:31 -0400
Message-ID: <4A54CE4B.9080403@kernel.org>
Date: Wed, 08 Jul 2009 09:50:19 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Christoph Lameter <cl@linux-foundation.org>, alex.shi@intel.com,
       Mel Gorman <mel@csn.ul.ie>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       yanmin.zhang@intel.com, tim.c.chen@intel.com
Subject: [PATCH] x86: don't clear nodes_states[N_NORMAL_MEMORY] when numa
 is not compiled in -v2
References: <bug-13690-10286@http.bugzilla.kernel.org/>  <20090701183452.8660c8a9.akpm@linux-foundation.org>  <4A4C17FD.3080404@kernel.org> <1246517111.15721.5.camel@alexs-hp> <4A4C74D8.30809@kernel.org> <alpine.DEB.1.10.0907021003450.16359@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0907021003450.16359@gentwo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Alex found:
for x86_64 machine the specjbb2005 still can not run with hugepage

only happens when numa is not compiled in

the root cause: node_set_state will not set it back for us in that case

so don't clear that when numa is not select in config

v2: use node_clear_state instead

Reported-and-Tested-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/init_64.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -598,8 +598,15 @@ void __init paging_init(void)
 
 	sparse_memory_present_with_active_regions(MAX_NUMNODES);
 	sparse_init();
-	/* clear the default setting with node 0 */
-	nodes_clear(node_states[N_NORMAL_MEMORY]);
+
+	/*
+	 * clear the default setting with node 0
+	 * note: don't use nodes_clear here, that is really clearing when
+	 *	 numa support is not compiled in, and later node_set_state
+	 *	 will not set it back.
+	 */
+	node_clear_state(0, N_NORMAL_MEMORY);
+
 	free_area_init_nodes(max_zone_pfns);
 }
 

