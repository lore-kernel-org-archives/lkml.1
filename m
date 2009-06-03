Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbZFCDQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbZFCDQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 23:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbZFCDQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 23:16:02 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:42658 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbZFCDQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 23:16:01 -0400
Date: Wed, 3 Jun 2009 11:49:08 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH mmotm 1/2] memcg: add interface to reset limits
Message-Id: <20090603114908.52c3aed5.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090603114518.301cef4d.nishimura@mxp.nes.nec.co.jp>
References: <20090603114518.301cef4d.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting mem.limit or memsw.limit to 0 has no meaning
in actual use(no process can run in such condition).

We don't have interface to reset mem.limit or memsw.limit now,
so let's reset the mem.limit or memsw.limit to default(unlimited)
when they are being set to 0.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
 Documentation/cgroups/memory.txt |    1 +
 include/linux/res_counter.h      |    2 ++
 kernel/res_counter.c             |    2 +-
 mm/memcontrol.c                  |    2 ++
 4 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index 1a60887..e1c69f3 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -204,6 +204,7 @@ We can alter the memory limit:
 
 NOTE: We can use a suffix (k, K, m, M, g or G) to indicate values in kilo,
 mega or gigabytes.
+NOTE: We can write "0" to reset the *.limit_in_bytes(unlimited).
 
 # cat /cgroups/0/memory.limit_in_bytes
 4194304
diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index 4c5bcf6..511f42f 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -49,6 +49,8 @@ struct res_counter {
 	struct res_counter *parent;
 };
 
+#define RESOURCE_MAX (unsigned long long)LLONG_MAX
+
 /**
  * Helpers to interact with userspace
  * res_counter_read_u64() - returns the value of the specified member.
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index bf8e753..0a45778 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -18,7 +18,7 @@
 void res_counter_init(struct res_counter *counter, struct res_counter *parent)
 {
 	spin_lock_init(&counter->lock);
-	counter->limit = (unsigned long long)LLONG_MAX;
+	counter->limit = RESOURCE_MAX;
 	counter->parent = parent;
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a83e039..6629ed2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2040,6 +2040,8 @@ static int mem_cgroup_write(struct cgroup *cont, struct cftype *cft,
 		ret = res_counter_memparse_write_strategy(buffer, &val);
 		if (ret)
 			break;
+		if (!val)
+			val = RESOURCE_MAX;
 		if (type == _MEM)
 			ret = mem_cgroup_resize_limit(memcg, val);
 		else
