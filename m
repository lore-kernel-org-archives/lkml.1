Return-Path: <linux-kernel-owner+w=401wt.eu-S934265AbZGQJJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934265AbZGQJJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 05:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934226AbZGQJJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 05:09:38 -0400
Received: from smtp-out.google.com ([216.239.33.17]:63457 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934203AbZGQJJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 05:09:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=OrDBFJw0npvva0bjCYpXuK/fcQGPpQuh11isYp4uQM0V/6yuoBZ3vNCaVb9jUhnjl
	IoO+rOsIXq4omHfxpcAUQ==
Date: Fri, 17 Jul 2009 02:09:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Miao Xie <miaox@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Paul Menage <menage@google.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] set_mempolicy(MPOL_INTERLEAV) cause kernel panic
In-Reply-To: <20090717095745.1d3039b1.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907170203330.13151@chino.kir.corp.google.com>
References: <1247679064.4089.26.camel@useless.americas.hpqcorp.net> <alpine.DEB.2.00.0907161257190.31844@chino.kir.corp.google.com> <20090717090003.A903.A69D9226@jp.fujitsu.com> <20090717095745.1d3039b1.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jul 2009, KAMEZAWA Hiroyuki wrote:

> IMHO, the application itseld should be notifed to change its mempolicy by
> hot-plug script on the host. While an application uses interleave, a new node
> hot-added is just a noise. I think "How pages are interleaved" should not be
> changed implicitly. Then, checking at set_mempolicy() seems sane. If notified,
> application can do page migration and rebuild his mapping in ideal way.
> 

Agreed, it doesn't seem helpful to add a node to MPOL_INTERLEAVE for 
memory hotplug; the same is probably true of MPOL_BIND as well since the 
application will never want to unknowingly expand its set of allowed 
nodes.  There's no case where MPOL_PREFERRED would want to implicitly 
switch to the added node.

I'm not convinced that we have to support hot-add in existing mempolicies 
at all.

> BUT I don't linke init->mem_allowed contains N_POSSIBLE...it should be initialized
> to N_HIGH_MEMORY, IMHO.
> 

It doesn't matter for the page allocator since zonelists will never 
include zones from nodes that aren't online, so the underlying bug here 
does seem to be the behavior of ->mems_allowed and we're probably only 
triggering it by mempolicies.  cpuset_track_online_nodes() should be 
keeping top_cpuset's mems_allowed consistent with N_HIGH_MEMORY and all 
descendents must have a subset of top_cpuset's nodes, though.
