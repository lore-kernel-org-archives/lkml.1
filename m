Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbYBXXcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbYBXXcs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 18:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbYBXXck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 18:32:40 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:52165 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751224AbYBXXcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 18:32:39 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.25-rc3
Date: Mon, 25 Feb 2008 01:29:15 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kmcmartin@redhat.com, lguest@ozlabs.org, rusty@rustcorp.com.au
References: <alpine.LFD.1.00.0802241354200.14934@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802241354200.14934@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802250129.17526.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

25 Şub 2008 Pts tarihinde, Linus Torvalds şunları yazmıştı: 
> 
> Ok, it's out there, ready for your enjoyment.
[...] 
> So give it a good testing, please,

-rc3 still fails for this [1] config

ERROR: "LGUEST_PAGES_guest_gdt_desc" [drivers/lguest/lg.ko] undefined!
ERROR: "LGUEST_PAGES_host_gdt_desc" [drivers/lguest/lg.ko] undefined!
ERROR: "LGUEST_PAGES_host_cr3" [drivers/lguest/lg.ko] undefined!
ERROR: "LGUEST_PAGES_regs" [drivers/lguest/lg.ko] undefined!
ERROR: "LGUEST_PAGES_host_idt_desc" [drivers/lguest/lg.ko] undefined!
ERROR: "LGUEST_PAGES_guest_gdt" [drivers/lguest/lg.ko] undefined!
ERROR: "LGUEST_PAGES_host_sp" [drivers/lguest/lg.ko] undefined!
ERROR: "LGUEST_PAGES_regs_trapnum" [drivers/lguest/lg.ko] undefined!
ERROR: "LGUEST_PAGES_guest_idt_desc" [drivers/lguest/lg.ko] undefined!

and following patch by Kyle McMartin solves this issue, this patch posted on 20 Feb to LKML but not CC'd to you.

From: Kyle McMartin <kyle@mcmartin.ca>

lguest uses asm-offsets to generate ... offsets, obviously, for use
in the lguest switcher code. When the hypervisor code is built as a
module though, the asm offsets it needs won't be generated since
CONFIG_LGUEST will be undefined.

Signed-off-by: Kyle McMartin <kmcmartin@redhat.com>

---
diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index a33d530..44bafdd 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -134,7 +134,7 @@ void foo(void)
        OFFSET(LGUEST_DATA_pgdir, lguest_data, pgdir);
 #endif
 
-#ifdef CONFIG_LGUEST
+#if defined(CONFIG_LGUEST) || defined(CONFIG_LGUEST_MODULE)
        BLANK();
        OFFSET(LGUEST_PAGES_host_gdt_desc, lguest_pages, state.host_gdt_desc);
        OFFSET(LGUEST_PAGES_host_idt_desc, lguest_pages, state.host_idt_desc);


[1] http://cekirdek.pardus.org.tr/~caglar/config.2.6.25-rc3
Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
