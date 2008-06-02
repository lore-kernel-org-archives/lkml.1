Return-Path: <linux-kernel-owner+w=401wt.eu-S1753072AbYFBLRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbYFBLRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 07:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbYFBLRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 07:17:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33824 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321AbYFBLRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 07:17:44 -0400
Date: Mon, 2 Jun 2008 13:17:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 08 of 12] xen-console: add save/restore
Message-ID: <20080602111720.GC18586@elte.hu>
References: <patchbomb.1211550067@localhost> <d9561e802a69a3ca269c.1211550075@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9561e802a69a3ca269c.1211550075@localhost>
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


-tip testing found the following xen-console symbols trouble:

 ERROR: "console_drivers" [drivers/video/xen-fbfront.ko] undefined!
 ERROR: "get_phys_to_machine" [drivers/video/xen-fbfront.ko] undefined!
 ERROR: "get_phys_to_machine" [drivers/net/xen-netfront.ko] undefined!
 ERROR: "get_phys_to_machine" [drivers/input/xen-kbdfront.ko] undefined!

with:

  http://redhat.com/~mingo/misc/config-Mon_Jun__2_12_26_38_CEST_2008.bad

get_phys_to_machine can indeed be exported but i'm less sure about the 
console_drivers export ... The temporary fix below resolves it for now.

	Ingo

------------->
Subject: xen: build fixes
From: Ingo Molnar <mingo@elte.hu>
Date: Mon Jun 02 13:13:04 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/xen/mmu.c |    1 +
 kernel/printk.c    |    2 ++
 2 files changed, 3 insertions(+)

Index: linux/arch/x86/xen/mmu.c
===================================================================
--- linux.orig/arch/x86/xen/mmu.c
+++ linux/arch/x86/xen/mmu.c
@@ -136,6 +136,7 @@ unsigned long get_phys_to_machine(unsign
 	idx = p2m_index(pfn);
 	return p2m_top[topidx][idx];
 }
+EXPORT_SYMBOL_GPL(get_phys_to_machine);
 
 static void alloc_p2m(unsigned long **pp, unsigned long *mfnp)
 {
Index: linux/kernel/printk.c
===================================================================
--- linux.orig/kernel/printk.c
+++ linux/kernel/printk.c
@@ -76,6 +76,8 @@ EXPORT_SYMBOL(oops_in_progress);
 static DECLARE_MUTEX(console_sem);
 static DECLARE_MUTEX(secondary_console_sem);
 struct console *console_drivers;
+EXPORT_SYMBOL_GPL(console_drivers);
+
 /*
  * This is used for debugging the mess that is the VT code by
  * keeping track if we have the console semaphore held. It's
