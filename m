Return-Path: <linux-kernel-owner+w=401wt.eu-S1757598AbZGFJDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbZGFJDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 05:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171AbZGFJDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 05:03:43 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:33263 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbZGFJDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 05:03:42 -0400
Message-ID: <4A51BD2C.7010105@gmail.com>
Date: Mon, 06 Jul 2009 11:00:28 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Linda Walsh <lkml@tlinx.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: pipe(2), read/write, maximums and behavior.
References: <4A51B127.8080807@tlinx.org>
In-Reply-To: <4A51B127.8080807@tlinx.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 06 Jul 2009 11:00:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linda Walsh a écrit :
> I've seen a few shells claim to limit pipe sizes to 8 512Byte buffers.
> Don't know where they get this value or how they think it applies, but
> it certainly doesn't seem to apply in linux.   However, I'm not
> sure what limits do apply compared to available memory.
> I suppose, starting off, one might look at at a maximum of
> (Physical+Swap-resident-non-swappable mem)/2 as a top limit.
> 
> A test machine I have has 8GB physical memory with a bit over 4GB
> of swap space making for about 12GB of memory.
> 
> If total memory was to go toward my proglet that splits into a master
> writer and slave pipe reader, they'd have to split memory to have
> matching buffer read/write sizes. I'd "expect", (I think) at least
> a 2GB write/read to work, and possibly a 4GB write/read to work
> with alot of swap activity -- that's assuming there are no other
> restraints in dividing 12GB of address space.
> 
> As it turns out -- the program dies at 2GB (the 1GB write/read works)
> but when the program tries a 2GB write & read it refuses the full write
> and the child gets less than 2GB.
> 
> The master gets back that it wrote 2097148KB, though it tried to
> write 2097152KB (and the child receives the 2GB-4K buffer upon read).
> 
> This is on a x86_64 machine, and unsigned long values are 8-bytes
> wide and being used with the read and write calls for lengths.
> 
> Shouldn't a 2GB read/write work?  At most, together the master
> and slave would have only used 4GB for each to have a 2GB buffer.
> 
> How would one determine the maximum size for 1 huge read or write
> through the pipe (from the pipe system call)?
> 
> On 2GHz multi-core machines, I get about 512MB/s throughput.
> 
> I attached the source file so anyone can see my methodology.
> 
> you have to include "-lrt" on the gcc command line as it uses
> clock_gettime to estimate the time for the write call (the read
> call always comes back with values too small to be reasonable, so
> I don't bother printing them.
> 
> 
> 

read()/write() system calls use generic vfs_read()/vfs_write() calls,
that in turn use rw_verify_area() which limits 'count' of bytes
to MAX_RW_COUNT

#define MAX_RW_COUNT (INT_MAX & PAGE_CACHE_MASK)

So yes, this currently limits to 2GB - (PAGE_SIZE)  (PAGE_SIZE=4KB on i386),
even on x86_64 kernels.

