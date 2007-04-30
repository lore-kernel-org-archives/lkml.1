Return-Path: <linux-kernel-owner+w=401wt.eu-S1423580AbXD3QBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423580AbXD3QBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423499AbXD3Pzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:55:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:45028 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423436AbXD3Pt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:49:57 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: dada1@cosmosbay.com, ak@suse.de, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [19/34] x86_64: move __vgetcpu_mode & __jiffies to the vsyscall_2 zone
Message-Id: <20070430154951.E03A01520A@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:49:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Eric Dumazet <dada1@cosmosbay.com>

We apparently hit the 1024 limit of vsyscall_0 zone when some debugging
options are set, or if __vsyscall_gtod_data is 64 bytes larger.

In order to save 128 bytes from the vsyscall_0 zone, we move __vgetcpu_mode
& __jiffies to vsyscall_2 zone where they really belong, since they are
used only from vgetcpu() (which is in this vsyscall_2 area).

After patch is applied, new layout is :

ffffffffff600000 T vgettimeofday
ffffffffff60004e t vsysc2
ffffffffff600140 t vread_hpet
ffffffffff600150 t vread_tsc
ffffffffff600180 D __vsyscall_gtod_data
ffffffffff600400 T vtime
ffffffffff600413 t vsysc1
ffffffffff600800 T vgetcpu
ffffffffff600870 D __vgetcpu_mode
ffffffffff600880 D __jiffies
ffffffffff600c00 T venosys_1

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/vmlinux.lds.S |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux/arch/x86_64/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/x86_64/kernel/vmlinux.lds.S
+++ linux/arch/x86_64/kernel/vmlinux.lds.S
@@ -95,6 +95,12 @@ SECTIONS
 		{ *(.vsyscall_gtod_data) }
   vsyscall_gtod_data = VVIRT(.vsyscall_gtod_data);
 
+
+  .vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1))
+		{ *(.vsyscall_1) }
+  .vsyscall_2 ADDR(.vsyscall_0) + 2048: AT(VLOAD(.vsyscall_2))
+		{ *(.vsyscall_2) }
+
   .vgetcpu_mode : AT(VLOAD(.vgetcpu_mode)) { *(.vgetcpu_mode) }
   vgetcpu_mode = VVIRT(.vgetcpu_mode);
 
@@ -102,10 +108,6 @@ SECTIONS
   .jiffies : AT(VLOAD(.jiffies)) { *(.jiffies) }
   jiffies = VVIRT(.jiffies);
 
-  .vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1))
-		{ *(.vsyscall_1) }
-  .vsyscall_2 ADDR(.vsyscall_0) + 2048: AT(VLOAD(.vsyscall_2))
-		{ *(.vsyscall_2) }
   .vsyscall_3 ADDR(.vsyscall_0) + 3072: AT(VLOAD(.vsyscall_3))
 		{ *(.vsyscall_3) }
 
