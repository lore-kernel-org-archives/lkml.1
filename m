Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbYJAGEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbYJAGEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 02:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbYJAGER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 02:04:17 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:52769 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbYJAGEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 02:04:16 -0400
Message-ID: <48E311A8.3000802@linux.vnet.ibm.com>
Date: Wed, 01 Oct 2008 11:29:04 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>,
       ryov@valinux.co.jp
Subject: Re: [PATCH 9/12] memcg allocate all page_cgroup at boot
References: <20080925151124.25898d22.kamezawa.hiroyu@jp.fujitsu.com> <20080925153206.281243dc.kamezawa.hiroyu@jp.fujitsu.com> <48E2F6A9.9010607@linux.vnet.ibm.com> <20081001140748.637b9831.kamezawa.hiroyu@jp.fujitsu.com> <20081001143242.1b44de24.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081001143242.1b44de24.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 1 Oct 2008 14:07:48 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>> Can we make this patch indepedent of the flags changes and push it in ASAP.
>>>
>> Need much work....Hmm..rewrite all again ? 
>>
> 
> BTW, do you have good idea to modify flag bit without affecting LOCK bit on
> page_cgroup->flags ?
> 
> At least, we'll have to set ACTIVE/INACTIVE/UNEVICTABLE flags dynamically.
> take lock_page_cgroup() always ?

In the past patches, I've used lock_page_cgroup(). In some cases like
initialization at boot time, I've ignored taking the lock, since I know no-one
is accessing them yet.

> __mem_cgroup_move_lists() will have some amount of changes. And we should
> check dead lock again.

__mem_cgroup_move_lists() is called from mem_cgroup_isolate_pages() and
mem_cgroup_move_lists(). In mem_cgroup_move_lists(), we have the page_cgroup
lock. I think the current code works on the assumption (although not documented
anywhere I've seen), that PAGE_CGROUP_FLAG_INACTIVE/ACTIVE/UNEVICTABLE bits are
protected by lru_lock. Please look at

__mem_cgroup_remove_list
__mem_cgroup_add_list
__mem_cgroup_move_lists
__mem_cgroup_charge_common (sets this flag, before the pc is associated with the
page).

Am I missing something (today is holiday here, so I am in a bit of a lazy/sleepy
mood :) )

-- 
	Balbir
