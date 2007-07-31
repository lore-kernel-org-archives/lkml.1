Return-Path: <linux-kernel-owner+w=401wt.eu-S968851AbXGaEfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968851AbXGaEfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967810AbXGaEbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:31:43 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34566 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966896AbXGaEbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:31:42 -0400
Date: Mon, 30 Jul 2007 21:32:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, dean@arctic.org, ak@suse.de, agl@us.ibm.com,
       bill.irwin@oracle.com, clameter@sgi.com,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 13/26] hugetlb: fix get_policy for stacked shared memory
	files
Message-ID: <20070731043248.GN3975@kroah.com>
References: <20070731042108.546594256@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hugetlb-fix-get_policy-for-stacked-shared-memory-files.patch"
In-Reply-To: <20070731043047.GA3975@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Adam Litke <agl@us.ibm.com>

Here's another breakage as a result of shared memory stacked files :(

The NUMA policy for a VMA is determined by checking the following (in the
order given):

1) vma->vm_ops->get_policy() (if defined)
2) vma->vm_policy (if defined)
3) task->mempolicy (if defined)
4) Fall back to default_policy

By switching to stacked files for shared memory, get_policy() is now always
set to shm_get_policy which is a wrapper function.  This causes us to stop
at step 1, which yields NULL for hugetlb instead of task->mempolicy which
was the previous (and correct) result.

This patch modifies the shm_get_policy() wrapper to maintain steps 1-3 for
the wrapped vm_ops.

(akpm: the refcounting of mempolicies is busted and this patch does nothing to
improve it)

Signed-off-by: Adam Litke <agl@us.ibm.com>
Acked-by: William Irwin <bill.irwin@oracle.com>
Cc: dean gaudet <dean@arctic.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 ipc/shm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.21.6.orig/ipc/shm.c
+++ linux-2.6.21.6/ipc/shm.c
@@ -254,8 +254,10 @@ struct mempolicy *shm_get_policy(struct 
 
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
