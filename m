Return-Path: <linux-kernel-owner+w=401wt.eu-S933717AbXGRW2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933717AbXGRW2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbXGRW2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:28:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:4292 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbXGRW2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:28:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=c5WId3jtd1usS094iFdDl0p50zGlvpXQy4HTlBgCxpDGJWp6OubnR+/yLhahGb7pY8mpBftUe5JnlgjRn3M5B0Gu9guUcMyQjzX+ZeT6brqKiu4BY1/rdJHI8sFKfxkdw2ELQwdI/Ro+slEtx/ZCVkZZeA/UXAGUBLAvDZWcLm0=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix memory leak in dlm_add_member() when dlm_node_weight() returns less than zero
Date: Thu, 19 Jul 2007 00:27:43 +0200
User-Agent: KMail/1.9.7
Cc: David Teigland <teigland@redhat.com>, Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707190027.43195.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

There's a memory leak in fs/dlm/member.c::dlm_add_member().

If "dlm_node_weight(ls->ls_name, nodeid)" returns < 0, then 
we'll return without freeing the memory allocated to the (at 
that point yet unused) 'memb'.
This patch frees the allocated memory in that case and thus 
avoids the leak.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 fs/dlm/member.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/dlm/member.c b/fs/dlm/member.c
index 073599d..d099775 100644
--- a/fs/dlm/member.c
+++ b/fs/dlm/member.c
@@ -56,8 +56,10 @@ static int dlm_add_member(struct dlm_ls *ls, int nodeid)
 		return -ENOMEM;
 
 	w = dlm_node_weight(ls->ls_name, nodeid);
-	if (w < 0)
+	if (w < 0) {
+		kfree(memb);
 		return w;
+	}
 
 	memb->nodeid = nodeid;
 	memb->weight = w;


