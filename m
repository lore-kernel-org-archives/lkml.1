Return-Path: <linux-kernel-owner+w=401wt.eu-S1760642AbXHNUkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbXHNUkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 16:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759800AbXHNUjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 16:39:32 -0400
Received: from styx.suse.cz ([82.119.242.94]:55229 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757334AbXHNUja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 16:39:30 -0400
Date: Tue, 14 Aug 2007 22:41:06 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ulrich Kunitz <kune@deine-taler.de>, Bret Towe <magnade@gmail.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] [RESEND] PIE executable randomization
In-Reply-To: <20070814200647.GN2063@devserv.devel.redhat.com>
Message-ID: <Pine.LNX.4.64.0708142224540.29843@jikos.suse.cz>
References: <Pine.LNX.4.64.0708081552010.11054@jikos.suse.cz>
 <20070814200647.GN2063@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(added Arjan to CC, as he has been working on the kernel part of the 
randomization previously)

On Tue, 14 Aug 2007, Jakub Jelinek wrote:

> If I'm reading the above hunk correctly, this means we will randomize 
> all PIEs and even all dynamic linkers invoked as executables on i?86 and 
> x86_64, and on the rest of arches we won't randomize at all, instead 
> load ET_DYN objects at ELF_ET_DYN_BASE address. But I don't see anything 
> i?86/x86_64 specific on this.

Hi Jakub,

actually, it is currently arch-specific, and that's because of different 
memory layouts on different archs.

It turned out recently that PIE-compiled binaries on x86_64, that perform 
larger amount of brk-allocations (for example bash) will not work (but 
they will work on ?86). This is because currently on ?86 the memory layout 
is as follows:

[TEXT][HEAP]...[MMAP area]..[STACK]..[VDSO]

for PIE-complied binaries, the situation is as follows (with the patch):

[MMAP area]...[TEXT][HEAP]..[STACK]..[VDSO]

which is perfectly fine (except for the non-randomized brk). However, on 
x86_64, the memory layout is different:

[TEXT][HEAP][MMAP area]..[STACK]..[VDSO]

which directly shows why brk() doesn't work well here -- it very soon hits 
another mmaped VMA.

I am currently thinking about the best way to address this issue -- I am 
thinking about randomizing brk properly (which we want to do anyway), so 
that it is placed in the area that doesn't overlap with mmap range.

> What would make much more sense to me would be conditionalizing on
> whether we are loading a dynamic linker (in which case loading it
> at ELF_ET_DYN_BASE is desirable or not (PIEs, ...; and for PIEs we
> want to randomize on all architectures).

Yes, I agree -- when we sort out the memory layout problems.

Thanks,

-- 
Jiri Kosina
SUSE Labs
