Return-Path: <linux-kernel-owner+w=401wt.eu-S1762466AbZGAAuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762466AbZGAAuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760890AbZGAAeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:22 -0400
Received: from kroah.org ([198.145.64.141]:60104 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760669AbZGAAeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:19 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:17 2009
Message-Id: <20090701002416.562974968@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Paris <eparis@redhat.com>, Mimi Zohar <zohar@us.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: [patch 014/108] IMA: Handle dentry_open failures
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=ima-handle-dentry_open-failures.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Paris <eparis@redhat.com>

commit f06dd16a03f6f7f72fab4db03be36e28c28c6fd6 upstream.

Currently IMA does not handle failures from dentry_open().  This means that we
leave a pointer set to ERR_PTR(errno) and then try to use it just a few lines
later in fput().  Oops.

Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/integrity/ima/ima_main.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -128,10 +128,6 @@ static int get_path_measurement(struct i
 {
 	int rc = 0;
 
-	if (IS_ERR(file)) {
-		pr_info("%s dentry_open failed\n", filename);
-		return rc;
-	}
 	iint->opencount++;
 	iint->readcount++;
 
@@ -197,6 +193,12 @@ int ima_path_check(struct path *path, in
 		struct vfsmount *mnt = mntget(path->mnt);
 
 		file = dentry_open(dentry, mnt, O_RDONLY, current_cred());
+		if (IS_ERR(file)) {
+			pr_info("%s dentry_open failed\n", dentry->d_name.name);
+			rc = PTR_ERR(file);
+			file = NULL;
+			goto out;
+		}
 		rc = get_path_measurement(iint, file, dentry->d_name.name);
 	}
 out:


