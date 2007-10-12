Return-Path: <linux-kernel-owner+w=401wt.eu-S1761772AbXJLQmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761772AbXJLQmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758547AbXJLQmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:42:10 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:41954 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757616AbXJLQmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:42:08 -0400
Date: Fri, 12 Oct 2007 11:38:39 -0500
From: Corey Minyard <minyard@acm.org>
Subject: [PATCH 2/7] IPMI: remove bogus semaphore from watchdog
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Reply-to: minyard@acm.org
Message-id: <20071012163839.GB22142@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Corey Minyard <cminyard@mvista.com>

Lockdep was giving an error when loading the IPMI watchdog module.  It
turns out that if you try to claim a lock in a parameter handling
routine, lockdep won't see that lock as "static" yet because the
module is not yet on the module list, so it will complain.

However, the semaphore in question is completely unnecessary.  So just
remove it.

Not needed for the stable kernel.

Signed-off-by: Corey Minyard <cminyard@mvista.com>

---
Index: linux-2.6.21/drivers/char/ipmi/ipmi_watchdog.c
===================================================================
--- linux-2.6.21.orig/drivers/char/ipmi/ipmi_watchdog.c
+++ linux-2.6.21/drivers/char/ipmi/ipmi_watchdog.c
@@ -164,8 +164,6 @@ static char expect_close;
 
 static int ifnum_to_use = -1;
 
-static DECLARE_RWSEM(register_sem);
-
 /* Parameters to ipmi_set_timeout */
 #define IPMI_SET_TIMEOUT_NO_HB			0
 #define IPMI_SET_TIMEOUT_HB_IF_NECESSARY	1
@@ -191,11 +189,9 @@ static int set_param_int(const char *val
 	if (endp == val)
 		return -EINVAL;
 
-	down_read(&register_sem);
 	*((int *)kp->arg) = l;
 	if (watchdog_user)
 		rv = ipmi_set_timeout(IPMI_SET_TIMEOUT_HB_IF_NECESSARY);
-	up_read(&register_sem);
 
 	return rv;
 }
@@ -224,17 +220,15 @@ static int set_param_str(const char *val
 
 	s = strstrip(valcp);
 
-	down_read(&register_sem);
 	rv = fn(s, NULL);
 	if (rv)
-		goto out_unlock;
+		goto out;
 
 	check_parms();
 	if (watchdog_user)
 		rv = ipmi_set_timeout(IPMI_SET_TIMEOUT_HB_IF_NECESSARY);
 
- out_unlock:
-	up_read(&register_sem);
+ out:
 	return rv;
 }
 
@@ -893,7 +887,6 @@ static void ipmi_register_watchdog(int i
 {
 	int rv = -EBUSY;
 
-	down_write(&register_sem);
 	if (watchdog_user)
 		goto out;
 
@@ -920,8 +913,6 @@ static void ipmi_register_watchdog(int i
 	}
 
  out:
-	up_write(&register_sem);
-
 	if ((start_now) && (rv == 0)) {
 		/* Run from startup, so start the timer now. */
 		start_now = 0; /* Disable this function after first startup. */
@@ -935,8 +926,6 @@ static void ipmi_unregister_watchdog(int
 {
 	int rv;
 
-	down_write(&register_sem);
-
 	if (!watchdog_user)
 		goto out;
 
@@ -961,7 +950,7 @@ static void ipmi_unregister_watchdog(int
 	watchdog_user = NULL;
 
  out:
-	up_write(&register_sem);
+	return;
 }
 
 #ifdef HAVE_NMI_HANDLER
