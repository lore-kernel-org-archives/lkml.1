Return-Path: <linux-kernel-owner+w=401wt.eu-S1759229AbZGGQqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229AbZGGQqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756602AbZGGQqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:46:35 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:34085 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756527AbZGGQqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:46:34 -0400
Date: Tue, 7 Jul 2009 12:46:24 -0400
From: Nelson Elhage <nelhage@ksplice.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jeff Arnold <jbarnold@ksplice.com>, linux-kernel@vger.kernel.org,
       tabbott@ksplice.com, wdaher@ksplice.com, andersk@ksplice.com,
       price@ksplice.com, geofft@ksplice.com
Subject: Re: Ksplice updates for Ubuntu 9.04 Jaunty
Message-ID: <20090707164624.GE15616@mit.edu>
References: <alpine.DEB.1.10.0906250451210.22588@vinegar-pot.mit.edu> <20090630063152.GC1351@ucw.cz> <alpine.DEB.1.10.0907010909250.26501@vinegar-pot.mit.edu> <20090702213823.GB1485@ucw.cz> <alpine.DEB.1.10.0907021740140.8890@vinegar-pot.mit.edu> <20090705184710.GB17910@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090705184710.GB17910@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 05, 2009 at 08:47:10PM +0200, Pavel Machek wrote:
> Lets say something adds field to task_struct. Can you handle that?

Yes. It looks like the most recent such patch that was added to a
stable tree is 3b53fbf. Applying that patch using Ksplice requires
writing about 40 semicolon-terminated lines of new code. I've included
the modified patch and the Ksplice command to apply it to a running
machine below.

Ksplice has not yet been fully honed for this case of adding fields to
data structures because this capability is rarely needed for bug-fix
patches. For now, we are carefully writing (and reviewing and testing)
these bits of new code as they are needed. In the future, these
patches that add fields to data structures will be even easier to
apply using Ksplice.

- Nelson Elhage

Once you've set up your kernel source directory for Ksplice [1], you can
apply this patch using two commands:

$ ksplice-create --patch=taskstruct.patch ~/linux-source
Ksplice update tarball written to ksplice-if5askfa.tar.gz
$ ksplice-apply ksplice-if5askfa.tar.gz

[1] http://www.ksplice.com/example-update

---
Original patch diffstat (stable tree 3b53fbf):
 include/linux/sched.h |    2 ++
 include/net/scm.h     |    5 +++--
 net/core/scm.c        |   24 +++++++++++++++++++++---
 3 files changed, 26 insertions(+), 5 deletions(-)

Modified Ksplice patch diffstat (below):
 net/core/scm.c |   76 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 73 insertions(+), 3 deletions(-)

diff --git a/net/core/scm.c b/net/core/scm.c
index 10f5c65..7280c89 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -36,6 +36,25 @@
 #include <net/compat.h>
 #include <net/scm.h>
 
+#include "ksplice-patch.h"
+#include "ksplice-shadow.h"
+
+struct task_struct_shadow {
+	struct list_head	*scm_work_list;
+};
+
+#define init_new_task_struct_shadow(shadow) (shadow)->scm_work_list = NULL
+DEFINE_SHADOW_FIELD(struct task_struct, struct task_struct_shadow, GFP_ATOMIC,
+                    task_struct, init_new_task_struct_shadow);
+
+struct scm_fp_list_shadow {
+	struct list_head	list;
+	struct scm_fp_list	*fpl;
+};
+
+#define init_new_fp_list_shadow(shadow) INIT_LIST_HEAD(&(shadow)->list)
+DEFINE_SHADOW_FIELD(struct scm_fp_list, struct scm_fp_list_shadow, GFP_ATOMIC,
+                    fp_list, init_new_fp_list_shadow);
 
 /*
  *	Only allow a user to send credentials, that they could set with
@@ -58,6 +77,7 @@ static int scm_fp_copy(struct cmsghdr *cmsg, struct scm_fp_list **fplp)
 {
 	int *fdp = (int*)CMSG_DATA(cmsg);
 	struct scm_fp_list *fpl = *fplp;
+	struct scm_fp_list_shadow *fpl_shadow;
 	struct file **fpp;
 	int i, num;
 
@@ -74,6 +94,11 @@ static int scm_fp_copy(struct cmsghdr *cmsg, struct scm_fp_list **fplp)
 		fpl = kmalloc(sizeof(struct scm_fp_list), GFP_KERNEL);
 		if (!fpl)
 			return -ENOMEM;
+		fpl_shadow = init_fp_list_shadow(fpl, GFP_KERNEL);
+		if (!fpl_shadow) {
+			kfree(fpl);
+			return -ENOMEM;
+		}
 		*fplp = fpl;
 		fpl->count = 0;
 	}
@@ -105,10 +130,48 @@ void __scm_destroy(struct scm_cookie *scm)
 	int i;
 
 	if (fpl) {
+		struct scm_fp_list_shadow *fpl_shadow;
+		struct task_struct_shadow *current_shadow;
+
+		fpl_shadow = make_fp_list_shadow(fpl, GFP_ATOMIC);
+		if (!fpl_shadow) {
+			printk(KERN_WARNING "__scm_destroy: Unable to allocate fpl_shadow");
+			WARN_ON(1);
+			return;
+		}
+
+		current_shadow = make_task_struct_shadow(current, GFP_ATOMIC);
+		if (!current_shadow) {
+			kfree(fpl_shadow);
+			printk(KERN_WARNING "__scm_destroy: Unable to allocate current_shadow");
+			WARN_ON(1);
+			return;
+		}
+
+		fpl_shadow->fpl = fpl;
 		scm->fp = NULL;
-		for (i=fpl->count-1; i>=0; i--)
-			fput(fpl->fp[i]);
-		kfree(fpl);
+		if (current_shadow->scm_work_list) {
+			list_add_tail(&fpl_shadow->list, current_shadow->scm_work_list);
+		} else {
+			LIST_HEAD(work_list);
+
+			current_shadow->scm_work_list = &work_list;
+
+			list_add(&fpl_shadow->list, &work_list);
+			while (!list_empty(&work_list)) {
+				fpl_shadow = list_first_entry(&work_list, struct scm_fp_list_shadow, list);
+				fpl = fpl_shadow->fpl;
+
+				list_del(&fpl_shadow->list);
+				for (i=fpl->count-1; i>=0; i--)
+					fput(fpl->fp[i]);
+
+				cleanup_fp_list_shadow(fpl);
+				kfree(fpl);
+			}
+
+			cleanup_task_struct_shadow(current);
+		}
 	}
 }
 
@@ -277,6 +340,7 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
 struct scm_fp_list *scm_fp_dup(struct scm_fp_list *fpl)
 {
 	struct scm_fp_list *new_fpl;
+	struct scm_fp_list_shadow *new_fpl_shadow;
 	int i;
 
 	if (!fpl)
@@ -284,6 +348,12 @@ struct scm_fp_list *scm_fp_dup(struct scm_fp_list *fpl)
 
 	new_fpl = kmalloc(sizeof(*fpl), GFP_KERNEL);
 	if (new_fpl) {
+		new_fpl_shadow = init_fp_list_shadow(new_fpl, GFP_KERNEL);
+		if (!new_fpl_shadow) {
+			kfree(new_fpl);
+			return NULL;
+		}
+
 		for (i=fpl->count-1; i>=0; i--)
 			get_file(fpl->fp[i]);
 		memcpy(new_fpl, fpl, sizeof(*fpl));
