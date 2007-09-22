Return-Path: <linux-kernel-owner+w=401wt.eu-S1758362AbXIVElD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362AbXIVElD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 00:41:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbXIVEky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 00:40:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:2077 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbXIVEkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 00:40:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=sNHJkVICxkQTC5kR2hOutbuQAN/Q4mmdFyKok0I9dmAj9Kk9eIrmN7ABlXYctbXWy/JnpoVTwNgXRLMUjnboZIPP0DYesIWtnPHtXWHCBOWfpUT7pC/oIuauHkonD1TQ2rWg6dKe434PoqGCVKiM4ReSjG0D1T3d71X4QBvIv70=
Date: Sat, 22 Sep 2007 12:39:55 +0800
From: lepton <ytht.net@gmail.com>
To: jdike@karaya.com
Cc: lkm <linux-kernel@vger.kernel.org>
Subject: [PATCH] 2.6.22.6 user-mode linux: use address instead of value as argument in os_free_irq_by_cb
Message-ID: <20070922043955.GA4550@router.lepton.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  There is a bug in os_free_irq_by_cb, when the first element
  of active_fds list  is free, the value of active_fds is not
  updated, just value in stack is updated.

  The intresting thing is that without this patch, a poweroff
  in user mode linux guest will halt the host linux system.It
  seems that after the tracing thread is dead, the syscall to
  sys_reboot of the traced thread is executed by host. I don't
  know if it is another bug.

Signed-off-by: Lepton Wu <ytht.net@gmail.com>

diff -X linux-2.6.22.6/Documentation/dontdiff -pru linux-2.6.22.6/arch/um/include/os.h linux-2.6.22.6-lepton/arch/um/include/os.h
--- linux-2.6.22.6/arch/um/include/os.h	2007-09-14 17:41:10.000000000 +0800
+++ linux-2.6.22.6-lepton/arch/um/include/os.h	2007-09-22 12:15:28.000000000 +0800
@@ -325,7 +325,7 @@ extern void reboot_skas(void);
 extern int os_waiting_for_events(struct irq_fd *active_fds);
 extern int os_create_pollfd(int fd, int events, void *tmp_pfd, int size_tmpfds);
 extern void os_free_irq_by_cb(int (*test)(struct irq_fd *, void *), void *arg,
-		struct irq_fd *active_fds, struct irq_fd ***last_irq_ptr2);
+		struct irq_fd **active_fds_ptr, struct irq_fd ***last_irq_ptr2);
 extern void os_free_irq_later(struct irq_fd *active_fds,
 		int irq, void *dev_id);
 extern int os_get_pollfd(int i);
diff -X linux-2.6.22.6/Documentation/dontdiff -pru linux-2.6.22.6/arch/um/kernel/irq.c linux-2.6.22.6-lepton/arch/um/kernel/irq.c
--- linux-2.6.22.6/arch/um/kernel/irq.c	2007-09-14 17:41:10.000000000 +0800
+++ linux-2.6.22.6-lepton/arch/um/kernel/irq.c	2007-09-22 12:15:05.000000000 +0800
@@ -218,7 +218,7 @@ static void free_irq_by_cb(int (*test)(s
 	unsigned long flags;
 
 	spin_lock_irqsave(&irq_lock, flags);
-	os_free_irq_by_cb(test, arg, active_fds, &last_irq_ptr);
+	os_free_irq_by_cb(test, arg, &active_fds, &last_irq_ptr);
 	spin_unlock_irqrestore(&irq_lock, flags);
 }
 
diff -X linux-2.6.22.6/Documentation/dontdiff -pru linux-2.6.22.6/arch/um/os-Linux/irq.c linux-2.6.22.6-lepton/arch/um/os-Linux/irq.c
--- linux-2.6.22.6/arch/um/os-Linux/irq.c	2007-09-14 17:41:10.000000000 +0800
+++ linux-2.6.22.6-lepton/arch/um/os-Linux/irq.c	2007-09-22 12:15:42.000000000 +0800
@@ -84,12 +84,12 @@ int os_create_pollfd(int fd, int events,
 }
 
 void os_free_irq_by_cb(int (*test)(struct irq_fd *, void *), void *arg,
-		struct irq_fd *active_fds, struct irq_fd ***last_irq_ptr2)
+		struct irq_fd **active_fds_ptr, struct irq_fd ***last_irq_ptr2)
 {
 	struct irq_fd **prev;
 	int i = 0;
 
-	prev = &active_fds;
+	prev = active_fds_ptr;
 	while (*prev != NULL) {
 		if ((*test)(*prev, arg)) {
 			struct irq_fd *old_fd = *prev;
