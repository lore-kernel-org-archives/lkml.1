Return-Path: <linux-kernel-owner+w=401wt.eu-S1761392AbXJZCPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761392AbXJZCPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 22:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757895AbXJZCOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 22:14:45 -0400
Received: from smtp-out.google.com ([216.239.45.13]:49575 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761274AbXJZCOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 22:14:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=EvjE1p0WI3zIttDDojHWS7HsDsBnL3I+IXgfrjxkQpj+fF5twqAK3PXFvFZLQ7Tvq
	fXN+sQcvnFsSSDH9R3jOw==
Date: Thu, 25 Oct 2007 19:14:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <ak@suse.de>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 2/3] mempolicy: mpol_rebind_policy cleanup
In-Reply-To: <alpine.DEB.0.9999.0710251912300.30400@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.0.9999.0710251913130.30400@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251912300.30400@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Set the memory policy nodemask to the new nodemask on rebind only in one
place.  The only memory policy that does not need an associated mpolmask
is MPOL_DEFAULT.

Cc: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Paul Jackson <pj@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/mempolicy.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1741,14 +1741,12 @@ static void mpol_rebind_policy(struct mempolicy *pol,
 	case MPOL_INTERLEAVE:
 		nodes_remap(tmp, pol->v.nodes, *mpolmask, *newmask);
 		pol->v.nodes = tmp;
-		*mpolmask = *newmask;
 		current->il_next = node_remap(current->il_next,
 						*mpolmask, *newmask);
 		break;
 	case MPOL_PREFERRED:
 		pol->v.preferred_node = node_remap(pol->v.preferred_node,
 						*mpolmask, *newmask);
-		*mpolmask = *newmask;
 		break;
 	case MPOL_BIND: {
 		nodemask_t nodes;
@@ -1773,13 +1771,14 @@ static void mpol_rebind_policy(struct mempolicy *pol,
 			kfree(pol->v.zonelist);
 			pol->v.zonelist = zonelist;
 		}
-		*mpolmask = *newmask;
 		break;
 	}
 	default:
 		BUG();
 		break;
 	}
+	if (pol->policy != MPOL_DEFAULT)
+		*mpolmask = *newmask;
 }
 
 /*
