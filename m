Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933990Ab0BQDYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 22:24:44 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55564 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933957Ab0BQDYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 22:24:43 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 17 Feb 2010 12:21:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 4/9 v2] oom: remove compulsory panic_on_oom mode
Message-Id: <20100217122106.31e12398.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1002161850540.3106@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1002151610380.14484@chino.kir.corp.google.com>
	<20100216092311.86bceb0c.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002160058470.17122@chino.kir.corp.google.com>
	<20100217084239.265c65ea.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002161550550.11952@chino.kir.corp.google.com>
	<20100217090124.398769d5.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002161623190.11952@chino.kir.corp.google.com>
	<20100217094137.a0d26fbb.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002161648570.31753@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1002161756100.15079@chino.kir.corp.google.com>
	<20100217111319.d342f10e.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002161825280.2768@chino.kir.corp.google.com>
	<20100217113430.9528438d.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002161850540.3106@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010 18:58:17 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Wed, 17 Feb 2010, KAMEZAWA Hiroyuki wrote:
> 
> > > We want to lock all populated zones with ZONE_OOM_LOCKED to avoid 
> > > needlessly killing more than one task regardless of how many memcgs are 
> > > oom.
> > > 
> > Current implentation archive what memcg want. Why remove and destroy memcg ?
> > 
> 
> I've updated my patch to not take ZONE_OOM_LOCKED for any zones on memcg 
> oom.  I'm hoping that you will add sysctl_panic_on_oom == 2 for this case 
> later, however.
> 
I'll write panic_on_oom for memcg, later. 

> > What I mean is
> >  - What VM_FAULT_OOM means is not "memory is exhausted" but "something is exhausted".
> > 
> > For example, when hugepages are all used, it may return VM_FAULT_OOM.
> > Especially when nr_overcommit_hugepage == usage_of_hugepage, it returns VM_FAULT_OOM.
> > 
> 
> The hugetlb case seems to be the only misuse of VM_FAULT_OOM where it 
> doesn't mean we simply don't have the memory to handle the page fault, 
> i.e. your earlier "memory is exhausted" definition.  That was handled well 
> before calling out_of_memory() by simply killing current since we know it 
> is faulting hugetlb pages and its resource is limited.
> 
> We could pass the vma to pagefault_out_of_memory() and simply kill current 
> if its killable and is_vm_hugetlb_page(vma).
> 

No. hugepage is not only case.
You may not read but we annoyed i915's driver bug recently and it was clearly
misuse of VM_FAULT_OOM. Then, we got many reports of OOM killer in these months.
(thanks to Kosaki about this.)

quick glance around core codes...
 - HUGEPAGE at el. should return some VM_FAULT_NO_RESOUECE rather than VM_FAULT_OOM.
 - filemap.c's VM_FAULT_OOM shoudn't call page_fault_oom_kill because it has already
   called oom_killer if it can. 
 - about relayfs, is VM_FAULT_OOM should be BUG_ON()...
 - filemap_xip.c return VM_FAULT_OOM....but it doesn't seem to be OOM..
   just like VM_FAULT_NO_VALID_PAGE_FOUND. (But I'm not familiar with this area.)
 - fs/buffer.c 's VM_FAULT_OOM is returned oom-killer is called.
 - shmem.c's VM_FAULT_OOM is retuned oom-killer is called.

i915's VM_FAULT_OOM is miterious but I can't find whether its real OOM or just shortage
of is own resource. I think VM_FAULT_NO_RESOUCE should be added.


Thanks,
-Kame


