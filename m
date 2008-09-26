Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbYIZK3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbYIZK3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 06:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYIZK2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 06:28:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46129 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752768AbYIZK2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 06:28:53 -0400
Date: Fri, 26 Sep 2008 11:28:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>, tglx@tglx.de, mingo@elte.hu
Subject: Re: Warning/Oops report of the week of September 16th, 2008
Message-ID: <20080926112815.0f8e9de6@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.1.10.0809241541320.3265@nehalem.linux-foundation.org>
References: <20080916092206.6342c498@infradead.org>
	<200809250036.47277.elendil@planet.nl>
	<alpine.LFD.1.10.0809241541320.3265@nehalem.linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In the meantime, that warning is just best ignored entirely. It's not a 
> kernel bug per se, or even anything that is fixable without changing 
> exported user interfaces that in my opinion aren't necessarily even 
> _worth_ changing (the only reasonable change is extending on the insane 
> interface that nobody cares about).

How about a quickfix for the moment. This ought to do the job. BTW I
disagree that the link should be to first, it would be best a link to the
active driver IMHO.

Has been Torvalds-tested only (ie it compiled)

--

parport: quickfix the proc registration bug

From: Alan Cox <alan@redhat.com>

Ideally we should have a directory of drivers and a link to the 'active'
driver. For now just show the first device which is effectively the existing
semantics without a warning.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/parport/share.c   |   13 ++++++++++---
 drivers/serial/8250_pci.c |    4 ++--
 include/linux/parport.h   |    4 ++++
 3 files changed, 16 insertions(+), 5 deletions(-)


diff --git a/drivers/parport/share.c b/drivers/parport/share.c
index a8a62bb..0750dcb 100644
--- a/drivers/parport/share.c
+++ b/drivers/parport/share.c
@@ -614,7 +614,10 @@ parport_register_device(struct parport *port, const char *name,
 	 * pardevice fields. -arca
 	 */
 	port->ops->init_state(tmp, tmp->state);
-	parport_device_proc_register(tmp);
+	if (test_and_set_bit(PARPORT_DEVPROC_REGISTERED, &port->devflags)) {
+		port->proc_device = tmp;
+		parport_device_proc_register(tmp);
+	}
 	return tmp;
 
  out_free_all:
@@ -646,10 +649,14 @@ void parport_unregister_device(struct pardevice *dev)
 	}
 #endif
 
-	parport_device_proc_unregister(dev);
-
 	port = dev->port->physport;
 
+	if (port->proc_device == dev) {
+		port->proc_device = NULL;
+		clear_bit(PARPORT_DEVPROC_REGISTERED, &port->devflags);
+		parport_device_proc_unregister(dev);
+	}
+
 	if (port->cad == dev) {
 		printk(KERN_DEBUG "%s: %s forgot to release port\n",
 		       port->name, dev->name);
diff --git a/include/linux/parport.h b/include/linux/parport.h
index 6a0d7cd..986252e 100644
--- a/include/linux/parport.h
+++ b/include/linux/parport.h
@@ -326,6 +326,10 @@ struct parport {
 	int spintime;
 	atomic_t ref_count;
 
+	unsigned long devflags;
+#define PARPORT_DEVPROC_REGISTERED	0
+	struct pardevice *proc_device;	/* Currently register proc device */
+
 	struct list_head full_list;
 	struct parport *slaves[3];
 };
