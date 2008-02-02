Return-Path: <linux-kernel-owner+w=401wt.eu-S1763813AbYBBWMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763813AbYBBWMt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 17:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbYBBWMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 17:12:40 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:30176 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbYBBWMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:12:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=qgLgmavzibaOvTYGg8m5+hqyhb3do47Y1d5e/9UbSRctNLauoroftFpNNl/BSHQZBxJu0JN2jS8aCUMROe/qQF7xlM2gZb6rv9KN/8y+CoMXJL6GbmgrMq+EqwoWr0a3tfvCHZPf6X+NQLmc5+dvJcavIR8uZDZx5qfuxkrdwaI=
Date: Sun, 3 Feb 2008 01:12:11 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC] x86: setup code_bytes - use mask to restrict it's size
Message-ID: <20080202221211.GA6749@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch strips off 8 bytes from text section. Not a really
big advantage (especially for __init section). It seems 8192
bytes of disassembled code is rare used anyway.

before:
	text    data     bss     dec     hex filename
	9900     176      20   10096    2770 arch/x86/kernel/traps_64.o.old
after:
	text    data     bss     dec     hex filename
	9892     176      20   10088    2768 arch/x86/kernel/traps_64.o

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

If there is no benefit at all - just drop the patch.
Any comments are welcome ;)

Index: linux-2.6.git/arch/x86/kernel/traps_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/traps_32.c	2008-02-02 23:52:16.000000000 +0300
+++ linux-2.6.git/arch/x86/kernel/traps_32.c	2008-02-03 00:39:58.000000000 +0300
@@ -1229,8 +1229,9 @@ __setup("kstack=", kstack_setup);
 static int __init code_bytes_setup(char *s)
 {
 	code_bytes = simple_strtoul(s, NULL, 0);
-	if (code_bytes > 8192)
-		code_bytes = 8192;
+
+	/* we don't want too long code-dump */
+	code_bytes &= 8191;
 
 	return 1;
 }
Index: linux-2.6.git/arch/x86/kernel/traps_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/traps_64.c	2008-02-02 23:52:16.000000000 +0300
+++ linux-2.6.git/arch/x86/kernel/traps_64.c	2008-02-03 00:38:10.000000000 +0300
@@ -1196,8 +1196,9 @@ early_param("kstack", kstack_setup);
 static int __init code_bytes_setup(char *s)
 {
 	code_bytes = simple_strtoul(s, NULL, 0);
-	if (code_bytes > 8192)
-		code_bytes = 8192;
+
+	/* we don't want too long code-dump */
+	code_bytes &= 8191;
 
 	return 1;
 }
