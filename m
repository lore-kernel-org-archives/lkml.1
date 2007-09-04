Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbXIDQ4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbXIDQ4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 12:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbXIDQz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 12:55:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34853 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbXIDQz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 12:55:56 -0400
Date: Tue, 4 Sep 2007 09:55:45 -0700
Message-Id: <200709041655.l84GtjiJ008962@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christian Ehrhardt <lk@c--e.de>
Subject: [GIT PULL] x86 setup: work around bug in Xen HVM
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git for-linus

Christian Ehrhardt (1):
      [x86 setup] Work around bug in Xen HVM

 arch/i386/boot/pm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

[Log messages and full diffs follow]

commit 92ea189254b87727d6be407558d9c18fed0937bb
Author: Christian Ehrhardt <lk@c--e.de>
Date:   Mon Sep 3 20:32:38 2007 +0200

    [x86 setup] Work around bug in Xen HVM
    
    Apparently XEN does not keep the contents of the 48-bit gdt_48 data
    structure that is passed to lgdt in the XEN machine state. Instead it
    appears to save the _address_ of the 48-bit descriptor
    somewhere. Unfortunately this data happens to reside on the stack and
    is probably no longer availiable at the time of the actual protected
    mode jump.
    
    This is Xen bug but given that there is a one-line patch to work
    around this problem, the linux kernel should probably do this.  My fix
    is to make the gdt_48 description in setup_gdt static (in setup_idt
    this is already the case). This allows the kernel to boot under
    Xen HVM again.
    
    Signed-off-by: Christian Ehrhardt <lk@c--e.de>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/i386/boot/pm.c b/arch/i386/boot/pm.c
index 6be9ca8..f7958f1 100644
--- a/arch/i386/boot/pm.c
+++ b/arch/i386/boot/pm.c
@@ -122,7 +122,7 @@ static void setup_gdt(void)
 		/* DS: data, read/write, 4 GB, base 0 */
 		[GDT_ENTRY_BOOT_DS] = GDT_ENTRY(0xc093, 0, 0xfffff),
 	};
-	struct gdt_ptr gdt;
+	static struct gdt_ptr gdt;
 
 	gdt.len = sizeof(boot_gdt)-1;
 	gdt.ptr = (u32)&boot_gdt + (ds() << 4);
