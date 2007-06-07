Return-Path: <linux-kernel-owner+w=401wt.eu-S1764757AbXFGPmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764757AbXFGPmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757898AbXFGPmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:42:32 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2431 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbXFGPmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:42:31 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 7 Jun 2007 08:42:29 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <20070607123937.db4a9f30.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0706070842010.6059@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169031.1>
 <4667AB97.8090603@cosmosbay.com> <Pine.LNX.4.64.0706070004470.4875@alien.or.mcafeemobile.com>
 <20070607123937.db4a9f30.dada1@cosmosbay.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007, Eric Dumazet wrote:

> Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > The sys_accept() system call has been modified to return a file
> > descriptor inside the non-sequential area, if the listening fd is.
> 
> > -   newfd = sock_alloc_fd(&newfile);
> > +   newfd = sock_alloc_fd(&newfile,
> > +         fd > current->signal->rlim[RLIMIT_NOFILE].rlim_cur ? O_NONSEQFD: 0);
> 
> This will break apps that change/downgrade their rlimit (after getting a high fd listen socket)
> Yes probably insane, but who knows...
> 
> sock = socket(...);
> bind(...);
> listen(sock, backlog); ...
> fd = dup2(sock, 1023);
> close(sock);
> 
> setrlimit( RLIMIT_NOFILE, rlim.rlim_cur = 256);
> ...
> while ((newsock = accept(fd, ...)) != -1) {
>      fork();...
>      Plain legacy code, expecting newsock being *small*
>      FD_SET(newsock , &rd_set);
>      ...oops... fd is too large to fit in fd_set
>      select(newsock + 1, &rd_set, ...);
>      }
> 
> 
> So you might change logic to straight :
> 
> newfd = sock_alloc_fd(&newfile, (fd >= FDMAP_NONSEQ_BASE) ? O_NONSEQFD: 0);

Yes, that makes perfectly sense to me.


- Davide


