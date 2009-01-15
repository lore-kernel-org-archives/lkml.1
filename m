Return-Path: <linux-kernel-owner+w=401wt.eu-S1762270AbZAOHvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762270AbZAOHvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 02:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbZAOHvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 02:51:36 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:46006 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbZAOHvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 02:51:35 -0500
Date: Thu, 15 Jan 2009 16:45:37 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: nishimura@mxp.nes.nec.co.jp, "LKML" <linux-kernel@vger.kernel.org>,
       "linux-mm" <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Pavel Emelyanov" <xemul@openvz.org>, "Li Zefan" <lizf@cn.fujitsu.com>,
       "Paul Menage" <menage@google.com>
Subject: [RFC][PATCH] memcg: get/put parents at create/free
Message-Id: <20090115164537.d402e95f.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090115133814.a52460fa.nishimura@mxp.nes.nec.co.jp>
References: <20090113184533.6ffd2af9.nishimura@mxp.nes.nec.co.jp>
	<20090114175121.275ecd59.nishimura@mxp.nes.nec.co.jp>
	<7602a77a9fc6b1e8757468048fde749a.squirrel@webmail-b.css.fujitsu.com>
	<20090115100330.37d89d3d.nishimura@mxp.nes.nec.co.jp>
	<20090115110044.3a863af8.kamezawa.hiroyu@jp.fujitsu.com>
	<20090115111420.8559bdb3.nishimura@mxp.nes.nec.co.jp>
	<20090115133814.a52460fa.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009 13:38:14 +0900, Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> On Thu, 15 Jan 2009 11:14:20 +0900, Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > > > > To handle the problem "parent may be obsolete",
> > > > > 
> > > > > call mem_cgroup_get(parent) at create()
> > > > > call mem_cgroup_put(parent) at freeing memcg.
> > > > >      (regardless of use_hierarchy.)
> > > > > 
> > > > > is clearer way to go, I think.
> > > > > 
> > > > > I wonder whether there is  mis-accounting problem or not..
> > > > > 
> hmm, after more consideration, although this patch can prevent the BUG,
> it can leak memsw accounting of parents because memsw of parents, which
> have been incremented by charge, does not decremented.
> 
> I'll try pet/put parent approach..
> Or any other good ideas ?
> 
I attach a tryial patch.

It has been working fine so far(for about 1 hour).

Thanks,
Daisuke Nishimura.
===
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

mem_cgroup_get ensures that the memcg that has been got can be accessed
even after the directory has been removed, but it doesn't ensure that parents
of it can be accessed: parents might have been freed already by rmdir.

This causes a bug in case of use_hierarchy==1, because res_counter_uncharge
climb up the tree.

This patch tries to fix this probrem by getting parents at create, and
putting them at freeing.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
 mm/memcontrol.c |   33 ++++++++++++++++++++++++++++++++-
 1 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index fb62b43..b4aed07 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -202,6 +202,8 @@ pcg_default_flags[NR_CHARGE_TYPE] = {
 
 static void mem_cgroup_get(struct mem_cgroup *mem);
 static void mem_cgroup_put(struct mem_cgroup *mem);
+static void mem_cgroup_get_parents(struct mem_cgroup *mem);
+static void mem_cgroup_put_parents(struct mem_cgroup *mem);
 
 static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
 					 struct page_cgroup *pc,
@@ -2185,10 +2187,38 @@ static void mem_cgroup_get(struct mem_cgroup *mem)
 
 static void mem_cgroup_put(struct mem_cgroup *mem)
 {
-	if (atomic_dec_and_test(&mem->refcnt))
+	if (atomic_dec_and_test(&mem->refcnt)) {
+		mem_cgroup_put_parents(mem);
 		__mem_cgroup_free(mem);
+	}
+}
+
+static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem)
+{
+	if (!mem->res.parent)
+		return NULL;
+	return mem_cgroup_from_res_counter(mem->res.parent, res);
+}
+
+static void mem_cgroup_get_parents(struct mem_cgroup *mem)
+{
+	struct mem_cgroup *parent = parent_mem_cgroup(mem);
+
+	while (parent) {
+		mem_cgroup_get(parent);
+		parent = parent_mem_cgroup(parent);
+	}
 }
 
+static void mem_cgroup_put_parents(struct mem_cgroup *mem)
+{
+	struct mem_cgroup *parent = parent_mem_cgroup(mem);
+
+	while (parent) {
+		mem_cgroup_put(parent);
+		parent = parent_mem_cgroup(parent);
+	}
+}
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 static void __init enable_swap_cgroup(void)
@@ -2237,6 +2267,7 @@ mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
 	if (parent)
 		mem->swappiness = get_swappiness(parent);
 	atomic_set(&mem->refcnt, 1);
+	mem_cgroup_get_parents(mem);
 	return &mem->css;
 free_out:
 	__mem_cgroup_free(mem);
