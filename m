Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbZJ0NiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbZJ0NiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 09:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbZJ0Nh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 09:37:59 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:63918 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634AbZJ0Nh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 09:37:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=u2E84pW2+WXPlgF/zecPkHEWkqgow5Qbkf1VgakZcRjsS5uJMP/dr+yelm2tvqY0vS
         jf1vaz+GdS3zz3Ia1in7Fg6uHyXvlEYri2FGu8Jt5MZK+ED6rDxTs/SMCX9NTe0o0gkc
         Gig9nfDhKr0cIgtntfh+jUp5XbGOyIabFtirE=
Subject: mipsel-linux-gnu-gcc: -pg and -fomit-frame-pointer are incompatible
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Steven Rostedt <rostedt@goodmis.org>, rdsandiford@googlemail.com
Cc: David Daney <ddaney@caviumnetworks.com>,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Tue, 27 Oct 2009 21:32:30 +0800
Message-Id: <1256650350.5499.117.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

FUNCTION_TRACER have selected FRAME_POINTER by default to avoid the
following "weird" error when using -pg and -fomit-frame-pointer
together:

"-pg and -fomit-frame-pointer are incompatible"

kernel/trace/Kconfig:

config FUNCTION_TRACER
        bool "Kernel Function Tracer"
        depends on HAVE_FUNCTION_TRACER
        select FRAME_POINTER

and here is what FRAME_POINTER does in (linux)/Makefile:

ifdef CONFIG_FRAME_POINTER
KBUILD_CFLAGS   += -fno-omit-frame-pointer -fno-optimize-sibling-calls
else
KBUILD_CFLAGS   += -fomit-frame-pointer
endif

but in reality, from the manual of gcc:

"Don’t keep the frame pointer in a register for functions that don’t
need one.  This avoids the instructions to save, set up and restore
frame pointers; it also makes an extra register available in many
functions.  It also makes debugging impossible on some machines.

On some machines, such as the VAX, this flag has no effect, because the
standard calling sequence automatically handles the frame pointer and
nothing is saved by pretending it doesn’t exist.  The
machine-description macro "FRAME_POINTER_REQUIRED" controls whether a
target machine supports this flag.

Enabled at levels -O, -O2, -O3, -Os."

-fomit-frame-pointer will be enabled by default for -O2, and If I
disable -fno-omit-frame-pointer, it will really not keep the frame
pointer in a register:

ffffffff80200400 <do_one_initcall>:
ffffffff80200400:       67bdffd0        daddiu  sp,sp,-48
ffffffff80200404:       ffbf0028        sd      ra,40(sp)
ffffffff80200408:       ffb40020        sd      s4,32(sp)
ffffffff8020040c:       ffb30018        sd      s3,24(sp)
ffffffff80200410:       ffb20010        sd      s2,16(sp)
ffffffff80200414:       ffb10008        sd      s1,8(sp)
ffffffff80200418:       ffb00000        sd      s0,0(sp)
ffffffff8020041c:       3c038021        lui     v1,0x8021
ffffffff80200420:       64630fb0        daddiu  v1,v1,4016  <> with -pg
ffffffff80200424:       03e0082d        move    at,ra
ffffffff80200428:       0060f809        jalr    v1
ffffffff8020042c:       00020021        nop
[...]
ffffffff80205b18 <au1k_wait>:
ffffffff80205b18:       3c038021        lui     v1,0x8021
ffffffff80205b1c:       64630fb0        daddiu  v1,v1,4016
ffffffff80205b20:       03e0082d        move    at,ra
ffffffff80205b24:       0060f809        jalr    v1
ffffffff80205b28:       00020021        nop

And without -fno-omit-frame-pointer option, ftrace for MIPS also works
normally and can save some overhead for us!

But perhaps some archs need the frame pointer, so, remove the
-fno-omit-frame-pointer from (linux)/Makefile, and add it into the arch
specific Makefile?

Besides, should we clear the "weird" error in gcc when using -pg and
-fomit-frame-pinter together?

Thanks & Regards,
	Wu Zhangjin

