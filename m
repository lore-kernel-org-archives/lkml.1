Return-Path: <linux-kernel-owner+w=401wt.eu-S1756991AbZDVVLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991AbZDVVLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 17:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbZDVVL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 17:11:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43614 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbZDVVL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 17:11:29 -0400
Date: Wed, 22 Apr 2009 23:15:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH] X86-32: Let gcc decide whether to inline memcpy was Re: New x86 warning
Message-ID: <20090422211501.GD13896@one.firstfloor.org>
References: <49EEBD3C.3060009@garzik.org> <20090422070157.GA28438@elte.hu> <8763gxoz50.fsf_-_@basil.nowhere.org> <alpine.LFD.2.00.0904221354320.3101@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904221354320.3101@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 01:56:54PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 22 Apr 2009, Andi Kleen wrote:
> > 
> > Modern gcc (and that is all that is supported now) should be able to
> > generate this code on its own already.  So if you call __builtin_* it
> > will  just work (that is what 64bit does) without that explicit code.
> 
> Last time we tried that, it wasn't true. Gcc wouldn't inline even trivial 
> cases of constant sizes.

AFAIK it's all true on 3.2+ when it can figure out the alignment
(but some gcc versions had problems passing the alignment around e.g.
through inlining), under the assumption that out of line can do
a better job with unaligned data. That's not true with my patch,
but could be true in theory.

Quick test here:

char a[10];
char b[2];
char c[4];
char d[8];

short x;
long y;

char xyz[100];


f()
{
#define C(x) memcpy(&x, xyz, sizeof(x));
        C(x)
        C(y)
        C(a)
        C(b)
        C(c)
        C(d)
}

and everything gets inlined with gcc 3.2 which is the oldest
we still care about:

gcc version 3.2.3

        movzwl  xyz+8(%rip), %eax
        movzwl  xyz(%rip), %ecx
        movq    xyz(%rip), %rdx
        movw    %ax, a+8(%rip)
        movw    %cx, x(%rip)
        movw    %cx, b(%rip)
        movl    xyz(%rip), %eax
        movq    %rdx, y(%rip)
        movq    %rdx, a(%rip)
        movq    %rdx, d(%rip)
        movl    %eax, c(%rip)
        ret

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
