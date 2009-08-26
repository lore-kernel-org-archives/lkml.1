Return-Path: <linux-kernel-owner+w=401wt.eu-S932872AbZHZCKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872AbZHZCKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 22:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932834AbZHZCKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 22:10:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52019 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932814AbZHZCKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 22:10:04 -0400
Date: Tue, 25 Aug 2009 22:10:05 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Mimi Zohar <zohar@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, eparis@redhat.com,
       torvalds@linux-foundation.org
Subject: [PATCH] allow disabling IMA at runtime
Message-ID: <20090826021005.GD19494@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

Due to a memory leak in IMA that we're currently debugging in Fedora
rawhide, it would be nice to be able to disable that support at runtime.
Currently it's only able to be built in, and there's no toggle to avoid
initializing it.

Provide one, in order to enhance debuggability. If a user can reboot a
machine and edit its command line, one can do a far sight worse things
than disabling a security precaution.

Signed-off-by: Kyle McMartin <kyle@redhat.com>

---
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7936b80..0d1b1ed 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -926,6 +926,11 @@ and is between 256 and 4096 characters. It is defined in the file
 	ihash_entries=	[KNL]
 			Set number of hash buckets for inode cache.
 
+	ima=		[IMA]
+			Format: { "0" | "1" }
+			0 -- disable IMA.
+			1 -- enable IMA. (default)
+
 	ima_audit=	[IMA]
 			Format: { "0" | "1" }
 			0 -- integrity auditing messages. (Default)
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 101c512..cc7603e 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -339,10 +339,27 @@ int ima_bprm_check(struct linux_binprm *bprm)
 	return 0;
 }
 
+static int ima_disabled = 0;
+static int __init ima_enabled(char *str)
+{
+	unsigned long enabled;
+
+	if (!strict_strtoul(str, 0, &enabled))
+		ima_disabled = enabled ? 0 : 1;
+
+	return 1;
+}
+__setup("ima=", ima_enabled);
+
 static int __init init_ima(void)
 {
 	int error;
 
+	if (ima_disabled) {
+		pr_info("IMA disabled at user request.\n");
+		return 0;
+	}
+
 	ima_iintcache_init();
 	error = ima_init();
 	ima_initialized = 1;
