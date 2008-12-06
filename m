Return-Path: <linux-kernel-owner+w=401wt.eu-S1757202AbYLFCsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202AbYLFCsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 21:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbYLFCsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 21:48:16 -0500
Received: from rcpt-expgw.biglobe.ne.jp ([133.205.19.66]:38785 "EHLO
	rcpt-expgw.biglobe.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbYLFCsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 21:48:15 -0500
X-Biglobe-Sender: <d-nishimura@mtf.biglobe.ne.jp>
Date: Sat, 6 Dec 2008 11:47:57 +0900
From: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>
To: balbir@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, d-nishimura@mtf.biglobe.ne.jp,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH -mmotm 1/4] memcg: don't trigger oom at page
 migration
Message-Id: <20081206114757.c323c63b.d-nishimura@mtf.biglobe.ne.jp>
In-Reply-To: <20081205133925.GA10004@balbir.in.ibm.com>
References: <20081205212208.31d904e0.nishimura@mxp.nes.nec.co.jp>
	<20081205212304.f7018ea1.nishimura@mxp.nes.nec.co.jp>
	<20081205133925.GA10004@balbir.in.ibm.com>
Reply-To: nishimura@mxp.nes.nec.co.jp
X-Mailer: Sylpheed 2.5.0rc2 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2008 19:09:26 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> [2008-12-05 21:23:04]:
> 
> > I think triggering OOM at mem_cgroup_prepare_migration would be just a bit
> > overkill.
> > Returning -ENOMEM would be enough for mem_cgroup_prepare_migration.
> > The caller would handle the case anyway.
> > 
> > Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> > ---
> >  mm/memcontrol.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 4dbce1d..50ee1be 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -1330,7 +1330,7 @@ int mem_cgroup_prepare_migration(struct page *page, struct mem_cgroup **ptr)
> >  	unlock_page_cgroup(pc);
> > 
> >  	if (mem) {
> > -		ret = mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem);
> > +		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem, false);
> >  		css_put(&mem->css);
> >  	}
> >  	*ptr = mem;
> >
> 
> Seems reasonable to me. A comment indicating or adding a noreclaim
> wrapper around __mem_cgroup_try_charge to indicate that no reclaim
> will take place will be nice.
> 
Ah.. this flag to __mem_cgroup_try_charge doesn't mean "don't reclaim"
but "don't cause oom after it tried to free memory but couldn't
free enough memory after all".

Thanks,
Daisuke Nishimura.

> Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com> 
> 
> -- 
> 	Balbir
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
