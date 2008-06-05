Return-Path: <linux-kernel-owner+w=401wt.eu-S1755087AbYFEPW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbYFEPW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 11:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbYFEPV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 11:21:56 -0400
Received: from gw.goop.org ([64.81.55.164]:54369 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbYFEPVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 11:21:55 -0400
Message-ID: <4848046A.5060006@goop.org>
Date: Thu, 05 Jun 2008 16:21:14 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: x86@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>, Stable Kernel <stable@kernel.org>
Subject: [PATCH] x86: set PAE PHYSICAL_MASK_SHIFT to match 64-bit
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a 64-bit x86 processor runs in 32-bit PAE mode, a pte can
potentially have the same number of physical address bits as the
64-bit host ("Enhanced Legacy PAE Paging").

This is a bugfix for two cases:
1. running a 32-bit PAE kernel on a machine with
   more than 64GB RAM.
2. running a 32-bit PAE Xen guest on a host machine with
   more than 64GB RAM

In both cases, a pte could need to have more than 36 bits of physical,
and masking it to 36-bits will cause fairly severe havoc.

The 46-bit mask used in 64-bit seems pretty arbitrary.  The physical
size could be between 40 and 52 bits.  Setting the mask to 40 bits
would restrict the physical size to 1TB, which is definitely too
small.  Setting it to 52 would be ridiculously large, and runs the
risk that one of the vendors may decide to put flags rather than
physical address in one of the upper reserved bits.

Doing it "properly" would require testing cpuid leaf 0x80000008, but
it would mean that we would lose the ability to make all these
compile-time constants.

So, stick with 46 bits.  It's enough for now.

[ Ingo: This needs a test, but I think it should be fairly low-risk.
   If it checks out OK, it should be slipped to Linus fairly soon,
   since it is a bugfix.  It's probably worth putting into stable
   too. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Stable Kernel <stable@kernel.org>

diff -r 0eebd30011dc include/asm-x86/page_32.h
--- a/include/asm-x86/page_32.h	Wed Jun 04 10:32:01 2008 +0100
+++ b/include/asm-x86/page_32.h	Thu Jun 05 16:09:53 2008 +0100
@@ -22,7 +22,7 @@
 
 
 #ifdef CONFIG_X86_PAE
-#define __PHYSICAL_MASK_SHIFT	36
+#define __PHYSICAL_MASK_SHIFT	46
 #define __VIRTUAL_MASK_SHIFT	32
 #define PAGETABLE_LEVELS	3
 


