Return-Path: <linux-kernel-owner+w=401wt.eu-S1754395AbYIHTai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbYIHTai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 15:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbYIHTab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 15:30:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751767AbYIHTaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 15:30:30 -0400
Date: Mon, 8 Sep 2008 12:30:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Arjan van de Ven <arjan@infradead.org>,
       x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 fixes
In-Reply-To: <20080908190249.GA21998@elte.hu>
Message-ID: <alpine.LFD.1.10.0809081213330.3117@nehalem.linux-foundation.org>
References: <200809081752.m88Hq6tn005080@askone.hos.anvin.org> <alpine.LFD.1.10.0809081056350.3117@nehalem.linux-foundation.org> <48C56D60.7010405@zytor.com> <20080908114619.741b6786@infradead.org> <48C57439.3040903@zytor.com>
 <20080908190249.GA21998@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Sep 2008, Ingo Molnar wrote:
> 
> but 486 and higher is certainly quite reasonable, and is still being 
> tested.
> 
> ... and _in practice_ 99% of all systems that run Linux today understand 
> CMOV.

cmov, cmpxchg and xadd are the noticeable things.

I think there are realistically three classes:

 - _really_ old, to the point of being totally useless for SMP.

   This is really just 386 and clones. We _need_ a working WP for a 
   race-free access_ok(), and we need cmpxchg (and lately xadd).

   SMP cannot really realistically work reasonably (ys, there were SMP 
   machines. No, they don't matter), and you'd have to be insane to care 
   about this as a vendor even on UP. Probably nobody really cares (ie if 
   you have hardware that old, you are likely much better off with an 
   older kernel too)

   Smaller pains even on UP: bswap doesn't exist. invlpg doesn't exist. 

 - old. pre-cmov. i486 and pentium, and some clones.

   It's workable, but code generation differences are really big enough 
   that it's worth having a totally separate architecture option for newer 
   CPUs where the kernel simply won't work.

   And most newer distros probably simply don't care, although there may 
   be individual cases where this makes sense (embedded places still use 
   pentium clones etc, and there are probably a fair amount of individuals 
   that want to still use this)

   Other pains: TSC doesn't necessarily exist.

 - "modern 32-bit": PPro and better. Can take CMOV, MMX and TSC for 
   granted.

Yes, there are graduations to the above, but reasonably, those three are I 
think the "architectural" big versions. The rest should be:

 - pure "tuning" options. A Pentium 4 is different from Core 2 in tuning, 
   and the best code sequences can be very very different, but the binary 
   should work on both.

 - with *dynamic* choices for the differences that are architecturally 
   visible.

   Ie the whole choice of syscall/sysenter/int80 is dynamic, not specified 
   statically at compile time with a config option. So are things like the 
   different XMM versions etc.

Hmm? Doesn't that sound like a sane model?

		Linus
