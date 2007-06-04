Return-Path: <linux-kernel-owner+w=401wt.eu-S1755606AbXFDNZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbXFDNZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 09:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbXFDNZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 09:25:43 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:44829 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbXFDNZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 09:25:42 -0400
Date: Mon, 4 Jun 2007 15:25:40 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 1/2] ufd v1 - unsequential O(1) fdmap core
Message-Id: <20070604152540.985c186a.dada1@cosmosbay.com>
In-Reply-To: <Pine.LNX.4.64.0706040523150.30231@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.24319.1180825145.1>
	<46633047.1020707@cosmosbay.com>
	<Pine.LNX.4.64.0706031536000.13247@alien.or.mcafeemobile.com>
	<20070603230859.5000424d.akpm@linux-foundation.org>
	<20070604080537.GA22898@elte.hu>
	<20070604080941.GA23537@elte.hu>
	<20070604013449.ea3acca8.akpm@linux-foundation.org>
	<20070604122857.1399e3fc.dada1@cosmosbay.com>
	<Pine.LNX.4.64.0706040523150.30231@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007 05:55:42 -0700 (PDT)
Davide Libenzi <davidel@xmailserver.org> wrote:

> On Mon, 4 Jun 2007, Eric Dumazet wrote:
> 
> > Goals :
> > 1) libc wants 'private fds'
> > 2) Latencies of get_unused_fd() for huge processes (more than 100.000 file handles)
> > 
> > Point 1) can use a top-down allocation, or use a 'last unused' index.
> > 
> > 
> > Point 2) Instead of introducing a *complex* layer, couldnt we improve existing one ?
> 
> Complex layer?! It's an array with free slots chained by a double linked 
> list.
> 
> 
> > If the main problem we want to solve is the potentially slow bitmap 
> > search, 
> > we could logically divide the open_fds bitmap into pages (4096*8 = 32768 
> > bits per page on i386/x86_64 arches)
> > 
> > We would have to add a new field in 'struct fdtable', pointer to an 
> > array of u32 counters, that would count the number of 'one' bits in each 
> > PAGE. This array is tiny : 128 bytes only for 1.000.000 file handles
> > 
> > get_unused_fd() could then use this array to select an appropriate page 
> > (a page known to have at least one zero bit), then do a 
> > find_next_zero_bit() restricted to at most PAGE_SIZE bytes. Max latency 
> > would be similar to vm one when clearing a page. If applications use 
> > Point 1) hint (asking kernel one fd, not the POSIX low fd), typical 
> > latency will be null.
> 
> And look at what you're describing here, talking about simplicity. You'd 
> still need two bitmaps, so you'd still need the out-of-fdmap.c/h code. 
> You're trying to fit an horse-shoe to a deer :)
> The most appropriate structure for this, is an array (O(1) lookup) with 
> free elements chained by a dbl linked list (O(1) alloc and free). Plus, 
> the extra pointer can nicely fit other per-allocated-fd flags w/out adding 
> extra custom flags bitmaps to the fdtable.
> 

Bitmaps are already there, you didnt zap them.

Your proposal is going to double size taken by file table, since you need two long words
per file instead of one pointer.

You add conditional branches on very hot spots.

When you open/close a file, you need to access previous and next cells, so you need 3 cache lines, exactly like
current *legacy* code. (one for file pointer, one on each bitmap flags(open/close_on_exec) )

O(1) lookup doesnt imply it needs to be super-fast. You make a confusion about this.

O(128) is still O(1) for instance. Having to search a bit in a PAGE is a sensible compromise, if we dont add overhead
on each fget() calls.

Instead of adding complexity and a pile of new bugs  (see how long it takes to bring RCU on files to a stable state), we can take a safe path. Then if it happens to still be a problem, we can consider the painfull way.

I probably can code a < 100 lines patch, later this evening after my day job.

