Return-Path: <linux-kernel-owner+w=401wt.eu-S933308AbZJaVZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933308AbZJaVZg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 17:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933287AbZJaVZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 17:25:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59131 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933273AbZJaVZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 17:25:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Help needed, Re: [Bug #14334] pcmcia suspend regression from 2.6.31.1 to 2.6.31.2 - Dell Inspiron 600m
Date: Sat, 31 Oct 2009 22:27:15 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, Jose Marino <braket@hotmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <200910311031.17660.rjw@sisk.pl> <1257022890.7907.14.camel@pasglop>
In-Reply-To: <1257022890.7907.14.camel@pasglop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910312227.15493.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 October 2009, Benjamin Herrenschmidt wrote:
> On Sat, 2009-10-31 at 10:31 +0100, Rafael J. Wysocki wrote:
> 
> > > To me the proper approach would be to split it so that
> > 
> > Well, agreed, but ...
> > 
> > >  - early_resume() restores power & config space etc... so that existing
> > > devices can move on (might check for removal). There's no other hotplug
> > > activity
> > 
> > ... that's exactly what doesn't work at the moment.
> 
> BTW. This is a PCMCIA problem, a Cardbus or both ?

I _think_ it's a CardBus problem.  Evidently, it only happens if the second
CardBus bridge is resumed right after the first one (which resumes entirely
correctly) and only if that happens in the early resume phase (ie. before
resume_device_irqs()).

> I'll see if I can dig something on monday ?

In the meantime I invented a patch that works, ie. apparently fixes the problem
and if there was a card in the socket during the suspend, it's standard config
space is restored correctly.  I tested it on one of my boxes with two different
CardBus adapters and Jose says it fixes the problem for him.

The patch is appended, please have a look.

> >From the little email history I caught, it smells like pcmcia old style.
> 
> I don't see a problem per-se with the mutex usage with the new interrupt
> masking style as Linus says. socket_resume() also looks reasonably sane,
> it's the whole handling of removal that should be deferred.

In the failing case we don't even get there.  There are two CardBus bridges in
the system, but both sockets are empty, so we take the socket_insert() code
path.

> Maybe instead of doing socket_remove_drivers()...send_event() etc.. in there,
> we could simply just shut the socket down (PCMCIA drivers should cope
> with sockets returning ffff's for a short amount of time), flag it dead
> in skt->state and have the "late" resume  actually fire off the driver
> removal and sending of the event.
> 
> BTW. Have we ever documented whether it's kosher to ->remove() a driver
> before ->resume()'ing it ? (In which case obviously we wouldn't resume
> it).

The PM core doesn't have a problem with that.  Whether or not it's sane from
the driver design point of view is a separate question, though.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / yenta: Split resume into early and late parts

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
 drivers/pcmcia/cs.c           |   79 +++++++++++++++++++++++++++++-------------
 drivers/pcmcia/yenta_socket.c |   12 +++++-
 include/pcmcia/ss.h           |    2 +
 3 files changed, 68 insertions(+), 25 deletions(-)

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
@@ -546,23 +554,30 @@ static int socket_suspend(struct pcmcia_
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
+}
+
+static int socket_early_resume(struct pcmcia_socket *skt)
+{
+	if ((skt->state & SOCKET_SUSPEND) && (skt->state & SOCKET_PRESENT))
+		socket_start_resume(skt);
+
+	return 0;
+}
+
+static int socket_late_resume(struct pcmcia_socket *skt)
+{
+	int ret;
+
+	if (!(skt->state & SOCKET_SUSPEND))
+		return 0;
 
 	if (!(skt->state & SOCKET_PRESENT)) {
+		socket_start_resume(skt);
 		skt->state &= ~SOCKET_SUSPEND;
 		return socket_insert(skt);
 	}
@@ -596,6 +611,22 @@ static int socket_resume(struct pcmcia_s
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
+	if (skt->state & SOCKET_PRESENT)
+		socket_start_resume(skt);
+
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
@@ -280,6 +280,8 @@ extern struct pccard_resource_ops pccard
 
 /* socket drivers are expected to use these callbacks in their .drv struct */
 extern int pcmcia_socket_dev_suspend(struct device *dev);
+extern void pcmcia_socket_dev_early_resume(struct device *dev);
+extern void pcmcia_socket_dev_late_resume(struct device *dev);
 extern int pcmcia_socket_dev_resume(struct device *dev);
 
 /* socket drivers use this callback in their IRQ handler */
