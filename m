Return-Path: <linux-kernel-owner+w=401wt.eu-S1759624AbYG1CWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624AbYG1CWy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 22:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbYG1CWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 22:22:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62744 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbYG1CWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 22:22:32 -0400
Message-ID: <488D2D08.2090903@cn.fujitsu.com>
Date: Mon, 28 Jul 2008 10:20:56 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cgroup: fix possible memory leak
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a leak if copy_from_user() returns failure.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 657f8f8..28debe4 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1424,14 +1424,17 @@ static ssize_t cgroup_write_string(struct cgroup *cgrp, struct cftype *cft,
 		if (buffer == NULL)
 			return -ENOMEM;
 	}
-	if (nbytes && copy_from_user(buffer, userbuf, nbytes))
-		return -EFAULT;
+	if (nbytes && copy_from_user(buffer, userbuf, nbytes)) {
+		retval = -EFAULT;
+		goto out;
+	}
 
 	buffer[nbytes] = 0;     /* nul-terminate */
 	strstrip(buffer);
 	retval = cft->write_string(cgrp, cft, buffer);
 	if (!retval)
 		retval = nbytes;
+out:
 	if (buffer != local_buffer)
 		kfree(buffer);
 	return retval;
-- 
1.5.4.rc3
