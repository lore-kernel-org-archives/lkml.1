Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbZASVrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbZASVrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 16:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759534AbZASVqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 16:46:48 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:36505 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759274AbZASVqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 16:46:47 -0500
Date: Mon, 19 Jan 2009 13:46:41 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Cc: yhlu.kernel@gmail.com, garyhade@us.ibm.com, lcm@us.ibm.com, x86@kernel.org
Subject: [PATCH] x86_64: remove kernel_physical_mapping_init() from init
	section
Message-ID: <20090119214641.GB7476@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


kernel_physical_mapping_init() is called during memory hotplug
so it does not belong in the init section.

If the kernel is built with CONFIG_DEBUG_SECTION_MISMATCH=y on
the make command line, arch/x86/mm/init_64.c is compiled with
the -fno-inline-functions-called-once gcc option defeating
inlining of kernel_physical_mapping_init() within init_memory_mapping().
When kernel_physical_mapping_init() is not inlined it is placed
in the .init.text section according to the __init in it's current
declaration.  A later call to kernel_physical_mapping_init() during
a memory hotplug operation encounters an int3 trap because the
.init.text section memory has been freed.  This patch eliminates
the crash caused by the int3 trap by moving the non-inlined
kernel_physical_mapping_init() from .init.text to .meminit.text.

Signed-off-by: Gary Hade <garyhade@us.ibm.com>

---

--- linux-2.6.29-rc2/arch/x86/mm/init_64.c.orig	2009-01-16 14:38:34.000000000 -0800
+++ linux-2.6.29-rc2/arch/x86/mm/init_64.c	2009-01-16 14:39:21.000000000 -0800
@@ -596,7 +596,7 @@ static void __init init_gbpages(void)
 		direct_gbpages = 0;
 }
 
-static unsigned long __init kernel_physical_mapping_init(unsigned long start,
+static unsigned long __meminit kernel_physical_mapping_init(unsigned long start,
 						unsigned long end,
 						unsigned long page_size_mask)
 {
