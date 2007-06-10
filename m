Return-Path: <linux-kernel-owner+w=401wt.eu-S1761784AbXFJTQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761784AbXFJTQs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 15:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbXFJTQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 15:16:41 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4578 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437AbXFJTQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 15:16:40 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 10 Jun 2007 12:16:34 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Paul Mackerras <paulus@samba.org>
cc: Kyle Moffett <mrmacman_g4@mac.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ulrich Drepper <drepper@redhat.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <18027.40637.672203.14305@cargo.ozlabs.ibm.com>
Message-ID: <Pine.LNX.4.64.0706101142400.24939@alien.or.mcafeemobile.com>
References: <466741BD.20106@redhat.com> <20070607110432.73be7960@the-village.bc.nu>
 <B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com> <20070607151243.22caab9e.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com>
 <466864F8.2050903@cosmosbay. <18027.40637.672203.14305@cargo.ozlabs.ibm.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jun 2007, Paul Mackerras wrote:

> > for (i = 0; i < NR_OPEN; i++)
> > 	if (!fd_is_special_to_us(i))
> > 		close(i);
> > 
> > Note that this is conceptually buggy, but occurs in several major C  
> > programming books, most of the major shells, and a lot of other  
> > software to boot.
> 
> Buggy in what way?  In the use of the NR_OPEN constant?

That is buggy because the code assumes it is the only owner of the fd 
space. Thing that is not true if runtimes have opened their own file 
descriptors to handle their own links to the kernel.
The syslog case is kinda bogus. For certain things, you can afford a retry 
policy (assuming somone else did not open another fd over the fd that you 
cached - then it's gonna be fun). It is crappy, but it *may* work. Sure 
is, does not fit any definition of "reliable" I'm aware of.
Think about a runtime that had an epoll fd open and a few fds dropped into 
it to, say, deliver some sort of events to the application. After the 
Close Loop of Death, the whole thing is gone.
As is, runtimes cannot reliably use (cached) fds for their own internal 
communication with the kernel. That, I think we can agree it is a fact.
We can then say that we do not care if runtimes cannot reliably use fds, 
and move on. But it's hard to say that the problem does not exist.



- Davide


