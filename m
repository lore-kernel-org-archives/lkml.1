Return-Path: <linux-kernel-owner+w=401wt.eu-S1758200AbYG3Heu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbYG3Heu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 03:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbYG3Hem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 03:34:42 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:45858 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbYG3Hel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 03:34:41 -0400
Date: Wed, 30 Jul 2008 09:34:38 +0200
From: Bastian Blank <waldi@debian.org>
To: Michael Ellerman <michael@ellerman.id.au>, linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] hvc - register all available consoles (was: Re: [PATCH]
	powerpc/lpar - defer prefered console setup)
Message-ID: <20080730073438.GA29700@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	Michael Ellerman <michael@ellerman.id.au>, linuxppc-dev@ozlabs.org,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linux-kernel@vger.kernel.org
References: <20080728185651.GA29530@wavehammer.waldi.eu.org> <1217385291.10646.2.camel@localhost> <20080730062313.GA26044@wavehammer.waldi.eu.org> <20080730062919.GA27281@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080730062919.GA27281@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 08:29:19AM +0200, Bastian Blank wrote:
> Okay, so hvc_console is the culprit. It don't register a preferred
> console if it knows it is not the first in the list.

The patch registers all available hvc consoles. It adds one "struct
console" for all possible hvc consoles.

Signed-off-by: Bastian Blank <waldi@debian.org>

diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
index 44160d5..143a4b2 100644
--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -137,15 +137,36 @@ static struct hvc_struct *hvc_get_by_index(int index)
 }
 
 
+static void hvc_console_print(struct console *co, const char *b,
+			      unsigned count);
+static struct tty_driver *hvc_console_device(struct console *c, int *index);
+static int __init hvc_console_setup(struct console *co, char *options);
+
 /*
  * Initial console vtermnos for console API usage prior to full console
  * initialization.  Any vty adapter outside this range will not have usable
  * console interfaces but can still be used as a tty device.  This has to be
  * static because kmalloc will not work during early console init.
  */
-static struct hv_ops *cons_ops[MAX_NR_HVC_CONSOLES];
-static uint32_t vtermnos[MAX_NR_HVC_CONSOLES] =
-	{[0 ... MAX_NR_HVC_CONSOLES - 1] = -1};
+struct hvc_console
+{
+	uint32_t vtermno;
+	struct hv_ops *ops;
+	struct console console;
+};
+static struct hvc_console consoles[MAX_NR_HVC_CONSOLES] = {
+	[0 ... MAX_NR_HVC_CONSOLES - 1] = {
+		.vtermno = -1,
+		.console = {
+			.name		= "hvc",
+			.write		= hvc_console_print,
+			.device		= hvc_console_device,
+			.setup		= hvc_console_setup,
+			.flags		= CON_PRINTBUFFER,
+			.index		= -1,
+		},
+	}
+};
 
 /*
  * Console APIs, NOT TTY.  These APIs are available immediately when
@@ -164,7 +185,7 @@ static void hvc_console_print(struct console *co, const char *b,
 		return;
 
 	/* This console adapter was removed so it is not usable. */
-	if (vtermnos[index] < 0)
+	if (consoles[index].vtermno < 0)
 		return;
 
 	while (count > 0 || i > 0) {
@@ -178,7 +199,7 @@ static void hvc_console_print(struct console *co, const char *b,
 				--count;
 			}
 		} else {
-			r = cons_ops[index]->put_chars(vtermnos[index], c, i);
+			r = consoles[index].ops->put_chars(consoles[index].vtermno, c, i);
 			if (r < 0) {
 				/* throw away chars on error */
 				i = 0;
@@ -193,7 +214,7 @@ static void hvc_console_print(struct console *co, const char *b,
 
 static struct tty_driver *hvc_console_device(struct console *c, int *index)
 {
-	if (vtermnos[c->index] == -1)
+	if (consoles[c->index].vtermno == -1)
 		return NULL;
 
 	*index = c->index;
@@ -205,43 +226,12 @@ static int __init hvc_console_setup(struct console *co, char *options)
 	if (co->index < 0 || co->index >= MAX_NR_HVC_CONSOLES)
 		return -ENODEV;
 
-	if (vtermnos[co->index] == -1)
+	if (consoles[co->index].vtermno == -1)
 		return -ENODEV;
 
 	return 0;
 }
 
-static struct console hvc_con_driver = {
-	.name		= "hvc",
-	.write		= hvc_console_print,
-	.device		= hvc_console_device,
-	.setup		= hvc_console_setup,
-	.flags		= CON_PRINTBUFFER,
-	.index		= -1,
-};
-
-/*
- * Early console initialization.  Precedes driver initialization.
- *
- * (1) we are first, and the user specified another driver
- * -- index will remain -1
- * (2) we are first and the user specified no driver
- * -- index will be set to 0, then we will fail setup.
- * (3)  we are first and the user specified our driver
- * -- index will be set to user specified driver, and we will fail
- * (4) we are after driver, and this initcall will register us
- * -- if the user didn't specify a driver then the console will match
- *
- * Note that for cases 2 and 3, we will match later when the io driver
- * calls hvc_instantiate() and call register again.
- */
-static int __init hvc_console_init(void)
-{
-	register_console(&hvc_con_driver);
-	return 0;
-}
-console_initcall(hvc_console_init);
-
 /* callback when the kboject ref count reaches zero. */
 static void destroy_hvc_struct(struct kref *kref)
 {
@@ -267,12 +257,13 @@ static void destroy_hvc_struct(struct kref *kref)
  */
 int hvc_instantiate(uint32_t vtermno, int index, struct hv_ops *ops)
 {
+	struct hvc_console *hc;
 	struct hvc_struct *hp;
 
 	if (index < 0 || index >= MAX_NR_HVC_CONSOLES)
 		return -1;
 
-	if (vtermnos[index] != -1)
+	if (consoles[index].vtermno != -1)
 		return -1;
 
 	/* make sure no no tty has been registered in this index */
@@ -282,19 +273,17 @@ int hvc_instantiate(uint32_t vtermno, int index, struct hv_ops *ops)
 		return -1;
 	}
 
-	vtermnos[index] = vtermno;
-	cons_ops[index] = ops;
+	hc = &consoles[index];
+
+	hc->vtermno = vtermno;
+	hc->ops = ops;
+	hc->console.index = index;
 
 	/* reserve all indices up to and including this index */
 	if (last_hvc < index)
 		last_hvc = index;
 
-	/* if this index is what the user requested, then register
-	 * now (setup won't fail at this point).  It's ok to just
-	 * call register again if previously .setup failed.
-	 */
-	if (index == hvc_con_driver.index)
-		register_console(&hvc_con_driver);
+	register_console(&hc->console);
 
 	return 0;
 }
@@ -637,7 +626,7 @@ static int hvc_poll(struct hvc_struct *hp)
 		}
 		for (i = 0; i < n; ++i) {
 #ifdef CONFIG_MAGIC_SYSRQ
-			if (hp->index == hvc_con_driver.index) {
+			if (consoles[hp->index].console.flags & CON_CONSDEV) {
 				/* Handle the SysRq Hack */
 				/* XXX should support a sequence */
 				if (buf[i] == '\x0f') {	/* ^O */
@@ -775,8 +764,8 @@ struct hvc_struct __devinit *hvc_alloc(uint32_t vtermno, int irq,
 	 * see if this vterm id matches one registered for console.
 	 */
 	for (i=0; i < MAX_NR_HVC_CONSOLES; i++)
-		if (vtermnos[i] == hp->vtermno &&
-		    cons_ops[i] == hp->ops)
+		if (consoles[i].vtermno == hp->vtermno &&
+		    consoles[i].ops == hp->ops)
 			break;
 
 	/* no matching slot, just use a counter */
@@ -800,7 +789,7 @@ int __devexit hvc_remove(struct hvc_struct *hp)
 	tty = hp->tty;
 
 	if (hp->index < MAX_NR_HVC_CONSOLES)
-		vtermnos[hp->index] = -1;
+		consoles[hp->index].vtermno = -1;
 
 	/* Don't whack hp->irq because tty_hangup() will need to free the irq. */
 
@@ -881,13 +870,16 @@ out:
  */
 static void __exit hvc_exit(void)
 {
+	int i;
+
 	if (hvc_driver) {
 		kthread_stop(hvc_task);
 
 		tty_unregister_driver(hvc_driver);
 		/* return tty_struct instances allocated in hvc_init(). */
 		put_tty_driver(hvc_driver);
-		unregister_console(&hvc_con_driver);
+		for (i = 0; i < MAX_NR_HVC_CONSOLES; i++)
+			unregister_console(&consoles->console);
 	}
 }
 module_exit(hvc_exit);

-- 
There is an order of things in this universe.
		-- Apollo, "Who Mourns for Adonais?" stardate 3468.1
