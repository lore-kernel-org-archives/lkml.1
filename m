Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbZJAKFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbZJAKFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 06:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbZJAKFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 06:05:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbZJAKFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 06:05:49 -0400
Date: Thu, 1 Oct 2009 15:34:39 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Alan Cox <alan@linux.intel.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for
	generic guest and host communication
Message-ID: <20091001100439.GA9684@amit-x200.redhat.com>
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <200909291531.23389.borntraeger@de.ibm.com> <20090930171321.GA17200@amit-x200.redhat.com> <200910011100.48087.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910011100.48087.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Thu) Oct 01 2009 [11:00:48], Christian Borntraeger wrote:
> Am Mittwoch 30 September 2009 19:13:21 schrieb Amit Shah:
> > - uses port->id instead of a static hvc_vtermno to pass on a value to
> >   hvc_alloc(). Motivation explained within comments in the code.
> 
> [...]
> > +	 * The first argument of hvc_alloc() is the virtual console
> > +	 * number. hvc_alloc() checks if a console with the same value
> > +	 * was used in hvc_instantiate(). We may not end up passing
> > +	 * the same value here (we use the value 0 in
> > +	 * hvc_instantiate() but the console port may not be at id
> > +	 * 0). This isn't a problem, though. Nothing in hvc really
> > +	 * depends on these numbers and since this number is passed on
> > +	 * to us when cons_get/put_chars() is called, it's preferable
> > +	 * to pass on the port->id so that we can get the port struct
> > +	 * via get_port_from_id().
> [...]
> > +	port->hvc = hvc_alloc(port->id, 0, &virtio_cons, PAGE_SIZE);
> 
> I am not sure if this is going to be ok. 
> 
> When I change the old code (without your patch) to use vtermno=0 in 
> hvc_instantiate and vtermno=1 in hvc_alloc I get 
> "Warning: unable to open an initial console."
> 
> It seems to me that we have to pass the same values.

OK; that's bad enough. The following diff reverts that patch and adds a
new get_port_from_vtermno() that works from hvc callbacks.

What do you think? (Applies on top of the latest patch I sent.)

		Amit


diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index b2de2df..a8ba5aa 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -105,12 +105,42 @@ struct virtio_console_port {
 	/* The 'id' to identify the port with the Host */
 	u32 id;
 
+	/*
+	 * If this port is a console port, this number identifies the
+	 * number that we used to register with hvc in
+	 * hvc_instantiate() and hvc_alloc().
+	 */
+	u32 vtermno;
+
 	/* Is the host device open */
 	bool host_connected;
 };
 
 static struct virtio_console_struct virtconsole;
 
+/*
+ * This is used to keep track of the number of hvc consoles spawned.
+ * This number is given as first argument to hvc_alloc(). We could as
+ * well pass on the minor number of the char device but to correctly
+ * map an initial console spawned via hvc_instantiate to the console
+ * being hooked up via hvc_alloc, we need to pass the same vtermno.
+ *
+ * With this int, we just assume the first console being initialised
+ * was the first one that got used as the initial console.
+ */
+static unsigned int hvc_vtermno;
+
+static struct virtio_console_port *get_port_from_vtermno(u32 vtermno)
+{
+	struct virtio_console_port *port;
+
+	list_for_each_entry(port, &virtconsole.port_head, next) {
+		if (port->vtermno == vtermno)
+			return port;
+	}
+	return NULL;
+}
+
 static struct virtio_console_port *get_port_from_devt(dev_t devt)
 {
 	struct virtio_console_port *port;
@@ -457,7 +487,7 @@ static int cons_put_chars(u32 vtermno, const char *buf, int count)
 {
 	struct virtio_console_port *port;
 
-	port = get_port_from_id(vtermno);
+	port = get_port_from_vtermno(vtermno);
 	if (!port)
 		return 0;
 
@@ -478,7 +508,7 @@ static int cons_get_chars(u32 vtermno, char *buf, int count)
 	/* If we don't have an input queue yet, we can't get input. */
 	BUG_ON(!virtconsole.in_vq);
 
-	port = get_port_from_id(vtermno);
+	port = get_port_from_vtermno(vtermno);
 	if (!port)
 		return 0;
 
@@ -566,32 +596,23 @@ int init_port_console(struct virtio_console_port *port)
 	 * hvc_alloc().
 	 *
 	 * The first argument of hvc_alloc() is the virtual console
-	 * number. hvc_alloc() checks if a console with the same value
-	 * was used in hvc_instantiate(). We may not end up passing
-	 * the same value here (we use the value 0 in
-	 * hvc_instantiate() but the console port may not be at id
-	 * 0). This isn't a problem, though. Nothing in hvc really
-	 * depends on these numbers and since this number is passed on
-	 * to us when cons_get/put_chars() is called, it's preferable
-	 * to pass on the port->id so that we can get the port struct
-	 * via get_port_from_id().
-	 *
-	 * The second argument is the parameter for the notification
-	 * mechanism (like irq number). We currently leave this as
-	 * zero, virtqueues have implicit notifications.
+	 * number.  The second argument is the parameter for the
+	 * notification mechanism (like irq number). We currently
+	 * leave this as zero, virtqueues have implicit notifications.
 	 *
 	 * The third argument is a "struct hv_ops" containing the
 	 * put_chars() get_chars(), notifier_add() and notifier_del()
 	 * pointers.  The final argument is the output buffer size: we
 	 * can do any size, so we put PAGE_SIZE here.
 	 */
-	port->hvc = hvc_alloc(port->id, 0, &virtio_cons, PAGE_SIZE);
+	port->hvc = hvc_alloc(hvc_vtermno, 0, &virtio_cons, PAGE_SIZE);
 	if (IS_ERR(port->hvc)) {
 		ret = PTR_ERR(port->hvc);
 		pr_err("%s: Could not alloc hvc for virtio console port, ret = %d\n",
 		       __func__, ret);
 		port->hvc = NULL;
 	}
+	port->vtermno = hvc_vtermno++;
 	return ret;
 }
 
