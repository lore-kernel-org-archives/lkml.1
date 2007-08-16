Return-Path: <linux-kernel-owner+w=401wt.eu-S1765585AbXHPT2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765585AbXHPT2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 15:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756509AbXHPT2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 15:28:34 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:51914 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925AbXHPT2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 15:28:33 -0400
Date: Thu, 16 Aug 2007 15:26:39 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@osdl.org>, stable@kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Alberto Pires de Oliveira Neto <apon1@terra.com.br>, giedrius@su.lt
Subject: Re: [PATCH] UML - Add a .note.SuSE section
Message-ID: <20070816192639.GA8957@c2.user-mode-linux.org>
References: <20070816162428.GA8128@c2.user-mode-linux.org> <1187281856.2663.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187281856.2663.0.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 09:30:56AM -0700, Arjan van de Ven wrote:
> this sounds like something really stupid and bad... why would the kernel
> need to have a per-distro note section???

On Thu, Aug 16, 2007 at 09:39:06AM -0700, Chris Wright wrote:
> Huh!?  Why do we need a SuSE section?

On Thu, Aug 16, 2007 at 09:54:55AM -0700, Greg KH wrote:
> I agree, what did we mess up in the SuSE kernel to require such a hack?

Beats the crap out of me.

Drop this patch - it looks like it might just be papering over
symptoms rather than fixing the real problem - see below.

What I do know is that current UML doesn't run when built on a SuSE
host, the UML commit which caused it to break is
c35e584c087381aaa5f1ed40a28b978535c18fb2 

	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=c35e584c087381aaa5f1ed40a28b978535c18fb2;hp=a5bd1786fb30abe663b904f6d79bba413e9ba883

and the difference between a working UML binary and a broken one is
this:

+  1 .note.ABI-tag 00000020  0000000060000254  0000000060000254  00000254  2**2
+                  CONTENTS, ALLOC, LOAD, READONLY, DATA
+  2 .note.SuSE    00000018  0000000060000274  0000000060000274  00000274  2**2
+                  CONTENTS, ALLOC, LOAD, READONLY, DATA

and the .note.SuSE section makes the difference.

Looking into it a bit further, the contents of the section are:

	objdump --section=.note.SuSE -s uml8796-linux-good

	uml8796-linux-good:     file format elf64-x86-64

	Contents of section .note.SuSE:
	 60000274 05000000 04000000 53755345 53755345  ........SuSESuSE
	 60000284 00000000 01000a02                    ........        

which seems kind of pointless, but also harmless.

The crash is in this section:

  __uml_setup_start = .;
  .uml.setup.init : { *(.uml.setup.init) }
  __uml_setup_end = .;

with &__uml_setup_start being 8 bytes before the start of the first
16-byte structure in .uml.setup.init, so the structures are misaligned
wrt the start symbol.

I don't see any connection between the presence of a section at the
start of the binary and this misalignment, so the patch is probably wrong.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
