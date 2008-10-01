Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbYJAGLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbYJAGLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 02:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbYJAGK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 02:10:58 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52062 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbYJAGK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 02:10:58 -0400
Date: Wed, 1 Oct 2008 15:17:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>,
       ryov@valinux.co.jp
Subject: Re: [PATCH 9/12] memcg allocate all page_cgroup at boot
Message-Id: <20081001151734.7e241903.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <48E311A8.3000802@linux.vnet.ibm.com>
References: <20080925151124.25898d22.kamezawa.hiroyu@jp.fujitsu.com>
	<20080925153206.281243dc.kamezawa.hiroyu@jp.fujitsu.com>
	<48E2F6A9.9010607@linux.vnet.ibm.com>
	<20081001140748.637b9831.kamezawa.hiroyu@jp.fujitsu.com>
	<20081001143242.1b44de24.kamezawa.hiroyu@jp.fujitsu.com>
	<48E311A8.3000802@linux.vnet.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Oct 2008 11:29:04 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > __mem_cgroup_move_lists() will have some amount of changes. And we should
> > check dead lock again.
> 
> __mem_cgroup_move_lists() is called from mem_cgroup_isolate_pages() and
> mem_cgroup_move_lists(). In mem_cgroup_move_lists(), we have the page_cgroup
> lock. I think the current code works on the assumption (although not documented
> anywhere I've seen), that PAGE_CGROUP_FLAG_INACTIVE/ACTIVE/UNEVICTABLE bits are
> protected by lru_lock. Please look at
yes, I wrote them.

> 
> __mem_cgroup_remove_list
> __mem_cgroup_add_list
> __mem_cgroup_move_lists
> __mem_cgroup_charge_common (sets this flag, before the pc is associated with the
> page).
> 
But my point is lru_lock doesn't means page_cgroup is not locked by someone and
we must take always lock_page_cgroup() when we modify flags.

Then, mem_cgroup_isolate_page() should have to take lock.
But this means we have to care preemption for avoiding deadlock.
Maybe need some time to test.

Thanks,
-Kame

