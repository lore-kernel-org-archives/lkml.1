Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862AbZK3XJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbZK3XJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 18:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbZK3XJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 18:09:47 -0500
Received: from smtp-out.google.com ([216.239.33.17]:43076 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbZK3XJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 18:09:46 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=m/7d24A4USM7v8TA6StD5VsICylBtDvzOpNQDTNyVbusPuEoLPy9c6gVhMTJRVXh5
	4TXbUDNOVUsZ6k0QoITMw==
Date: Mon, 30 Nov 2009 15:09:44 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrea Arcangeli <aarcange@redhat.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, vedran.furac@gmail.com,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] oom_kill: use rss value instead of vm size for badness
In-Reply-To: <20091127182607.GA30235@random.random>
Message-ID: <alpine.DEB.2.00.0911301502160.12038@chino.kir.corp.google.com>
References: <20091028175846.49a1d29c.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0910280206430.7122@chino.kir.corp.google.com> <abbed627532b26d8d96990e2f95c02fc.squirrel@webmail-b.css.fujitsu.com> <20091029100042.973328d3.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.2.00.0910290125390.11476@chino.kir.corp.google.com> <20091125124433.GB27615@random.random> <alpine.DEB.2.00.0911251334020.8191@chino.kir.corp.google.com> <20091127182607.GA30235@random.random>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Nov 2009, Andrea Arcangeli wrote:

> Ok I can see the fact by being dynamic and less predictable worries
> you. The "second to last" tasks especially are going to be less
> predictable, but the memory hog would normally end up accounting for
> most of the memory and this should increase the badness delta between
> the offending tasks (or tasks) and the innocent stuff, so making it
> more reliable. The innocent stuff should be more and more paged out
> from ram. So I tend to think it'll be much less likely to kill an
> innocent task this way (as demonstrated in practice by your
> measurement too), but it's true there's no guarantee it'll always do
> the right thing, because it's a heuristic anyway, but even total_vm
> doesn't provide guarantee unless your workload is stationary and your
> badness scores are fixed and no virtual memory is ever allocated by
> any task in the system and no new task are spawned.
> 

The purpose of /proc/pid/oom_adj is not always to polarize the heuristic 
for the task it represents, it allows userspace to define when a task is 
rogue.  Working with total_vm as a baseline, it is simple to use the 
interface to tune the heuristic to prefer a certain task over another when 
its memory consumption goes beyond what is expected.  With this interface, 
I can easily define when an application should be oom killed because it is 
using far more memory than expected.  I can also disable oom killing 
completely for it, if necessary.  Unless you have a consistent baseline 
for all tasks, the adjustment wouldn't contextually make any sense.  Using 
rss does not allow users to statically define when a task is rogue and is 
dependent on the current state of memory at the time of oom.

I would support removing most of the other heuristics other than the 
baseline and the nodes intersection with mems_allowed to prefer tasks in 
the same cpuset, though, to make it easier to understand and tune.
