Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbYI0DmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbYI0DmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 23:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbYI0Dl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 23:41:56 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59290 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbYI0Dlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 23:41:55 -0400
Date: Sat, 27 Sep 2008 12:47:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>,
       ryov@valinux.co.jp
Subject: Re: [PATCH 9/12] memcg allocate all page_cgroup at boot
Message-Id: <20080927124745.2e216381.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080926145422.327fb53f.nishimura@mxp.nes.nec.co.jp>
References: <20080925151124.25898d22.kamezawa.hiroyu@jp.fujitsu.com>
	<20080925153206.281243dc.kamezawa.hiroyu@jp.fujitsu.com>
	<20080926100022.8bfb8d4d.nishimura@mxp.nes.nec.co.jp>
	<20080926104336.d96ab5bd.kamezawa.hiroyu@jp.fujitsu.com>
	<20080926110550.2292287b.kamezawa.hiroyu@jp.fujitsu.com>
	<20080926145422.327fb53f.nishimura@mxp.nes.nec.co.jp>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2008 14:54:22 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > Sorry, my brain seems to be sleeping.. above page_mapped() check doesn't
> > help this situation. Maybe this page_mapped() check is not necessary
> > because it's of no use.
> > 
> > I think this kind of problem will not be fixed until we handle SwapCache.
> > 
> I've not fully understood yet what [12/12] does, but if we handle
> swapcache properly, [12/12] would become unnecessary?
> 

Try to illustrate what is trouble more precisely.


in do_swap_page(), page is charged when SwapCache lookup ends.

Here, 
     - charged when page is not mapped.
     - not charged when page is mapped.
set_pte() etc...are done under appropriate lock.

On the other side, when a task exits, zap_pte_range() is called.
It calls page_remove_rmap(). 

Case A) Following is race.

            Thread A                     Thread B

     do_swap_page()                      zap_pte_range()
	(1)try charge (mapcount=1)
                                         (2) page_remove_rmap()
					     (3) uncharge page. 
	(4) map it


Then,
 at (1),  mapcount=1 and this page is not charged.
 at (2),  page_remove_rmap() is called and mapcount goes down to Zero.
          uncharge(3) is called.
 at (4),  at the end of do_swap_page(), page->mapcount=1 but not charged.

Case B) In another scenario.

            Thread A                     Thread B

     do_swap_page()                      zap_pte_range()
	(1)try charge (mapcount=1)
                                         (2) page_remove_rmap()
	(3) map it
                                         (4) uncharge is called.

In (4), uncharge is capped but mapcount can go up to 1.

protocol 12/12 is for case (A).
After 12/12, double-check page_mapped() under lock_page_cgroup() will be fix to
case (B).

Huu, I don't like swap-cache ;)
Anyway, we'll have to handle swap cache later.

Thanks,
-Kame






















