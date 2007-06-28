Return-Path: <linux-kernel-owner+w=401wt.eu-S1764007AbXF1CQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764007AbXF1CQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 22:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761294AbXF1CQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 22:16:03 -0400
Received: from mail.fieldses.org ([66.93.2.214]:42511 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761007AbXF1CQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 22:16:01 -0400
Date: Wed, 27 Jun 2007 22:15:52 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 007 of 8] knfsd: nfsd4: vary maximum delegation limit based on RAM size
Message-ID: <20070628021551.GB20605@fieldses.org>
References: <20070621142604.727.patches@notabene> <1070621043112.1144@suse.de> <20070625205244.bbf0976a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625205244.bbf0976a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This code would benefit from a little more explanation.

Also, I screwed up the previous patch and forgot to delete a line, so the
calculation here is off; fix it.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
---

 fs/nfsd/nfs4state.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

On Mon, Jun 25, 2007 at 08:52:44PM -0700, Andrew Morton wrote:
>
> Please put yourself in the position of the reader who happens across this
> code and wonders why it is that way.
> 
> They could of course go hunt it out of the git repo but I do think it's
> quite a bit more reader-friendly to explain the thinking in code comments.
>

Yup, sorry about that.  Could you apply this?

--b.

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index fbbbcab..1b2657f 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3203,13 +3203,27 @@ get_nfs4_grace_period(void)
 	return max(user_lease_time, lease_time) * HZ;
 }
 
+/*
+ * Since the lifetime of a delegation isn't limited to that of an open, a
+ * client may quite reasonably hang on to a delegation as long as it has
+ * the inode cached.  This becomes an obvious problem the first time a
+ * client's inode cache approaches the size of the server's total memory.
+ *
+ * For now we avoid this problem by imposing a hard limit on the number
+ * of delegations, which varies according to the server's memory size.
+ */
 static void
 set_max_delegations(void)
 {
 	struct sysinfo sys;
 
 	si_meminfo(&sys);
-	sys.totalram *= sys.mem_unit;
+	/*
+	 * Allow at most 4 delegations per megabyte of RAM.  Quick
+	 * estimates suggest that in the worst case (where every delegation
+	 * is for a different inode), a delegation could take about 1.5K,
+	 * giving a worst case usage of about 6% of memory.
+	 */
 	sys.totalram >>= (18 - PAGE_SHIFT);
 	max_delegations = (unsigned int) sys.totalram;
 }
-- 
1.5.2.58.g98ee

