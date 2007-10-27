Return-Path: <linux-kernel-owner+w=401wt.eu-S1756833AbXJ0Q7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbXJ0Q7W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 12:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbXJ0Q7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 12:59:14 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:58413 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbXJ0Q7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 12:59:13 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 27 Oct 2007 09:59:07 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Marc Lehmann <linux-kernel@tst.eu>
cc: Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: epoll design problems with common fork/exec patterns
In-Reply-To: <20071027085125.GC12326@schmorp.de>
Message-ID: <Pine.LNX.4.64.0710270950170.12127@alien.or.mcafeemobile.com>
References: <20071027062236.GA12476@schmorp.de> <4722F575.8080204@cosmosbay.com>
 <20071027085125.GC12326@schmorp.de>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Oct 2007, Marc Lehmann wrote:

> > Please provide some code to illustrate one exact problem you have.
> 
>    // assume there is an open epoll set that listens for events on fd 5
>    if (fork () = 0)
>      {
>        close (5);
>        // fd 5 is now removed from the epoll set of the parent.
>        _exit (0);
>      }

Hmmm ... what? I assume you know that:

1) A file descriptor is a userspace view/handle of a kernel object

2) The kernel object has a use-count for as many file descriptors that 
   have been handed out to userspace

3) A close() decreases the internal counter by one

4) The kernel object gets effectively closed when the internal counter 
   goes to zero

5) A fork() acts as a dup() on the file descriptors by hence bumping up 
   its internal counter

6) Epoll removes the file from the set, when the *kernel* object gets 
   closed (internal use-count goes to zero)

With that in mind, how can the code snippet above trigger a removal from 
the epoll set?



- Davide


