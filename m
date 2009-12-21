Return-Path: <linux-kernel-owner+w=401wt.eu-S1756527AbZLUBWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbZLUBWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 20:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756395AbZLUBUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 20:20:33 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37716 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368AbZLUBU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 20:20:29 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20091221220.243954235@firstfloor.org>
In-Reply-To: <20091221220.243954235@firstfloor.org>
To: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       ebiederm@xmission.com
Subject: [PATCH] [5/11] SYSCTL: Add call_usermodehelper_cleanup()
Message-Id: <20091221012026.A5B9EB158A@basil.firstfloor.org>
Date: Mon, 21 Dec 2009 02:20:26 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the same as call_usermodehelper(), but with an cleanup callback.
Needed for some of the followon proc_rcu_string() users.

This avoids open coding this.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/kmod.h |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

Index: linux-2.6.33-rc1-ak/include/linux/kmod.h
===================================================================
--- linux-2.6.33-rc1-ak.orig/include/linux/kmod.h
+++ linux-2.6.33-rc1-ak/include/linux/kmod.h
@@ -72,7 +72,8 @@ int call_usermodehelper_exec(struct subp
 void call_usermodehelper_freeinfo(struct subprocess_info *info);
 
 static inline int
-call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
+call_usermodehelper_cleanup(char *path, char **argv, char **envp, enum umh_wait wait,
+			    void (*cleanup)(char **, char **))
 {
 	struct subprocess_info *info;
 	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
@@ -80,10 +81,18 @@ call_usermodehelper(char *path, char **a
 	info = call_usermodehelper_setup(path, argv, envp, gfp_mask);
 	if (info == NULL)
 		return -ENOMEM;
+	if (cleanup)
+		call_usermodehelper_setcleanup(info, cleanup);
 	return call_usermodehelper_exec(info, wait);
 }
 
 static inline int
+call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
+{
+	return call_usermodehelper_cleanup(path, argv, envp, wait, NULL);
+}
+
+static inline int
 call_usermodehelper_keys(char *path, char **argv, char **envp,
 			 struct key *session_keyring, enum umh_wait wait)
 {
