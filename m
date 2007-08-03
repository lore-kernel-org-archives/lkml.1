Return-Path: <linux-kernel-owner+w=401wt.eu-S1763044AbXHCTPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763044AbXHCTPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 15:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758267AbXHCTPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 15:15:23 -0400
Received: from antonio.urjc.es ([193.147.184.24]:37223 "EHLO antonio.urjc.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757177AbXHCTPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 15:15:22 -0400
X-Greylist: delayed 476 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Aug 2007 15:15:22 EDT
Message-ID: <46B37CF7.2020803@urjc.es>
Date: Fri, 03 Aug 2007 21:07:35 +0200
From: Javier Pello <javier.pello@urjc.es>
Organization: Universidad Rey Juan Carlos
User-Agent: Thunderbird 2.0.0.0 (X11/20070503)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Greg KH <greg@kroah.com>
Subject: [PATCH] request_firmware: skip timeout if userspace was not 
	notified
Content-Type: text/plain;
	charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender DNS name whitelisted, not delayed by 
	milter-greylist-2.0.2 (antonio.urjc.es [193.147.184.24]); Fri, 03 Aug 2007 
	21:07:00 +0200 (CEST)
X-imss-version: 2.047
X-imss-result: Passed
X-imss-scanInfo: M:B L:E SM:2
X-imss-tmaseResult: TT:1 TS:-8.8985 TC:02 TRN:49 TV:3.6.1039(15340.003)
X-imss-scores: Clean:100.00000 C:0 M:0 S:0 R:0
X-imss-settings: Baseline:1 C:1 M:1 S:1 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have prepared a patch that makes request_firmware skip the usual
grace period that it gives firmware images to show up, if it determines
that userspace was not notified at all.

When request_firmware is called, it sends an event to userspace to
ask for the firmware image that is needed, and then it installs a
timeout so that it will not wait forever for the image. However,
if userspace did not receive the event at all (no /sbin/hotplug,
for instance), then having the kernel wait is pointless. This is
particularly true during boot, when the wait is done synchronously
and the whole kernel freezes for a minute.

The attached patch fixes this by making _request_firmware check whether
the firmware loading event was succesfully sent to userspace, and skip
the timeout if it has not. The patch comes in two parts:

1. The first part changes kobject_uevent_env in lib/kobject_uevent.c
to report a failure if both netlink_broadcast (if applicable) and
call_usermodehelper fail to send the event to userspace. Nothing in
the kernel seems to care about the return value of kobject_uevent_env,
so this should not break anything.

2. The second part changes _request_firmware in
drivers/base/firmware_class.c to actually check the return value of
kobject_uevent and skip the loading_timeout delay if the loading event
was not delivered to userspace at all.

The patches apply cleanly against 2.6.23-rc1. Any suggestions or feedback
will be welcome.

Javier

PS  Please CC: me on replies, as I am not subscribed to the list.


==========
From: Javier Pello <javier.pello@urjc.es>

kobject_uevent: return an error if event was not delivered to userspace

Make kobject_uevent_env return an error to the caller if the event was
not delivered to userspace either via netlink or via uevent_helper.

Signed-off-by: Javier Pello <javier.pello@urjc.es>

---
diff -u linux-2.6.22/lib/kobject_uevent.c linux-2.6.22-p/lib/kobject_uevent.c
--- linux-2.6.22/lib/kobject_uevent.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-2.6.22-p/lib/kobject_uevent.c	2007-07-18 20:17:10.000000000 +0200
@@ -186,7 +186,8 @@
 			}
 
 			NETLINK_CB(skb).dst_group = 1;
-			netlink_broadcast(uevent_sock, skb, 0, 1, GFP_KERNEL);
+			retval = netlink_broadcast(uevent_sock, skb, 0, 1,
+						GFP_KERNEL);
 		}
 	}
 #endif
@@ -198,7 +199,18 @@
 		argv [0] = uevent_helper;
 		argv [1] = (char *)subsystem;
 		argv [2] = NULL;
-		call_usermodehelper (argv[0], argv, envp, UMH_WAIT_EXEC);
+#if defined(CONFIG_NET)
+		if (retval) {
+			retval = call_usermodehelper (argv[0], argv, envp,
+						UMH_WAIT_EXEC);
+		} else {
+			call_usermodehelper (argv[0], argv, envp,
+						UMH_WAIT_EXEC);
+		}
+#else
+		retval = call_usermodehelper (argv[0], argv, envp,
+						UMH_WAIT_EXEC);
+#endif
 	}
 
 exit:

==========
From: Javier Pello <javier.pello@urjc.es>

request_firmware: skip timeout if userspace was not notified

Stop _request_firmware from setting up a timer and waiting for
the firmware image to appear if kobject_uevent returns an error
(meaning userspace was not notified at all).

This prevents useless delays if there is no userspace tool to
provide the firmware image (eg during boot).

Signed-off-by: Javier Pello <javier.pello@urjc.es>

---
diff -u linux-2.6.22/drivers/base/firmware_class.c linux-2.6.22-p/drivers/base/firmware_class.c
--- linux-2.6.22/drivers/base/firmware_class.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-2.6.22-p/drivers/base/firmware_class.c	2007-07-18 20:06:53.000000000 +0200
@@ -420,8 +420,12 @@
 			add_timer(&fw_priv->timeout);
 		}
 
-		kobject_uevent(&f_dev->kobj, KOBJ_ADD);
-		wait_for_completion(&fw_priv->completion);
+		retval = kobject_uevent(&f_dev->kobj, KOBJ_ADD);
+		if (retval) {
+			fw_load_abort(fw_priv);
+		} else {
+			wait_for_completion(&fw_priv->completion);
+		}
 		set_bit(FW_STATUS_DONE, &fw_priv->status);
 		del_timer_sync(&fw_priv->timeout);
 	} else
==========



