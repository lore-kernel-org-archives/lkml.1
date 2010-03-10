Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab0CJWua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 17:50:30 -0500
Received: from smtp-out.google.com ([216.239.44.51]:20742 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757393Ab0CJWu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 17:50:27 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=CW20FGNXzWTngQRa8W0ZeNGziRgdVm1R84HJCkr5tuvSw7XcPpO/wVFyd57bBTcmj
	PWqHCWgv7cgHow/KjRsNA==
Date: Wed, 10 Mar 2010 14:50:21 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: [patch] numa: fix BUILD_BUG_ON for node_read_distance
Message-ID: <alpine.DEB.2.00.1003101449480.21849@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

node_read_distance() has a BUILD_BUG_ON() to prevent buffer overruns when
the number of nodes printed will exceed the buffer length.

Each node only needs four chars: three for distance (maximum distance is
255) and one for a seperating space or a trailing newline.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/base/node.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -165,8 +165,11 @@ static ssize_t node_read_distance(struct sys_device * dev,
 	int len = 0;
 	int i;
 
-	/* buf currently PAGE_SIZE, need ~4 chars per node */
-	BUILD_BUG_ON(MAX_NUMNODES*4 > PAGE_SIZE/2);
+	/*
+	 * buf is currently PAGE_SIZE in length and each node needs 4 chars
+	 * at the most (distance + space or newline).
+	 */
+	BUILD_BUG_ON(MAX_NUMNODES*4 > PAGE_SIZE);
 
 	for_each_online_node(i)
 		len += sprintf(buf + len, "%s%d", i ? " " : "", node_distance(nid, i));
