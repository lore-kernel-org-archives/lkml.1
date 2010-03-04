Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab0CDEIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 23:08:11 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:33026 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079Ab0CDEII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 23:08:08 -0500
Date: Thu, 4 Mar 2010 13:04:06 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       rientjes@google.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [BUGFIX][PATCH] memcg: fix oom kill behavior v3
Message-Id: <20100304130406.95789929.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20100303162304.eaf49099.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100302115834.c0045175.kamezawa.hiroyu@jp.fujitsu.com>
	<20100302135524.afe2f7ab.kamezawa.hiroyu@jp.fujitsu.com>
	<20100302143738.5cd42026.nishimura@mxp.nes.nec.co.jp>
	<20100302145644.0f8fbcca.kamezawa.hiroyu@jp.fujitsu.com>
	<20100302151544.59c23678.nishimura@mxp.nes.nec.co.jp>
	<20100303092606.2e2152fc.nishimura@mxp.nes.nec.co.jp>
	<20100303093844.cf768ea4.kamezawa.hiroyu@jp.fujitsu.com>
	<20100303162304.eaf49099.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Mar 2010 16:23:04 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 3 Mar 2010 09:38:44 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Wed, 3 Mar 2010 09:26:06 +0900
> > Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > 
> > > > I'll test this patch all through this night, and check whether it doesn't trigger
> > > > global oom after memcg's oom.
> > > > 
> > > O.K. It works well.
> > > Feel free to add my signs.
> > > 
> > > 	Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> > > 	Tested-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> > > 
> > 
> > Thank you !
> > 
> > I'll apply Balbir's comment and post v3.
> > 
> 
> rebased onto mmotm-Mar2.
> tested on x86-64.
> 
I found a small race problem. This is the fix for it.

===
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

We must avoid making oom_lock of a newly created child be negative.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
 mm/memcontrol.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3ce8c5b..9e25400 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1272,7 +1272,12 @@ static bool mem_cgroup_oom_lock(struct mem_cgroup *mem)
 
 static int mem_cgroup_oom_unlock_cb(struct mem_cgroup *mem, void *data)
 {
-	atomic_dec(&mem->oom_lock);
+	/*
+	 * There is a small race window where a new child can be created after
+	 * we called mem_cgroup_oom_lock(). Use atomic_add_unless() to avoid
+	 * making oom_lock of such a child be negative.
+	 */
+	atomic_add_unless(&mem->oom_lock, -1, 0);
 	return 0;
 }
 
-- 
1.6.4
