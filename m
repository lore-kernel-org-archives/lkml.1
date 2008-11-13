Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbYKMCb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbYKMCb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 21:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbYKMCbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 21:31:20 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33771 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbYKMCbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 21:31:19 -0500
Date: Thu, 13 Nov 2008 11:30:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, nishimura@mxp.nes.nec.co.jp,
       menage@google.com
Subject: Re: [RFC][PATCH 1/6] memcg: free all at rmdir
Message-Id: <20081113113035.844e8756.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <491B802B.2060401@linux.vnet.ibm.com>
References: <20081112122606.76051530.kamezawa.hiroyu@jp.fujitsu.com>
	<20081112122656.c6e56248.kamezawa.hiroyu@jp.fujitsu.com>
	<20081112160758.3dca0b22.akpm@linux-foundation.org>
	<491B7395.8040606@linux.vnet.ibm.com>
	<20081112164637.b6f3cb78.akpm@linux-foundation.org>
	<491B7978.7010300@linux.vnet.ibm.com>
	<20081112170400.bfb7211c.akpm@linux-foundation.org>
	<491B802B.2060401@linux.vnet.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008 06:47:31 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> > btw, mem_cgroup_force_empty_list() uses PageLRU() outside ->lru_lock. 
> > That's racy, although afaict this race will only cause an accounting
> > error.
> > 
> > Or maybe not.  What happens if
> > __mem_cgroup_uncharge_common()->__mem_cgroup_remove_list() is passed a
> > page which isn't on an LRU any more?  boom?
> > 
> 
> IIRC, Kamezawa has been working on redoing force_empty interface. We are
> reworking its internals as well.
> 

PageLRU() is not used in account_move() version (in mmotm queue)
patches/memcg-move-all-acccounts-to-parent-at-rmdir.patch removes that.

We're now testing patch [6/6] which does

 1. remove per-memcg-lru-lock
 2. use zone->lru_lock instead of that.

Then, maintenance of this memcontrol.c will be much easier.

After patch [6/6]. account_move does

  isolate_page(page);
	move to other cgroup
  putback_lru_page(page);

as other usual routine does.

Thanks,
-Kame

