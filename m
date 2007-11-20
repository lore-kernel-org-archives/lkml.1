Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407AbXKTFO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbXKTFO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 00:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbXKTFOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 00:14:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:50558 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbXKTFOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 00:14:48 -0500
Date: Tue, 20 Nov 2007 06:14:47 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch] vt: bitlock fix
Message-ID: <20071120051447.GC18332@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Don't know who maintains vt.c, but Antonino's name comes up regularly ;)

--
vt is missing a memory barrier to close the critical section. Use a real
spinlock for this.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
Index: linux-2.6/drivers/char/vt.c
===================================================================
--- linux-2.6.orig/drivers/char/vt.c
+++ linux-2.6/drivers/char/vt.c
@@ -2400,13 +2400,15 @@ static void vt_console_print(struct cons
 {
 	struct vc_data *vc = vc_cons[fg_console].d;
 	unsigned char c;
-	static unsigned long printing;
+	static DEFINE_SPINLOCK(printing_lock);
 	const ushort *start;
 	ushort cnt = 0;
 	ushort myx;
 
 	/* console busy or not yet initialized */
-	if (!printable || test_and_set_bit(0, &printing))
+	if (!printable)
+		return;
+	if (!spin_trylock(&printing_lock))
 		return;
 
 	if (kmsg_redirect && vc_cons_allocated(kmsg_redirect - 1))
@@ -2481,7 +2483,7 @@ static void vt_console_print(struct cons
 	notify_update(vc);
 
 quit:
-	clear_bit(0, &printing);
+	spin_unlock(&printing_lock);
 }
 
 static struct tty_driver *vt_console_device(struct console *c, int *index)
