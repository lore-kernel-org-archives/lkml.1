Return-Path: <linux-kernel-owner+w=401wt.eu-S1759318AbXFGNMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbXFGNMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 09:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbXFGNMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 09:12:46 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:41268 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbXFGNMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 09:12:45 -0400
Date: Thu, 7 Jun 2007 15:12:43 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Kyle Moffett <mrmacman_g4@mac.com>,
       Davide Libenzi <davidel@xmailserver.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-Id: <20070607151243.22caab9e.dada1@cosmosbay.com>
In-Reply-To: <B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
	<20070606235906.72439d16@the-village.bc.nu>
	<Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com>
	<20070607001932.35c9591c@the-village.bc.nu>
	<466741BD.20106@redhat.com>
	<20070607110432.73be7960@the-village.bc.nu>
	<B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 07:59:47 -0400
Kyle Moffett <mrmacman_g4@mac.com> wrote:


> Likewise there are a massive group of other libraries (especially  
> user-interface and server related ones) that would really like to  
> have support for creating file-descriptors without the top-level  
> application closing them randomly (like several shells seem to).
> 

True, shells are sometimes quite strange.

For example, bash uses file descriptor 255 (FD_CLOEXEC)

When it forks a new process, child gets a file table with 256 slots.

At exec() time, 255 is closed but file table doesnt shrink.
(shrinking is done at fork() time only)

With fdmap, that means each process started by bash uses at least 
256 * sizeof(list_head) bytes, ie 4096 bytes on x86_64, even if only three 
file-descriptors are opened (0,1,2)

FD_CLOFORK should help here (BTW : current patch from Davide doesnt take this
into account and might need a change in fdmap_top_open_fd())

Davide, are you sure we want FIFO for non sequential allocations ?

This tends to use all the fmap slots, and not very cache friendly
if an app does a lot of [open(),...,close()] things. We already got a 
perf drop because of RCUification of file freeing (FIFO mode instead 
of LIFO given by kmalloc()/kfree())

If the idea behind this FIFO was security (ie not easy for an app to predict 
next glibc file handle), we/glibc might use yet another FD_SECUREMODE flag, 
wich ORed with O_NONSEQFD would ask to fdmap_newfd() to take the tail of 
fmap->slist, not head.

