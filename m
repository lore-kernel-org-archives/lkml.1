Return-Path: <linux-kernel-owner+w=401wt.eu-S1758489AbXKCCrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbXKCCrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 22:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755733AbXKCCrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 22:47:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50161 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755747AbXKCCrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 22:47:04 -0400
Date: Fri, 2 Nov 2007 19:46:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ralf Baechle <ralf@linux-mips.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jay Estabrook <jay.estabrook@hp.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] Use i8253.c lock for PC speaker on MIPS, too.
In-Reply-To: <20071102172606.GA29513@linux-mips.org>
Message-ID: <alpine.LFD.0.999.0711021940010.3342@woody.linux-foundation.org>
References: <20071102161650.GA28459@linux-mips.org>
 <20071102172606.GA29513@linux-mips.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Nov 2007, Ralf Baechle wrote:
>
> The Jazz machines have to use the PIT timer for dyntick and highresolution
> kernels.  This may break because currently just like i386 used to do MIPS
> uses two separate spinlocks in the actual PIT code and the PC speaker
> code.  So switch to do it the same that x86 currently does PIT locking.

Hmm. That leaves apparently just alpha/ppc/powerpc as supporting pcspkr, 
and *not* doing this. Maybe they should be forced to do the i8253 lock in 
arch code too, and expose it through <asm/i8253.h>, instead of having that 
butt-ugly #ifdef remain in the sources?

Paul, Jay, Ivan: right now drivers/input/pcspkr.c does this:

	#if defined(CONFIG_MIPS) || defined(CONFIG_X86)
	/* Use the global PIT lock ! */
	#include <asm/i8253.h>
	#else
	#include <asm/8253pit.h>
	static DEFINE_SPINLOCK(i8253_lock);
	#endif

and wouldn't it be nice if we just changed it to

	#include <asm/i8253.h>

and got rid of one totally unnecessary stupid arch difference?

		Linus
