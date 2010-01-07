Return-Path: <linux-kernel-owner+w=401wt.eu-S1753332Ab0AGFdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab0AGFdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 00:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811Ab0AGFdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 00:33:32 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:46201 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab0AGFdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 00:33:31 -0500
Date: Thu, 7 Jan 2010 14:14:01 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH -mmotm] build fix for
 memcg-move-charges-of-anonymous-swap.patch
Message-Id: <20100107141401.6a182085.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20100107133026.6350bd9d.kamezawa.hiroyu@jp.fujitsu.com>
References: <201001062259.o06MxQrp023236@imap1.linux-foundation.org>
	<20100106171058.f1d6f393.randy.dunlap@oracle.com>
	<20100107111319.7d95fe86.nishimura@mxp.nes.nec.co.jp>
	<20100107112150.2e585f1c.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107115901.594330d0.nishimura@mxp.nes.nec.co.jp>
	<20100107120233.f244d4b7.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107130609.31fe83dc.nishimura@mxp.nes.nec.co.jp>
	<20100107133026.6350bd9d.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010 13:30:26 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Thu, 7 Jan 2010 13:06:09 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
> > build fix in !CONFIG_SWAP case.
> > 
> >   CC      mm/memcontrol.o
> > mm/memcontrol.c: In function 'is_target_pte_for_mc':
> > mm/memcontrol.c:3648: error: implicit declaration of function 'mem_cgroup_count_swap_user'
> > make[1]: *** [mm/memcontrol.o] Error 1
> > make: *** [mm] Error 2
> > 
> > Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
> Hmm, this doesn't seem include fix for CONFIG_CGROUP_MEM_RES_CTLR_SWAP=n
> ==
> static int is_target_pte_for_mc(struct vm_area_struct *vma,
>                 unsigned long addr, pte_t ptent, union mc_target *target)
> {
> ....
>                 else if (is_swap_pte(ptent)) {
>                         ent = pte_to_swp_entry(ptent);
>                         if (!move_anon || non_swap_entry(ent))
>                                 return 0;
>                         usage_count = mem_cgroup_count_swap_user(ent, &page);
>                 }
> ==
> At least, !do_swap_account check is necessary, I think.
> I'm sorry if I miss something...
> 
mem_cgroup_count_swap_user() is defined in CONFIG_CGROUP_MEM_RES_CTLR case,
so the build error has nothing to do with CONFIG_CGROUP_MEM_RES_CTLR_SWAP(i.e. do_swap_account).
And I think adding !do_swap_account would ignore unmaped-but-not-uncharged-yet
swapcache in CONFIG_SWAP && !CONFIG_CGROUP_MEM_RES_CTLR_SWAP case.
(it would not be a big problem though).

Anyway, I'm sorry that the first patch was wrong...
This is the correct one.

===
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

build fix in !CONFIG_SWAP case.

  CC      mm/memcontrol.o
mm/memcontrol.c: In function 'is_target_pte_for_mc':
mm/memcontrol.c:3648: error: implicit declaration of function 'mem_cgroup_count_swap_user'
make[1]: *** [mm/memcontrol.o] Error 1
make: *** [mm] Error 2

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
This can be applied after memcg-move-charges-of-anonymous-swap.patch.

 include/linux/swap.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index d9b06f7..c2a4295 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -488,6 +488,14 @@ mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent)
 {
 }
 
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+static inline int
+mem_cgroup_count_swap_user(swp_entry_t ent, struct page **pagep)
+{
+	return 0;
+}
+#endif
+
 #endif /* CONFIG_SWAP */
 #endif /* __KERNEL__*/
 #endif /* _LINUX_SWAP_H */
-- 
1.5.6.1
