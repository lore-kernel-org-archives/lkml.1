Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbZKBNiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbZKBNiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 08:38:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755218AbZKBNiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 08:38:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37496 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126AbZKBNh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 08:37:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Help needed, Re: [Bug #14334] pcmcia suspend regression from 2.6.31.1 to 2.6.31.2 - Dell Inspiron 600m
Date: Mon, 2 Nov 2009 14:39:28 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, Jose Marino <braket@hotmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <200911010936.10409.rjw@sisk.pl> <alpine.LFD.2.01.0911010914100.31845@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0911010914100.31845@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911021439.28266.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 November 2009, Linus Torvalds wrote:
> 
> On Sun, 1 Nov 2009, Rafael J. Wysocki wrote:
> > 
> > If people don't object, I'll push it through the suspend-2.6 tree along 
> > with a few other bug fixes.
> 
> No objections, but a cleanup request:
> 
> > +static int socket_early_resume(struct pcmcia_socket *skt)
> > +{
> > +	if (skt->state & SOCKET_SUSPEND)
> > +		socket_start_resume(skt);
> > +
> > +	return 0;
> > +}
> > +
> > +static int socket_late_resume(struct pcmcia_socket *skt)
> > +{
> > +	if (!(skt->state & SOCKET_SUSPEND))
> > +		return 0;
> 
> As far as I can tell, that "SOCKET_SUSPEND" test is totally pointless. 

Right.

> That socket _is_ going to be suspended, and testing for it here just seems 
> to confuse things. 
> 
> So I'd remove it from both early_resume and late_resume, and only keep it 
> in the case of the legacy user-requested suspend/resume (do we even do 
> that any more?).

OK, updated patch is appended.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / yenta: Split resume into early and late parts (rev. 3)

Commit 0c570cdeb8fdfcb354a3e9cd81bfc6a09c19de0c
(PM / yenta: Fix cardbus suspend/resume regression) caused resume to
fail on systems with two CardBus bridges.  While the exact nature
of the failure is not known at the moment, it can be worked around by
splitting the yenta resume into an early part, executed during the
early phase of resume, that will only resume the socket and power it
up if there was a card in it during suspend, and a late part,
executed during "regular" resume, that will carry out all of the
remaining yenta resume operations.

Fixes http://bugzilla.kernel.org/show_bug.cgi?id=14334, which is a
listed regression from 2.6.31.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pcmcia/cs.c           |   74 +++++++++++++++++++++++++++---------------
 drivers/pcmcia/yenta_socket.c |   12 ++++++
 include/pcmcia/ss.h           |    4 ++
 3 files changed, 63 insertions(+), 27 deletions(-)

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
@@ -546,29 +554,29 @@ static int socket_suspend(struct pcmcia_
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
 
+static int socket_early_resume(struct pcmcia_socket *skt)
+{
+	socket_start_resume(skt);
+	return 0;
+}
+
+static int socket_late_resume(struct pcmcia_socket *skt)
+{
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
@@ -596,6 +604,20 @@ static int socket_resume(struct pcmcia_s
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
