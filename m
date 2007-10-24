Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbXJXMfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbXJXMfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 08:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756280AbXJXMfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 08:35:11 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:46928 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbXJXMfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 08:35:10 -0400
X-IronPort-AV: i="4.21,324,1188792000"; 
   d="scan'208"; a="54767038:sNHT27509671"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: paulus@samba.org
Subject: history of extratext sections?
Date: Wed, 24 Oct 2007 08:36:13 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710240836.13412.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 24 Oct 2007 12:35:08.0492 (UTC) FILETIME=[4FED38C0:01C8163A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul:

I noticed that when passing a zero address to kallsyms_lookup(), the kernel 
thought it was a valid kernel address, even if it was not for the specific 
architecture I was running things on.

This was because is_kernel_extratext() was checking against labels that don't 
exist on many archs. Since PPC is the only kernel which defines _extra_text, 
(which doesn't seem to be used anymore?) there are three options:
 - make the check dependant on PPC
 - make the check dependant on extratext being populated
 - remove _extra_text support from:
    linux-2.6.x/arch/ppc/kernel/vmlinux.lds.S
    linux-2.6.x/include/asm-generic/sections.h
    linux-2.6.x/kernel/kallsyms.c
    linux-2.6.x/scripts/kallsyms.c

Since I don't know the history on that label I thought I would ask (since you 
seem to be the only arch using it) before I sent a patch.

-Robin

Because #1 & #2 are trivial, here is what I was thinking:

 - make the check dependant on PPC
===================================================================
--- linux-2.6.x/kernel/kallsyms.c       (revision 3760)
+++ linux-2.6.x/kernel/kallsyms.c       (working copy)
@@ -51,7 +51,8 @@
 static inline int is_kernel_extratext(unsigned long addr)
 {
+ #ifdef CONFIG_PPC
        if (addr >= (unsigned long)_sextratext
            && addr <= (unsigned long)_eextratext)
                return 1;
+ #endif
        return 0;
 }

OR 

 - make the check dependant on extratext being populated
===================================================================
--- linux-2.6.x/kernel/kallsyms.c       (revision 3760)
+++ linux-2.6.x/kernel/kallsyms.c       (working copy)
@@ -51,7 +51,8 @@
 static inline int is_kernel_extratext(unsigned long addr)
 {
        if (addr >= (unsigned long)_sextratext
-           && addr <= (unsigned long)_eextratext)
+           && addr <= (unsigned long)_eextratext
+           && _sextratext && _eextratext)
                return 1;
        return 0;
 }
