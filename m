Return-Path: <linux-kernel-owner+w=401wt.eu-S935717AbXLQXr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935717AbXLQXr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 18:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933457AbXLQXrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 18:47:41 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51680 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933172AbXLQXrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:39 -0500
Date: Mon, 17 Dec 2007 15:47:27 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
To: "Tony Luck" <tony.luck@intel.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>, protasnb@gmail.com,
       tytso@thunk.org
Subject: Re: Top kernel oopses/warnings this week
Message-ID: <20071217154727.404e4bc4@laptopd505.fenrus.org>
In-Reply-To: <12c511ca0712171526h242a7de8vadec78cd48747bd@mail.gmail.com>
References: <4762CF8C.90808@linux.intel.com>
	<20071217172331.GA23070@elte.hu>
	<20071217133631.5bbc5842@laptopd505.fenrus.org>
	<12c511ca0712171458n1bc05b40nab6b4b7c92433c8d@mail.gmail.com>
	<476703A4.7000401@linux.intel.com>
	<12c511ca0712171526h242a7de8vadec78cd48747bd@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 15:26:46 -0800
"Tony Luck" <tony.luck@intel.com> wrote:

> On Dec 17, 2007 3:17 PM, Arjan van de Ven <arjan@linux.intel.com>
> wrote:
> >
> > Tony Luck wrote:
> > >> +       static char target[80];
> > >  ...
> > >> +               sprintf(target,
> > >> "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-"
> > >> +                       "%02x%02x%02x%02x%02x%02x",
> > >
> > > [80] is overkill ... [37] bytes should be enough (unless I went
> > > cross-eyed counting the "%02x" :-)
> > >
> >
> > %02x doesn't guarantee that it's at most 2, but at LEAST 2...
> 
> How will you fit a number that requires >2 hex digits into an
> "unsigned char"?

eh eh because at first it was a signed char but I fixed that bug later

updated patch attached; using 38 to have a hard 0 at the end in case sprintf does
something weird and 2 cpus race over oopsing (I don't want to add locking to the oops codepath
if I can avoid it; the worst case with 38 is a truncated UUID string)


Subject: [patch] terminate the oops printing with a defined string/uuid
From: Arjan van de Ven <arjan@linux.intel.com>

Right now, it's hard for automated tools to determine when an oops has
ended; there's no clear marker for this. In addition, there's no good
way to find out if an oops is unique. Sometimes it's the same oops
just reported multiple times, while other times it's a different
instance of the crash with the same signature. Printing the boot UUID
as part of the end string resolves this ambiguity.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

---
 drivers/char/random.c  |   35 ++++++++++++++++++++++++++++++++++-
 include/linux/random.h |    1 +
 kernel/panic.c         |    2 ++
 3 files changed, 37 insertions(+), 1 deletion(-)

Index: linux-2.6.24-rc5/drivers/char/random.c
===================================================================
--- linux-2.6.24-rc5.orig/drivers/char/random.c
+++ linux-2.6.24-rc5/drivers/char/random.c
@@ -1176,8 +1176,41 @@ static int max_read_thresh = INPUT_POOL_
 static int max_write_thresh = INPUT_POOL_WORDS * 32;
 static char sysctl_bootid[16];
 
+/**
+ *	get_boot_uuid	- return a string pointer to a system wide boot UUID
+ *
+ *	Returns a pointer to the boot UUID. This UUID is unique per system
+ *	boot but persistent for one boot session.
+ *
+ *	The memory returned via the return pointer is static allocated and
+ *	owned by the random.c driver; this should not be kfree()'d.
+ *
+ *	Locking: none
+ */
+ */
+char *get_boot_uuid(void)
+{
+	static char target[38];
+	unsigned char *uuid;
+
+	if (sysctl_bootid[8] == 0)
+		generate_random_uuid(sysctl_bootid);
+	/* sysctl_bootid is signed, to print we need unsigned .. */
+	uuid = sysctl_bootid;
+
+	if (target[0] == 0) {
+		sprintf(target, "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-"
+			"%02x%02x%02x%02x%02x%02x",
+		uuid[0],  uuid[1],  uuid[2],  uuid[3],  uuid[4],
+		uuid[5],  uuid[6],  uuid[7],  uuid[8],  uuid[9],
+		uuid[10], uuid[11], uuid[12], uuid[13], uuid[14],
+		uuid[15]);
+	}
+	return target;
+}
+
 /*
- * These functions is used to return both the bootid UUID, and random
+ * These functions are used to return both the bootid UUID, and random
  * UUID.  The difference is in whether table->data is NULL; if it is,
  * then a new UUID is generated and returned to the user.
  *
Index: linux-2.6.24-rc5/include/linux/random.h
===================================================================
--- linux-2.6.24-rc5.orig/include/linux/random.h
+++ linux-2.6.24-rc5/include/linux/random.h
@@ -71,6 +71,7 @@ unsigned long randomize_range(unsigned l
 
 u32 random32(void);
 void srandom32(u32 seed);
+char *get_boot_uuid(void);
 
 #endif /* __KERNEL___ */
 
Index: linux-2.6.24-rc5/kernel/panic.c
===================================================================
--- linux-2.6.24-rc5.orig/kernel/panic.c
+++ linux-2.6.24-rc5/kernel/panic.c
@@ -19,6 +19,7 @@
 #include <linux/nmi.h>
 #include <linux/kexec.h>
 #include <linux/debug_locks.h>
+#include <linux/random.h>
 
 int panic_on_oops;
 int tainted;
@@ -272,6 +273,7 @@ void oops_enter(void)
 void oops_exit(void)
 {
 	do_oops_enter_exit();
+	printk("---[ end of trace %s ]---\n", get_boot_uuid());
 }
 
 #ifdef CONFIG_CC_STACKPROTECTOR
