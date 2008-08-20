Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbYHTKxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbYHTKxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 06:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbYHTKxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 06:53:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34209 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbYHTKxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 06:53:44 -0400
Date: Wed, 20 Aug 2008 12:53:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, tglx@linutronix.de, hpa@zytor.com,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] merge io_apic_xx.c -- fix
Message-ID: <20080820105313.GA18524@elte.hu>
References: <1218881249-3028-1-git-send-email-yhlu.kernel@gmail.com> <20080816133554.GB11063@elte.hu> <20080819152156.c79f31e4.randy.dunlap@oracle.com> <86802c440808191724j68f50b1fx7b2488963fcf96fd@mail.gmail.com> <20080819172757.63b16451.akpm@linux-foundation.org> <48AB6628.8060409@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48AB6628.8060409@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Crud, I had a copy-paste error.  There are also printk format warnings
> in io_apic_64.c:
> 
> linux-next-20080819/arch/x86/kernel/io_apic_64.c:1284: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'long unsigned int'
> linux-next-20080819/arch/x86/kernel/io_apic_64.c:1285: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'long unsigned int

i have the commit below queued up in tip/irq/sparseirq.

	Ingo

-------------->
>From 0a7c144ca555c86b8410f2d6e1c10bf14fd481d1 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 18 Aug 2008 13:04:26 +0200
Subject: [PATCH] warning: fix arch x86 kernel io_apic c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

fix warning:

  arch/x86/kernel/io_apic.c: In function ‘print_local_APIC’:
  arch/x86/kernel/io_apic.c:1786: warning: format ‘%08x’ expects type ‘unsigned int’, but argument 2 has type ‘u64’
  arch/x86/kernel/io_apic.c:1787: warning: format ‘%08x’ expects type ‘unsigned int’, but argument 2 has type ‘u64’

By creating uniform behavior on 32-bit and 64-bit and printing out the ICR
value in two 32-bit words.

Code has changed:

   text	   data	    bss	    dec	    hex	filename
  22901	  19650	  17040	  59591	   e8c7	io_apic.o.before
  22899	  19650	  17040	  59589	   e8c5	io_apic.o.after

Due to the 32-bit cast narrowing the printed out value on 64-bit.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/io_apic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index f7e8026..34c74cf 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -1774,8 +1774,8 @@ __apicdebuginit(void) print_local_APIC(void *dummy)
 	}
 
 	icr = apic_icr_read();
-	printk(KERN_DEBUG "... APIC ICR: %08x\n", icr);
-	printk(KERN_DEBUG "... APIC ICR2: %08x\n", icr >> 32);
+	printk(KERN_DEBUG "... APIC ICR: %08x\n", (u32)icr);
+	printk(KERN_DEBUG "... APIC ICR2: %08x\n", (u32)(icr >> 32));
 
 	v = apic_read(APIC_LVTT);
 	printk(KERN_DEBUG "... APIC LVTT: %08x\n", v);
