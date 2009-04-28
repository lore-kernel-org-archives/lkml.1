Return-Path: <linux-kernel-owner+w=401wt.eu-S1760282AbZD1MrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760282AbZD1MrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 08:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760042AbZD1Mqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 08:46:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43172 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760116AbZD1Mqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 08:46:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.DEB.1.10.0904271946520.27012@vinegar-pot.mit.edu>
References: <alpine.DEB.1.10.0904271946520.27012@vinegar-pot.mit.edu> <1240864388-26315-4-git-send-email-tabbott@mit.edu> <1240864388-26315-1-git-send-email-tabbott@mit.edu> <1240864388-26315-2-git-send-email-tabbott@mit.edu> <1240864388-26315-3-git-send-email-tabbott@mit.edu> <4678.1240875782@redhat.com>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: dhowells@redhat.com, Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 03/14] mn10300: Use macros for .bss.page_aligned section.
Date: Tue, 28 Apr 2009 13:45:36 +0100
Message-ID: <31713.1240922736@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Abbott <tabbott@MIT.EDU> wrote:

> No, it is.  The macro is new in PATCH 1/14 of this series.

Aha!  Okay, I've applied that patch too, and now I see:

  LD      .tmp_vmlinux1
/opt/nickc/H-i686-pc-linux-gnulibc2.3/bin/am33_2.0-linux-gnu-ld:arch/mn10300/kernel/vmlinux.lds:237: syntax error

Where the error occurs on line 237, which is:

	  __bss_start = .; /* BSS */
	  .bss : {
	 . = ALIGN(+(1 << 12)) *(.bss.page_aligned)
	 *(.bss)
 ==>	  }
	  . = ALIGN(4);
	  __bss_stop = .;

in the expanded linker script.

The problem is that your patch #1 is wrong.  You need to apply:

---
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index a76275f..c9b16a6 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -118,11 +118,11 @@
 	TRACE_SYSCALLS()
 
 #define PAGE_ALIGNED_DATA						\
-	. = ALIGN(PAGE_SIZE)						\
+	. = ALIGN(PAGE_SIZE);						\
 	*(.data.page_aligned)
 
 #define PAGE_ALIGNED_BSS						\
-	. = ALIGN(PAGE_SIZE)						\
+	. = ALIGN(PAGE_SIZE);						\
 	*(.bss.page_aligned)
 
 #define RO_DATA(align)							\
---

to it.

David
