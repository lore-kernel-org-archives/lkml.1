Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbYJVD6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbYJVD6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 23:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbYJVD6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 23:58:41 -0400
Received: from ozlabs.org ([203.10.76.45]:55292 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbYJVD6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 23:58:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18686.42209.47915.184451@cargo.ozlabs.ibm.com>
Date: Wed, 22 Oct 2008 14:58:25 +1100
From: Paul Mackerras <paulus@samba.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Chris Friesen" <cfriesen@nortel.com>, linuxppc-dev@ozlabs.org,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: build failure on powerpc with current -git
In-Reply-To: <20081021191324.d4810d40.sfr@canb.auug.org.au>
References: <48F8E86B.702@nortel.com>
	<18685.27030.529655.761257@cargo.ozlabs.ibm.com>
	<20081021191324.d4810d40.sfr@canb.auug.org.au>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell writes:

> On Tue, 21 Oct 2008 16:33:10 +1100 Paul Mackerras <paulus@samba.org> wrote:
> >
> > It's a bug in older versions of ld (including 2.16.1) that's fixed in
> > the current version (2.18).  However, this patch appears to work
> > around the problem - at least, it let me build a 32-bit kernel with a
> > cross-toolchain including a 2.16.1 ld.  Let me know if this gets it
> > working for you.
> 
> With that patch applied I got these errors for a powerpc ppc64_defconfig
> build (linux-next).
> 
> /usr/bin/objcopy: Warning: '/dev/null' is not an ordinary file

Hmmm, so do I, and in fact the arch/powerpc/boot/wrapper change now
seems to be unnecessary with my cross-compile setup (which has ld
2.16.1), whereas yesterday I'm sure it got errors.  Weird.

Chris, could you try just the following change (my previous patch
without the arch/powerpc/boot/wrapper change) and let me know if it
fixes things with the ld you use?

Paul.
---
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index b39c27e..384dca5 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -187,6 +187,7 @@ SECTIONS
 		*(.machine.desc)
 		__machine_desc_end = . ;
 	}
+#ifdef CONFIG_RELOCATABLE
 	. = ALIGN(8);
 	.dynsym : AT(ADDR(.dynsym) - LOAD_OFFSET) { *(.dynsym) }
 	.dynstr : AT(ADDR(.dynstr) - LOAD_OFFSET) { *(.dynstr) }
@@ -202,6 +203,7 @@ SECTIONS
 		__rela_dyn_start = .;
 		*(.rela*)
 	}
+#endif
 
 	/* Fake ELF header containing RPA note; for addnote */
 	.fakeelf : AT(ADDR(.fakeelf) - LOAD_OFFSET) { *(.fakeelf) }
