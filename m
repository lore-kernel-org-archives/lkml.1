Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbYBROBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbYBROBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 09:01:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbYBROBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 09:01:40 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:59942 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751382AbYBROBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 09:01:39 -0500
Date: Mon, 18 Feb 2008 15:01:35 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Adrian Bunk <bunk@kernel.org>
cc: Michael Ellerman <michael@ellerman.id.au>, Roel Kluin <12o3l@tiscali.nl>,
       lkml <linux-kernel@vger.kernel.org>, cbe-oss-dev@ozlabs.org,
       linuxppc-dev@ozlabs.org, Willy Tarreau <w@1wt.eu>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/3] Fix Unlikely(x) == y
In-Reply-To: <20080218135609.GD21080@cs181133002.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0802181500410.13406@vixen.sonytel.be>
References: <47B70A61.9030306@tiscali.nl> <20080216092552.325e5726@laptopd505.fenrus.org>
 <20080216173315.GU8953@1wt.eu> <20080216094226.1e8eede1@laptopd505.fenrus.org>
 <47B72BFE.9060302@am.sony.com> <20080216103927.2a02352b@laptopd505.fenrus.org>
 <1203249003.6718.24.camel@concordia> <20080218135609.GD21080@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-516462847-1203343295=:13406"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-516462847-1203343295=:13406
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 18 Feb 2008, Adrian Bunk wrote:
> On Sun, Feb 17, 2008 at 10:50:03PM +1100, Michael Ellerman wrote:
> > On Sat, 2008-02-16 at 10:39 -0800, Arjan van de Ven wrote:
> >...
> > > for mordern (last 10 years) x86 cpus... the cpu branchpredictor is better
> > > than the coder in general. Same for most other architectures.
> > > 
> > > unlikely() creates bigger code as well.
> > > 
> > > Now... we're talking about your super duper hotpath function here right?
> > > One where you care about 0.5 cycle speed improvement? (less on modern
> > > systems ;)
> > 
> > The first patch was to platforms/ps3 code, which runs on the Cell, in
> > particular the PPE ... which is not an x86 :)
> > 
> > eg:
> > 
> > [michael@schoenaich ~]$ cat branch.c
> > #include <stdio.h>
> > int main(void)
> > {
> >         int i, j;
> > 
> >         for (i = 0, j = 0; i < 1000000000; i++)
> >                 if (i % 4 == 0)
> >                         j++;
> > 
> >         printf("j = %d\n", j);
> >         return 0;
> > }
> > [michael@schoenaich ~]$ ppu-gcc -Wall -O3 -o branch branch.c
> > [michael@schoenaich ~]$ time ./branch
> > real    0m5.172s
> > 
> > [michael@schoenaich ~]$ cat branch.c
> > ..
> >         for (i = 0, j = 0; i < 1000000000; i++)
> >                 if (__builtin_expect(i % 4 == 0, 0))
> >                         j++;
> > ..
> > [michael@schoenaich ~]$ ppu-gcc -Wall -O3 -o branch branch.c
> > [michael@schoenaich ~]$ time ./branch
> > real    0m3.762s
> > 
> > 
> > Which looks as though unlikely() is helping. Admittedly we don't have a
> > lot of kernel code that looks like that, but at least unlikely is doing
> > what we want it to.
> 
> This means it generates faster code with a current gcc for your platform.
> 
> But a future gcc might e.g. replace the whole loop with a division
> (gcc SVN head (that will soon become gcc 4.3) already does 
> transformations like replacing loops with divisions [1]).

Hence shouldn't we ask the gcc people what's the purpose of __builtin_expect(),
if it doesn't live up to its promise?

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

Sony Network and Software Technology Center Europe
A division of Sony Service Centre (Europe) N.V.
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
VAT BE 0413.825.160 · RPR Brussels
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584349381-516462847-1203343295=:13406--
