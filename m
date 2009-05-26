Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbZEZNNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbZEZNNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 09:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbZEZNNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 09:13:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:39033 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbZEZNND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 09:13:03 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [PATCH] Fix build warning and avoid checking for mem != null twice
Date: Tue, 26 May 2009 18:44:32 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: Pavel Emelyanov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905261844.33864.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build warning, "mem_cgroup_is_obsolete defined but not used" when
CONFIG_DEBUG_VM is not set. Also avoid checking for !mem twice.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 01c2d8f..420fc61 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -314,14 +314,6 @@ static struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
 	return mem;
 }
 
-static bool mem_cgroup_is_obsolete(struct mem_cgroup *mem)
-{
-	if (!mem)
-		return true;
-	return css_is_removed(&mem->css);
-}
-
-
 /*
  * Call callback function against all cgroup under hierarchy tree.
  */
@@ -932,7 +924,7 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
 	if (unlikely(!mem))
 		return 0;
 
-	VM_BUG_ON(!mem || mem_cgroup_is_obsolete(mem));
+	VM_BUG_ON(!mem || css_is_removed(&mem->css));
 
 	while (1) {
 		int ret;

