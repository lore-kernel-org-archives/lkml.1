Return-Path: <linux-kernel-owner+w=401wt.eu-S1752519AbXCPGfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbXCPGfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 02:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbXCPGfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 02:35:43 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:48416 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbXCPGfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 02:35:42 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 15 Mar 2007 23:31:35 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/4] signalfd v1 - signalfd core ...
In-Reply-To: <a36005b50703152216s6c2fce0ck71d41a124940265f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0703152256490.12136@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703061639370.3661@alien.or.mcafeemobile.com> 
 <Pine.LNX.4.64.0703070854280.5963@woody.linux-foundation.org> 
 <Pine.LNX.4.64.0703070943180.12283@alien.or.mcafeemobile.com> 
 <45EF20F7.1050307@goop.org>  <Pine.LNX.4.64.0703071241590.12756@alien.or.mcafeemobile.com>
  <45EF2DFF.4060209@goop.org>  <Pine.LNX.4.64.0703071329080.12756@alien.or.mcafeemobile.com>
  <Pine.LNX.4.64.0703071347380.5963@woody.linux-foundation.org> 
 <a36005b50703071401m2b166832rb06f4cf73224f45e@mail.gmail.com> 
 <Pine.LNX.4.64.0703071406100.12756@alien.or.mcafeemobile.com>
 <a36005b50703152216s6c2fce0ck71d41a124940265f@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007, Ulrich Drepper wrote:

> On 3/7/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> > Let's do this. How about you throw this way one of the case that would
> > possibly break, and I test it?
> 
> Since you make such claims I assume your signalfd() implementation
> considers a signal delivered once it is reported to an epoll() caller.
> Right?

The wakeup phase in epoll does not mean the signal is delivered. That 
happens when the caller does a read(2) on the signalfd. The read(2) on the 
signalfd ends up in calling dequeue_signal(), the same function use by the 
kernel to spill out signals to deliver (they peek from the same queue).



> This is not what you really want, at least not in all cases.  A signal
> might be something you want to react on right away.  Unless
> pthread_kill() is used it is delivered to the _process_ and not a
> specific thread.  But this means if epoll() reports two events to one
> thread calling epoll() (one of them being a signal) and this thread is
> then stuck processing the other request, the signal is not handled
> even though there might be a second or third thread available to
> receive the signal.  Those threads have the same right to receive the
> signal and the current implementation always looks for the
> best/fastest way to deliver the signal.

The behaviour depends on the sigmask you pass to signalfd(). You can 
select signals that you want to handle in a standard way, and the ones 
that you want to handle with signalfd.
Typically programs using signalfd() do not want the asyncronous behaviour 
of signals at all (with all the limits you have in the handler), and the 
event dispatch loop never blocks by definition (otherwise you have more 
serious problems than a signal not delivered). They are also very likely 
to be single threaded.



> This means to me that reporting the signal in epoll() does _not_ mark
> the signal as handled.  Somehow (probably using the signalfd()
> descriptor) the thread must explicitly request the signal to be
> delivered.  But if you do this the epoll() handling is fantastically
> racy if the signal is not blocked.

As I said, when a signal hits send_signal (or the queued versions), a 
wakeup is done on the wait queue head poll (or select/epoll) is sleeping 
on. This ends up delivring a POLLIN, but the signal is not fetched (by the 
mean of dequeue_signal) until a read(2) on the signalfd is done.
Since both standard delivery and signalfd's read(2) fish from the same 
queue, you have to block the signals that you want to have the guarantee 
to be able to fetch with a read(2) (signalfd supports O_NONBLOCK also).
If you do not block the signal, you get a wakeup, but you may not find a 
signal to dequeue at the next read(2), because a standard delivery might 
have stole the signal by preceeding you in dequeue_signal.



- Davide


