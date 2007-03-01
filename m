Return-Path: <linux-kernel-owner+w=401wt.eu-S932903AbXCAHUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbXCAHUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 02:20:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932908AbXCAHUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 02:20:04 -0500
Received: from tomts5.bellnexxia.net ([209.226.175.25]:54187 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932903AbXCAHUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 02:20:03 -0500
Date: Thu, 1 Mar 2007 02:20:01 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [PATCH] linux-kernel-markers-documentation-update-flags
Message-ID: <20070301072001.GF19339@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 02:18:44 up 26 days, 21:26,  7 users,  load average: 1.22, 1.40, 1.33
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

linux-kernel-markers-documentation-update-flags

Documents the flag usage.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/Documentation/marker.txt
+++ b/Documentation/marker.txt
@@ -78,6 +78,21 @@ which saves a data cache hit, but also requires cross CPU code modification. In
 order to support embedded systems which use read-only memory for their code, the
 optimization can be disabled through menu options.
 
+The MF_* flags can be used to control the type of marker. See the
+include/marker.h header for the list of flags. They can be specified as the
+first parameter of the _MARK() macro, such as the following example which is
+safe wrt lockdep.c (useful for marking lockdep.c functions).
+
+_MARK(_MF_DEFAULT | ~_MF_LOCKDEP, subsystem_eventb,
+  MARK_NOARGS);
+
+Another example is to specify that a specific marker must never call printk :
+_MARK(_MF_DEFAULT | ~_MF_PRINTK, subsystem_eventc,
+  "%d %s %p[struct task_struct]",
+  someint, somestring, current);
+
+Flag compatibility is checked before connecting the probe to the marker.
+
 
 * Probe example
 
@@ -122,6 +137,13 @@ void probe_subsystem_event(const char *format, ...)
 	va_end(ap);
 }
 
+#define SUBSYSTEM_EVENTB_FORMAT MARK_NOARGS
+void probe_subsystem_eventb(const char *format, ...)
+{
+	/* Increment counters, trace, ... but _never_ generate a call to
+	 * lockdep.c ! */
+}
+
 static int __init probe_init(void)
 {
 	int result;
@@ -130,16 +152,24 @@ static int __init probe_init(void)
 			probe_subsystem_event);
 	if (!result)
 		goto cleanup;
+	result = _marker_set_probe(_MF_DEFAULT & ~_MF_LOCKDEP,
+			"subsystem_eventb",
+			SUBSYSTEM_EVENTB_FORMAT,
+			probe_subsystem_eventb);
+	if (!result)
+		goto cleanup;
 	return 0;
 
 cleanup:
 	marker_remove_probe(probe_subsystem_event);
+	marker_remove_probe(probe_subsystem_eventb);
 	return -EPERM;
 }
 
 static void __exit probe_fini(void)
 {
 	marker_remove_probe(probe_subsystem_event);
+	marker_remove_probe(probe_subsystem_eventb);
 }
 
 module_init(probe_init);
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
