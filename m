Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933938Ab0BQC6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 21:58:30 -0500
Received: from smtp-out.google.com ([216.239.33.17]:46909 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933664Ab0BQC62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 21:58:28 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=JWa3xK2CPzwT03qekfL0IuoCXxLSIfBVx6KnA0SlUlZute/Fho7A8E32aZpr8H2gs
	qjZEatqaDQtLWDSAr82WQ==
Date: Tue, 16 Feb 2010 18:58:17 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 4/9 v2] oom: remove compulsory panic_on_oom mode
In-Reply-To: <20100217113430.9528438d.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002161850540.3106@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com> <20100216090005.f362f869.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002151610380.14484@chino.kir.corp.google.com> <20100216092311.86bceb0c.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.2.00.1002160058470.17122@chino.kir.corp.google.com> <20100217084239.265c65ea.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002161550550.11952@chino.kir.corp.google.com> <20100217090124.398769d5.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.2.00.1002161623190.11952@chino.kir.corp.google.com> <20100217094137.a0d26fbb.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002161648570.31753@chino.kir.corp.google.com> <alpine.DEB.2.00.1002161756100.15079@chino.kir.corp.google.com>
 <20100217111319.d342f10e.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002161825280.2768@chino.kir.corp.google.com> <20100217113430.9528438d.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Feb 2010, KAMEZAWA Hiroyuki wrote:

> > We want to lock all populated zones with ZONE_OOM_LOCKED to avoid 
> > needlessly killing more than one task regardless of how many memcgs are 
> > oom.
> > 
> Current implentation archive what memcg want. Why remove and destroy memcg ?
> 

I've updated my patch to not take ZONE_OOM_LOCKED for any zones on memcg 
oom.  I'm hoping that you will add sysctl_panic_on_oom == 2 for this case 
later, however.

> What I mean is
>  - What VM_FAULT_OOM means is not "memory is exhausted" but "something is exhausted".
> 
> For example, when hugepages are all used, it may return VM_FAULT_OOM.
> Especially when nr_overcommit_hugepage == usage_of_hugepage, it returns VM_FAULT_OOM.
> 

The hugetlb case seems to be the only misuse of VM_FAULT_OOM where it 
doesn't mean we simply don't have the memory to handle the page fault, 
i.e. your earlier "memory is exhausted" definition.  That was handled well 
before calling out_of_memory() by simply killing current since we know it 
is faulting hugetlb pages and its resource is limited.

We could pass the vma to pagefault_out_of_memory() and simply kill current 
if its killable and is_vm_hugetlb_page(vma).
