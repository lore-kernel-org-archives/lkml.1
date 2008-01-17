Return-Path: <linux-kernel-owner+w=401wt.eu-S1759691AbYAQVsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759691AbYAQVsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758538AbYAQVmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:42:17 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:44825 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531AbYAQVmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:42:16 -0500
Date: Thu, 17 Jan 2008 16:40:50 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Daniel Walker <dwalker@mvista.com>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 19/20] UML - port mutex conversion
Message-ID: <20080117214050.GA6782@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walker <dwalker@mvista.com>

The port_sem is already used as a mutex since it's using DECLARE_MUTEX(),
but the underlying construct is still a semaphore .. This patch switches
it over to a struct mutex.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/port_kern.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6.22/arch/um/drivers/port_kern.c
===================================================================
--- linux-2.6.22.orig/arch/um/drivers/port_kern.c	2008-01-17 13:44:46.000000000 -0500
+++ linux-2.6.22/arch/um/drivers/port_kern.c	2008-01-17 13:47:39.000000000 -0500
@@ -6,6 +6,7 @@
 #include "linux/completion.h"
 #include "linux/interrupt.h"
 #include "linux/list.h"
+#include "linux/mutex.h"
 #include "asm/atomic.h"
 #include "init.h"
 #include "irq_kern.h"
@@ -120,7 +121,7 @@ static int port_accept(struct port_list 
 	return 0;
 }
 
-static DECLARE_MUTEX(ports_sem);
+static DEFINE_MUTEX(ports_mutex);
 static LIST_HEAD(ports);
 
 static void port_work_proc(struct work_struct *unused)
@@ -161,7 +162,7 @@ void *port_data(int port_num)
 	struct port_dev *dev = NULL;
 	int fd;
 
-	down(&ports_sem);
+	mutex_lock(&ports_mutex);
 	list_for_each(ele, &ports) {
 		port = list_entry(ele, struct port_list, list);
 		if (port->port == port_num)
@@ -216,7 +217,7 @@ void *port_data(int port_num)
  out_free:
 	kfree(port);
  out:
-	up(&ports_sem);
+	mutex_unlock(&ports_mutex);
 	return dev;
 }
 
