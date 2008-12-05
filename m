Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397AbYLEMbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbYLEMbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 07:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbYLEMbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 07:31:15 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:39265 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYLEMbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 07:31:15 -0500
Date: Fri, 5 Dec 2008 21:23:04 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, nishimura@mxp.nes.nec.co.jp
Subject: [RFC][PATCH -mmotm 1/4] memcg: don't trigger oom at page migration
Message-Id: <20081205212304.f7018ea1.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20081205212208.31d904e0.nishimura@mxp.nes.nec.co.jp>
References: <20081205212208.31d904e0.nishimura@mxp.nes.nec.co.jp>
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
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4dbce1d..50ee1be 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1330,7 +1330,7 @@ int mem_cgroup_prepare_migration(struct page *page, struct mem_cgroup **ptr)
 	unlock_page_cgroup(pc);
 
 	if (mem) {
-		ret = mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem);
+		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem, false);
 		css_put(&mem->css);
 	}
 	*ptr = mem;
