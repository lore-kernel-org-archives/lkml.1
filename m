Return-Path: <linux-kernel-owner+w=401wt.eu-S1759839AbYG1Cya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759839AbYG1Cya (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 22:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758931AbYG1Cx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 22:53:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55596 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758753AbYG1CxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 22:53:25 -0400
Message-ID: <488D3331.8000306@cn.fujitsu.com>
Date: Mon, 28 Jul 2008 10:47:13 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Jackson <pj@sgi.com>, Paul Menage <menage@google.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] cpuset: fix wrong calculation of relax domain level
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When multiple cpusets are overlapping in their 'cpus' and hence they
form a single sched domain, the largest sched_relax_domain_level among
those should be used. But when top_cpuset's sched_load_balance is
set, its sched_relax_domain_level is used regardless other sub-cpusets'.

This patch fixes it by walking the cpuset hierarchy to find the largest
sched_relax_domain_level.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cpuset.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index d274a94..b1f1fa1 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -614,7 +614,7 @@ void rebuild_sched_domains(void)
 		dattr = kmalloc(sizeof(struct sched_domain_attr), GFP_KERNEL);
 		if (dattr) {
 			*dattr = SD_ATTR_INIT;
-			update_domain_attr(dattr, &top_cpuset);
+			update_domain_attr_tree(dattr, &top_cpuset);
 		}
 		*doms = top_cpuset.cpus_allowed;
 		goto rebuild;
-- 
1.5.4.rc3

