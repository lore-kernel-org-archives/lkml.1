Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbZLAABt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbZLAABt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 19:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbZLAABs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 19:01:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:48576 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034AbZLAABr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 19:01:47 -0500
Message-ID: <4B145CE9.1060608@kernel.org>
Date: Tue, 01 Dec 2009 09:01:45 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] percpu: explain quick paths in pcpu_[de]populate_chunk()
References: <20091130091501.4507.28683.sendpatchset@localhost.localdomain> <4B13A7ED.9010905@kernel.org> <alpine.DEB.2.00.0911301258370.18682@router.home>
In-Reply-To: <alpine.DEB.2.00.0911301258370.18682@router.home>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcpu_[de]populate_chunk() check whether there's actually any work to
do at the beginning and exit early if not.  This checking is done by
seeing whether the first iteration of pcpu_for_each_[un]pop_region()
covers the whole requested region.  The resulting code is a bit
unusual in that it's loop-like but never loops which apparently
confuses people.  Add comments to explain it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Amerigo Wang <amwang@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
Added to percpu#for-next.  This should be clear enough, right?

 mm/percpu.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 442010c..c264315 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -912,10 +912,15 @@ static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, int off, int size)
 	unsigned long *populated;
 	int rs, re;
 
-	/* quick path, check whether it's empty already */
+	/*
+	 * Quick path, check whether it's already empty.  If the
+	 * region is completely empty, the first iteration will cover
+	 * the whole region.
+	 */
 	pcpu_for_each_unpop_region(chunk, rs, re, page_start, page_end) {
 		if (rs == page_start && re == page_end)
 			return;
+		/* it didn't cover the whole thing, break to slow path */
 		break;
 	}
 
@@ -967,10 +972,15 @@ static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
 	unsigned int cpu;
 	int rs, re, rc;
 
-	/* quick path, check whether all pages are already there */
+	/*
+	 * Quick path, check whether all pages are already there.  If
+	 * the region is fully populated, the first iteration will
+	 * cover the whole region.
+	 */
 	pcpu_for_each_pop_region(chunk, rs, re, page_start, page_end) {
 		if (rs == page_start && re == page_end)
 			goto clear;
+		/* it didn't cover the whole thing, break to slow path */
 		break;
 	}
 
-- 
1.6.4.2

