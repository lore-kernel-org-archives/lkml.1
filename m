Return-Path: <linux-kernel-owner+w=401wt.eu-S933413AbXFEWjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413AbXFEWjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 18:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763433AbXFEWjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 18:39:23 -0400
Received: from smtp-out.google.com ([216.239.45.13]:9115 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762644AbXFEWjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 18:39:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	mime-version:content-type;
	b=xUtnGneL9gJ5UDbix5myPoNVe0Qy4LsZpJvN8BfvHnwBnOSZLe/iMqrrnxItF6gf3
	pyGiTLH4Wx6GDtJUVW7DA==
Date: Tue, 5 Jun 2007 15:39:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@engr.sgi.com>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Subject: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
 globally
Message-ID: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Reverts git commit c596d9f320aaf30d28c1d793ff3a976dee1db8f5.

OOM-killed tasks, marked as TIF_MEMDIE, should not be able to access 
memory outside its cpuset because it could potentially cause other 
exclusive cpusets to OOM themselves.

Cc: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 kernel/cpuset.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2431,12 +2431,6 @@ int __cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask)
 	might_sleep_if(!(gfp_mask & __GFP_HARDWALL));
 	if (node_isset(node, current->mems_allowed))
 		return 1;
-	/*
-	 * Allow tasks that have access to memory reserves because they have
-	 * been OOM killed to get memory anywhere.
-	 */
-	if (unlikely(test_thread_flag(TIF_MEMDIE)))
-		return 1;
 	if (gfp_mask & __GFP_HARDWALL)	/* If hardwall request, stop here */
 		return 0;
 
