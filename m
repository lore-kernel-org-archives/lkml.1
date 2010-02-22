Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab0BVU71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 15:59:27 -0500
Received: from smtp-out.google.com ([216.239.33.17]:2846 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab0BVU70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 15:59:26 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=testMGI9GSYECjk7S0tZEze9u+7pfPV/Mh79zh9G5v3GeoUyn6PxIaMeY7zGUBzrb
	q/ws35voK4NhC2E1giSNA==
Date: Mon, 22 Feb 2010 12:59:15 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Nick Piggin <npiggin@suse.de>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 4/9 v2] oom: remove compulsory panic_on_oom mode
In-Reply-To: <20100222204237.61e3c615.d-nishimura@mtf.biglobe.ne.jp>
Message-ID: <alpine.DEB.2.00.1002221256470.14426@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com> <20100216092311.86bceb0c.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002160058470.17122@chino.kir.corp.google.com> <20100217084239.265c65ea.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.2.00.1002161550550.11952@chino.kir.corp.google.com> <20100217090124.398769d5.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002161623190.11952@chino.kir.corp.google.com> <20100217094137.a0d26fbb.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.2.00.1002161648570.31753@chino.kir.corp.google.com> <alpine.DEB.2.00.1002161756100.15079@chino.kir.corp.google.com> <20100217111319.d342f10e.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002161825280.2768@chino.kir.corp.google.com>
 <20100217113430.9528438d.kamezawa.hiroyu@jp.fujitsu.com> <20100222143151.9e362c88.nishimura@mxp.nes.nec.co.jp> <20100222151513.0605d69e.kamezawa.hiroyu@jp.fujitsu.com> <20100222204237.61e3c615.d-nishimura@mtf.biglobe.ne.jp>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Feb 2010, Daisuke Nishimura wrote:

> hmm, I can agree with you. But I think we need some trick to distinguish normal VM_FAULT_OOM
> and memcg's VM_FAULT_OOM(the current itself was killed by memcg's oom, so exited the retry)
> at mem_cgroup_oom_called() to avoid the system from panic when panic_on_oom is enabled.
> (Mark the task which is being killed by memcg's oom ?).
> 

pagefault_out_of_memory() should use mem_cgroup_from_task(current) and 
then call mem_cgroup_out_of_memory() when it's non-NULL.  
select_bad_process() will return ERR_PTR(-1UL) if there is an already oom 
killed task attached to the memcg, so we can use that to avoid the 
panic_on_oom.  The setting of that sysctl doesn't imply that we can't scan 
the tasklist, it simply means we can't kill anything as a result of an 
oom.
