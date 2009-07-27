Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbZG0R4C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbZG0R4C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 13:56:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbZG0R4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 13:56:01 -0400
Received: from smtp-out.google.com ([216.239.33.17]:11958 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbZG0Rz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 13:55:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=nnLBjg9jRNdzjx7FDgIewfIWHWFY6toCAl+qK7vByaoNgTk+EHRC2KpIaiaCQfDD9
	wkIRyAKb6njBUmGe3LOsQ==
Date: Mon, 27 Jul 2009 10:55:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, miaox@cn.fujitsu.com,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Paul Menage <menage@google.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       y-goto@jp.fujitsu.com, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] set_mempolicy(MPOL_INTERLEAV) cause kernel panic
In-Reply-To: <9443f91bd4648e6214b32acff4512b97.squirrel@webmail-b.css.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907271047590.8408@chino.kir.corp.google.com>
References: <20090715182320.39B5.A69D9226@jp.fujitsu.com> <1247679064.4089.26.camel@useless.americas.hpqcorp.net> <alpine.DEB.2.00.0907161257190.31844@chino.kir.corp.google.com> <alpine.DEB.2.00.0907241551070.8573@chino.kir.corp.google.com>
 <20090724160936.a3b8ad29.akpm@linux-foundation.org> <337c5d83954b38b14a17f0adf4d357d8.squirrel@webmail-b.css.fujitsu.com> <5bb65c0e4c6828b1331d33745f34d9ee.squirrel@webmail-b.css.fujitsu.com>
 <9443f91bd4648e6214b32acff4512b97.squirrel@webmail-b.css.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Jul 2009, KAMEZAWA Hiroyuki wrote:

> _Direct_ use of task->mems_allowed is only in cpuset and mempolicy.
> If no policy is used, it's not checked.
> (See alloc_pages_current())
> 
> memory hotplug's notifier just updates top_cpuset's mems_allowed.
> But it doesn't update each task's ones.

That's not true, cpuset_track_online_nodes() will call 
scan_for_empty_cpusets() on top_cpuset, which works from the root to 
leaves updating each cpuset's mems_allowed by intersecting it with 
node_states[N_HIGH_MEMORY].  This is done as part of the MEM_OFFLINE 
callback in the cpuset code, so N_HIGH_MEMORY represents the nodes still 
online.

The nodemask for each task is updated to reflect the removal of a node and 
it calls mpol_rebind_mm() with the new nodemask.

This is admittedly pretty late to be removing mems from cpusets (and 
mempolicies) when the unplug has already happened.  We should look at 
doing the rebind for MEM_GOING_OFFLINE.
