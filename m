Return-Path: <linux-kernel-owner+w=401wt.eu-S1757878AbXI1QBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbXI1QBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 12:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbXI1QBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 12:01:41 -0400
Received: from [81.2.110.250] ([81.2.110.250]:45774 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751341AbXI1QBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:01:41 -0400
Date: Fri, 28 Sep 2007 17:07:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [patch] x86: improved memory barrier implementation
Message-ID: <20070928170719.2f617a7a@the-village.bc.nu>
In-Reply-To: <20070928154832.GB12538@wotan.suse.de>
References: <20070928154832.GB12538@wotan.suse.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The only alternative is to assume a weak memory model, and add the required
> barriers to spin_unlock -- something that has been explicitly avoided, but

We have the barriers in spin_unlock already for Pentium Pro and IDT
Winchip systems. The Winchip explicitly supports out of order store (and
was about 10-20% faster with it set this way), the PPro has some annoying
little store ordering bugs which is why we xchgb out of spin_unlock in
those cases.

> The complaint that broken old ppros get more broken seems to be bogus as well:
> wmb on i386 never catered to the old ppro to start with. The errata seem to

There are only a couple of awkward cases with the PPro and we carefully
work around them. The other half of the work is the flush_write_buffers.

> Buggy ppros: I have no interest in, given the vague errata and apparently
> unfixable problems with lockless code; anybody is welcome to try adding
> whatever they like to help them work, but again please don't confuse that
> with having anything to do with this patch...

PPro was fixed, made to work and brutally tested on quad PPro. There are
cases that wouldn't work (PPro + AGP which never happens) and there are
cases that need specific handling (PPro + Voodoo card and some other 3D
bits) which are handled currently in the X server. The rest is fine.

> Winchip: can any of these CPUs with ooostores do SMP? If not, then smp_wmb
> can also be a simple barrier on i386 too.

The IDT Winchip can do SMP apparently. Nobody has ever seen an SMP
winchip board so I don't think it matters and even if one existed we
wouldn't support it anyway

However 
- You've not shown the patch has any performance gain
- You've probably broken Pentium Pro
- and for modern processors its still not remotely clear your patch is
correct because of NT stores.

So NAK

Alan
