Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab0BQSRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 13:17:10 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:35552 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab0BQSRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 13:17:08 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 17 Feb 2010 10:16:57 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: THIELL Stephane <stephane.thiell@cea.fr>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch/rfc] Make poll/select report error (POLLNVAL and EBADF)
 for unsupported files
In-Reply-To: <4B7C25B3.5010206@cea.fr>
Message-ID: <alpine.DEB.2.00.1002171006310.19489@makko.or.mcafeemobile.com>
References: <alpine.DEB.2.00.1002141403240.18795@makko.or.mcafeemobile.com> <1266255759.8262.26.camel@edumazet-laptop> <alpine.DEB.2.00.1002150945460.7390@makko.or.mcafeemobile.com> <4B7C25B3.5010206@cea.fr>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Feb 2010, THIELL Stephane wrote:

> 
> > On Mon, 15 Feb 2010, Eric Dumazet wrote:
> > 
> >   
> > > Hmm, according to POSIX :
> > > 
> > > 	The poll() function shall support regular files, terminal and
> > > pseudo-terminal devices, FIFOs, pipes, sockets ...
> > > 
> > > 	Regular files shall always poll TRUE for reading and writing.
> > > 
> > >     
> As POSIX says poll(2) have to support regular files (and it seems all possible
> user file descriptors), then wouldn't it be better/more coherent to have
> epoll(7) behave the same way (ie. support regular files instead of
> epoll_ctl(2) returning EPERM), in order to allow generic code handling both
> very common situations like:
> 
> $ cat replay_file | application
> and
> $ application < replay_file
> 
> ...where for instance the application doesn't know the origine of its fd 0
> (pipe, file, or something else).

Most definitely no. POSIX behavior is just stupid, and should have been 
implemented by not having to report things/events that are not true.
Now, that's POSIX, and we cannot break its APIs.
New ones though, do not need to be necessarily stupid.
Besides, epoll needs an f_op->poll to work, and this would require all FS 
files to implement a bogus f_op->poll which simply returns the full event 
mask.
Which is just plain silly.
For things like epoll ET, this will simply not work, and even for LT, 
you'd get every time out of epoll_wait() because you have something there 
that always reports every event you ask, even though it is not true.


- Davide


