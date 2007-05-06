Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbXEFTr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbXEFTr1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 15:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185AbXEFTr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 15:47:27 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1976 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180AbXEFTr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 15:47:26 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 6 May 2007 12:47:21 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@gmail.com>
cc: Davi Arnaut <davi@haxent.com.br>, Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 14/22] pollfs: pollable futex
In-Reply-To: <a36005b50705060050q512462edoe53efbc18f754471@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705061034230.25105@alien.or.mcafeemobile.com>
References: <20070502052235.914764000@haxent.com.br> 
 <Pine.LNX.4.64.0705021059430.7176@alien.or.mcafeemobile.com> 
 <a36005b50705030646v5b729838pe8dc7b91dc9bee2b@mail.gmail.com> 
 <Pine.LNX.4.64.0705031111320.6502@alien.or.mcafeemobile.com> 
 <a36005b50705031203w14df6f1fp26e186056b0fdef7@mail.gmail.com> 
 <Pine.LNX.4.64.0705031433470.6502@alien.or.mcafeemobile.com> 
 <a36005b50705040828l28f1d039oe58224ff18286ecd@mail.gmail.com> 
 <Pine.LNX.4.64.0705041201390.6958@alien.or.mcafeemobile.com> 
 <a36005b50705041638h37cd0654q442e7d50f1e63040@mail.gmail.com> 
 <Pine.LNX.4.64.0705051118030.19104@alien.or.mcafeemobile.com>
 <a36005b50705060050q512462edoe53efbc18f754471@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 May 2007, Ulrich Drepper wrote:

> On 5/5/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> > But we have our own *sane* version of WaitForMultipleObjects, and it's
> > called poll(2).
> 
> No, we don't.  Don't start all over again.  The interface of poll it
> to primitive.  See the kevent code, each record is, IIRC, 16 bytes in
> size to return more data.  For poll you only have bits.

Yes, event bits plus opaque token are enough for most of it. Then you use 
POSIX read/write to fetch/store the data. All the files (sockets, pipes, ...)
works this way. Signals you fetch a siginfo-like structure, through POSIX 
read. Timers, you fetch a counter, through POSIX read. AIO, you use the 
native AIO API (that I'd prefer, or you can choose to have a POSIX read 
too). All these through isolated POSIX read semantics.
Now let's see how it'd look with a monolitic kevent-like interface. You'll 
have a mosnter-union ala siginfo_t, with multiple nested structures, and 
every time you need to extend it, you'll go through pain. Come on, that's 
beyond ugly. With a file-like interface, each new addition comes to a 
seaparate isolated interface, with separate POSIX read/write ABI.
Do you realise that to justify your all new bulk interface, 
you had to pull out of the hat a Windows WaitForMultipleObjects?
Please drop the BS. I made you a full list of things that are readily and 
POSIX-friendly handled/signaled with file-like interfaces.
Any sockets, pipes, all devices, signals, timers, AIO, and I'm probably 
forgetting something.
You pulled "it's slow". False.
You pulled "it's memory expensive". It's not.
So far, I did not hear a single valid reason to go with a new, monolitic 
interface. WaitForMultipleObjects? Please ...



- Davide


