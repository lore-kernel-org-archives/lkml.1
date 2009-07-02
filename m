Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbZGBIv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbZGBIv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 04:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbZGBIvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 04:51:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:45463 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbZGBIvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 04:51:20 -0400
Message-ID: <4A4C74D8.30809@kernel.org>
Date: Thu, 02 Jul 2009 01:50:32 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: alex.shi@intel.com, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
CC: "bugzilla-daemon@bugzilla.kernel.org" 
	<bugzilla-daemon@bugzilla.kernel.org>,
       "bugme-daemon@bugzilla.kernel.org" <bugme-daemon@bugzilla.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       yanmin.zhang@intel.com, tim.c.chen@intel.com
Subject: Re: [Bugme-new] [Bug 13690] New: nodes_clear cause hugepage unusable
 on non-NUMA machine
References: <bug-13690-10286@http.bugzilla.kernel.org/>	 <20090701183452.8660c8a9.akpm@linux-foundation.org>	 <4A4C17FD.3080404@kernel.org> <1246517111.15721.5.camel@alexs-hp>
In-Reply-To: <1246517111.15721.5.camel@alexs-hp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Shi wrote:
> The new patch works for my stoakley i386 machine. But for x86_64 machine
> the specjbb2005 still can not run with hugepage. The specjbb2005 use the
> same java setting as i386 system. After apply your patch, the iomem of
> x86_64 is:

please check

[PATCH] x86: don't clear nodes_states[N_NORMAL_MEMORY] when numa is not compiled in

Alex found:
for x86_64 machine the specjbb2005 still can not run with hugepage

only happens when numa is not compiled in

the root cause: node_set_state will not set it back for us in that case

so don't clear that when numa is not select in config

Reported-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/init_64.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -598,8 +598,14 @@ void __init paging_init(void)
 
 	sparse_memory_present_with_active_regions(MAX_NUMNODES);
 	sparse_init();
-	/* clear the default setting with node 0 */
+#if MAX_NUMNODES > 1
+	/*
+	 * clear the default setting with node 0
+	 * note: don't clear it, node_set_state will do nothing
+	 *	 (aka set it back) when numa support is not compiled in
+	 */
 	nodes_clear(node_states[N_NORMAL_MEMORY]);
+#endif
 	free_area_init_nodes(max_zone_pfns);
 }
 
