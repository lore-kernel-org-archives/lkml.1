Return-Path: <linux-kernel-owner+w=401wt.eu-S1752918AbZK0S0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbZK0S0l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 13:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbZK0S0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 13:26:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbZK0S0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 13:26:40 -0500
Date: Fri, 27 Nov 2009 19:26:07 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, vedran.furac@gmail.com,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] oom_kill: use rss value instead of vm size for badness
Message-ID: <20091127182607.GA30235@random.random>
References: <20091028175846.49a1d29c.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.2.00.0910280206430.7122@chino.kir.corp.google.com>
 <abbed627532b26d8d96990e2f95c02fc.squirrel@webmail-b.css.fujitsu.com>
 <20091029100042.973328d3.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.2.00.0910290125390.11476@chino.kir.corp.google.com>
 <20091125124433.GB27615@random.random>
 <alpine.DEB.2.00.0911251334020.8191@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0911251334020.8191@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 01:39:59PM -0800, David Rientjes wrote:
> adjust that heuristic.  That has traditionally always used total_vm as a 
> baseline which is a much more static value and can be quantified within a 
> reasonable range by experimental data when it would not be defined as 
> rogue.  By changing the baseline to rss, we lose much of that control 
> since its more dynamic and dependent on the current state of the machine 
> at the time of the oom which can be predicted with less accuracy.

Ok I can see the fact by being dynamic and less predictable worries
you. The "second to last" tasks especially are going to be less
predictable, but the memory hog would normally end up accounting for
most of the memory and this should increase the badness delta between
the offending tasks (or tasks) and the innocent stuff, so making it
more reliable. The innocent stuff should be more and more paged out
from ram. So I tend to think it'll be much less likely to kill an
innocent task this way (as demonstrated in practice by your
measurement too), but it's true there's no guarantee it'll always do
the right thing, because it's a heuristic anyway, but even total_vm
doesn't provide guarantee unless your workload is stationary and your
badness scores are fixed and no virtual memory is ever allocated by
any task in the system and no new task are spawned.

It'd help if you posted a regression showing smaller delta between
oom-target task and second task. My email was just to point out, your
measurement was a good thing in oom killing terms. If I've to imagine
the worst case for this, is an app allocating memory at very low
peace, and then slowly getting swapped out and taking huge swap
size. Maybe we need to add swap size to rss, dunno, but the paged out
MAP_SHARED equivalent can't be accounted like we can account swap
size, so in practice I feel a raw rss is going to be more practical
than making swap special vs file mappings.
