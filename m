Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbZJ1WcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbZJ1WcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 18:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbZJ1WcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 18:32:12 -0400
Received: from ozlabs.org ([203.10.76.45]:60089 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026AbZJ1WcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 18:32:11 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] param sysfs oops (simple, leaky) fix, bool arrays fix
Date: Thu, 29 Oct 2009 09:02:12 +1030
User-Agent: KMail/1.11.2 (Linux/2.6.28-16-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
       Sitsofe Wheeler <sitsofe@yahoo.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christof Schmitt <christof.schmitt@de.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910290902.13724.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Thanks to Takashi-san, who found the oops and kept reading the code to spot
 the others.  A more complete fix is pending, but this works for 2.6.32 and
 -stable: see commit message and FIXME in code.)

The following changes since commit 964fe080d94db82a3268443e9b9ece4c60246414:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../rusty/linux-2.6-for-linus

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-param-fixes.git master

Rusty Russell (3):
      param: fix lots of bugs with writing charp params from sysfs, by leaking mem.
      param: fix NULL comparison on oom
      param: fix setting arrays of bool

 include/linux/moduleparam.h |    1 -
 kernel/params.c             |   17 ++++++-----------
 2 files changed, 6 insertions(+), 12 deletions(-)

commit 65afac7d80ab3bc9f81e75eafb71eeb92a3ebdef
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Oct 29 08:56:16 2009 -0600

    param: fix lots of bugs with writing charp params from sysfs, by leaking mem.
    
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
    Cc: stable@kernel.org

 include/linux/moduleparam.h |    1 -
 kernel/params.c             |   10 +---------
 2 files changed, 1 insertions(+), 10 deletions(-)

commit d553ad864e3b3dde3f1038d491e207021b2d6293
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Oct 29 08:56:17 2009 -0600

    param: fix NULL comparison on oom
    
    kp->arg is always true: it's the contents of that pointer we care about.
    
    Reported-by: Takashi Iwai <tiwai@suse.de>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: stable@kernel.org

 kernel/params.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

commit 3c7d76e371ac1a3802ae1673f5c63554af59325c
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Oct 29 08:56:19 2009 -0600

    param: fix setting arrays of bool
    
    We create a dummy struct kernel_param on the stack for parsing each
    array element, but we didn't initialize the flags word.  This matters
    for arrays of type "bool", where the flag indicates if it really is
    an array of bools or unsigned int (old-style).
    
    Reported-by: Takashi Iwai <tiwai@suse.de>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: stable@kernel.org

 kernel/params.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 6547c3c..82a9124 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -37,7 +37,6 @@ typedef int (*param_set_fn)(const char *val, struct kernel_param *kp);
 typedef int (*param_get_fn)(char *buffer, struct kernel_param *kp);
 
 /* Flag bits for kernel_param.flags */
-#define KPARAM_KMALLOCED	1
 #define KPARAM_ISBOOL		2
 
 struct kernel_param {
diff --git a/kernel/params.c b/kernel/params.c
index 9da58ea..d656c27 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -218,15 +218,11 @@ int param_set_charp(const char *val, struct kernel_param *kp)
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
-		if (!kp->arg)
+		if (!*(char **)kp->arg)
 			return -ENOMEM;
 	} else
 		*(const char **)kp->arg = val;
@@ -304,6 +300,7 @@ static int param_array(const char *name,
 		       unsigned int min, unsigned int max,
 		       void *elem, int elemsize,
 		       int (*set)(const char *, struct kernel_param *kp),
+		       u16 flags,
 		       unsigned int *num)
 {
 	int ret;
@@ -313,6 +310,7 @@ static int param_array(const char *name,
 	/* Get the name right for errors. */
 	kp.name = name;
 	kp.arg = elem;
+	kp.flags = flags;
 
 	/* No equals sign? */
 	if (!val) {
@@ -358,7 +356,8 @@ int param_array_set(const char *val, struct kernel_param *kp)
 	unsigned int temp_num;
 
 	return param_array(kp->name, val, 1, arr->max, arr->elem,
-			   arr->elemsize, arr->set, arr->num ?: &temp_num);
+			   arr->elemsize, arr->set, kp->flags,
+			   arr->num ?: &temp_num);
 }
 
 int param_array_get(char *buffer, struct kernel_param *kp)
@@ -605,11 +604,7 @@ void module_param_sysfs_remove(struct module *mod)
 
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
