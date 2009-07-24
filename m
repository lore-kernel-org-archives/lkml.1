Return-Path: <linux-kernel-owner+w=401wt.eu-S1752111AbZGXHMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbZGXHMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 03:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbZGXHMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 03:12:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52117 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbZGXHMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 03:12:32 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH] lib/kobject: put kobject if kobject_add_internal fails
Date: Fri, 24 Jul 2009 15:12:27 +0800
Message-Id: <1248419547-30261-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The proper way to use kobject_init_and_add should be:

        retval = kobject_init_and_add(&foo->kobj, &foo_ktype, NULL, "%s", name);
        if (retval) {
                kobject_put(&foo->kobj); (*)
                return NULL;
        }

kobject_init_and_add calls kobject_add_vargs finally, kobject_add_vargs is divided
into two parts: kobject_set_name_vargs and kobject_add_internal. Both the two parts
may return an error. If the error is came from kobject_add_internal, this means
kobject_set_name_vargs already alloc memory for kobj->name.

So if caller forgets to use kobject_put when this kind of error occurs, the memory
for kobj->name leaks. Unfortunately, most of the callers is forgotten to use
kobject_put in this rare situation, grep kobject_init_and_add in kernel source code,
there are 20+ files forgotten this. So I'd prefer to fix this in lib/kobject, not
the whole 20+ files.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
---
 lib/kobject.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index b512b74..e6e6e03 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -200,6 +200,7 @@ static int kobject_add_internal(struct kobject *kobj)
 			printk(KERN_ERR "%s failed for %s (%d)\n",
 			       __func__, kobject_name(kobj), error);
 		dump_stack();
+		kobject_put(kobj);
 	} else
 		kobj->state_in_sysfs = 1;
 
@@ -657,7 +658,6 @@ struct kobject *kobject_create_and_add(const char *name, struct kobject *parent)
 	if (retval) {
 		printk(KERN_WARNING "%s: kobject_add error: %d\n",
 		       __func__, retval);
-		kobject_put(kobj);
 		kobj = NULL;
 	}
 	return kobj;
-- 
1.6.2.5

