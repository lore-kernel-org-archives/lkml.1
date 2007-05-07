Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbXEGSji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbXEGSji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 14:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbXEGSji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 14:39:38 -0400
Received: from allen.werkleitz.de ([80.190.251.108]:37529 "EHLO
	allen.werkleitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbXEGSjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 14:39:37 -0400
Date: Mon, 7 May 2007 20:39:31 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Esben Nielsen <nielsen.esben@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Message-ID: <20070507183931.GB3472@linuxtv.org>
References: <20070501212223.GA29867@elte.hu> <463854F3.3020403@linux.vnet.ibm.com> <20070502100545.GA6857@elte.hu> <46386F2B.9050307@linux.vnet.ibm.com> <20070502111742.GA18132@elte.hu> <Pine.LNX.4.64.0705051016420.12880@frodo.shire> <alpine.LFD.0.98.0705051040420.3819@woody.linux-foundation.org> <Pine.LNX.4.64.0705071159530.14011@frodo.shire> <alpine.LFD.0.98.0705070921390.3802@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705070921390.3802@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 87.162.100.22
Subject: Re: [patch] CFS scheduler, -v8
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on allen.werkleitz.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007, Linus Torvalds wrote:
> On Mon, 7 May 2007, Esben Nielsen wrote:
> > 
> > What is (long)(a-b) ? I have tried to look it up in the C99 standeard but I
> > can't find it. Maybe it is in the referred LIA-1 standeard, which I can't find
> > with google.

C99 defines unsigned overflow semantics, but it doesn't say anything
about signed overflow, thus it's undefined -- and you have a hard
time finding it out.

However, I have no clue *why* it's undefined and not
implementation defined. Does someone know?

> I don't worry about non-2's-complement machines (they don't exist, and 
> likely won't exist in the future either).

I think DSPs can do saturated arithmetics (clamp to min/max
values instead of wrap around). Not that it matters for Linux...

> So I worry about compilers rewriting my code.

gcc has -fwrapv and -ftrapv to change signed integer overflow
behaviour.

One baffling example where gcc rewrites code is when
conditionals depend on signed integer overflow:

$ cat xx.c
#include <assert.h>

int foo(int a)
{
	assert(a + 100 > a);
	return a;
}

int bar(int a)
{
	if (a + 100 > a)
		a += 100;
	return a;
}
$ gcc -Wall -Wextra -fomit-frame-pointer -c xx.c
$ objdump -dr xx.o

xx.o:     file format elf32-i386

Disassembly of section .text:

00000000 <foo>:
   0:   8b 44 24 04             mov    0x4(%esp),%eax
   4:   c3                      ret

00000005 <bar>:
   5:   83 44 24 04 64          addl   $0x64,0x4(%esp)
   a:   8b 44 24 04             mov    0x4(%esp),%eax
   e:   c3                      ret


The assert and the condition were just dropped
by gcc -- without any warning.

gcc-4.2 will add -fstrict-overflow and -Wstrict-overflow.
http://gcc.gnu.org/gcc-4.2/changes.html


Johannes
