Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbXFDMz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbXFDMz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 08:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbXFDMzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 08:55:48 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4014 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbXFDMzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 08:55:47 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 4 Jun 2007 05:55:42 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 1/2] ufd v1 - unsequential O(1) fdmap core
In-Reply-To: <20070604122857.1399e3fc.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0706040523150.30231@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.24319.1180825145.1>
 <46633047.1020707@cosmosbay.com> <Pine.LNX.4.64.0706031536000.13247@alien.or.mcafeemobile.com>
 <20070603230859.5000424d.akpm@linux-foundation.org> <20070604080537.GA22898@elte.hu>
 <20070604080941.GA23537@elte.hu> <20070604013449.ea3acca8.akpm@linux-foundation.org>
 <20070604122857.1399e3fc.dada1@cosmosbay.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007, Eric Dumazet wrote:

> Goals :
> 1) libc wants 'private fds'
> 2) Latencies of get_unused_fd() for huge processes (more than 100.000 file handles)
> 
> Point 1) can use a top-down allocation, or use a 'last unused' index.
> 
> 
> Point 2) Instead of introducing a *complex* layer, couldnt we improve existing one ?

Complex layer?! It's an array with free slots chained by a double linked 
list.


> If the main problem we want to solve is the potentially slow bitmap 
> search, 
> we could logically divide the open_fds bitmap into pages (4096*8 = 32768 
> bits per page on i386/x86_64 arches)
> 
> We would have to add a new field in 'struct fdtable', pointer to an 
> array of u32 counters, that would count the number of 'one' bits in each 
> PAGE. This array is tiny : 128 bytes only for 1.000.000 file handles
> 
> get_unused_fd() could then use this array to select an appropriate page 
> (a page known to have at least one zero bit), then do a 
> find_next_zero_bit() restricted to at most PAGE_SIZE bytes. Max latency 
> would be similar to vm one when clearing a page. If applications use 
> Point 1) hint (asking kernel one fd, not the POSIX low fd), typical 
> latency will be null.

And look at what you're describing here, talking about simplicity. You'd 
still need two bitmaps, so you'd still need the out-of-fdmap.c/h code. 
You're trying to fit an horse-shoe to a deer :)
The most appropriate structure for this, is an array (O(1) lookup) with 
free elements chained by a dbl linked list (O(1) alloc and free). Plus, 
the extra pointer can nicely fit other per-allocated-fd flags w/out adding 
extra custom flags bitmaps to the fdtable.



- Davide


