Return-Path: <linux-kernel-owner+w=401wt.eu-S1761643AbZFQWgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761643AbZFQWgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 18:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbZFQWgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 18:36:08 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45921 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754200AbZFQWgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 18:36:07 -0400
X-Sasl-enc: QVPeo4wpQWeF/8D8ovqr/I+PQFwYrLzO+NkksSiV6C1J 1245278167
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <andi@firstfloor.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Stas Sergeev <stsp@aknet.ru>, Tejun Heo <tj@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 0/3] x86: fix return from kernel to userspace with 16-bit stack
Date: Thu, 18 Jun 2009 00:35:56 +0200
Message-Id: <1245278159-6840-1-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset was generated against the current mainline-git tree, but
also applies just fine to the tip tree.

Some background...

If a userspace application is interrupted by a trap, interrupt, or nmi, 
the processor saves ss:esp, the flags register and cs:eip and loads a 
new ss:esp from the task segment, modifies the flags and loads cs:eip 
from the interrupt descriptor table. After handling the exception, the 
saved values are restored and the user process continues as if nothing 
happened... With one exception: if the process users a 16-bit stack 
segment (as described in the LDT), the processor only restores the low 
16 bits of esp from the saved value. The upper 16 bits are left equal to 
the upper word of the kernel esp. Only very few applications, like 
dosemu and wine, care, but it leads to those applications crashing with, 
usually, a bus error.

The implemented fix is to change the stack segment and stack pointer in 
a clever way just before returning to the userspace application. The 
espfix segment is a normal 32-bit segment, but with a non-zero base. The 
base of the espfix segment and the high word of the temporary esp are 
changed in unison, such that the temporary stack still points to the 
kernel stack, but the high word of esp is already equal to the high word 
of the saved userspace esp. On return to userspace the iret-instruction 
only loads the low word of esp, but the high word was already set to the 
correct value by changing to the temporary espfix stack. Using the 
espfix stack in C code is however unsafe, so fixups to change back to 
the normal stack before entering C code have to be in place.


The patches...

patch 1/3: i386: fix return to 16-bit stack from NMI handler

This patch adds switching to the espfix stack if the kernel returns to 
userspace from the NMI. Commit 55f327fa9e876758491a82af7491104f1cc3fc4d 
("lockdep: irqtrace subsystem, i386 support") removed this check/fixup 
from the NMI return path.

patch 2/3: i386: fix/simplify espfix stack switching, move it into assembly

A long-standing problem with the computation of the espfix base address 
and the temporary stack segment. The combined result always points to 
the kernel stack, but the high word of the espfix stack pointer was not 
always equal to the high word of the saved userspace stack pointer. This 
patch simplifies the fixup code and fixes it.

patch 3/3: x86: de-assembler-ize asm/desc.h

Cleanup patch, split out form previous versions of patch 2/3. In earlier 
versions I forgot to take into account x86_64 when I did the cleanup. 
This version compiles fine on x86_64.

Patch summary:

 arch/x86/include/asm/desc.h  |   26 -----------------
 arch/x86/kernel/cpu/common.c |    2 +-
 arch/x86/kernel/entry_32.S   |   64 +++++++++++++++++++++++++++--------------
 arch/x86/kernel/head_32.S    |    1 -
 arch/x86/kernel/head_64.S    |    1 -
 5 files changed, 43 insertions(+), 51 deletions(-)

I'm typing this message on an Authentic Sempron 2400+ running the 
patched kernel.

Greetings,
    Alexander
