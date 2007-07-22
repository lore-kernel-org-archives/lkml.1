Return-Path: <linux-kernel-owner+w=401wt.eu-S1762205AbXGVJA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762205AbXGVJA2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 05:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761077AbXGVI7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 04:59:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760801AbXGVI7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 04:59:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: David Miller <davem@davemloft.net>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: Re: "build-id" changes break sparc64
In-Reply-To: David Miller's message of  Sunday, 22 July 2007 01:23:21 -0700 <20070722.012321.79430375.davem@davemloft.net>
Emacs: because one operating system isn't enough.
Message-Id: <20070722085940.7E3DE4D05C1@magilla.localdomain>
Date: Sun, 22 Jul 2007 01:59:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> (This is in reference to commit 18991197b4b588255ccabf472ebc84db7b66a19c)
> 
> When actually used, the build-id linker option causes problems for the
> sparc64 kernel in two ways:
> 
> 1) When building modules we get tons of warnings from the linker
>    such as:
> 
>   LD [M]  drivers/scsi/sr_mod.o
> ld: warning: Cannot create .note.gnu.build-id section, --build-id ignored.

This is probably a bug in the new ld code (which is still quite unreleased,
even if bleeding-edge distro builds are using it already).  Please work
with me (off the kernel list) to figure that out.

>    build-id puts a second PT_LOAD into the kernel image (albeit a tiny
>    one) and as a result it cannot be booted

This probably just requires a linker script tweak to use the NOTES macro.
Maybe:

--- a/arch/sparc64/kernel/vmlinux.lds.S
+++ b/arch/sparc64/kernel/vmlinux.lds.S
@@ -19,6 +19,7 @@ SECTIONS
     SCHED_TEXT
     LOCK_TEXT
     KPROBES_TEXT
+    NOTES
     *(.gnu.warning)
   } =0
   _etext = .;

I did not change every platform's script where I wasn't sure if a change
was required or what it needed to be.  It may be that every platform that
doesn't use the NOTES macro in its vmlinux.lds.S really needs to.  (Place
it anywhere you like that is appropriate for a few dozen read-only bytes
that will rarely be read.)

> Whilst #1 could be some kind of binutils bug and the warning
> is harmless, #2 is an outright show-stopper for sparc32 and
> sparc64 and to be honest I would not be surprised if the
> boot loader on some other platforms have this limitation too.

There's no expectation of changing anything about the layout.
Just a linker script tweak might be required so the tiny new
section falls somewhere proper in the existing layout.

> Alternatively, if you think build-id is so valuable, impress me with
> your binutils ninja skills and show me how to perhaps do some objcopy
> tricks wherein I could dike out the PT_LOAD segment build-id generates
> for the "image" target et al.  in the arch/sparc{,64}/boot/Makefile's
> rules.

I have indeed performed some odd feats in this area in the past, but in
this case there should be not any need for anything of the sort.

I would prefer not to let the feature lag while every platform gets around
to adding a Makefile line.  It really should be universal and simple to
deal with.  The ld feature is still so bleeding-edge that there should be
ample time to iron out kinks before anyone could be bit by it who wasn't
really asking for it.


Thanks,
Roland
