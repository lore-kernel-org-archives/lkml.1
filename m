Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588AbXBDWwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbXBDWwQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 17:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbXBDWwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 17:52:16 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:3635 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbXBDWwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 17:52:15 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sun, 4 Feb 2007 14:52:08 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Jakub Jelinek <jakub@redhat.com>
cc: Bill Davidsen <davidsen@tmr.com>, Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ANN] Userspace M-on-N threading model implementation. Alpha
 release.
In-Reply-To: <20070204202053.GC20307@devserv.devel.redhat.com>
Message-ID: <Pine.LNX.4.64.0702041438180.18633@alien.or.mcafeemobile.com>
References: <66910A579C9312469A7DF9ADB54A8B7D5C2B90@exchange.ZeugmaSystems.local>
 <45C362D2.2040407@tmr.com> <1170516376.3073.1015.camel@laptopd505.fenrus.org>
 <45C63E30.4010106@tmr.com> <20070204202053.GC20307@devserv.devel.redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Feb 2007, Jakub Jelinek wrote:

> On Sun, Feb 04, 2007 at 03:12:32PM -0500, Bill Davidsen wrote:
> > Arjan van de Ven wrote:
> > >>Because user threading can avoid context switches, there will always be 
> > >>cases where it will outperform o/s threads for hardware reasons.
> > >
> > >actually.. switching from one "real" thread to another in Linux is not
> > >an actual context switch in the hardware sense... at least this part of
> > >your argument seems to be incorrect ;)
> > >
> > How does that work? Switching between kernel threads requires going into 
> > the kernel, user level thread switches are all done in user mode.
> > 
> > Do you have some way to change o/s threads w/o going into the kernel?
> 
> But going into kernel is not very expensive on Linux.
> 
> On the other side, the overhead you need to add for every single syscall
> that might block for the M:N threads and the associated complications
> which make it far harder to conform to POSIX IMHO far outweight the costs
> of going into the kernel for a context switch.

Agreed, definitely. A libpcl (using swapcontext(3)) cobench is about 50 
times faster than an context switch measured by lmbench (although I have 
serious doubts about about the ability of lat_ctx to measure it - but 
that's another story) on an Opteron 254. One may say "Wow! Really?!?".
The point is, who cares. We are talking about differences between 
super-fast (~2us) and ultra-fast (~0.04us).
The time (and code) that you'll have to drop in the syscall path to handle 
M:N is very likely to make you lose way more of what you gain by avoiding 
an OS context switch (a "soft" context switch you still have to do it).
Either use N:N (requires locking, but spread over multiple CPUs) or 1:N 
(I/O driven state machines or coroutines - no locking, once-CPU bound).



- Davide


