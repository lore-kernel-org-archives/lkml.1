Return-Path: <linux-kernel-owner+w=401wt.eu-S1760353AbYDKPMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760353AbYDKPMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 11:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759537AbYDKPML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 11:12:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45043 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758560AbYDKPMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 11:12:10 -0400
Date: Fri, 11 Apr 2008 16:11:56 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>, Dave Jones <davej@redhat.com>,
       drepper@redhat.com, mingo@redhat.com, tglx@redhat.com,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] Fix compile breakage caused by asmlinkage_protect
Message-ID: <20080411151156.GJ9785@ZenIV.linux.org.uk>
References: <alpine.LFD.1.00.0804101447240.3143@woody.linux-foundation.org> <20080410223738.80A8326F992@magilla.localdomain> <20080411114654.GA12270@osiris.boeblingen.de.ibm.com> <alpine.LFD.1.00.0804110744100.3143@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0804110744100.3143@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 07:46:48AM -0700, Linus Torvalds wrote:
> Ok, that's just _odd_.
> 
> > So just surround the new define with an #ifndef __ASSEMBLY__ to prevent
> > any side effects on asm code.
> 
> There are no side effects on asm code. It just adds a #define that 
> obviously won't be used.
> 
> Is the s390 assembler using some strange C pre-processor that is different 
> from the main C preprocessor and doesn't understand this pattern?
> 
> I really think you should fix *that*, because otherwise you'll hit these 
> kinds of bugs occasionally. There aren't that many asm files, it's not 
> worth it optimizing them to use some faster-but-stupider preprocessor.

FWIW, at least m68k and m32r cross-builds hit the same.  I think I've a very
good guess about the reasons:
arch/m32r/kernel/Makefile:EXTRA_AFLAGS  := -traditional
arch/m68k/fpsp040/Makefile:EXTRA_AFLAGS := -traditional
arch/m68k/ifpsp060/Makefile:EXTRA_AFLAGS := -traditional
arch/m68k/kernel/Makefile:EXTRA_AFLAGS := -traditional
arch/m68k/lib/Makefile:EXTRA_AFLAGS := -traditional
arch/m68k/math-emu/Makefile:EXTRA_AFLAGS := -traditional
arch/parisc/kernel/Makefile:AFLAGS_entry.o      := -traditional
arch/parisc/kernel/Makefile:AFLAGS_pacache.o := -traditional
arch/s390/kernel/Makefile:EXTRA_AFLAGS  := -traditional
arch/s390/lib/Makefile:EXTRA_AFLAGS := -traditional
arch/s390/math-emu/Makefile:EXTRA_AFLAGS := -traditional

and that gets us -traditional-cpp passed to cc1, with obvious resulting
unhappiness from vararg macro.
