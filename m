Return-Path: <linux-kernel-owner+w=401wt.eu-S1762084AbXJZCe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762084AbXJZCe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 22:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbXJZCew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 22:34:52 -0400
Received: from smtp-out.google.com ([216.239.45.13]:57470 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbXJZCev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 22:34:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	mime-version:content-type;
	b=sjWn3cGBWXxpk2MvKGPTwnJ4fYhv4yUek4V3BBC4VQjA080jyFBXwMfdeHCSxglbW
	ztOWaSO04TOdzhvIL8Tfw==
Date: Thu, 25 Oct 2007 19:34:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <ak@suse.de>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 4/3] cpusets: memory_spread_user interleaves over all
 mems_allowed
Message-ID: <alpine.DEB.0.9999.0710251933490.2989@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using current's mems_allowed, which may differ from the
mems_allowed of the cpuset being updated, the newmask passed to
mpol_rebind_mm() is used as the interleave mask in the
memory_spread_user case.

Cc: Andi Kleen <ak@suse.de>
Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/mempolicy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1740,7 +1740,7 @@ static void mpol_rebind_policy(struct mempolicy *pol,
 		break;
 	case MPOL_INTERLEAVE:
 		if (current_cpuset_is_spread_user())
-			tmp = cpuset_mems_allowed(current);
+			tmp = *newmask;
 		else
 			nodes_remap(tmp, pol->v.nodes, *mpolmask, *newmask);
 		pol->v.nodes = tmp;
