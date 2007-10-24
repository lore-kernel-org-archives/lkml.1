Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbXJXRgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbXJXRgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbXJXRgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:36:23 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43885 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753599AbXJXRgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:36:22 -0400
From: Paul Jackson <pj@sgi.com>
To: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org
Date: Wed, 24 Oct 2007 10:36:21 -0700
Message-Id: <20071024173621.24359.1372.sendpatchset@jackhammer.engr.sgi.com>
Subject: [RFC] cgroup simplify space stripping
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Simplify the space stripping code in cgroup file write.

Signed-off-by: Paul Jackson <pj@sgi.com>

---

This patch applies after both:
	Adrian Bunk's: [2.6 patch] kernel/cgroup.c: remove dead code
	pj's: [PATCH] cgroup brace coding style fix

 kernel/cgroup.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

--- 2.6.23-mm1.orig/kernel/cgroup.c	2007-10-24 10:03:11.847801501 -0700
+++ 2.6.23-mm1/kernel/cgroup.c	2007-10-24 10:29:08.355032464 -0700
@@ -1327,6 +1327,7 @@ static ssize_t cgroup_common_file_write(
 		goto out1;
 	}
 	buffer[nbytes] = 0;	/* nul-terminate */
+	strstrip(buffer);	/* strip -just- trailing whitespace */
 
 	mutex_lock(&cgroup_mutex);
 
@@ -1347,19 +1348,9 @@ static ssize_t cgroup_common_file_write(
 			clear_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
 		break;
 	case FILE_RELEASE_AGENT:
-	{
-		struct cgroupfs_root *root = cgrp->root;
-		/* Strip trailing newline */
-		if (nbytes && (buffer[nbytes-1] == '\n'))
-			buffer[nbytes-1] = 0;
-		/* We never write anything other than '\0'
-		 * into the last char of release_agent_path,
-		 * so it always remains a NUL-terminated
-		 * string */
-		strncpy(root->release_agent_path, buffer, nbytes);
-		root->release_agent_path[nbytes] = 0;
+		BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX);
+		strcpy(cgrp->root->release_agent_path, buffer);
 		break;
-	}
 	default:
 		retval = -EINVAL;
 		goto out2;

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
