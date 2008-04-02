Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbYDBO5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbYDBO5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 10:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755793AbYDBO5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 10:57:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275AbYDBO5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 10:57:34 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       mingo@redhat.com
Subject: Re: xen: Make hvc0 the preferred console in domU
References: <87zltm1p0s.fsf@pike.pond.sub.org> <47F08688.6050206@goop.org>
From: Markus Armbruster <armbru@redhat.com>
Date: Wed, 02 Apr 2008 16:56:45 +0200
In-Reply-To: <47F08688.6050206@goop.org> (Jeremy Fitzhardinge's message of "Sun\, 30 Mar 2008 23\:36\:56 -0700")
Message-ID: <87iqz0e24y.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Markus Armbruster wrote:
>> This makes the Xen console just work.  Before, you had to ask for it
>> on the kernel command line with console=hvc0
>>   
>
> I see that this has been causing issues when people expect the pvfb
> driver to be the console.  Should we make it a config option, which
> depends on !XENFB?
>
>    J

This turns out to a thornier problem than one might think.

Consoles tty, hvc and ttyS register in this order.

Unless the kernel command line dictates otherwise, the first one to
register becomes the preferred console (the one behind /dev/console).
This is tty.  Except we patched things so that hvc wins over tty in
domU.  That's what we want there; tty is the dummy console there.

Enter PV framebuffer.  It turns tty into a useful console, which we
want to use.  But the PVFB is created only if it's enabled for this
domain, and we learn that from xenstore.

Problem: when tty registers, we can't yet know whether the PVFB is
enabled.  By the time we can know, the console setup game is over.

The non-pvops PVFB has the same problem.  Jeremy Katz solved it there
with a fairly gross hack: right after the Xen console is up, at the
end of xencons_init(), we forcefully make the Xen console the
preferred console if the PVFB is disabled:

        /* Check about framebuffer messing up the console */
        if (!is_initial_xendomain() &&
	    !xenbus_exists(XBT_NIL, "device", "vfb")) {
		/* FIXME: this is ugly */
		unregister_console(&kcons_info);
		kcons_info.flags |= CON_CONSDEV;
		register_console(&kcons_info);
	}

Aside: we tried to get that into linux-2.6.18-xen.hg a couple of times
before we gave up.  If you use that tree unmodified, you simply get no
working console when you diable the PVFB.

I append the straight pvops port of this hack.

Instead of putting hvc_force_consdev() into hvc_console.c, we could
also have a force_console() in kernel/printk.c, like this:

void
force_console(char *name, int index)
{
	struct console *c, *cc;

	acquire_console_sem();
	for (c = console_drivers; c->next; c = c->next) {
		cc = c->next;
		if (!strcmp(cc->name, name) && cc->index == index) {
			c->next = c->next->next;
			cc->next = console_drivers;
			console_drivers->flags &= ~CON_CONSDEV;
			console_drivers = cc;
			cc->flags |= CON_CONSDEV;
			break;
		}
	}
	release_console_sem();
}

If one of these two hacks is acceptable, I'll prepare a proper patch.
If not, I'd appreciate advice on how to solve this better.

Markus



diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index a94605e..54e7b46 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1211,8 +1211,10 @@ asmlinkage void __init xen_start_kernel(void)
 		? __pa(xen_start_info->mod_start) : 0;
 	boot_params.hdr.ramdisk_size = xen_start_info->mod_len;
 
-	if (!is_initial_xendomain())
+	if (!is_initial_xendomain()) {
 		add_preferred_console("hvc", 0, NULL);
+		add_preferred_console("tty", 0, NULL);
+	}
 
 	/* Start the world */
 	start_kernel();
diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
index 44160d5..11904ad 100644
--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -299,6 +299,13 @@ int hvc_instantiate(uint32_t vtermno, int index, struct hv_ops *ops)
 	return 0;
 }
 
+void hvc_force_consdev(void)
+{
+	unregister_console(&hvc_con_driver);
+	hvc_con_driver.flags |= CON_ENABLED | CON_CONSDEV;
+	register_console(&hvc_con_driver);
+}
+
 /* Wake the sleeping khvcd */
 static void hvc_kick(void)
 {
diff --git a/drivers/char/hvc_console.h b/drivers/char/hvc_console.h
index 8c59818..ee98bb0 100644
--- a/drivers/char/hvc_console.h
+++ b/drivers/char/hvc_console.h
@@ -54,6 +54,9 @@ struct hvc_struct;
 /* Register a vterm and a slot index for use as a console (console_init) */
 extern int hvc_instantiate(uint32_t vtermno, int index, struct hv_ops *ops);
 
+/* Forcefully make hvc the preferred console driver (hack) */
+extern void hvc_force_consdev(void);
+
 /* register a vterm for hvc tty operation (module_init or hotplug add) */
 extern struct hvc_struct * __devinit hvc_alloc(uint32_t vtermno, int irq,
 				struct hv_ops *ops, int outbuf_size);
diff --git a/drivers/char/hvc_xen.c b/drivers/char/hvc_xen.c
index dd68f85..7ccbec2 100644
--- a/drivers/char/hvc_xen.c
+++ b/drivers/char/hvc_xen.c
@@ -29,6 +29,7 @@
 #include <xen/events.h>
 #include <xen/interface/io/console.h>
 #include <xen/hvc-console.h>
+#include <xen/xenbus.h>
 
 #include "hvc_console.h"
 
@@ -104,6 +105,14 @@ static int __init xen_init(void)
 	if (!is_running_on_xen())
 		return 0;
 
+	printk(KERN_DEBUG "hvc xen_init()\n");
+        /* Check about framebuffer messing up the console */
+        if (!is_initial_xendomain() &&
+	    !xenbus_exists(XBT_NIL, "device", "vfb")) {
+		/* disgusting kludge */
+		hvc_force_consdev();
+	}
+
 	xencons_irq = bind_evtchn_to_irq(xen_start_info->console.domU.evtchn);
 	if (xencons_irq < 0)
 		xencons_irq = 0 /* NO_IRQ */;
