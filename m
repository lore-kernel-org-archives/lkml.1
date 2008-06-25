Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407AbYFYEiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbYFYEiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYFYEhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:07 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37422 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752501AbYFYEhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:05 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 22 of 36] x86_64: split x86_64_start_kernel
X-Mercurial-Node: d88834c50aa16b6c03d82c18fdfc3a436e83f1b6
Message-Id: <d88834c50aa16b6c03d8.1214367558@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:18 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split x86_64_start_kernel() into two pieces:

   The first essentially cleans up after head_64.S.  It clears the
   bss, zaps low identity mappings, sets up some early exception
   handlers.

   The second part preserves the boot data, reserves the kernel's
   text/data/bss, pagetables and ramdisk, and then starts the kernel
   proper.

This split is so that Xen can call the second part to do the set up it
needs done.  It doesn't need any of the first part setups, because it
doesn't boot via head_64.S, and its redundant or actively damaging.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

---
 arch/x86/kernel/head64.c |    5 +++++
 include/asm-x86/setup.h  |    2 ++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -108,6 +108,11 @@
 
 	early_printk("Kernel really alive\n");
 
+	x86_64_start_reservations(real_mode_data);
+}
+
+void __init x86_64_start_reservations(char *real_mode_data)
+{
 	copy_bootdata(__va(real_mode_data));
 
 	reserve_early(__pa_symbol(&_text), __pa_symbol(&_end), "TEXT DATA BSS");
diff --git a/include/asm-x86/setup.h b/include/asm-x86/setup.h
--- a/include/asm-x86/setup.h
+++ b/include/asm-x86/setup.h
@@ -63,6 +63,8 @@
 
 #else
 void __init x86_64_start_kernel(char *real_mode);
+void __init x86_64_start_reservations(char *real_mode_data);
+
 #endif /* __i386__ */
 #endif /* _SETUP */
 #endif /* __ASSEMBLY__ */


