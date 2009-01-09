Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbZAIEsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbZAIEsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 23:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbZAIEso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 23:48:44 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56545 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbZAIEsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 23:48:43 -0500
Date: Fri, 9 Jan 2009 13:47:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, menage@google.com,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 1/4] memcg: fix for
 mem_cgroup_get_reclaim_stat_from_page
Message-Id: <20090109134736.a995fc49.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090109043257.GB9737@balbir.in.ibm.com>
References: <20090108190818.b663ce20.nishimura@mxp.nes.nec.co.jp>
	<20090108191430.af89e037.nishimura@mxp.nes.nec.co.jp>
	<20090109043257.GB9737@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009 10:02:57 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> >  	pc = lookup_page_cgroup(page);
> > +	smp_rmb();
> 
> Do you really need the read memory barrier?
> 
Necessary.

> > +	if (!PageCgroupUsed(pc))
> > +		return NULL;
> > +
> 
> In this case we've hit a case where the page is valid and the pc is
> not. This does fix the problem, but won't this impact us getting
> correct reclaim stats and thus indirectly impact the working of
> pressure?
> 
 - If retruns NULL, only global LRU's status is updated. 

Because this page is not belongs to any memcg, we cannot update
any counters. But yes, your point is a concern.

Maybe moving acitvate_page() to
==
do_swap_page()
{
    
- activate_page()
   mem_cgroup_try_charge()..
   ....
   mem_cgroup_commit_charge()....
   ....
+  activate_page()   
}
==
is necessary. How do you think, kosaki ?

Thanks,
-Kame

