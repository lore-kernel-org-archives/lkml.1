Return-Path: <linux-kernel-owner+w=401wt.eu-S1755051AbZKKHcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbZKKHcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 02:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbZKKHcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 02:32:22 -0500
Received: from smtp-out.google.com ([216.239.33.17]:17434 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbZKKHcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 02:32:21 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=oIA8D5BOeyvih/ofrZgPPf7ABykpf99h4OKhwQufOLHUnxMs7xT/Jvw/bRJBflcpg
	OL/5WlTLSluaWuq7Rc0fw==
Date: Tue, 10 Nov 2009 23:32:18 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] oom-kill: fix NUMA consraint check with nodemask
 v4.2
In-Reply-To: <20091111153414.3c263842.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0911102331550.15125@chino.kir.corp.google.com>
References: <20091110162121.361B.A69D9226@jp.fujitsu.com> <20091110162445.c6db7521.kamezawa.hiroyu@jp.fujitsu.com> <20091110163419.361E.A69D9226@jp.fujitsu.com> <20091110164055.a1b44a4b.kamezawa.hiroyu@jp.fujitsu.com> <20091110170338.9f3bb417.nishimura@mxp.nes.nec.co.jp>
 <20091110171704.3800f081.kamezawa.hiroyu@jp.fujitsu.com> <20091111112404.0026e601.kamezawa.hiroyu@jp.fujitsu.com> <20091111134514.4edd3011.kamezawa.hiroyu@jp.fujitsu.com> <20091111142811.eb16f062.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.2.00.0911102155580.2924@chino.kir.corp.google.com> <20091111152004.3d585cee.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0911102224440.6652@chino.kir.corp.google.com> <20091111153414.3c263842.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009, KAMEZAWA Hiroyuki wrote:

> From: KAMEZAWA Hiroyuki <kamezawa.hioryu@jp.fujitsu.com>
> 
> Fixing node-oriented allocation handling in oom-kill.c
> I myself think this as bugfix not as ehnancement.
> 
> In these days, things are changed as
>   - alloc_pages() eats nodemask as its arguments, __alloc_pages_nodemask().
>   - mempolicy don't maintain its own private zonelists.
>   (And cpuset doesn't use nodemask for __alloc_pages_nodemask())
> 
> So, current oom-killer's check function is wrong.
> 
> This patch does
>   - check nodemask, if nodemask && nodemask doesn't cover all
>     node_states[N_HIGH_MEMORY], this is CONSTRAINT_MEMORY_POLICY.
>   - Scan all zonelist under nodemask, if it hits cpuset's wall
>     this faiulre is from cpuset.
> And
>   - modifies the caller of out_of_memory not to call oom if __GFP_THISNODE.
>     This doesn't change "current" behavior. If callers use __GFP_THISNODE
>     it should handle "page allocation failure" by itself.
> 
>   - handle __GFP_NOFAIL+__GFP_THISNODE path.
>     This is something like a FIXME but this gfpmask is not used now.
> 
> Changelog: 2009/11/11(2)
>  - uses nodes_subset().
>  - clean up.
>  - added __GFP_NOFAIL case. And added waring.
>  - removed inline
>  - removed 'ret'
> 
> Changelog: 2009/11/11
>  - fixed nodes_equal() calculation.
>  - return CONSTRAINT_MEMPOLICY always if given nodemask is not enough big.
> 
> Changelog: 2009/11/06
>  - fixed lack of oom.h
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hioryu@jp.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>
