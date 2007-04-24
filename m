Return-Path: <linux-kernel-owner+w=401wt.eu-S1030573AbXDXMsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030573AbXDXMsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 08:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031071AbXDXMsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 08:48:36 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:55900 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030573AbXDXMsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 08:48:35 -0400
Date: Tue, 24 Apr 2007 14:48:27 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Alex Vorona <voron@amhost.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Re[2]: sendfile to nonblocking socket
Message-Id: <20070424144827.fdac3bb4.dada1@cosmosbay.com>
In-Reply-To: <1211570752.20070424143348@amhost.net>
References: <462D8D92.9050301@amhost.net>
	<MDEHLPKNGKAHNMBLJOLKIEDFDEAC.davids@webmaster.com>
	<1211570752.20070424143348@amhost.net>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 14:33:48 +0400
Alex Vorona <voron@amhost.net> wrote:

> Hello David,
> 
> Tuesday, April 24, 2007, 1:19:49 PM, you wrote:
> 
> >> sendfile function is not just a more efficient version of a read 
> >> followed by a write.  It reads from one fd and write to another at tha
> >> same time. Please try to read 2G, and then write 2G - and how much 
> >> memory you will be need and how much time you will loose while reading
> >> 2G from disk, but not writing them to socket.
> 
> DS> You are correct. What I meant to say was that it's just a
> DS> more efficient version of 'mmap'ing a file and then 'write'ing
> DS> from the 'mmap'. The 'write' to a non-blocking socket can still
> DS> 'block' on disk I/O.
> 
> How can I avoid that blocking? Or maybe another question - how can I
> deliver data from disk to network with minimal copy operations, etc.
> 

I believe the modern way would be to use splice() system call :

loop
 splice(from disk , to pipe) with SPLICE_F_NONBLOCK
 wait_event_from_epoll (pipe ready for reading)
 splice(from pipe, to socket)
 wait_event_from_epoll (socket ready for writing)

But :

1) I am not sure epoll can get an event when page(s) is/are ready in pipe (ie disk delivered the page(s) to cache)
2) I am not sure splice() to socket is actually implemented with 0-copy
3) I am not sure pipe capacity (16 pages) would be enough to get a good readahead.

Eric



