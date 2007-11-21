Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbXKUS1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbXKUS1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 13:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbXKUS1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 13:27:04 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:39535 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbXKUS1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 13:27:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:organization:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=GFPncyVKuOsEAxWoB/qbqFIK/VMdbDs6Sv6Eh2LcymywDWkkOLSnWqWgHmsPkGMaFe7/XT9Sk8hmbolo89h9aEdT0A9v22qoEcP7r1AtVSWfqLEWxRo2MoVf8Qe316/BRFqgHpCu42csQ6MaSnszrcr9uTFisOgDjP0CGEBcGtE=
Message-ID: <47447871.1010900@gmail.com>
Date: Wed, 21 Nov 2007 21:26:57 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Rajesh Venkatasubramanian <vrajesh@umich.edu>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] loop cleanup in lib/prio_tree.c
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rajesh,

It seems that using a goto-based construct in the prio_tree_next() is not justified, and using the while()-based loop is better from the coding style POV.

The patch below replaces the goto-based loop by a while-based one. However, if I overlooked something and using the goto operator in this routine is necessary, I would be grateful to you if you could explain why it is necessary.

Thanks.

Signed-off-by Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
diff --git a/lib/prio_tree.c b/lib/prio_tree.c
index ccfd850..d56880f 100644
--- a/lib/prio_tree.c
+++ b/lib/prio_tree.c
@@ -461,24 +461,23 @@ struct prio_tree_node *prio_tree_next(st
 	if (iter->cur == NULL)
 		return prio_tree_first(iter);
 
-repeat:
-	while (prio_tree_left(iter, &r_index, &h_index))
-		if (overlap(iter, r_index, h_index))
-			return iter->cur;
-
-	while (!prio_tree_right(iter, &r_index, &h_index)) {
-	    	while (!prio_tree_root(iter->cur) &&
-				iter->cur->parent->right == iter->cur)
-			prio_tree_parent(iter);
+	while (1) {
+		while (prio_tree_left(iter, &r_index, &h_index))
+			if (overlap(iter, r_index, h_index))
+				return iter->cur;
 
-		if (prio_tree_root(iter->cur))
-			return NULL;
+		while (!prio_tree_right(iter, &r_index, &h_index)) {
+			while (!prio_tree_root(iter->cur) &&
+					iter->cur->parent->right == iter->cur)
+				prio_tree_parent(iter);
 
-		prio_tree_parent(iter);
-	}
+			if (prio_tree_root(iter->cur))
+				return NULL;
 
-	if (overlap(iter, r_index, h_index))
-		return iter->cur;
+			prio_tree_parent(iter);
+		}
 
-	goto repeat;
+		if (overlap(iter, r_index, h_index))
+			return iter->cur;
+	}
 }
