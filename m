Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622Ab0AGCZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab0AGCZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 21:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280Ab0AGCZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 21:25:31 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52976 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756609Ab0AGCZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 21:25:30 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 7 Jan 2010 11:21:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: mmotm 2010-01-06-14-34 uploaded (mm/memcontrol)
Message-Id: <20100107112150.2e585f1c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100107111319.7d95fe86.nishimura@mxp.nes.nec.co.jp>
References: <201001062259.o06MxQrp023236@imap1.linux-foundation.org>
	<20100106171058.f1d6f393.randy.dunlap@oracle.com>
	<20100107111319.7d95fe86.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010 11:13:19 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> Thank you for your report.
 
> > config attached.
> > 
> I'm sorry I missed the !CONFIG_SWAP or !CONFIG_CGROUP_MEM_RES_CTLR_SWAP case.
> 
> I'll prepare fixes.
> 
Nishimura-san, could you double check this ?

Andrew, this is a fix onto Nishimura-san's memcg move account patch series.
Maybe this -> patches/memcg-move-charges-of-anonymous-swap.patch

Thanks,
-Kame
==

Build fix to following build error when CONFIG_CGROUP_MEM_RES_CTLR_SWAP is off.

mm/memcontrol.c: In function 'is_target_pte_for_mc':
mm/memcontrol.c:3985: error: implicit declaration of function 'mem_cgroup_count_swap_user'
mm/memcontrol.c: In function 'mem_cgroup_move_charge_pte_range':
mm/memcontrol.c:4220: error: too many arguments to function 'mem_cgroup_move_swap_account'
mm/memcontrol.c:4220: error: too many arguments to function 'mem_cgroup_move_swap_account'
mm/memcontrol.c:4220: error: too many arguments to function 'mem_cgroup_move_swap_account'

CC: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: ref-mmotm/mm/memcontrol.c
===================================================================
--- ref-mmotm.orig/mm/memcontrol.c
+++ ref-mmotm/mm/memcontrol.c
@@ -2369,7 +2369,7 @@ static int mem_cgroup_move_swap_account(
 }
 #else
 static inline int mem_cgroup_move_swap_account(swp_entry_t entry,
-				struct mem_cgroup *from, struct mem_cgroup *to)
+		struct mem_cgroup *from, struct mem_cgroup *to, bool need_fixup)
 {
 	return -EINVAL;
 }
@@ -3976,7 +3976,7 @@ static int is_target_pte_for_mc(struct v
 
 	if (!pte_present(ptent)) {
 		/* TODO: handle swap of shmes/tmpfs */
-		if (pte_none(ptent) || pte_file(ptent))
+		if (pte_none(ptent) || pte_file(ptent) || !do_swap_account)
 			return 0;
 		else if (is_swap_pte(ptent)) {
 			ent = pte_to_swp_entry(ptent);

