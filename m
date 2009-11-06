Return-Path: <linux-kernel-owner+w=401wt.eu-S1760182AbZKFWW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760182AbZKFWW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932427AbZKFWWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:22:51 -0500
Received: from kroah.org ([198.145.64.141]:56815 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760146AbZKFWWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:50 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:43 2009
Message-Id: <20091106221543.453166367@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sitsofe Wheeler <sitsofe@yahoo.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christof Schmitt <christof.schmitt@de.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [36/99] param: fix lots of bugs with writing charp params from sysfs, by leaking mem.
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=param-fix-lots-of-bugs-with-writing-charp-params-from-sysfs-by-leaking-mem.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Rusty Russell <rusty@rustcorp.com.au>

commit 65afac7d80ab3bc9f81e75eafb71eeb92a3ebdef upstream.

e180a6b7759a "param: fix charp parameters set via sysfs" fixed the case
where charp parameters written via sysfs were freed, leaving drivers
accessing random memory.

Unfortunately, storing a flag in the kparam struct was a bad idea: it's
rodata so setting it causes an oops on some archs.  But that's not all:

1) module_param_array() on charp doesn't work reliably, since we use an
   uninitialized temporary struct kernel_param.
2) there's a fundamental race if a module uses this parameter and then
   it's changed: they will still access the old, freed, memory.

The simplest fix (ie. for 2.6.32) is to never free the memory.  This
prevents all these problems, at cost of a memory leak.  In practice, there
are only 18 places where a charp is writable via sysfs, and all are
root-only writable.

Reported-by: Takashi Iwai <tiwai@suse.de>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/moduleparam.h |    1 -
 kernel/params.c             |   10 +---------
 2 files changed, 1 insertion(+), 10 deletions(-)

--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -37,7 +37,6 @@ typedef int (*param_set_fn)(const char *
 typedef int (*param_get_fn)(char *buffer, struct kernel_param *kp);
 
 /* Flag bits for kernel_param.flags */
-#define KPARAM_KMALLOCED	1
 #define KPARAM_ISBOOL		2
 
 struct kernel_param {
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -217,13 +217,9 @@ int param_set_charp(const char *val, str
 		return -ENOSPC;
 	}
 
-	if (kp->flags & KPARAM_KMALLOCED)
-		kfree(*(char **)kp->arg);
-
 	/* This is a hack.  We can't need to strdup in early boot, and we
 	 * don't need to; this mangled commandline is preserved. */
 	if (slab_is_available()) {
-		kp->flags |= KPARAM_KMALLOCED;
 		*(char **)kp->arg = kstrdup(val, GFP_KERNEL);
 		if (!kp->arg)
 			return -ENOMEM;
@@ -604,11 +600,7 @@ void module_param_sysfs_remove(struct mo
 
 void destroy_params(const struct kernel_param *params, unsigned num)
 {
-	unsigned int i;
-
-	for (i = 0; i < num; i++)
-		if (params[i].flags & KPARAM_KMALLOCED)
-			kfree(*(char **)params[i].arg);
+	/* FIXME: This should free kmalloced charp parameters.  It doesn't. */
 }
 
 static void __init kernel_add_sysfs_param(const char *name,


