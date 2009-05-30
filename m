Return-Path: <linux-kernel-owner+w=401wt.eu-S1763431AbZE3Tfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763431AbZE3Tfn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 15:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757821AbZE3Tff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 15:35:35 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:55654 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167AbZE3Tff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 15:35:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=Na2JMyuvyEdQ5ZVTBiKGOt3WH1NpFFXtkgw7sSiurzf86AgSXYVTsvr6Plp2LZQTGS
         8/tYv+JCUcuSLcpfte55gEIJPi/WuVYXDEhCgXEK216lpjv8TWYoVeuO/wS7YtTl7Fqf
         YUzaAXCLVsO7hLKJIR1Sa3ItD71rNk3wS5x64=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for May 29 (__rdmsr_on_cpu() OOPS)
Date: Sat, 30 May 2009 21:37:57 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc7-next-20090529-06589-g7701864-dirty; KDE/4.2.3; i686; ; )
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
References: <20090529145018.ff547ea1.sfr@canb.auug.org.au>
In-Reply-To: <20090529145018.ff547ea1.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905302137.57644.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


next-20090529 oopses in __rdmsr_on_cpu() on my Pentium M laptop.

.jpg + .config:
http://www.kernel.org/pub/linux/kernel/people/bart/next-20090529-oops.*

(gdb) l *0xc023410f
0xc023410f is in __rdmsr_on_cpu (arch/x86/lib/msr.c:25).
20              if (rv->msrs)
21                      reg = &rv->msrs[this_cpu - rv->off];
22              else
23                      reg = &rv->reg;
24
25              rdmsr(rv->msr_no, reg->l, reg->h);
26      }
27
28      static void __wrmsr_on_cpu(void *info)
29      {

Thus the problem seems to be introduced by:

commit 23d19840368b2787d2da97ad0f0f29248503648a
Author: Borislav Petkov <borislav.petkov@amd.com>
Date:   Fri May 22 13:52:19 2009 +0200

    x86: MSR: add methods for writing of an MSR on several CPUs
...

and indeed the following patch fixes it:

[ Borislav, feel free to fold it into the above change or replace by
  a more complete one if needed (there may be more rv fields needing
  initialization). ]

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] x86: MSR: fix __rdmsr_on_cpu() OOPS

{rd,wr}msr_on_cpu() need to explicitly initalize rv.msrs
(since rv is allocated on the stack).

Cc: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 arch/x86/lib/msr.c |    2 ++
 1 file changed, 2 insertions(+)

Index: b/arch/x86/lib/msr.c
===================================================================
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
@@ -44,6 +44,7 @@ int rdmsr_on_cpu(unsigned int cpu, u32 m
 	int err;
 	struct msr_info rv;
 
+	rv.msrs   = NULL;
 	rv.msr_no = msr_no;
 	err = smp_call_function_single(cpu, __rdmsr_on_cpu, &rv, 1);
 	*l = rv.reg.l;
@@ -58,6 +59,7 @@ int wrmsr_on_cpu(unsigned int cpu, u32 m
 	int err;
 	struct msr_info rv;
 
+	rv.msrs   = NULL;
 	rv.msr_no = msr_no;
 	rv.reg.l = l;
 	rv.reg.h = h;
