Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbYJHLRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbYJHLRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 07:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbYJHLRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 07:17:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40413 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbYJHLRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 07:17:32 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1223450773.8195.80.camel@brick>
References: <1223450773.8195.80.camel@brick>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: dhowells@redhat.com, Russell King <rmk@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: FRV/ARM unaligned access question
Date: Wed, 08 Oct 2008 12:16:06 +0100
Message-ID: <19824.1223464566@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison <harvey.harrison@gmail.com> wrote:

> If there isn't an issue I'm missing, could ARM/FRV move over to the
> packed-struct version?

Using this source:

	typedef unsigned char u8;
	typedef unsigned int u32;

	struct __una_u32 { u32 x __attribute__((packed)); };

	#if 0 // packed struct
	static inline u32 __get_unaligned_cpu32(const void *p)
	{
		const struct __una_u32 *ptr = (const struct __una_u32 *)p;
		return ptr->x;
	}

	static inline u32 get_unaligned_be32(const void *p)
	{
		return __get_unaligned_cpu32((const u8 *)p);
	}

	#else // manual byteshift
	static inline u32 __get_unaligned_be32(const u8 *p)
	{
		return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
	}

	static inline u32 get_unaligned_be32(const void *p)
	{
		return __get_unaligned_be32((const u8 *)p);
	}
	#endif

	u32 jump(u32 *p)
	{
		return get_unaligned_be32(p);
	}

I see the packed struct version compile (with -O2) to:

	jump:
		ldub @(gr8,gr0),gr6
		ldubi @(gr8,1),gr4
		ldubi @(gr8,2),gr5
		ldubi @(gr8,3),gr8
		slli gr6,#24,gr6
		slli gr4,#16,gr4
		or.p gr4, gr6, gr4
		slli gr5,#8,gr5
		or gr5, gr4, gr5
		or.p gr8, gr5, gr8
		ret

and the byteshift version compile to:

	jump:
		ldubi.p @(gr8,1),gr7
		mov gr8, gr5
		ldubi @(gr5,2),gr6
		ldub @(gr8,gr0),gr8
		ldubi @(gr5,3),gr9
		slli gr7,#16,gr7
		slli gr6,#8,gr6
		slli.p gr8,#24,gr8
		or gr6, gr7, gr6
		or gr8, gr9, gr8
		or.p gr8, gr6, gr8
		ret

so they're more or less equivalent, give or take the compiler using an extra
instruction unnecessarily.


Switching to the packed struct algorithms also reduces the kernel size very
slightly.  Before:

	warthog>size vmlinux
	   text    data     bss     dec     hex filename
	2207836   66588  150189 2424613  24ff25 vmlinux

After:

	warthog>size vmlinux
	   text    data     bss     dec     hex filename
	2207804   66588  150189 2424581  24ff05 vmlinux

The attached patch boots okay over NFS.

David
---
[PATCH] FRV: Use packed-struct unalignment rather than manual-shift

From: David Howells <dhowells@redhat.com>

Use the packed-struct unalignment algorithms rather than the manual-shift
unalignment algorithms.

This makes the kernel very slightly smaller.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/asm-frv/unaligned.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/include/asm-frv/unaligned.h b/include/asm-frv/unaligned.h
index 839a2fb..d06b9bc 100644
--- a/include/asm-frv/unaligned.h
+++ b/include/asm-frv/unaligned.h
@@ -12,8 +12,8 @@
 #ifndef _ASM_UNALIGNED_H
 #define _ASM_UNALIGNED_H
 
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/be_byteshift.h>
+#include <linux/unaligned/le_struct.h>
+#include <linux/unaligned/be_struct.h>
 #include <linux/unaligned/generic.h>
 
 #define get_unaligned	__get_unaligned_be
