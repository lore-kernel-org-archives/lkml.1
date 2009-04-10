Return-Path: <linux-kernel-owner+w=401wt.eu-S934132AbZDJCfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934132AbZDJCfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 22:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765054AbZDJCeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 22:34:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:39817 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933213AbZDJCe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 22:34:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=YwbNLiqJpCJJZpI9HnmaTOrZhVscWj2ahX3FviOtVmvrd1RmAlCELEGU+sonSGVk+4
         XzdfupTQHKHa7nISM++B9XpnsL+Iv40KvVmOeAY6dyOjlLT3Y8WmQD5pOeIvQVHaBlGZ
         6HD+Btd+LJjSc9U1xZ7E47yxTV/07PowIgzfs=
Date: Fri, 10 Apr 2009 06:34:31 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, containers@lists.linux-foundation.org
Cc: xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, orenl@cs.columbia.edu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/30] netns: don't get/put old netns on CLONE_NEWNET
Message-ID: <20090410023431.GG27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_net_ns() doesn't copy anything, it creates fresh netns,
so get/put of old netns is unneeded.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/core/net_namespace.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

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
