Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbXJDFWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbXJDFWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 01:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXJDFV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 01:21:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:50206 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbXJDFVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 01:21:55 -0400
Date: Thu, 4 Oct 2007 07:21:54 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: [rfc][patch 1/3] x86_64: fence nontemproal stores
Message-ID: <20071004052153.GA15131@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's a couple of patches to improve the memory barrier situation on x86.
They probably aren't going upstream until after the x86 merge, however I'm
posting them here for RFC, and in case anybody wants to backport into stable
trees.

---
movnt* instructions are not strongly ordered with respect to other stores,
so if we are to assume stores are strongly ordered in the rest of the x86_64
kernel, we must fence these off (see similar examples in i386 kernel).

[ The AMD memory ordering document seems to say that nontemporal stores can
  also pass earlier regular stores, so maybe we need sfences _before_ movnt*
  everywhere too? ]

Signed-off-by: Nick Piggin <npiggin@suse.de>

Index: linux-2.6/arch/x86_64/lib/copy_user_nocache.S
===================================================================
--- linux-2.6.orig/arch/x86_64/lib/copy_user_nocache.S
+++ linux-2.6/arch/x86_64/lib/copy_user_nocache.S
@@ -117,6 +117,7 @@ ENTRY(__copy_user_nocache)
 	popq %rbx
 	CFI_ADJUST_CFA_OFFSET -8
 	CFI_RESTORE rbx
+	sfence
 	ret
 	CFI_RESTORE_STATE
 
