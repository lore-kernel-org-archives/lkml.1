Return-Path: <linux-kernel-owner+w=401wt.eu-S1161306AbXDSIPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161306AbXDSIPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 04:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161224AbXDSIOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 04:14:54 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33957 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993209AbXDSINs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 04:13:48 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH] macintosh/therm_windtunnel.c: Convert to kthread API.
Date: Thu, 19 Apr 2007 01:58:48 -0600
Message-Id: <11769695873569-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.1.1.g2de0
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Start the g4fand using kthread_run not a combination
of kernel_thread and deamonize.  This makes the code
a little simpler and more maintainable.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/macintosh/therm_windtunnel.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
index a1d3a98..5d888e7 100644
--- a/drivers/macintosh/therm_windtunnel.c
+++ b/drivers/macintosh/therm_windtunnel.c
@@ -36,6 +36,7 @@
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/init.h>
+#include <linux/kthread.h>
 
 #include <asm/prom.h>
 #include <asm/machdep.h>
@@ -62,7 +63,6 @@ I2C_CLIENT_INSMOD;
 static struct {
 	volatile int		running;
 	struct completion	completion;
-	pid_t			poll_task;
 	
 	struct semaphore 	lock;
 	struct of_device	*of_dev;
@@ -285,7 +285,6 @@ restore_regs( void )
 static int
 control_loop( void *dummy )
 {
-	daemonize("g4fand");
 
 	down( &x.lock );
 	setup_hardware();
@@ -323,7 +322,7 @@ do_attach( struct i2c_adapter *adapter )
 		if( x.thermostat && x.fan ) {
 			x.running = 1;
 			init_completion( &x.completion );
-			x.poll_task = kernel_thread( control_loop, NULL, SIGCHLD | CLONE_KERNEL );
+			kthread_run( control_loop, NULL, "g4fand");
 		}
 	}
 	return ret;
-- 
1.5.0.g53756

