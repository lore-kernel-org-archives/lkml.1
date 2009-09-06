Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbZIFXEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbZIFXEP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 19:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758195AbZIFXEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 19:04:14 -0400
Received: from rcpt-expgw.biglobe.ne.jp ([133.205.19.65]:42144 "EHLO
	rcpt-expgw.biglobe.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758183AbZIFXEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 19:04:13 -0400
X-Biglobe-Sender: <d-nishimura@mtf.biglobe.ne.jp>
Date: Mon, 7 Sep 2009 08:04:03 +0900
From: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       d-nishimura@mtf.biglobe.ne.jp,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [mmotm][BUGFIX][PATCH] memcg: fix softlimit css refcnt handling(yet
 another one)
Message-Id: <20090907080403.5e4510b3.d-nishimura@mtf.biglobe.ne.jp>
In-Reply-To: <20090904190726.6442f3df.d-nishimura@mtf.biglobe.ne.jp>
References: <20090902093438.eed47a57.kamezawa.hiroyu@jp.fujitsu.com>
	<20090902134114.b6f1a04d.kamezawa.hiroyu@jp.fujitsu.com>
	<20090902182923.c6d98fd6.kamezawa.hiroyu@jp.fujitsu.com>
	<20090903141727.ccde7e91.nishimura@mxp.nes.nec.co.jp>
	<20090904131835.ac2b8cc8.kamezawa.hiroyu@jp.fujitsu.com>
	<20090904141157.4640ec1e.nishimura@mxp.nes.nec.co.jp>
	<20090904142143.15ffcb53.kamezawa.hiroyu@jp.fujitsu.com>
	<20090904142654.08dd159f.kamezawa.hiroyu@jp.fujitsu.com>
	<20090904154050.25873aa5.nishimura@mxp.nes.nec.co.jp>
	<20090904163758.a5604fee.kamezawa.hiroyu@jp.fujitsu.com>
	<20090904190726.6442f3df.d-nishimura@mtf.biglobe.ne.jp>
Reply-To: nishimura@mxp.nes.nec.co.jp
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Sep 2009 19:07:26 +0900
Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp> wrote:

> On Fri, 4 Sep 2009 16:37:58 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Fri, 4 Sep 2009 15:40:50 +0900
> > Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > > > Ah, one more question. What memory.usage_in_bytes shows in that case ?
> > > > If not zero, charge/uncharge coalescing is guilty.
> > > > 
> > > usage_in_bytes is 0.
> > > I've confirmed by crash command that the mem_cgroup has extra ref counts.
> > > 
> > > I'll dig more..
> > > 
> > BTW, do you use softlimit ? I found this but...Hmm
> > 
> No.
> I'm sorry I can't access my machine, so can't test this.
> 
> 
> But I think this patch itself is needed and looks good.
> 
I've found the cause of the issue.

Andrew, could you add this one after KAMEZAWA-san's
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch ?

===
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

refcount of the "victim" should be decremented before exiting the loop.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
 mm/memcontrol.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ac51294..011aba6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1133,8 +1133,10 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
 				 * anything, it might because there are
 				 * no reclaimable pages under this hierarchy
 				 */
-				if (!check_soft || !total)
+				if (!check_soft || !total) {
+					css_put(&victim->css);
 					break;
+				}
 				/*
 				 * We want to do more targetted reclaim.
 				 * excess >> 2 is not to excessive so as to
@@ -1142,8 +1144,10 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
 				 * coming back to reclaim from this cgroup
 				 */
 				if (total >= (excess >> 2) ||
-					(loop > MEM_CGROUP_MAX_RECLAIM_LOOPS))
+					(loop > MEM_CGROUP_MAX_RECLAIM_LOOPS)) {
+					css_put(&victim->css);
 					break;
+				}
 			}
 		}
 		if (!mem_cgroup_local_usage(&victim->stat)) {
