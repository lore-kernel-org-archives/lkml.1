Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbZEROqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbZEROqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 10:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbZEROqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 10:46:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58287 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbZEROqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 10:46:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] asm-generic: add a dma-mapping.h file
Date: Mon, 18 May 2009 16:45:24 +0200
User-Agent: KMail/1.9.9
Cc: jgarzik@pobox.com, hancockrwd@gmail.com, htejun@gmail.com,
       alan@lxorguk.ukuu.org.uk, flar@allandria.com,
       schmitz@biophys.uni-duesseldorf.de, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, takata@linux-m32r.org, geert@linux-m68k.org,
       linux-m68k@vger.kernel.org, ysato@users.sourceforge.jp
References: <200905172138.55145.arnd@arndb.de> <200905172245.23774.arnd@arndb.de> <20090518194443R.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090518194443R.fujita.tomonori@lab.ntt.co.jp>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905181645.26305.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1++SeUxKsFkiWAK6DlilH1zPU9ypyeOzdIczw+
 8p6z2dNu/NdOrNoj1TVf+Cy0pV1cxNEiZqcGOEt6agB4Q+r5Xv
 6e3zNKPH61l6O2HXzRPpw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 May 2009, FUJITA Tomonori wrote:
> 
> NACK'ed, sorry.

I had no idea how hard it would get to fix a simple
allyesconfig build error. This is the third time
that a new approach to getting ATA to build on all
platforms is gets a NAK...

> - these idndef tricks are really ugly and wrong.
> - these functions are not generic at all.

I was trying to do two things at once:

- provide a default implementation for each function
  that an architecture can override, therefore the
  #ifdef magic.
- Have a minimal working implementation of the API
  that at least makes sense for architectures that
  do not support DMA, but want to share some of the
  code.

Ten of the existing architectures simply try do a
linear mapping, and that should easily be possible
in a generic way not too different from what I posted.
Would you agree to a patch that works with the same
code on e.g. arm, microblaze, mn10300 and sh and
uses only a few #ifdefs?

> - it's confusing to have two ways to handle this issue;
> dma-mapping-broken.h and dma-mapping.h.

We actually already have three ways to handle this right
now:

- dma-mapping-broken.h:
  only used on Sun3 m68k, i.e. not interesting any more,
  plus it does not solve the question of how to build
  ATA drivers on architectures without DMA.
- selecting NO_DMA:
  This works fine for everything except ATA. All other
  drivers using dma-mapping.h either depend on HAS_DMA
  or sprinkle their files with #ifdef.
- adding a bogus dma-mapping.h: cris, um and microblaze
  currently set HAS_DMA but add a dma-mapping.h that
  allows stuff to compile but cannot actually work.

I think that dma-mapping-broken.h has served its purpose
and we should now have two implementations in asm-generic,
the one you posted recently for ia64, x86, parisc, powerpc
and sparc64 and one for all architectures that only have
linear mappings. The version I posted is certainly not
generic enough for those, but I can keep improving it.

	Arnd <><
