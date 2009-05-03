Return-Path: <linux-kernel-owner+w=401wt.eu-S1757097AbZECX1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097AbZECX1v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 19:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756693AbZECX1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 19:27:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:32675 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049AbZECX1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 19:27:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=XcAXD2uutWpXON59wN9iACMKtVbdt5nzX3kaxF4PJIYX4JUVJIpw8YQO9LsbhKjopO
         8+d3yUeFDBpbMMveGjv4atw3jNZe4M/p6RfPaKQL+kCSDgy0z6kir6qIrrFQWRhqRAxO
         /uLZpxTPQrqPHJrj/oESxk0PcJCmDryyVCPqA=
Date: Mon, 4 May 2009 03:28:25 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       netdev@vger.kernel.org
Subject: [PATCH 1/2] netns 1/2: don't get/put old netns on CLONE_NEWNET
Message-ID: <20090503232825.GF16631@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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
