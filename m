Return-Path: <linux-kernel-owner+w=401wt.eu-S1755763Ab0A0BBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab0A0BBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 20:01:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755657Ab0A0BBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 20:01:37 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39978 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576Ab0A0BBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 20:01:35 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 27 Jan 2010 09:58:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, rientjes@google.com,
       minchan.kim@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] oom-kill: add lowmem usage aware oom kill handling
Message-Id: <20100127095812.d7493a8f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100126161952.ee267d1c.akpm@linux-foundation.org>
References: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com>
	<20100122152332.750f50d9.kamezawa.hiroyu@jp.fujitsu.com>
	<20100125151503.49060e74.kamezawa.hiroyu@jp.fujitsu.com>
	<20100126151202.75bd9347.akpm@linux-foundation.org>
	<20100127085355.f5306e78.kamezawa.hiroyu@jp.fujitsu.com>
	<20100126161952.ee267d1c.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jan 2010 16:19:52 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 27 Jan 2010 08:53:55 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > > Hardly anyone will know to enable
> > > it so the feature won't get much testing and this binary decision
> > > fractures the testing effort.  It would be much better if we can get
> > > everyone running the same code.  I mean, if there are certain workloads
> > > on certain machines with which the oom-killer doesn't behave correctly
> > > then fix it!
> > Yes, I think you're right. But "breaking current behaviro of our servers!"
> > arguments kills all proposal to this area and this oom-killer or vmscan is
> > a feature should be tested by real users. (I'll write fork-bomb detector
> > and RSS based OOM again.)
> 
> Well don't break their servers then ;)
> 
> What I'm not understanding is: why is it not possible to improve the
> behaviour on the affected machines without affecting the behaviour on
> other machines?
> 

Now, /proc/<pid>/oom_score and /proc/<pid>/oom_adj are used by servers.
After this patch, badness() returns different value based on given context.
Changing format of them was an idea, but, as David said, using "RSS" values
will show unstable oom_score. So, I didn't modify oom_score (for this time).

To be honest, all my work are for guys who don't tweak oom_adj based on oom_score.
IOW, this is for usual novice people. And I don't wan't to break servers which
depends on oom black magic currently supported.

It may be better to show lowmem_rss via /proc/<pid>/statm or somewhere. But
I didn't do that because usual people doesn't check that in periodic and
tweak oom_adj.

For my customers, I don't like oom black magic. I'd like to recommend to
use memcg, of course ;) But lowmem oom cannot be handled by memcg, well.
So I started from this. 


> What are these "servers" to which you refer?
Almost all servers/PCs/laptops which have multiple zones in memory layout.


> x86_32 servers, I assume
> - the patch shouldn't affect 64-bit machines.  Why don't they also want
> this treatment and in what way does the patch "break" them?

Ah, explanation was not enough.

This patch depends on mm-add-lowmem-detection-logic.patch
The lowmem is
   - ZONE_NORMAL in x86-32 which has HIGHMEM
   - ZONE_DMA32  in x86-64 which has ZONE_NORMAL
   - ZONE_DMA    in x86-64 which doesn't have ZONE_NORMAL(memory < 4G)
   - ZONE_DMA    in ia64 which has ZONE_NORMAL(memory > 4G)
   - no zone     in ppc. all zone are DMA. (lowmem_zone=-1)

So, this affects x86-64 hosts, especially when it has 4 Gbytes of memory
and 32bit pci cards.

Thanks,
-Kame














