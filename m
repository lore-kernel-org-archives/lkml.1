Return-Path: <linux-kernel-owner+w=401wt.eu-S1759769AbXHaPJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759769AbXHaPJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 11:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755638AbXHaPJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 11:09:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56979 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506AbXHaPJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 11:09:25 -0400
Subject: Re: [PATCH] Increase lockdep MAX_LOCK_DEPTH
From: Peter Zijlstra <peterz@infradead.org>
To: David Chinner <dgc@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs-oss <xfs@oss.sgi.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070831150511.GA734179@sgi.com>
References: <46D79C62.1010304@sandeen.net> <1188542389.6112.44.camel@twins>
	 <20070831135042.GD422459@sgi.com> <1188570831.6112.64.camel@twins>
	 <20070831150511.GA734179@sgi.com>
Content-Type: text/plain
Date: Fri, 31 Aug 2007 17:09:21 +0200
Message-Id: <1188572961.6112.72.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-01 at 01:05 +1000, David Chinner wrote:

> > Trouble is, we'd like to have a sane upper bound on the amount of held
> > locks at any one time, obviously this is just wanting, because a lot of
> > lock chains also depend on the number of online cpus...
> 
> Sure - this is an obvious case where it is valid to take >30 locks at
> once in a single thread. In fact, worst case here we are taking twice this
> number of locks - we actually take 2 per inode (ilock and flock) so a
> full 32 inode cluster free would take >60 locks in the middle of this
> function and we should be busting this depth couter limit all the
> time. 

I think this started because jeffpc couldn't boot without XFS busting
lockdep :-)

> Do semaphores (the flush locks) contribute to the lock depth
> counters? 

No, alas, we cannot handle semaphores in lockdep. Semaphores don't have
a strict owner, hence we cannot track them. This is one of the reasons
to rid ourselves of semaphores - that and there are very few cases where
the actual semantics of semaphores are needed. Most of the times code
using semaphores can be expressed with either a mutex or a completion.

