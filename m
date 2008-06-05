Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbYFELxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbYFELxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 07:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755879AbYFELxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 07:53:23 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:37591 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755878AbYFELxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 07:53:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=m/7fepfkSLwb+XOxng1YXtwLwiR3vIHUR8qflGL51h16caf4Ky2wS2xoBcKXq+Zl6vLBauJYkxrhP5xnEezgwZiOzaDjCxs4oRdHLOpKfj5R9zypmcZRw4VEQgbpWjNqKn2llk1H+wa6yJP3pMR+KFTvmk9S1P/XgIs/jDKD/L4=  ;
X-YMail-OSG: 2WqP0fsVM1loKnjNfDAYL7HEOocasTJO74CzdlvnOu9Q8lYdrqRzkCdO_tQMIJCHYsbZPeQuVUHbJDcsZBqarJvRFOBNaYKMI3Cq0IMuDwlF9nlaXI4kiyWCJewyTkoS2hQ-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: npiggin@suse.de
Subject: Re: [patch 0/7] speculative page references, lockless pagecache, lockless gup
Date: Thu, 5 Jun 2008 21:53:11 +1000
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, paulus@samba.org
References: <20080605094300.295184000@nick.local0.net>
In-Reply-To: <20080605094300.295184000@nick.local0.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806052153.11841.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 June 2008 19:43, npiggin@suse.de wrote:
> Hi,
>
> I've decided to submit the speculative page references patch to get merged.
> I think I've now got enough reasons to get it merged. Well... I always
> thought I did, I just didn't think anyone else thought I did. If you know
> what I mean.
>
> cc'ing the powerpc guys specifically because everyone else who probably
> cares should be on linux-mm...
>
> So speculative page references are required to support lockless pagecache
> and lockless get_user_pages (on architectures that can't use the x86
> trick). Other uses for speculative page references could also pop up, it is
> a pretty useful concept. Doesn't need to be pagecache pages either.
>
> Anyway,
>
> lockless pagecache:
> - speeds up single threaded pagecache lookup operations significantly, by
>   avoiding atomic operations, memory barriers, and interrupts-off sections.
>   I just measured again on a few CPUs I have lying around here, and the
>   speedup is over 2x reduction in cycles on them all, closer to 3x in some
>   cases.
>
>    find_get_page takes:
>                 ppc970 (g5)     K10             P4 Nocona       Core2
>     vanilla     275 (cycles)    85              315             143
>     lockless    125             40              127             61
>
> - speeds up single threaded pagecache modification operations, by using
>   regular spinlocks rather than rwlocks and avoiding an atomic operation
>   on x86 for one. Also, most real paths which involve pagecache
> modification also involve pagecache lookups, so it is hard not to get a net
> speedup.
>
> - solves the rwlock starvation problem for pagecache operations. This is
>   being noticed on big SGI systems, but theoretically could happen on
>   relatively small systems (dozens of CPUs) due to the really nasty
>   writer starvation problem of rwlocks -- not even hardware fairness can
>   solve that.
>
> - improves pagecache scalability to operations on a single file. I
>   demonstrated page faults to a single file were improved in throughput
>   by 250x on a 64-way Altix several years ago. We now have systems with
>   thousands of CPUs in them.

Oh that's actually anothr thing I remember now that I posted the scalable
vmap code...

The lock I ended up hitting next in the XFS large directory workload that
improved so much with the vmap patches was tree_lock of the buffer cache.
So lockless pagecache gave a reasonable improvement there too IIRC :)
