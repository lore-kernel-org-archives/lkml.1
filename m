Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbZAICkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbZAICkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 21:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbZAICkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 21:40:19 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49280 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbZAICkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 21:40:18 -0500
Date: Fri, 9 Jan 2009 11:39:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       balbir@linux.vnet.ibm.com, lizf@cn.fujitsu.com, menage@google.com
Subject: Re: [RFC][PATCH 4/4] memcg: make oom less frequently
Message-Id: <20090109113910.5edcc8ab.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090109112922.68881c05.nishimura@mxp.nes.nec.co.jp>
References: <20090108190818.b663ce20.nishimura@mxp.nes.nec.co.jp>
	<20090108191520.df9c1d92.nishimura@mxp.nes.nec.co.jp>
	<44480.10.75.179.62.1231413588.squirrel@webmail-b.css.fujitsu.com>
	<20090109104416.9bf4aab7.nishimura@mxp.nes.nec.co.jp>
	<20090109110358.8a0d991a.kamezawa.hiroyu@jp.fujitsu.com>
	<20090109112922.68881c05.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009 11:29:22 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> > > @@ -870,8 +870,13 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
> > >  		if (!(gfp_mask & __GFP_WAIT))
> > >  			goto nomem;
> > >  
> > > +		if (signal_pending(current))
> > > +			goto oom;
> > > +
> > 
> > I think it's better to avoid to add this check *now*. and "signal is pending" 
> > doesn't mean oom situation.
> > 
> hmm.. charge is assumed to return 0 or -ENOMEM, what should we return on
> signal_pending case ?
> 
> In case of shmem for example, if charge at shmem_getpage fails by -ENOMEM, 
> shmem_fault returns VM_FAULT_OOM, so pagefault_out_of_memory would be called.
> If memcg had not invoked oom-killer, system wide oom would be invoked.
> 
yes, that's problem.

I think generic -EAGAIN support is appreciated. But it will not be for -rc ;)
(... that will make codes other than memcontrol.c more complicated.)

Thanks,
-Kame

> > Hmm..Maybe we can tell "please retry page fault again, it's too long latency in
> > memory reclaim and you received signal." in future.
> > 
> OK.
> 
> > IMHO, only quick path which we can add here now is
> > ==
> > 	if (test_thread_flag(TIG_MEMDIE)) { /* This thread is killed by OOM */
> > 		*memcg = NULL;
> > 		return 0;
> > 	}
> > ==
> > like this.
> > 
> > Anyway, please discuss this "quick exit path" in other patch and just remove 
> > siginal check.
> > 
> > Other part looks ok to me.
> > 
> Thanks :)
> 
> I'll update this one by removing the signal_pendign check.
> 
> 
> Thanks,
> Daisuke Nishimura.
> 

