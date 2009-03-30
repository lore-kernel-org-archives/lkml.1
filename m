Return-Path: <linux-kernel-owner+w=401wt.eu-S1758736AbZC3X7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736AbZC3X7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 19:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZC3X7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 19:59:01 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45368 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbZC3X7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 19:59:00 -0400
Date: Tue, 31 Mar 2009 08:57:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH] memcg soft limit (yet another new design) v1
Message-Id: <20090331085729.c0c2b384.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090329130138.GA15608@balbir.in.ibm.com>
References: <20090327135933.789729cb.kamezawa.hiroyu@jp.fujitsu.com>
	<20090329130138.GA15608@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Mar 2009 18:31:38 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> > 
> >  - Inactive/Active rotation scheme of global LRU will be broken.
> > 
> >  - File/Anon reclaim ratio scheme of global LRU will be broken.
> >     - vm.swappiness will be ignored.
> > 
> 
> Not true, with my patches none of these are affected since the reclaim
> for soft limits is limited to mem cgroup LRU lists only. Zone reclaim
> that happens in parallel can of-course change the global LRU.
> 
> >  - If using memcg's memory reclaim routine, 
> >     - shrink_slab() will be never called.
> >     - stale SwapCache has no chance to be reclaimed (stale SwapCache means
> >       readed but not used one.)
> >     - memcg can have no memory in a zone.
> >     - memcg can have no Anon memory
> >     - lumpty_reclaim() is not called.
> > 
> > 
> > This patch tries to avoid to use existing memcg's reclaim routine and
> > just tell "Hints" to global LRU. This patch is briefly tested and shows
> > good result to me. (But may not to you. plz brame me.)
> > 
> 
> I don't like the results, they are functionaly broken (see my other
> email). Why should "B" get reclaimed from if it is not above its soft
> limit? Why is there a swapout from "B"?
> 
I explained in other mail.




> 
> > Major characteristic is.
> >  - memcg will be inserted to softlimit-queue at charge() if usage excess
> >    soft limit.
> >  - softlimit-queue is a queue with priority. priority is detemined by size
> >    of excessing usage.
> >  - memcg's soft limit hooks is called by shrink_xxx_list() to show hints.
> >  - Behavior is affected by vm.swappiness and LRU scan rate is determined by
> >    global LRU's status.
> > 
> > I'm sorry that I'm tend not to tell enough explanation.  plz ask me.
> > There will be much discussion points, anyway. As usual, I'm not in hurry.
> >
> 
> The code seems to add a lot of complexity and does not achieve expected
> functionality. I am going to start testing this series soon
>  



> > 
> > ==brief test result==
> > On 2CPU/1.6GB bytes machine. create group A and B
> >   A.  soft limit=300M
> >   B.  no soft limit
> > 
> >   Run a malloc() program on B and allcoate 1G of memory. The program just
> >   sleeps after allocating memory and no memory refernce after it.
> >   Run make -j 6 and compile the kernel.
> > 
> >   When vm.swappiness = 60  => 60MB of memory are swapped out from B.
> >   When vm.swappiness = 10  => 1MB of memory are swapped out from B    
> > 
> >   If no soft limit, 350MB of swap out will happen from B.(swapiness=60)
> > 
> > I'll try much more complexed ones in the weekend.
> 
> Please see my response to this test result in a previous email.
> 
you too, I repoted to your thread one week ago,

Thanks,
-Kame

> -- 
> 	Balbir

