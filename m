Return-Path: <linux-kernel-owner+w=401wt.eu-S1763627AbZEAVsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763627AbZEAVsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 17:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760266AbZEAVsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 17:48:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34046 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbZEAVsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 17:48:10 -0400
Message-ID: <49FB6DC3.3090000@redhat.com>
Date: Fri, 01 May 2009 17:46:43 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: elladan@eskimo.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
       tytso@mit.edu, kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org
Subject: Re: [PATCH] vmscan: evict use-once pages first (v2)
References: <20090428044426.GA5035@eskimo.com>	<20090428192907.556f3a34@bree.surriel.com>	<1240987349.4512.18.camel@laptop>	<20090429114708.66114c03@cuia.bos.redhat.com>	<20090430072057.GA4663@eskimo.com>	<20090430174536.d0f438dd.akpm@linux-foundation.org>	<20090430205936.0f8b29fc@riellaptop.surriel.com>	<20090430181340.6f07421d.akpm@linux-foundation.org>	<20090430215034.4748e615@riellaptop.surriel.com>	<20090430195439.e02edc26.akpm@linux-foundation.org>	<49FB01C1.6050204@redhat.com>	<20090501123541.7983a8ae.akpm@linux-foundation.org>	<49FB5623.3030403@redhat.com> <20090501134528.be5f27b2.akpm@linux-foundation.org>
In-Reply-To: <20090501134528.be5f27b2.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 01 May 2009 16:05:55 -0400
> Rik van Riel <riel@redhat.com> wrote:
> 
>> Are you open to evaluating other methods that could lead, on
>> desktop systems, to a behaviour similar to the one achieved
>> by the preserve-mapped-pages mechanism?
> 
> Well..  it's more a matter of retaining what we've learnt (unless we
> feel it's wrong, or technilogy change broke it) and carefully listening
> to and responding to what's happening in out-there land.

Treating mapped pages specially is a bad implementation,
because it does not scale.  The reason is the same reason
we dropped "treat referenced active file pages special"
right before the split LRU code was merged by Linus.

Also, it does not help workloads that have a large number
of unmapped pages, where we want to protect the frequently
used ones from a giant stream of used-once pages.  NFS and
FTP servers would be a typical example of this, but so
would a database server with postgres or mysql in a default
setup.

> The number of problem reports we're seeing from the LRU changes is
> pretty low.  Hopefully that's because the number of problems _is_
> low.

I believe the number of problems is low.  However, the
severity of this particular problem means that we'll
probably want to do something about it.

> Given the low level of problem reports, the relative immaturity of the
> code and our difficulty with determining what effect our changes will
> have upon everyone, I'd have thought that sit-tight-and-wait-and-see
> would be the prudent approach for the next few months.
> 
> otoh if you have a change and it proves good in your testing then sure,
> sooner rather than later.

I believe the patch I submitted in this thread should fix
the problem.  I have experimented with the patch before
and Elladan's results show that the situation is resolved
for him.

Furthermore, Peter and I believe the patch has a minimal
risk of side effects.

Of course, there may be better ideas yet.  It would be
nice if people could try to shoot holes in the concept
of the patch - if anybody can even think of a way in
which it could break, we can try to come up with a way
of fixing it.

> I still haven't forgotten prev_priority tho!

The whole priority thing could be(come) a problem too,
with us scanning WAY too many pages at once in a gigantic
memory zone.  Scanning a million pages at once will
probably lead to unacceptable latencies somewhere :)

-- 
All rights reversed.
