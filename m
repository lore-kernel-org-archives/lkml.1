Return-Path: <linux-kernel-owner+w=401wt.eu-S933189AbYEHS4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189AbYEHS4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 14:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757500AbYEHS42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 14:56:28 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:33384 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbYEHS41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 14:56:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=I4B01iBgIBr5QQtITUQYJdmMobAUkRwMiKGMQqg2tDHXCRkkPSSnfaZ9kr97e8SPkZxKlkelUXzBrLuVHdy2phwerrnyvggN4jHgwEjfHpbz++Rovo6pDvxXEXmNBDl6ZO5Pg5tjgTbwwERkMRuJiL4ngL9d3UpLa8IQBGWTZrk=
Date: Thu, 8 May 2008 20:56:21 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: [PATCH] kmemcheck: custom queue size and overflow detection
Message-ID: <20080508185621.GB3102@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is also missing from x86.git. Thanks.

Vegard


>From 7966e04efed4c52bc0d09e8aa5ae47e9aa225a6a Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Thu, 1 May 2008 19:26:06 +0200
Subject: [PATCH] kmemcheck: custom queue size and overflow detection

Add an option to Kconfig to set the size of the queue/buffer which
kmemcheck uses to report errors. Also keep count on how many times this
buffer was overflowed (e.g. the number of "lost reports") so this can be
printed as well.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/Kconfig.debug      |   11 +++++++++++
 arch/x86/kernel/kmemcheck.c |   14 ++++++++++++--
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 5d3e83a..255d054 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -287,6 +287,17 @@ config KMEMCHECK_ONESHOT_BY_DEFAULT
 
 endchoice
 
+config KMEMCHECK_QUEUE_SIZE
+	int "kmemcheck: error queue size"
+	depends on KMEMCHECK
+	default 64
+	help
+	  Select the maximum number of errors to store in the queue. This
+	  queue will be emptied once every second, so this is effectively a
+	  limit on how many reports to print in one go. Note however, that
+	  if the number of errors occuring between two bursts is larger than
+	  this number, the extra error reports will get lost.
+
 config KMEMCHECK_PARTIAL_OK
 	bool "kmemcheck: allow partially uninitialized memory"
 	depends on KMEMCHECK
diff --git a/arch/x86/kernel/kmemcheck.c b/arch/x86/kernel/kmemcheck.c
index 408ba6d..ebdbe20 100644
--- a/arch/x86/kernel/kmemcheck.c
+++ b/arch/x86/kernel/kmemcheck.c
@@ -61,10 +61,11 @@ struct kmemcheck_error {
  * from the kmemcheck traps, since this may call the console drivers and
  * result in a recursive fault.
  */
-static struct kmemcheck_error error_fifo[32];
+static struct kmemcheck_error error_fifo[CONFIG_KMEMCHECK_QUEUE_SIZE];
 static unsigned int error_count;
 static unsigned int error_rd;
 static unsigned int error_wr;
+static unsigned int error_missed_count;
 
 static struct timer_list kmemcheck_timer;
 
@@ -73,8 +74,10 @@ error_next_wr(void)
 {
 	struct kmemcheck_error *e;
 
-	if (error_count == ARRAY_SIZE(error_fifo))
+	if (error_count == ARRAY_SIZE(error_fifo)) {
+		++error_missed_count;
 		return NULL;
+	}
 
 	e = &error_fifo[error_wr];
 	if (++error_wr == ARRAY_SIZE(error_fifo))
@@ -194,6 +197,13 @@ do_wakeup(unsigned long data)
 {
 	while (error_count > 0)
 		error_recall();
+
+	if (error_missed_count > 0) {
+		printk(KERN_WARNING "kmemcheck: Lost %d error reports because "
+			"the queue was too small\n", error_missed_count);
+		error_missed_count = 0;
+	}
+
 	mod_timer(&kmemcheck_timer, kmemcheck_timer.expires + HZ);
 }
 
-- 
1.5.4.1

