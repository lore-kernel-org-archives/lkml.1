Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727Ab0AFDUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab0AFDUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 22:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549Ab0AFDUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 22:20:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:59460 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab0AFDUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 22:20:24 -0500
Date: Tue, 5 Jan 2010 19:22:43 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
Message-ID: <20100105192243.1d6b2213@infradead.org>
In-Reply-To: <alpine.DEB.2.00.1001050916300.1074@router.home>
References: <20100104182429.833180340@chello.nl>
	<20100104182813.753545361@chello.nl>
	<20100105054536.44bf8002@infradead.org>
	<alpine.DEB.2.00.1001050916300.1074@router.home>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010 09:17:11 -0600 (CST)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Tue, 5 Jan 2010, Arjan van de Ven wrote:
> 
> > while I appreciate the goal of reducing contention on this lock...
> > wouldn't step one be to remove the page zeroing from under this
> > lock? that's by far (easily by 10x I would guess) the most
> > expensive thing that's done under the lock, and I would expect a
> > first order of contention reduction just by having the zeroing of a
> > page not done under the lock...
> 
> The main issue is cacheline bouncing. mmap sem is a rw semaphore and
> only held for read during a fault.

depends on the workload; on a many-threads-java workload, you also get
it for write quite a bit (lots of malloc/frees in userspace in addition
to pagefaults).. at which point you do end up serializing on the
zeroing.

There's some real life real big workloads that show this pretty badly;
so far the workaround is to have glibc batch up a lot of the free()s..
but that's just pushing it a little further out.

> 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
