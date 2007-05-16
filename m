Return-Path: <linux-kernel-owner+w=401wt.eu-S1762855AbXEPFYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762855AbXEPFYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 01:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759891AbXEPFYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 01:24:42 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:59990 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759504AbXEPFYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 01:24:41 -0400
Date: Wed, 16 May 2007 07:24:40 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: stack alignment on i386
Message-ID: <Pine.LNX.4.64.0705160648320.18296@artax.karlin.mff.cuni.cz>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>    [PATCH] x86: Drop cc-options call for all options supported in gcc 
>3.2+
>
>    The kernel only supports gcc 3.2+ now so it doesn't make sense
>    anymore to explicitely check for options this compiler version
>    already has.
>
>    This actually fixes a bug. The -mprefered-stack-boundary check
>    never worked because gcc rightly complains
>
>      CC      arch/i386/kernel/asm-offsets.s
>    cc1: -mpreferred-stack-boundary=2 is not between 4 and 12
>

Hi

Your patch for stack alignment on i386 is wrong. -mprefered-stack-boundary 
is log2 of the stack alignment (read gcc man page). On AMD64 16-byte 
alignment is enforced because of SSE, on i386 minimal alignment is 4 
bytes.

See the code in gcc that triggered your error:
       i = atoi (ix86_preferred_stack_boundary_string);
       if (i < (TARGET_64BIT ? 4 : 2) || i > 12)
         error ("-mpreferred-stack-boundary=%d is not between %d and 12", 
i,
                TARGET_64BIT ? 4 : 2);
       else
         ix86_preferred_stack_boundary = (1 << i) * BITS_PER_UNIT;

You are actually dealing with gcc bug, not Linux bug --- when gcc is 
compiled with AMD64 support it enforces 16-byte alignment even in 32-bit 
mode.

Rather let it be as it was, adding -mpreferred-stack-boundary=4 doesn't 
make sense, because it is default.

Mikulas

Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

--- linux-2.6.22-rc1/arch/i386/Makefile_	Thu May 17 23:47:31 2007
+++ linux-2.6.22-rc1/arch/i386/Makefile	Thu May 17 23:47:45 2007
@@ -34,7 +34,9 @@
  CFLAGS += -pipe -msoft-float -mregparm=3 -freg-struct-return

  # prevent gcc from keeping the stack 16 byte aligned
-CFLAGS += -mpreferred-stack-boundary=4
+# gcc has a bug that it doesn't allow 4-byte alignment when compiled with
+# 64-bit support and producing 32-bit code, so this option must be tested
+CFLAGS += $(call cc-option,-mpreferred-stack-boundary=2)

  # CPU-specific tuning. Anything which can be shared with UML should go here.
  include $(srctree)/arch/i386/Makefile.cpu
