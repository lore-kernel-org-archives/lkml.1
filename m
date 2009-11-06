Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbZKFNAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbZKFNAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 08:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbZKFNAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 08:00:30 -0500
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:57853 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbZKFNA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 08:00:29 -0500
Message-ID: <1257512389.4af41dc504e1b@imp.free.fr>
Date: Fri, 06 Nov 2009 13:59:49 +0100
From: castet.matthieu@free.fr
To: linux-kernel@vger.kernel.org
Subject: Using x86 segments against NULL pointer deference exploit
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.8
X-Originating-IP: 213.41.129.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am wondering why we can't set the KERNEL_DS data segment to not contain the
first page, ie changing it from R/W flat model to R/W expand down from
0xffffffff to 4096.

The modification seems simple : change GDT_ENTRY_KERNEL_DS [1], and some
modification for syscall entry point that doesn't support segment (sysenter).

The drawback of this it that the kernel can't access anymore data in the first
segment. Is it needed for application like wine or dosemu ?


Regards,

Matthieu

PS : why x86_64 segment got access bit set and x86_32 doesn't ?

[1]
something like
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cc25c2b..898a569 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -101,7 +101,7 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = {
.gdt = {
 	[GDT_ENTRY_DEFAULT_USER_CS]	= GDT_ENTRY_INIT(0xa0fb, 0, 0xfffff),
 #else
 	[GDT_ENTRY_KERNEL_CS]		= GDT_ENTRY_INIT(0xc09a, 0, 0xfffff),
-	[GDT_ENTRY_KERNEL_DS]		= GDT_ENTRY_INIT(0xc092, 0, 0xfffff),
+	[GDT_ENTRY_KERNEL_DS]		= GDT_ENTRY_INIT(0xc096, 0, 0x00001),
 	[GDT_ENTRY_DEFAULT_USER_CS]	= GDT_ENTRY_INIT(0xc0fa, 0, 0xfffff),
 	[GDT_ENTRY_DEFAULT_USER_DS]	= GDT_ENTRY_INIT(0xc0f2, 0, 0xfffff),
 	/*
