Return-Path: <linux-kernel-owner+w=401wt.eu-S1762235AbZD1Psj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762235AbZD1Psj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755669AbZD1Ps3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:48:29 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:59584 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754639AbZD1Ps2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:48:28 -0400
Date: Tue, 28 Apr 2009 11:47:15 -0400 (EDT)
From: Tim Abbott <tabbott@MIT.EDU>
To: Paul Mackerras <paulus@samba.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: Please revert edada399 and 9203fc9c
In-Reply-To: <18934.35969.872225.70725@cargo.ozlabs.ibm.com>
Message-ID: <alpine.DEB.1.10.0904281126550.15450@vinegar-pot.mit.edu>
References: <18934.35969.872225.70725@cargo.ozlabs.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please revert commits edada399 ("powerpc: Use TEXT_TEXT macro in
> linker script.") and 9203fc9c ("powerpc: Use __REF macro instead of
> old .text.init.refok."), which depends on edada399.

Paul,

Sorry for breaking the build.  I will be sure to CC you and 
linuxppc-dev@ozlabs.org on future powerpc patches in this section name 
cleanup project.

I think just reverting commits edada399 and 9203fc9c will cause a section 
mismatch warning since commit 27b18332 removed the support code for the 
.text.init.refok section.  The following patch I believe should fix this 
by effectively reverting just commit edada399.  Can someone who has a 
64-bit powerpc machine confirm?

	-Tim Abbott

--

powerpc: Revert switch to TEXT_TEXT in linker script

Commit edada399 broke the build on 64-bit powerpc because it moved the
__ftr_alt_* sections of a file away from the .text section, causing
link failures due to relative conditional branch targets being too far
away from the branch instructions.  This happens on pretty much all
64-bit powerpc configs.

This change reverts commit edada399 while preserving the update from
the *.refok sections to .ref.text that has happened since.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
---
 arch/powerpc/kernel/vmlinux.lds.S |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 433ae11..a047a6c 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -54,8 +54,8 @@ SECTIONS
 		ALIGN_FUNCTION();
 		HEAD_TEXT
 		_text = .;
-		TEXT_TEXT
-		*(.fixup __ftr_alt_*)
+		/* careful! __ftr_alt_* sections need to be close to .text */
+		*(.text .fixup __ftr_alt_* .ref.text)
 		SCHED_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
-- 
1.6.2.1

