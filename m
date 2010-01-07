Return-Path: <linux-kernel-owner+w=401wt.eu-S1756207Ab0AGJHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab0AGJHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 04:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756048Ab0AGJHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 04:07:18 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56055 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997Ab0AGJHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 04:07:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 7 Jan 2010 18:04:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, akpm@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH -mmotm] memcg: implement memory thresholds document
 fixes
Message-Id: <20100107180401.2bca081f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100107085256.GU3059@balbir.in.ibm.com>
References: <201001062259.o06MxQrp023236@imap1.linux-foundation.org>
	<20100107095714.9edc4201.nishimura@mxp.nes.nec.co.jp>
	<20100107101805.b26a1f1a.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107085256.GU3059@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010 14:22:56 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-01-07 10:18:05]:
> 
> > On Thu, 7 Jan 2010 09:57:14 +0900
> > Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > 
> > > Each memcg-implement-memory-thresholds.patch and
> > > memcg-add-interface-to-move-charge-at-task-migration.patch try to add a new
> > > section to Documentation/cgroup/memory.txt, so the document has been a bit
> > > mangled when these patches are merged at the same time.
> > > 
> > > This patch fixes it.
> > > 
> > 
> > Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > BTW, I'll prepare total update for memcg (especially around percpu counter).
> > Do you have something may conflict in plan ?
> 
> Kame, could you clarify percpu counter? Is this on for resource
> counter scalability patches I had?
> 
No.

Now. memcg's percpu counter uses following code.
==
static inline void
__mem_cgroup_stat_set_safe(struct mem_cgroup_stat_cpu *stat,
                                enum mem_cgroup_stat_index idx, s64 val)
{
        stat->count[idx] = val;
}
static int mem_cgroup_size(void)
{
        int cpustat_size = nr_cpu_ids * sizeof(struct mem_cgroup_stat_cpu);
        return sizeof(struct mem_cgroup) + cpustat_size;
}

static struct mem_cgroup *mem_cgroup_alloc(void)
{
        struct mem_cgroup *mem;
        int size = mem_cgroup_size();

        if (size < PAGE_SIZE)
                mem = kmalloc(size, GFP_KERNEL);
        else
                mem = vmalloc(size);

==

But this is not NUMA-aware and slow. i.e. BAD.

Now, we have good codes for percpu_alloc(). we should use it.

like this => http://patchwork.kernel.org/patch/58662/

Things will be simplified.
I need to rewrite all to catch up recent changes _AND_ we have to
detect why 2 seconds of overhead is added by threshold patches.
And hopefuly, reduce it. I think softlimit/threshold event counter
can be rewritten in unified clean way.

Thanks,
-Kame





