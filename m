Return-Path: <linux-kernel-owner+w=401wt.eu-S1764484AbYCDNOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764484AbYCDNOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 08:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758284AbYCDNOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 08:14:14 -0500
Received: from gv-out-0910.google.com ([216.239.58.190]:59911 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760150AbYCDNON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 08:14:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=D4Ts8ho3jixrL4iqxJCrR9fPEvD/IlCy3PySuO/wmpxEbikZDVKIiKY5qOrehiiPlVTS5yUew2Rt31XRd4+3cy9lNTmgpwpQPA4tfILIkXwK/iUiG9Hjt0nph0Eh1aknmwaOWSewp4fK4xL39ytOYtg5naSVtjacNRR9v3Agsjk=
Date: Tue, 4 Mar 2008 15:10:55 +0200
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus <torvalds@linux-foundation.org>
Subject: [PATCH BUGFIX -rc3] Smack: Don't register smackfs if we're not
	loaded
Message-ID: <20080304131055.GA25577@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Smackfs initialization without an enabled Smack leads to
an early Oops that renders the system unusable.

Introduce a global smack_enabled variable that will be used
to make sure that no smack components will be registered 
(ala smackfs) if we are not already enabled.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

The Oops is triggered by the security= patch that will be sent
soon.

I can't imagine an SELinux guru finding /smackfs instead of 
his usual /selinuxfs when he hits a tab completion after 's' ;).
As a bonus, this patch will handle that case too.

 smack.h     |    9 +++++++++
 smack_lsm.c |    8 ++++++++
 smackfs.c   |    3 +++

 3 files changed, 20 insertions(+)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index a21a0e9..17c55ad 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -18,6 +18,15 @@
 #include <net/netlabel.h>
 
 /*
+ * We must not bother the rest of the kernel by exporting our
+ * own stuff if we are not already enabled. We may not be loaded
+ * if another or no LSM was chosen on boot.
+ * Smackfs is currently the only exported component, but this
+ * may change in the future.
+ */
+extern int smack_enabled;
+
+/*
  * Why 23? CIPSO is constrained to 30, so a 32 byte buffer is
  * bigger than can be used, and 24 is the next lower multiple
  * of 8, and there are too many issues if there isn't space set
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 770eb06..6fe7869 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -36,6 +36,8 @@
 #define SOCKFS_MAGIC		0x534F434B
 #define TMPFS_MAGIC		0x01021994
 
+int smack_enabled;
+
 /**
  * smk_fetch - Fetch the smack label from a file.
  * @ip: a pointer to the inode
@@ -2589,6 +2591,12 @@ static __init int smack_init(void)
 	if (register_security(&smack_ops))
 		panic("smack: Unable to register with kernel.\n");
 
+	/*
+	 * Notify other Smack components that it's now safe to
+	 * to register themselves.
+	 */
+	smack_enabled = 1;
+
 	return 0;
 }
 
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 358c92c..e1687c0 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -992,6 +992,9 @@ static int __init init_smk_fs(void)
 {
 	int err;
 
+	if (!smack_enabled)
+		return 0;
+
 	err = register_filesystem(&smk_fs_type);
 	if (!err) {
 		smackfs_mount = kern_mount(&smk_fs_type);

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

