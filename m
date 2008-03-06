Return-Path: <linux-kernel-owner+w=401wt.eu-S1764164AbYCFBu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764164AbYCFBu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 20:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbYCFBuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 20:50:50 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46371 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbYCFBut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 20:50:49 -0500
Date: Wed, 5 Mar 2008 17:48:11 -0800
From: Greg KH <greg@kroah.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/5] object debugging infrastructure V2
Message-ID: <20080306014810.GA4927@kroah.com>
References: <20080305154829.185609547@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305154829.185609547@linutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 04:03:33PM -0000, Thomas Gleixner wrote:
> This is version 2 of the object debugging infrastructure. Changes
> versus V1:
> 
> - review comments processed:
>   - multiplexing interfaces replaced
>   - object type is determined by a caller provided pointer to 
>     a debug structure which replaces the object type identifier
>     -> No changes to the core code for new users
>   - new debug state "destroyed" (kobject wishlist)
>   - various cleanups
> 
> - complete detachment of the tracker object from the real object
>   (no change to the real objects data structure necessary anymore)
> 
> - improved robustness (object memory management, oom cleanup)
> 
> - full set of self tests
> 
> - debugfs statistics 
> 
> - docbook documentation

Here's a patch adding kobjects to this infrastructure (I didn't use a
new CONFIG option, which it probably should be.)

Does this look correct?  I can't tell if this is going to catch
anything, as my trees all seem to have these kinds of bugs worked out
now, as we are already catching a number of these types of things
already with kobjects.

Should I be doing more checks?  Different things based on the state of
the object?

thanks,

greg k-h

-------------------

From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: kobjects: hook them up to the debugobjects infrastructure

I think this is right, but it's hard to tell...

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/kobject.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -18,8 +18,59 @@
 #include <linux/stat.h>
 #include <linux/slab.h>
 #include <linux/kallsyms.h>
+#include <linux/debugobjects.h>
 #include <asm-generic/sections.h>
 
+#ifdef CONFIG_DEBUG_OBJECTS
+static int kobject_fixup_init(void *addr, enum debug_obj_state state)
+{
+	struct kobject *kobj = addr;
+
+	switch (state) {
+	case ODEBUG_STATE_ACTIVE:
+		printk("kobject: '%s' (%p): is being initialized after "
+			"it was already active\n", kobject_name(kobj), kobj);
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+static int kobject_fixup_destroy(void *addr, enum debug_obj_state state)
+{
+	struct kobject *kobj = addr;
+
+	switch (state) {
+	case ODEBUG_STATE_ACTIVE:
+		printk("kobject: '%s' (%p): is being destroyed yet it is "
+			"still active\n", kobject_name(kobj), kobj);
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+static struct debug_obj_descr kobject_debug_descr = {
+	.name = "kobjects",
+	.fixup_init = kobject_fixup_init,
+	.fixup_destroy = kobject_fixup_destroy,
+};
+
+static void debug_kobject_init(struct kobject *kobj)
+{
+	debug_object_init(kobj, &kobject_debug_descr);
+}
+
+static void debug_kobject_destroy(struct kobject *kobj)
+{
+	debug_object_destroy(kobj, &kobject_debug_descr);
+}
+
+#else
+static inline void debug_kobject_init(struct kobject *kobj) { }
+static inline void debug_kobject_destroy(struct kobject *kobj) { }
+#endif
+
 #ifdef CONFIG_X86_32
 static int ptr_in_range(void *ptr, void *start, void *end)
 {
@@ -202,6 +253,7 @@ static void kobject_init_internal(struct
 {
 	if (!kobj)
 		return;
+	debug_kobject_init(kobj);
 	kref_init(&kobj->kref);
 	INIT_LIST_HEAD(&kobj->entry);
 	kobj->state_in_sysfs = 0;
@@ -599,6 +651,7 @@ static void kobject_cleanup(struct kobje
 	pr_debug("kobject: '%s' (%p): %s\n",
 		 kobject_name(kobj), kobj, __FUNCTION__);
 
+	debug_kobject_destroy(kobj);
 	if (t && !t->release)
 		pr_debug("kobject: '%s' (%p): does not have a release() "
 			 "function, it is broken and must be fixed.\n",
