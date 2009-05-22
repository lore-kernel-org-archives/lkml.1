Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbZEVE5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbZEVE5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 00:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbZEVEzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 00:55:46 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45240 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbZEVEzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 00:55:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wVry4VNXQjcaIRnV0ikc/ovjcP+8fnxcDu3lVHiM4rvHrz8p0nWlsapwalcUdArvV/
         Xm1q+mtQp2SJ0z/wJotj7v1eU7dIt5aHuxDfK0UoBDVtb4usn8CsCt7QisvXmKLqGDwg
         M12EVcpb4hZPxwWmhewtemxG4QdkpM2WmYR1w=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       torvalds@linux-foundation.org, xemul@parallels.com,
       orenl@cs.columbia.edu, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 09/38] netns 1/2: don't get/put old netns on CLONE_NEWNET
Date: Fri, 22 May 2009 08:55:03 +0400
Message-Id: <1242968132-1044-9-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_net_ns() doesn't copy anything, it creates fresh netns, so get/put of old
netns isn't needed.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
 net/core/net_namespace.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index e3bebd3..4488010 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -120,10 +120,8 @@ struct net *copy_net_ns(unsigned long flags, struct net *old_net)
 	struct net *new_net = NULL;
 	int err;
 
-	get_net(old_net);
-
 	if (!(flags & CLONE_NEWNET))
-		return old_net;
+		return get_net(old_net);
 
 	err = -ENOMEM;
 	new_net = net_alloc();
@@ -142,7 +140,6 @@ struct net *copy_net_ns(unsigned long flags, struct net *old_net)
 	if (err)
 		goto out_free;
 out:
-	put_net(old_net);
 	return new_net;
 
 out_free:
-- 
1.5.6.5

