Return-Path: <linux-kernel-owner+w=401wt.eu-S1752674Ab0AMFjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab0AMFjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 00:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411Ab0AMFjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 00:39:17 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36753 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab0AMFjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 00:39:15 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 13 Jan 2010 14:35:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       stable <stable@kernel.org>, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUGFIX][PATCH] memcg: ensure list is empty at rmdir
Message-Id: <20100113143555.df2cb1cc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100113142707.1c857d1d.nishimura@mxp.nes.nec.co.jp>
References: <20100112140836.45e7fabb.nishimura@mxp.nes.nec.co.jp>
	<20100113103006.8cf3b23c.nishimura@mxp.nes.nec.co.jp>
	<20100113122754.d390d0a2.kamezawa.hiroyu@jp.fujitsu.com>
	<20100113142707.1c857d1d.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jan 2010 14:27:07 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> For example:
> - Pages can be uncharged by its owner process while they are on LRU.
> - race between mem_cgroup_add_lru_list() and __mem_cgroup_uncharge_common().
> 
> So there can be a case in which the usage is zero but some of the LRUs are not empty.
> 
> OTOH, mem_cgroup_del_lru_list(), which can be called asynchronously with rmdir,
> accesses the mem_cgroup, so this access can cause a problem if it races with
> rmdir because the mem_cgroup might have been freed by rmdir.
> 
 
> The problem here is pages on LRU may contain pointer to stale memcg.
> To make res->usage to be 0, all pages on memcg must be uncharged or moved to
> another(parent) memcg. Moved page_cgroup have already removed from original LRU,
> but uncharged page_cgroup contains pointer to memcg withou PCG_USED bit. (This
> asynchronous LRU work is for improving performance.) If PCG_USED bit is not set,
> page_cgroup will never be added to memcg's LRU. So, about pages not on LRU, they
> never access stale pointer. Then, what we have to take care of is page_cgroup
> _on_ LRU list. This patch fixes this problem by making mem_cgroup_force_empty()
> visit all LRUs before exiting its loop and guarantee there are no pages on its LRU.
> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> Cc: stable@kernel.org

Thank you. very nice.

Regards,
-Kame

