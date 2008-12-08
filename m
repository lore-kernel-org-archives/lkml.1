Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823AbYLHCd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbYLHCd7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 21:33:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbYLHCdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 21:33:49 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:57761 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbYLHCds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 21:33:48 -0500
Date: Mon, 8 Dec 2008 11:02:42 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, nishimura@mxp.nes.nec.co.jp
Subject: [PATCH -mmotm 1/4] memcg: don't trigger oom at page migration
Message-Id: <20081208110242.477e0837.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20081208105824.f8f5d67b.nishimura@mxp.nes.nec.co.jp>
References: <20081208105824.f8f5d67b.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think triggering OOM at mem_cgroup_prepare_migration would be just a bit
overkill.
Returning -ENOMEM would be enough for mem_cgroup_prepare_migration.
The caller would handle the case anyway.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a4854a7..0683459 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1331,7 +1331,7 @@ int mem_cgroup_prepare_migration(struct page *page, struct mem_cgroup **ptr)
 	unlock_page_cgroup(pc);
 
 	if (mem) {
-		ret = mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem);
+		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem, false);
 		css_put(&mem->css);
 	}
 	*ptr = mem;
