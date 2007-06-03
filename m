Return-Path: <linux-kernel-owner+w=401wt.eu-S1752401AbXFCWvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbXFCWvY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 18:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbXFCWvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 18:51:16 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4666 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbXFCWvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 18:51:15 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 3 Jun 2007 15:51:13 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/2] ufd v1 - unsequential O(1) fdmap core
In-Reply-To: <46633047.1020707@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0706031536000.13247@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.24319.1180825145.1>
 <46633047.1020707@cosmosbay.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1795850513-1674781915-1180910600=:13247"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1795850513-1674781915-1180910600=:13247
Content-Type: TEXT/PLAIN; CHARSET=X-UNKNOWN
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sun, 3 Jun 2007, Eric Dumazet wrote:

> Davide Libenzi a =E9crit :
> > Core code for the unsequential fdmap implementation. Random allocation,
> > exact allocation, de-allocation and lookup are all O(1) operations.
> > The only operation that is O(N) is the strict from-N-up kind of allocat=
ion,
> > but that only used by F_DUPFD and it's definitely not frequently used
> > (and current code is O(N) too).
> > Like the "struct fdtable", the unsequential fdmap is RCU friendly too.
> >=20
> >=20
> >=20
>=20
> Could you please provide a diffstat ?

With or w/out the comments? :)



> Me think : "Huge patch, and icache pressure for what exact gain ?"
>
> File descriptor allocation is dust compared to socket setup costs and net=
work
> stuf. (Not speaking of close() wich is O(1) obviously)
>=20
> If we want a different file descriptor allocation, why should we use a
> parallel structure, and adding one level of complexity ?
>=20
> Instead of finding the first zero bit in a bitmap, we could just use a cy=
clic
> allocation, ie finding a zero bit from a 'last' position. Keeping fd_coun=
t
> would help not atempting a findzerobit in the case all bits are known to =
be
> set.

A bitmap allocator made sense because it has the property of making=20
allocations compact. Once that requirement is relaxed, it does not make=20
any sense to use it (and you have still to modify it in any case).
I generally agree on code re-use, but that just not the right structure.=20
You can tweak it how much you like, but you're still doing a search inside=
=20
an N-sized bitmap. It's just the *wrong* structure.
I-cache pressure? All the extra code that you see out of fdmap.c/h, comes=
=20
from handling two "bitmaps", that you still have to have (unless you=20
plan to have a single huge botmap that covers legacy and non-sequential=20
areas). But with a bitmap structure, you're gonna have more D-cache=20
pressure. And that's a fact.



- Davide

--1795850513-1674781915-1180910600=:13247--
