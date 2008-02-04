Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbYBDXDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbYBDXDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 18:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756219AbYBDXDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 18:03:03 -0500
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:29160 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756212AbYBDXDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 18:03:01 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=pLbkjymI/1qjctYFZlaf7JPVJz74F4nBWkgK1TYn8t4jFdGSQLoMD9dWKZlsnW3o8z5CiucywrBnA7so6aFi4GNNnDN+z99s34zARAQxjneh/fWLeWRB3KjPjwE0dBf2ibtZUNYIGYCikfOxGKvKqGxnM+cMVMRWsDxcmXFspRI=  ;
X-YMail-OSG: RvHX5a4VM1kU4BW99YQWYfj.vPZ_tH.wFxrdlMvPUXjr5z6yt1T9h_2F02LDAKQvRRCmVyFzCg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: 2.6.24 regression: pan hanging unkilleable and un-straceable
Date: Tue, 5 Feb 2008 10:02:27 +1100
User-Agent: KMail/1.9.5
Cc: Frederik Himpe <fhimpe@telenet.be>, linux-kernel@vger.kernel.org
References: <1200949086.6648.19.camel@Anastacia> <1200980828.4643.11.camel@homer.simson.net> <1202136558.7282.18.camel@homer.simson.net>
In-Reply-To: <1202136558.7282.18.camel@homer.simson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802051002.28051.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2008 01:49, Mike Galbraith wrote:
> On Tue, 2008-01-22 at 06:47 +0100, Mike Galbraith wrote:
> > On Tue, 2008-01-22 at 16:25 +1100, Nick Piggin wrote:
> > > On Tuesday 22 January 2008 16:03, Mike Galbraith wrote:
> > > > I've hit same twice recently (not pan, and not repeatable).
> > >
> > > Nasty. The attached patch is something really simple that can sometimes
> > > help. sysrq+p is also an option, if you're on a UP system.
> >
> > SMP (P4/HT imitating real cores)
> >
> > > Any luck getting traces?
> >
> > We'll see.  Armed.
>
> Hm.  ld just went loopy (but killable) in v2.6.24-6928-g9135f19.  During
> kbuild, modpost segfaulted, restart build, ld goes gaga.  Third attempt,
> build finished.  Not what I hit before, but mentionable.
>
>
> [  674.589134] modpost[18588]: segfault at 3e8dc42c ip 0804a96d sp af982920
> error 5 in modpost[8048000+9000] [  674.589211] mm/memory.c:115: bad pgd
> 3e081163.
> [  674.589214] mm/memory.c:115: bad pgd 3e0d2163.
> [  674.589217] mm/memory.c:115: bad pgd 3eb01163.

Hmm, this _could_ be bad memory. Or if it is very easy to reproduce with
a particular kernel version, then it is probably a memory scribble from
another part of the kernel :(

First thing I guess would be easy and helpful to run memtest86 for a
while if you have time.

If that's clean, then I don't have another good option except to bisect
the problem. Turning on DEBUG_VM, DEBUG_SLAB, DEBUG_LIST, DEBUG_PAGEALLOC,
DEBUG_STACKOVERFLOW, DEBUG_RODATA might help catch it sooner... SLAB and
PAGEALLOC could slow you down quite a bit though. And if the problem is
quite reproduceable, then obviously don't touch your config ;)

Thanks,
Nick


>
> [ 1407.322144]  =======================
> [ 1407.322144] ld            R running      0 21963  21962
> [ 1407.322144]        db9d7f1c 00200086 c75f9020 b1814300 b0428300 b0428300
> b0428300 c75f9280 [ 1407.322144]        b1814300 00000001 db9d7000 00000000
> d08c2f90 dba4f300 00000002 00000000 [ 1407.322144]        b1810120 dba4f334
> 00200046 ffffffff db9d7000 c75f9020 db9d7f30 b02f333f [ 1407.322144] Call
> Trace:
> [ 1407.322144]  [<b02f333f>] preempt_schedule_irq+0x45/0x5b
> [ 1407.322144]  [<b0117a10>] ? do_page_fault+0x0/0x470
> [ 1407.322144]  [<b0104d6e>] need_resched+0x1f/0x21
> [ 1407.322144]  [<b0117a10>] ? do_page_fault+0x0/0x470
> [ 1407.322144]  [<b0117a5c>] ? do_page_fault+0x4c/0x470
> [ 1407.322144]  [<b0117a10>] ? do_page_fault+0x0/0x470
> [ 1407.322144]  [<b02f4a3a>] ? error_code+0x72/0x78
> [ 1407.322144]  [<b02f0000>] ? init_transmeta+0xcf/0x22f <== zzt P4
