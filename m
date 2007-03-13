Return-Path: <linux-kernel-owner+w=401wt.eu-S1030268AbXCMMCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030268AbXCMMCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 08:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030265AbXCMMCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 08:02:40 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:34670 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030268AbXCMMCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 08:02:39 -0400
From: Eric Dumazet <dada1@cosmosbay.com>
To: Andrea Arcangeli <andrea@suse.de>
Subject: Re: SMP performance degradation with sysbench
Date: Tue, 13 Mar 2007 13:02:44 +0100
User-Agent: KMail/1.9.5
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Anton Blanchard <anton@samba.org>,
       Rik van Riel <riel@redhat.com>,
       Lorenzo Allegrucci <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
References: <45E21FEC.9060605@redhat.com> <45F68713.9040608@yahoo.com.au> <20070313114215.GI8992@v2.random>
In-Reply-To: <20070313114215.GI8992@v2.random>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703131302.45216.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 March 2007 12:42, Andrea Arcangeli wrote:

> My wild guess is that they're allocating memory after taking
> futexes. If they do, something like this will happen:
>
>      taskA		taskB		taskC
>      user lock
> 			mmap_sem lock
>      mmap sem -> schedule
> 					user lock -> schedule
>
> If taskB wouldn't be there triggering more random trashing over the
> mmap_sem, the lock holder wouldn't wait and task C wouldn't wait too.
>
> I suspect the real fix is not to allocate memory or to run other
> expensive syscalls that can block inside the futex critical sections...

glibc malloc uses arenas, and trylock() only. It should not block because if 
an arena is already locked, thread automatically chose another arena, and 
might create a new one if necessary.

But yes, mmap_sem contention is a big problem, because it's also taken by 
futex code (unfortunately)

