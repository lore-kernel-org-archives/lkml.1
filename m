Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbYJOLF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbYJOLF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 07:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbYJOLFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 07:05:19 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:65168 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbYJOLFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 07:05:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:subject:message-id:mime-version
         :content-type;
        b=AgIl+x+AEEjXsSviQl1SOrdoFWi9hn3oCc4ZkHEtfi/RsCR6VqaXcPeqMX3g3Nzzxj
         32C/dMAeJ79f3BDjbrLMwbseQek5JnjC5jT7LuVtwvB9pU8uTw5GyXHnaIyodREdSzOQ
         T1xHJ37xfzkXlzO4xFZp6LlBGwebHEwAiPFRY=
Date: Wed, 15 Oct 2008 19:05:02 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: linux 2.6.27 kernel panic on x86 - please revert commit
 3a85e770aa77e4f1a4096275c97b64c10cd7323e
Message-ID: <Pine.LNX.4.64.0810151902510.19590@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Commit 3a85e770aa77e4f1a4096275c97b64c10cd7323e broke linux boot on x86 
resulting in kernel panic. Here's the console output ...

Net: Registered protocol family 17
Using IPI No-Shortcut mode
RAMDISK: Compressed image found at block 0
VFS: Mounted root (ext2 filesystem (readonly).
Freeing unsued kernel memory: 312k freed
init[1]: segfault at ffffe01c up b7f0dc28 sp bfc26628 error 5 in ld-2.7.90.so[b7f0b000+1c000]
Kernel panic - not syncing: Attempted to kill init!


Thanks,
Jeff.


Please revert this ...

commit 3a85e770aa77e4f1a4096275c97b64c10cd7323e
Author: Suresh Siddha <suresh.b.siddha@intel.com>
Date:   Tue Sep 23 14:00:37 2008 -0700

     x86, cpa: remove USER permission from the very early identity mapping attribute

     remove USER from the PTE/PDE attributes for the very early identity
     mapping. We overwrite these mappings with KERNEL attribute later
     in the boot. Just being paranoid here as there is no need for USER bit
     to be set.

     If this breaks something(don't know the history), then we can simply drop
     this change.

     Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
     Cc: Suresh Siddha <suresh.b.siddha@intel.com>
     Cc: arjan@linux.intel.com
     Cc: venkatesh.pallipadi@intel.com
     Cc: jeremy@goop.org
     Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
index 0ff73e7..bbf0f59 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -138,8 +138,8 @@
  #ifdef CONFIG_X86_64
  #define __PAGE_KERNEL_IDENT_LARGE_EXEC	__PAGE_KERNEL_LARGE_EXEC
  #else
-#define PTE_IDENT_ATTR	 0x007		/* PRESENT+RW+USER */
-#define PDE_IDENT_ATTR	 0x067		/* PRESENT+RW+USER+DIRTY+ACCESSED */
+#define PTE_IDENT_ATTR	 0x003		/* PRESENT+RW */
+#define PDE_IDENT_ATTR	 0x063		/* PRESENT+RW+DIRTY+ACCESSED */
  #define PGD_IDENT_ATTR	 0x001		/* PRESENT (no other attributes) */
  #endif

