Return-Path: <linux-kernel-owner+w=401wt.eu-S1758351AbZFBCjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351AbZFBCjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 22:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755397AbZFBCjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 22:39:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59846 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755026AbZFBCjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 22:39:03 -0400
Message-ID: <4A24911F.4070601@cn.fujitsu.com>
Date: Tue, 02 Jun 2009 10:40:31 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cgroups: forbid noprefix if mounting more than just cpuset
 subsystem
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'noprefix' option was introduced for backwards-compatibility of
cpuset, but actually it can be used when mounting other subsystems.

This results in possibility of name collision, and now the collision
can really happen, because we have 'stat' file in both memory and
cpuacct subsystem:

	# mount -t cgroup -o noprefix,memory,cpuacct xxx /mnt

Cgroup will happily mount the 2 subsystems, but only 'stat' file of
memory subsys can be seen.

We don't want users to use nopreifx, and also want to avoid name
collision, so we change to allow noprefix only if mounting just
the cpuset subsystem.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a7267bf..ad17f9d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -842,6 +842,11 @@ static int parse_cgroupfs_options(char *data,
 				     struct cgroup_sb_opts *opts)
 {
 	char *token, *o = data ?: "all";
+	unsigned long mask = (unsigned long)-1;
+
+#ifdef CONFIG_CPUSETS
+	mask = ~(1 << cpuset_subsys_id);
+#endif
 
 	opts->subsys_bits = 0;
 	opts->flags = 0;
@@ -886,6 +891,11 @@ static int parse_cgroupfs_options(char *data,
 		}
 	}
 
+	/* We allow noprefix only if mounting just the cpuset subsystem */
+	if (test_bit(ROOT_NOPREFIX, &opts->flags) &&
+	    (opts->subsys_bits & mask))
+		return -EINVAL;
+
 	/* We can't have an empty hierarchy */
 	if (!opts->subsys_bits)
 		return -EINVAL;
-- 
1.5.4.rc3

