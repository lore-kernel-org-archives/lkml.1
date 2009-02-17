Return-Path: <linux-kernel-owner+w=401wt.eu-S1754976AbZBQAGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbZBQAGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 19:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbZBQAGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 19:06:40 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50815 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbZBQAGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 19:06:39 -0500
Date: Tue, 17 Feb 2009 09:05:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Bharata B Rao <bharata@in.ibm.com>, Paul Menage <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/4] Memory controller soft limit patches (v2)
Message-Id: <20090217090523.975bbec2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090216110844.29795.17804.sendpatchset@localhost.localdomain>
References: <20090216110844.29795.17804.sendpatchset@localhost.localdomain>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Feb 2009 16:38:44 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> 
> From: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> Changelog v2...v1
> 1. Soft limits now support hierarchies
> 2. Use spinlocks instead of mutexes for synchronization of the RB tree
> 
> Here is v2 of the new soft limit implementation. Soft limits is a new feature
> for the memory resource controller, something similar has existed in the
> group scheduler in the form of shares. The CPU controllers interpretation
> of shares is very different though. We'll compare shares and soft limits
> below.
> 
> Soft limits are the most useful feature to have for environments where
> the administrator wants to overcommit the system, such that only on memory
> contention do the limits become active. The current soft limits implementation
> provides a soft_limit_in_bytes interface for the memory controller and not
> for memory+swap controller. The implementation maintains an RB-Tree of groups
> that exceed their soft limit and starts reclaiming from the group that
> exceeds this limit by the maximum amount.
> 
> This is an RFC implementation and is not meant for inclusion
> 

some thoughts after reading patch.

1. As I pointed out, cpuset/mempolicy case is not handled yet.
2. I don't like to change usual direct-memory-reclaim path. It will be obstacles
   for VM-maintaners to improve memory reclaim. memcg's LRU is designed for
   shrinking memory usage and not for avoiding memory shortage. IOW, it's slow routine
   for reclaiming memory for memory shortage.
3. After this patch, res_counter is no longer for general purpose res_counter...
   It seems to have too many unnecessary accessories for general purpose.  
4. please use css_tryget() rather than mem_cgroup_get().
5. please remove mem_cgroup from tree at force_empty or rmdir.
   Just making  memcg->on_tree=false is enough ? I'm in doubt.
6. What happens when the-largest-soft-limit-memcg has tons on Anon on swapless
   system and memory reclaim cannot make enough progress ?

Thanks,
-Kame


