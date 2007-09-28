Return-Path: <linux-kernel-owner+w=401wt.eu-S1759779AbXI1I5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759779AbXI1I5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbXI1I5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:57:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43955 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbXI1I5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:57:08 -0400
Date: Fri, 28 Sep 2007 01:56:57 -0700
Message-Id: <200709280856.l8S8uvS5002291@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jkeating@redhat.com, cebbert@redhat.com, jordan.crouse@amd.com,
       pommnitz@yahoo.com
Subject: [GIT PULL] Correct the SMAP check in the e820 probe
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git for-linus

H. Peter Anvin (1):
      [x86 setup] Correct the SMAP check for INT 0x15, AX=0xe820

 arch/i386/boot/memory.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

[Log messages and full diffs follow]

commit 24b4ac15fe9ea5772630e0c58d9b6243a6c68385
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Thu Sep 27 17:17:12 2007 -0700

    [x86 setup] Correct the SMAP check for INT 0x15, AX=0xe820
    
    The e820 probe code was checking %edx, not %eax, for the SMAP
    signature on return.  This worked on *almost* all systems, since %edx
    still contained SMAP from the call on entry, but on a handful of
    systems it failed -- plus, we would have missed real mismatches.
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/i386/boot/memory.c b/arch/i386/boot/memory.c
index bccaa1c..2f37568 100644
--- a/arch/i386/boot/memory.c
+++ b/arch/i386/boot/memory.c
@@ -28,11 +28,10 @@ static int detect_memory_e820(void)
 
 	do {
 		size = sizeof(struct e820entry);
-		id = SMAP;
 		asm("int $0x15; setc %0"
-		    : "=am" (err), "+b" (next), "+d" (id), "+c" (size),
+		    : "=dm" (err), "+b" (next), "=a" (id), "+c" (size),
 		      "=m" (*desc)
-		    : "D" (desc), "a" (0xe820));
+		    : "D" (desc), "d" (SMAP), "a" (0xe820));
 
 		/* Some BIOSes stop returning SMAP in the middle of
 		   the search loop.  We don't know exactly how the BIOS
