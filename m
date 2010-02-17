Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933553Ab0BQC2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 21:28:16 -0500
Received: from smtp-out.google.com ([216.239.44.51]:38461 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933335Ab0BQC2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 21:28:14 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=hgD4qnHmPcbL7x0umjt+KwKDG+0S3AdkjCcniF1xRbW1cUiiM/ygMdJ8C9tlb37y9
	Db2qud3hB7WwPB4EvV+vA==
Date: Tue, 16 Feb 2010 18:28:05 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 4/9 v2] oom: remove compulsory panic_on_oom mode
In-Reply-To: <20100217111319.d342f10e.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002161825280.2768@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com> <alpine.DEB.2.00.1002151418190.26927@chino.kir.corp.google.com> <20100216090005.f362f869.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002151610380.14484@chino.kir.corp.google.com>
 <20100216092311.86bceb0c.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002160058470.17122@chino.kir.corp.google.com> <20100217084239.265c65ea.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002161550550.11952@chino.kir.corp.google.com>
 <20100217090124.398769d5.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002161623190.11952@chino.kir.corp.google.com> <20100217094137.a0d26fbb.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002161648570.31753@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1002161756100.15079@chino.kir.corp.google.com> <20100217111319.d342f10e.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Feb 2010, KAMEZAWA Hiroyuki wrote:

> > What do you think about making pagefaults use out_of_memory() directly and 
> > respecting the sysctl_panic_on_oom settings?
> > 
> 
> I don't think this patch is good. Because several memcg can
> cause oom at the same time independently, system-wide oom locking is
> unsuitable. BTW, what I doubt is much more fundamental thing.
> 

We want to lock all populated zones with ZONE_OOM_LOCKED to avoid 
needlessly killing more than one task regardless of how many memcgs are 
oom.

> What I doubt at most is "why VM_FAULT_OOM is necessary ? or why we have
> to call oom_killer when page fault returns it".
> Is there someone who returns VM_FAULT_OOM without calling page allocator
> and oom-killer helps something in such situation ?
> 

Before we invoked the oom killer for VM_FAULT_OOM, we simply sent a 
SIGKILL to current because we simply don't have memory to fault the page 
in, it's better to select a memory-hogging task to kill based on badness() 
than to constantly kill current which may not help in the long term.
