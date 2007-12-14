Return-Path: <linux-kernel-owner+w=401wt.eu-S1762882AbXLNJTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762882AbXLNJTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 04:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbXLNJT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 04:19:28 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:52425 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbXLNJT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 04:19:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=ZEocEgLPlU3bf7mlgkQAUbPaXPnbnIPxsJyzkfUHubUlGUBxjBy6jhdveKuMZD3heblcMVd93SqdSnJeuVvK9DmZ1HfzCMwlvocbPPFvpEgmE4pz1QNLfQWnidZJ44G2ilUGL/8ycdMBfg2htICc+2Rszj6hMYaLUVskAgxC93U=
Date: Fri, 14 Dec 2007 17:24:05 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: gregkh@suse.de
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH -mm] kobject_add error handling when set name failed
Message-ID: <20071214092405.GA3361@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kobject_add, when kobject_set_name failed we should put the kobj and return.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
lib/kobject.c |   11 ++++++++---
1 file changed, 8 insertions(+), 3 deletions(-)

diff -upr linux/lib/kobject.c linux.new/lib/kobject.c
--- linux/lib/kobject.c	2007-12-14 17:14:03.000000000 +0800
+++ linux.new/lib/kobject.c	2007-12-14 17:17:48.000000000 +0800
@@ -228,8 +228,13 @@ int kobject_add(struct kobject * kobj)
 
 	if (!(kobj = kobject_get(kobj)))
 		return -ENOENT;
-	if (!kobj->k_name)
-		kobject_set_name(kobj, "NO_NAME");
+	if (!kobj->k_name) {
+		error = kobject_set_name(kobj, "NO_NAME"));
+		if (error) {
+			kobject_put(kobj);
+			return error;
+		}
+	}
 	if (!*kobj->k_name) {
 		pr_debug("kobject (%p) attempted to be registered with no "
 			 "name!\n", kobj);
@@ -371,7 +376,7 @@ void kobject_init_ng(struct kobject *kob
 		goto error;
 	}
 	if (!ktype) {
-		err_str = "must have a ktype to be initialized properly!\n";
+		err_str = "must have a ktype to be initialized properly!";
 		goto error;
 	}
 	if (atomic_read(&kobj->kref.refcount)) {
