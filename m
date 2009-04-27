Return-Path: <linux-kernel-owner+w=401wt.eu-S1760046AbZD0X7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760046AbZD0X7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 19:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbZD0X72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 19:59:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53034 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbZD0X71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 19:59:27 -0400
Date: Tue, 28 Apr 2009 08:57:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: nishimura@mxp.nes.nec.co.jp, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix leak of swap accounting as stale swap cache under 
 memcg
Message-Id: <20090428085753.a91b6007.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <661de9470904271217t7ef9e300x1e40bbf0362ca14f@mail.gmail.com>
References: <20090427181259.6efec90b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090427101323.GK4454@balbir.in.ibm.com>
	<20090427203535.4e3f970b.d-nishimura@mtf.biglobe.ne.jp>
	<661de9470904271217t7ef9e300x1e40bbf0362ca14f@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009 00:47:31 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Thanks for the detailed explanation of the possible race conditions. I
> am beginning to wonder why we don't have any hooks in add_to_swap.*.
> for charging a page. If the page is already charged and if it is a
> context issue (charging it to the right cgroup) that is already
> handled from what I see. Won't that help us solve the !PageCgroupUsed
> issue?
> 

For adding hook to add_to_swap_cache, we need to know which cgroup the swap cache
should be charged. Then, we have to remove CONFIG_CGROUP_MEM_RES_CTRL_SWAP_EXT
and enable memsw control always.

When using swap_cgroup, we'll know which cgroup the new swap cache should be charged.
Then, the new page readed in will be charged to recorded cgroup in swap_cgroup.
One bad thing of this method is a cgroup which swap_cgroup point to is different from
a cgroup which the task calls do_swap_fault(). This means that a page-fault by a
task can cause memory-reclaim under another cgroup and moreover, OOM.
I don't think it's sane behavior. So, current design of swap accounting waits until the
page is mapped.

Thanks,
-Kame

