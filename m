Return-Path: <linux-kernel-owner+w=401wt.eu-S1758172AbXFGKjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbXFGKjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 06:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbXFGKjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 06:39:40 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:38846 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbXFGKjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 06:39:39 -0400
Date: Thu, 7 Jun 2007 12:39:37 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-Id: <20070607123937.db4a9f30.dada1@cosmosbay.com>
In-Reply-To: <Pine.LNX.4.64.0706070004470.4875@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169031.1>
	<4667AB97.8090603@cosmosbay.com>
	<Pine.LNX.4.64.0706070004470.4875@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi <davidel@xmailserver.org> wrote:

> The sys_accept() system call has been modified to return a file
> descriptor inside the non-sequential area, if the listening fd is.

> -   newfd = sock_alloc_fd(&newfile);
> +   newfd = sock_alloc_fd(&newfile,
> +         fd > current->signal->rlim[RLIMIT_NOFILE].rlim_cur ? O_NONSEQFD: 0);

This will break apps that change/downgrade their rlimit (after getting a high fd listen socket)
Yes probably insane, but who knows...

sock = socket(...);
bind(...);
listen(sock, backlog); ...
fd = dup2(sock, 1023);
close(sock);

setrlimit( RLIMIT_NOFILE, rlim.rlim_cur = 256);
...
while ((newsock = accept(fd, ...)) != -1) {
     fork();...
     Plain legacy code, expecting newsock being *small*
     FD_SET(newsock , &rd_set);
     ...oops... fd is too large to fit in fd_set
     select(newsock + 1, &rd_set, ...);
     }


So you might change logic to straight :

newfd = sock_alloc_fd(&newfile, (fd >= FDMAP_NONSEQ_BASE) ? O_NONSEQFD: 0);

