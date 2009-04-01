Return-Path: <linux-kernel-owner+w=401wt.eu-S933583AbZDASw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933583AbZDASw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 14:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758219AbZDASwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 14:52:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58853 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761250AbZDASwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 14:52:17 -0400
Date: Wed, 1 Apr 2009 11:51:14 -0700
Message-Id: <200904011851.n31IpEfZ030035@voreg.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Michael K. Johnson" <johnsonm@rpath.com>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Jordan Hargrave <Jordan_Hargrave@dell.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] x86 setup BIOS workarounds
In-Reply-To: <alpine.LFD.2.00.0904011115210.4130@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> So at a _minimum_, I'd suggest that we set bug.ext_flags to 1 before the 
> call - so that if some random BIOS just leaves %ecx unchanged, it won't 
> mean that the area just gets ignored as a ACPI-3 entry.
> 

Argh, I had that in there originally, and then I shuffled stuff around
and it got left out.  Total thinko on my part.  I'm sorry, and thanks
for catching that.

I have had the ACPI 3 stuff in Syslinux for quite a while now (*with*
the flag initialization) and it hasn't caused problems there, so I
feel it should be safe to push into the kernel.

The following changes since commit c549e71d073a6e9a4847497344db28a784061455:
  H. Peter Anvin (1):
        x86, setup: ACPI 3, BIOS workaround for E820-probing code

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-setup-for-linus

H. Peter Anvin (1):
      x86, setup: guard against pre-ACPI 3 e820 code not updating %ecx

 arch/x86/boot/memory.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

commit cd670599b7b00d9263f6f11a05c0edeb9cbedaf3
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Wed Apr 1 11:35:00 2009 -0700

    x86, setup: guard against pre-ACPI 3 e820 code not updating %ecx
    
    Impact: BIOS bug safety
    
    For pre-ACPI 3 BIOSes, pre-initialize the end of the e820 buffer just
    in case the BIOS returns an unchanged %ecx but without actually
    touching the ACPI 3 extended flags field.
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/x86/boot/memory.c b/arch/x86/boot/memory.c
index d5d2360..5054c2d 100644
--- a/arch/x86/boot/memory.c
+++ b/arch/x86/boot/memory.c
@@ -31,6 +31,12 @@ static int detect_memory_e820(void)
 	struct e820entry *desc = boot_params.e820_map;
 	static struct e820_ext_entry buf; /* static so it is zeroed */
 
+	/*
+	 * Set this here so that if the BIOS doesn't change this field
+	 * but still doesn't change %ecx, we're still okay...
+	 */
+	buf.ext_flags = 1;
+
 	do {
 		size = sizeof buf;
 
