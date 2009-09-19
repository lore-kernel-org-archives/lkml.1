Return-Path: <linux-kernel-owner+w=401wt.eu-S1751607AbZISSD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbZISSD3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 14:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbZISSD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 14:03:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:60601 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbZISSD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 14:03:28 -0400
Message-ID: <4AB51CA2.9010608@kernel.org>
Date: Sat, 19 Sep 2009 11:02:10 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zachary Amsden <zach@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Xiao Guangrong <xiaooguangrong@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: linux-next: reservetop fix disables mem=
References: <Pine.LNX.4.64.0908241736520.32764@sister.anvils> <4A92D029.8090807@kernel.org> <20090824182713.GB9785@elte.hu> <Pine.LNX.4.64.0909160117260.6814@sister.anvils> <20090919175504.GJ5366@elte.hu>
In-Reply-To: <20090919175504.GJ5366@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> I thoroughly zapped it. Do you know about any commit ID where it snuck 
> in?

after close looking, it will break
1. some cpu feature  in early stage too, like cpu_has_x2apic
2. will break built-in-command line
3. will break other memmap= and mem=
4. early_dbgp and early_console that will use early_ioremap to access mmio (?)

YH

commit 8126dec32738421afa362114337331337b4be17f
Author: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Date:   Thu Aug 20 20:23:11 2009 +0800

    x86: Fix system crash when loading with "reservetop" parameter
    
    The system will die if the kernel is booted with "reservetop"
    parameter, in present code, parse "reservetop" parameter after
    early_ioremap_init(), and some function still use
    early_ioremap() after it.
    
    The problem is, "reservetop" parameter can modify
    'FIXADDR_TOP', then the virtual address got by early_ioremap()
    is base on old 'FIXADDR_TOP', but the page mapping is base on
    new 'FIXADDR_TOP', it will occur page fault, and the IDT is not
    prepare yet, so, the system is dead.
    
    So, put parse_early_param() in the front of
    early_ioremap_init() in this patch.
    
    Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
    Cc: yinghai@kernel.org
    Cc: Andrew Morton <akpm@linux-foundation.org>
    LKML-Reference: <4A8D402F.4080805@cn.fujitsu.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 63f32d2..02643cc 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -711,6 +711,11 @@ void __init setup_arch(char **cmdline_p)
        printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif
 
+       strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
+       *cmdline_p = command_line;
+
+       parse_early_param();
+
        /* VMI may relocate the fixmap; do this before touching ioremap area */
        vmi_init();
 
@@ -793,11 +798,6 @@ void __init setup_arch(char **cmdline_p)
 #endif
 #endif
 
-       strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
-       *cmdline_p = command_line;
-
-       parse_early_param();
-
 #ifdef CONFIG_X86_64
        check_efer();
 #endif


