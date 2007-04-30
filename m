Return-Path: <linux-kernel-owner+w=401wt.eu-S1423357AbXD3PYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423357AbXD3PYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423358AbXD3PYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:24:30 -0400
Received: from aun.it.uu.se ([130.238.12.36]:41163 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423357AbXD3PY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:24:29 -0400
Date: Mon, 30 Apr 2007 17:24:15 +0200 (MEST)
Message-Id: <200704301524.l3UFOFtI019810@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: andi@firstfloor.org, juergen127@kreuzholzen.de
Subject: Re: [PATCH] [1/1] CPU-i386-Geode: Chipset access macros do not work as expected
Cc: linux-kernel@vger.kernel.org, mikpe@it.uu.se
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 Apr 2007 17:32:04 +0200, Andi Kleen wrote:
> > From: Juergen Beisert <juergen.beisert@weihenstephan.org>
> > 
> > Replace NSC/Cyrix specific chipset access macros by inlined functions.
> > With the macros a line like this fails (and does nothing):
> > 	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
> > With inlined functions this line will work as expected.
> 
> Why do the macros not work? 

Delayed evaluation of parameters causing unexpected and broken
interleaving of side-effects. The macros look as follows:

#define getCx86(reg) ({ outb((reg), 0x22); inb(0x23); })

#define setCx86(reg, data) do { \
         outb((reg), 0x22); \
         outb((data), 0x23); \
} while (0)

So the statement
	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
becomes
	outb((CX86_CCR2), 0x22);
	outb((({ outb((CX86_CCR2), 0x22); inb(0x23); }) | 0x88), 0x23);
which is equivalent to
	outb(CX86_CCR2, 0x22);		// setCx86
	outb(CX86_CCR2, 0x22);		// getCx86
	tmp = inb(0x23) | 0x88;		// getCx86
	outb(tmp, 0x23);		// setCx86
which the processor doesn't like.

With inline functions the parameters are fully evaluated
before the bodies, so we get
	outb(CX86_CCR2, 0x22);		// getCx86
	tmp = inb(0x23) | 0x88;		// getCx86
	outb(CX86_CCR2, 0x22);		// setCx86
	outb(tmp, 0x23);		// setCx86
instead.

/Mikael
