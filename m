Return-Path: <linux-kernel-owner+w=401wt.eu-S1755348AbXH1KEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbXH1KEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 06:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbXH1KEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 06:04:40 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:25604
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751169AbXH1KEj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 06:04:39 -0400
Message-Id: <46D40F73.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 28 Aug 2007 11:05:07 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] handle recursive calls to bust_spinlocks()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Various architectures may call bust_spinlocks() recursively; the
function itself, however, doesn't appear to be meant to be called in
this manner. Nevertheless, this doesn't appear to be a problem as long
as bust_spinlocks(0) doesn't get called twice in a row (otherwise,
unblank_screen() may enter the scheduler). However, at least on i386
die() has been capable of returning (and on other architectures this
should really be that way, too) when notify_die() returns NOTIFY_STOP.

Short of getting a reply to a respective query, this patch makes
bust_spinlocks() increment/decrement oops_in_progress, and wake klogd
only when the count drops back to zero.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 lib/bust_spinlocks.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc4/lib/bust_spinlocks.c	2007-04-26 05:08:32.000000000 +0200
+++ 2.6.23-rc4-recursive-bust-spinlocks/lib/bust_spinlocks.c	2007-08-17 15:07:14.000000000 +0200
@@ -17,13 +17,13 @@
 void __attribute__((weak)) bust_spinlocks(int yes)
 {
 	if (yes) {
-		oops_in_progress = 1;
+		++oops_in_progress;
 	} else {
 #ifdef CONFIG_VT
 		unblank_screen();
 #endif
-		oops_in_progress = 0;
-		wake_up_klogd();
+		if (--oops_in_progress == 0)
+			wake_up_klogd();
 	}
 }
 



