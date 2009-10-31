Return-Path: <linux-kernel-owner+w=401wt.eu-S933405AbZJaXWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933405AbZJaXWS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 19:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933343AbZJaXWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 19:22:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59440 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933328AbZJaXWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 19:22:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Help needed, Re: [Bug #14334] pcmcia suspend regression from 2.6.31.1 to 2.6.31.2 - Dell Inspiron 600m
Date: Sun, 1 Nov 2009 00:24:11 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, Jose Marino <braket@hotmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <1257029775.7907.21.camel@pasglop> <200911010010.07394.rjw@sisk.pl>
In-Reply-To: <200911010010.07394.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911010024.12081.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 November 2009, Rafael J. Wysocki wrote:
> On Saturday 31 October 2009, Benjamin Herrenschmidt wrote:
> > On Sat, 2009-10-31 at 22:27 +0100, Rafael J. Wysocki wrote:
> > 
> > > In the meantime I invented a patch that works, ie. apparently fixes the problem
> > > and if there was a card in the socket during the suspend, it's standard config
> > > space is restored correctly.  I tested it on one of my boxes with two different
> > > CardBus adapters and Jose says it fixes the problem for him.
> > > 
> > > The patch is appended, please have a look.
> > 
> > Base idea of the patch sounds good, quick browse through looks good too,
> > 
> > I'll try to band on it with various PCMCIA & CB gear tomorrow.
> 
> Wait, I made a mistake when testing it, didn't notice that my distro ejected
> PCMCIA cards automatically before suspend (sigh).
> 
> Working on a better patch right now, will hopefully post it in a while.

Here you go.

Waiting for feedback from the reporters of BKO #14334, so there's no sign-off
for now.

---
 drivers/pcmcia/cs.c           |   79 ++++++++++++++++++++++++++++--------------
 drivers/pcmcia/yenta_socket.c |   12 +++++-
 include/pcmcia/ss.h           |    4 ++
 3 files changed, 68 insertions(+), 27 deletions(-)

Index: linux-2.6/drivers/pcmcia/yenta_socket.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/yenta_socket.c
+++ linux-2.6/drivers/pcmcia/yenta_socket.c
@@ -1275,16 +1275,26 @@ static int yenta_dev_resume_noirq(struct
 	if (socket->type && socket->type->restore_state)
 		socket->type->restore_state(socket);
 
-	return pcmcia_socket_dev_resume(dev);
+	pcmcia_socket_dev_early_resume(dev);
+	return 0;
+}
+
+static int yenta_dev_resume(struct device *dev)
+{
+	pcmcia_socket_dev_late_resume(dev);
+	return 0;
 }
 
 static struct dev_pm_ops yenta_pm_ops = {
 	.suspend_noirq = yenta_dev_suspend_noirq,
 	.resume_noirq = yenta_dev_resume_noirq,
+	.resume = yenta_dev_resume,
 	.freeze_noirq = yenta_dev_suspend_noirq,
 	.thaw_noirq = yenta_dev_resume_noirq,
+	.thaw = yenta_dev_resume,
 	.poweroff_noirq = yenta_dev_suspend_noirq,
 	.restore_noirq = yenta_dev_resume_noirq,
+	.restore = yenta_dev_resume,
 };
 
 #define YENTA_PM_OPS	(&yenta_pm_ops)
Index: linux-2.6/drivers/pcmcia/cs.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/cs.c
+++ linux-2.6/drivers/pcmcia/cs.c
@@ -98,10 +98,13 @@ EXPORT_SYMBOL(pcmcia_socket_list_rwsem);
  * These functions check for the appropriate struct pcmcia_soket arrays,
  * and pass them to the low-level functions pcmcia_{suspend,resume}_socket
  */
+static int socket_early_resume(struct pcmcia_socket *skt);
+static int socket_late_resume(struct pcmcia_socket *skt);
 static int socket_resume(struct pcmcia_socket *skt);
 static int socket_suspend(struct pcmcia_socket *skt);
 
-int pcmcia_socket_dev_suspend(struct device *dev)
+static void pcmcia_socket_dev_run(struct device *dev,
+				  int (*cb)(struct pcmcia_socket *))
 {
 	struct pcmcia_socket *socket;
 
@@ -110,29 +113,34 @@ int pcmcia_socket_dev_suspend(struct dev
 		if (socket->dev.parent != dev)
 			continue;
 		mutex_lock(&socket->skt_mutex);
-		socket_suspend(socket);
+		cb(socket);
 		mutex_unlock(&socket->skt_mutex);
 	}
 	up_read(&pcmcia_socket_list_rwsem);
+}
 
+int pcmcia_socket_dev_suspend(struct device *dev)
+{
+	pcmcia_socket_dev_run(dev, socket_suspend);
 	return 0;
 }
 EXPORT_SYMBOL(pcmcia_socket_dev_suspend);
 
-int pcmcia_socket_dev_resume(struct device *dev)
+void pcmcia_socket_dev_early_resume(struct device *dev)
 {
-	struct pcmcia_socket *socket;
+	pcmcia_socket_dev_run(dev, socket_early_resume);
+}
+EXPORT_SYMBOL(pcmcia_socket_dev_early_resume);
 
-	down_read(&pcmcia_socket_list_rwsem);
-	list_for_each_entry(socket, &pcmcia_socket_list, socket_list) {
-		if (socket->dev.parent != dev)
-			continue;
-		mutex_lock(&socket->skt_mutex);
-		socket_resume(socket);
-		mutex_unlock(&socket->skt_mutex);
-	}
-	up_read(&pcmcia_socket_list_rwsem);
+void pcmcia_socket_dev_late_resume(struct device *dev)
+{
+	pcmcia_socket_dev_run(dev, socket_late_resume);
+}
+EXPORT_SYMBOL(pcmcia_socket_dev_late_resume);
 
+int pcmcia_socket_dev_resume(struct device *dev)
+{
+	pcmcia_socket_dev_run(dev, socket_resume);
 	return 0;
 }
 EXPORT_SYMBOL(pcmcia_socket_dev_resume);
@@ -546,29 +554,34 @@ static int socket_suspend(struct pcmcia_
 	return 0;
 }
 
-/*
- * Resume a socket.  If a card is present, verify its CIS against
- * our cached copy.  If they are different, the card has been
- * replaced, and we need to tell the drivers.
- */
-static int socket_resume(struct pcmcia_socket *skt)
+static void socket_start_resume(struct pcmcia_socket *skt)
 {
-	int ret;
-
-	if (!(skt->state & SOCKET_SUSPEND))
-		return -EBUSY;
-
 	skt->socket = dead_socket;
 	skt->ops->init(skt);
 	skt->ops->set_socket(skt, &skt->socket);
+	if (skt->state & SOCKET_PRESENT)
+		skt->resume_status = socket_setup(skt, resume_delay);
+}
+
+static int socket_early_resume(struct pcmcia_socket *skt)
+{
+	if (skt->state & SOCKET_SUSPEND)
+		socket_start_resume(skt);
+
+	return 0;
+}
+
+static int socket_late_resume(struct pcmcia_socket *skt)
+{
+	if (!(skt->state & SOCKET_SUSPEND))
+		return 0;
 
 	if (!(skt->state & SOCKET_PRESENT)) {
 		skt->state &= ~SOCKET_SUSPEND;
 		return socket_insert(skt);
 	}
 
-	ret = socket_setup(skt, resume_delay);
-	if (ret == 0) {
+	if (skt->resume_status == 0) {
 		/*
 		 * FIXME: need a better check here for cardbus cards.
 		 */
@@ -596,6 +609,20 @@ static int socket_resume(struct pcmcia_s
 	return 0;
 }
 
+/*
+ * Resume a socket.  If a card is present, verify its CIS against
+ * our cached copy.  If they are different, the card has been
+ * replaced, and we need to tell the drivers.
+ */
+static int socket_resume(struct pcmcia_socket *skt)
+{
+	if (!(skt->state & SOCKET_SUSPEND))
+		return -EBUSY;
+
+	socket_start_resume(skt);
+	return socket_late_resume(skt);
+}
+
 static void socket_remove(struct pcmcia_socket *skt)
 {
 	dev_printk(KERN_NOTICE, &skt->dev,
Index: linux-2.6/include/pcmcia/ss.h
===================================================================
--- linux-2.6.orig/include/pcmcia/ss.h
+++ linux-2.6/include/pcmcia/ss.h
@@ -262,6 +262,8 @@ struct pcmcia_socket {
 	struct device			dev;
 	/* data internal to the socket driver */
 	void				*driver_data;
+	/* status of the card during resume from a system sleep state */
+	int				resume_status;
 };
 
 
@@ -280,6 +282,8 @@ extern struct pccard_resource_ops pccard
 
 /* socket drivers are expected to use these callbacks in their .drv struct */
 extern int pcmcia_socket_dev_suspend(struct device *dev);
+extern void pcmcia_socket_dev_early_resume(struct device *dev);
+extern void pcmcia_socket_dev_late_resume(struct device *dev);
 extern int pcmcia_socket_dev_resume(struct device *dev);
 
 /* socket drivers use this callback in their IRQ handler */
