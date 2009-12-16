Return-Path: <linux-kernel-owner+w=401wt.eu-S1763130AbZLPXCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763130AbZLPXCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 18:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763179AbZLPXCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 18:02:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:41369 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964874AbZLPXC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 18:02:26 -0500
Subject: Re: [mm][RFC][PATCH 0/11] mm accessor updates.
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>, minchan.kim@gmail.com
In-Reply-To: <alpine.DEB.2.00.0912161025290.8572@router.home>
References: <20091216120011.3eecfe79.kamezawa.hiroyu@jp.fujitsu.com>
	 <20091216101107.GA15031@basil.fritz.box>
	 <20091216191312.f4655dac.kamezawa.hiroyu@jp.fujitsu.com>
	 <20091216102806.GC15031@basil.fritz.box>
	 <20091216193109.778b881b.kamezawa.hiroyu@jp.fujitsu.com>
	 <20091216104951.GD15031@basil.fritz.box>
	 <20091216201218.42ff7f05.kamezawa.hiroyu@jp.fujitsu.com>
	 <20091216113158.GE15031@basil.fritz.box>
	 <alpine.DEB.2.00.0912161025290.8572@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Dec 2009 00:01:55 +0100
Message-ID: <1261004515.21028.510.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 10:27 -0600, Christoph Lameter wrote:
> On Wed, 16 Dec 2009, Andi Kleen wrote:
> 
> > > Do you have alternative recommendation rather than wrapping all accesses by
> > > special functions ?
> >
> > Work out what changes need to be done for ranged mmap locks and do them all
> > in one pass.
> 
> Locking ranges is already possible through the split ptlock and
> could be enhanced through placing locks in the vma structures.
> 
> That does nothing solve the basic locking issues of mmap_sem. We need
> Kame-sans abstraction layer. A vma based lock or a ptlock still needs to
> ensure that the mm struct does not vanish while the lock is held.

It should, you shouldn't be able to remove a mm while there's still
vma's around, and you shouldn't be able to remove a vma when there's
still pagetables around. And if you rcu-free all of them you're stable
enough for lots of speculative behaviour.

No need to retain mmap_sem for any of that.

As for per-vma locks, those are pretty much useless too, there's plenty
applications doing lots of work on a few very large vmas.

