Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187AbXFDK3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbXFDK3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 06:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbXFDK3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 06:29:00 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:43091 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbXFDK27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 06:28:59 -0400
Date: Mon, 4 Jun 2007 12:28:57 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 1/2] ufd v1 - unsequential O(1) fdmap core
Message-Id: <20070604122857.1399e3fc.dada1@cosmosbay.com>
In-Reply-To: <20070604013449.ea3acca8.akpm@linux-foundation.org>
References: <send-serie.davidel@xmailserver.org.24319.1180825145.1>
	<46633047.1020707@cosmosbay.com>
	<Pine.LNX.4.64.0706031536000.13247@alien.or.mcafeemobile.com>
	<20070603230859.5000424d.akpm@linux-foundation.org>
	<20070604080537.GA22898@elte.hu>
	<20070604080941.GA23537@elte.hu>
	<20070604013449.ea3acca8.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007 01:34:49 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 4 Jun 2007 10:09:41 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > i think this sums it up:
> > > 
> > >  http://www.uwsg.iu.edu/hypermail/linux/kernel/0705.3/2490.html
> > 
> > i mean this mail started it:
> > 
> >   http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-05/msg13070.html
> > 
> > > and some more, with a benchmark as well:
> > > 
> > >  http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-05/msg13685.html
> > 
> 
> Yeah, I remember all that but I don't think it provides a suitable
> description of what all this code is there for - what problem it is
> solving and how it solves it.
> 
> If we just want some pseudo-private fd space for glibc to use then I'd have
> thought that the existing code could be tweaked to do that: top-down
> allocation, start at some high offset, etc.  But apparently there's more
> to it than this.

Goals :
1) libc wants 'private fds'
2) Latencies of get_unused_fd() for huge processes (more than 100.000 file handles)

Point 1) can use a top-down allocation, or use a 'last unused' index.


Point 2) Instead of introducing a *complex* layer, couldnt we improve existing one ?

If the main problem we want to solve is the potentially slow bitmap search, 
we could logically divide the open_fds bitmap into pages (4096*8 = 32768 bits per page on i386/x86_64 arches)

We would have to add a new field in 'struct fdtable', pointer to an array of u32 counters, that would count the number of 'one' bits in each PAGE. This array is tiny : 128 bytes only for 1.000.000 file handles

get_unused_fd() could then use this array to select an appropriate page (a page known to have at least one zero bit), then do a find_next_zero_bit() restricted to at most PAGE_SIZE bytes. Max latency would be similar to vm one when clearing a page. If applications use Point 1) hint (asking kernel one fd, not the POSIX low fd), typical latency will be null.

Old applications (still asking for POSIX "give me the lowest fd crap") would benefit from this, without recompilation or glibc change.

