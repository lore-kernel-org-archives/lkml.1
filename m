Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbZCDCQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbZCDCQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 21:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbZCDCQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 21:16:34 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49386 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbZCDCQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 21:16:34 -0500
Message-ID: <49ADE4B0.5090405@cn.fujitsu.com>
Date: Wed, 04 Mar 2009 10:17:20 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cgroups: don't change release_agent when remount failed
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remount can fail in either case:
  - wrong mount options is specified, or option 'noprefix' is changed.
  - a to-be-added subsys is already mounted/active.

When using remount to change 'release_agent', for the above former failure
case, remount will return errno with release_agent unchanged, but for the
latter case, remount will return EBUSY with relase_agent changed, which is
unexpected I think:

 # mount -t cgroup -o cpu xxx /cgrp1
 # mount -t cgroup -o cpuset,release_agent=agent1 yyy /cgrp2
 # cat /cgrp2/release_agent
 agent1
 # mount -t cgroup -o remount,cpuset,noprefix,release_agent=agent2 yyy /cgrp2
 mount: /cgrp2 not mounted already, or bad option
 # cat /cgrp2/release_agent
 agent1     <-- ok
 # mount -t cgroup -o remount,cpu,cpuset,release_agent=agent2 yyy /cgrp2
 mount: /cgrp2 is busy
 # cat /cgrp2/release_agent
 agent2     <-- unexpected!

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ad10c5d..ebb4a4e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -915,10 +915,11 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
 	}
 
 	ret = rebind_subsystems(root, opts.subsys_bits);
+	if (ret)
+		goto out_unlock;
 
 	/* (re)populate subsystem files */
-	if (!ret)
-		cgroup_populate_dir(cgrp);
+	cgroup_populate_dir(cgrp);
 
 	if (opts.release_agent)
 		strcpy(root->release_agent_path, opts.release_agent);
-- 
1.5.4.rc3
