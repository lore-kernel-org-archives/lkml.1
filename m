Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab0BVU4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 15:56:08 -0500
Received: from smtp-out.google.com ([216.239.44.51]:32515 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab0BVU4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 15:56:06 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=UhHqEcGHOjtDiDiJQNqyrF8/nuIONvW5H7V4V5ioEW6osooQvX5RGhbrTl04YYr8n
	ThlhurxIZHbM3fV0PwLKQ==
Date: Mon, 22 Feb 2010 12:55:57 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Nick Piggin <npiggin@suse.de>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 4/9 v2] oom: remove compulsory panic_on_oom mode
In-Reply-To: <20100222151513.0605d69e.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002221250540.14426@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com> <alpine.DEB.2.00.1002151610380.14484@chino.kir.corp.google.com> <20100216092311.86bceb0c.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002160058470.17122@chino.kir.corp.google.com>
 <20100217084239.265c65ea.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002161550550.11952@chino.kir.corp.google.com> <20100217090124.398769d5.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002161623190.11952@chino.kir.corp.google.com>
 <20100217094137.a0d26fbb.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002161648570.31753@chino.kir.corp.google.com> <alpine.DEB.2.00.1002161756100.15079@chino.kir.corp.google.com> <20100217111319.d342f10e.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.2.00.1002161825280.2768@chino.kir.corp.google.com> <20100217113430.9528438d.kamezawa.hiroyu@jp.fujitsu.com> <20100222143151.9e362c88.nishimura@mxp.nes.nec.co.jp> <20100222151513.0605d69e.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Feb 2010, KAMEZAWA Hiroyuki wrote:

> Essential fix is better. The best fix is don't call oom-killer in
> pagefault_out_of_memory. So, returning other than VM_FAULT_OOM is
> the best, I think. But hmm...we don't have VM_FAULT_AGAIN etc..
> So, please avoid quick fix. 
> 

The last patch in my oom killer series defaults pagefault_out_of_memory() 
to always kill current first, if it's killable.  If it is unsuccessful, we 
fallback to scanning the entire tasklist.

For tasks that are constrained by a memcg, we could probably use 
mem_cgroup_from_task(current) and if it's non-NULL and non-root, call 
mem_cgroup_out_of_memory() with a gfp_mask of 0.  That would at least 
penalize the same memcg instead of invoking a global oom and would try the 
additional logic that you plan on adding to avoid killing any task at all 
in such conditions.
