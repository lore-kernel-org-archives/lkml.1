Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbXFKVfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbXFKVfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 17:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbXFKVe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 17:34:59 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:39797 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbXFKVe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 17:34:59 -0400
Subject: [shm][hugetlb] Fix get_policy for stacked shared memory files
From: Adam Litke <agl@us.ibm.com>
To: dean gaudet <dean@arctic.org>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, ak@suse.de, clameter@sgi.com
In-Reply-To: <Pine.LNX.4.64.0706092106220.10324@twinlark.arctic.org>
References: <Pine.LNX.4.64.0705152222550.14691@twinlark.arctic.org>
	 <20070516061259.GZ19966@holomorphy.com>
	 <Pine.LNX.4.64.0706092106220.10324@twinlark.arctic.org>
Content-Type: text/plain
Date: Mon, 11 Jun 2007 16:34:54 -0500
Message-Id: <1181597696.22671.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's another breakage as a result of shared memory stacked files :(

The NUMA policy for a VMA is determined by checking the following (in the order
given):

1) vma->vm_ops->get_policy() (if defined)
2) vma->vm_policy (if defined)
3) task->mempolicy (if defined)
4) Fall back to default_policy

By switching to stacked files for shared memory, get_policy() is now always set
to shm_get_policy which is a wrapper function.  This causes us to stop at step
1, which yields NULL for hugetlb instead of task->mempolicy which was the
previous (and correct) result.

This patch modifies the shm_get_policy() wrapper to maintain steps 1-3 for the
wrapped vm_ops.  Andi and Christoph, does this look right to you?

Signed-off-by: Adam Litke <agl@us.ibm.com>

diff --git a/ipc/shm.c b/ipc/shm.c
index 4fefbad..8d2672d 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -254,8 +254,10 @@ struct mempolicy *shm_get_policy(struct vm_area_struct *vma, unsigned long addr)
 
 	if (sfd->vm_ops->get_policy)
 		pol = sfd->vm_ops->get_policy(vma, addr);
-	else
+	else if (vma->vm_policy)
 		pol = vma->vm_policy;
+	else
+		pol = current->mempolicy;
 	return pol;
 }
 #endif

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

