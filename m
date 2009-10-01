Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbZJABbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbZJABbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 21:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbZJABbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 21:31:24 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37680 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334AbZJABbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 21:31:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 1 Oct 2009 10:29:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/2] memcg: replace memcg's per cpu status counter
 with array counter like vmstat
Message-Id: <20091001102912.7276a8b3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091001094514.c9d2b3d9.nishimura@mxp.nes.nec.co.jp>
References: <20090930190417.8823fa44.kamezawa.hiroyu@jp.fujitsu.com>
	<20091001094514.c9d2b3d9.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Oct 2009 09:45:14 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Wed, 30 Sep 2009 19:04:17 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > Hi,
> > 
> > In current implementation, memcg uses its own percpu counters for counting
> > evetns and # of RSS, CACHES. Now, counter is maintainer per cpu without
> > any synchronization as vm_stat[] or percpu_counter. So, this is
> >  update-is-fast-but-read-is-slow conter.
> > 
> > Because "read" for these counter was only done by memory.stat file, I thought
> > read-side-slowness was acceptable. Amount of memory usage, which affects
> > memory limit check, can be read by memory.usage_in_bytes. It's maintained
> > by res_counter.
> > 
> > But in current -rc, root memcg's memory usage is calcualted by this per cpu
> > counter and read side slowness may be trouble if it's frequently read.
> > 
> > And, in recent discusstion, I wonder we should maintain NR_DIRTY etc...
> > in memcg. So, slow-read-counter will not match our requirements, I guess.
> > I want some counter like vm_stat[] in memcg.
> > 
> I see your concern.
> 
> But IMHO, it would be better to explain why we need a new percpu array counter
> instead of using array of percpu_counter(size or consolidation of related counters ?),
> IOW, what the benefit of percpu array counter is.
> 
Ok.
  array of 4 percpu counter means a struct like following.

     lock                4bytes (int)
     count               8bytes
     list_head           16bytes
     pointer to percpu   8bytes
     lock                ,,,
     count
     list_head
     pointer to percpu
     lock
     count
     list_head
     pointer to percpu
     lock
     count
     list_head
     pointer to percpu

    36x4= 144 bytes and this has 4 spinlocks.2 cache lines.
    4 spinlock means if one of "batch" expires in a cpu, all cache above will
    be invalidated. Most of read-only data will lost.

    Making alignments of each percpu counter to cacheline for avoiding
    false sharing means this will use 4 cachelines + percpu area.
    That's bad.

  array counter of 4 entry is:
     s8 batch            4bytes (will be aligned)
     pointer to percpu   8bytes
     elements            4bytes.
     list head           16bytes
     ==== cacheline aligned here== 128bytes.
     atomic_long_t       4x8==32bytes
     ==== should be aligned to cache ? maybe yes===

  Then, this will occupy 2 cachelines + percpu area.
  No false sharing in read-only area.
  All writes are done in one (locked) access.

Hmm..I may have to consider more about archs which has not atomic_xxx ops.

Considerng sets of counters can be updated at once, array of percpu counter
is not good choice. I think.

Thanks,
-Kame


