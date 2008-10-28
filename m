Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbYJ1Fb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbYJ1Fb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 01:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbYJ1Fa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 01:30:58 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:61253
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307AbYJ1Fa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 01:30:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAK9ABkl8qQJT/2dsb2JhbADHJ4NP
X-IronPort-AV: E=Sophos;i="4.33,496,1220198400"; 
   d="scan'208";a="268952988"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 2/2] autofs4 - fix string validation check order
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Tue, 28 Oct 2008 14:30:53 +0900
Message-ID: <20081028053053.29379.15598.stgit@zeus.themaw.net>
In-Reply-To: <20081028053047.29379.19919.stgit@zeus.themaw.net>
References: <20081028053047.29379.19919.stgit@zeus.themaw.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function validate_dev_ioctl() we check that the string we've
been sent is a valid path. The function that does this check
assumes the string is NULL terminated but our NULL termination
check isn't done until after this call. This patch changes the
order of the check.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/autofs4/dev-ioctl.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index 3d5a327..4a084fa 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -124,7 +124,7 @@ static inline void free_dev_ioctl(struct autofs_dev_ioctl *param)
 
 /*
  * Check sanity of parameter control fields and if a path is present
- * check that it has a "/" and is terminated.
+ * check that it is terminated and contains at least one "/".
  */
 static int validate_dev_ioctl(int cmd, struct autofs_dev_ioctl *param)
 {
@@ -137,15 +137,16 @@ static int validate_dev_ioctl(int cmd, struct autofs_dev_ioctl *param)
 	}
 
 	if (param->size > sizeof(*param)) {
-		err = check_name(param->path);
+		err = invalid_str(param->path,
+				 (void *) ((size_t) param + param->size));
 		if (err) {
-			AUTOFS_WARN("invalid path supplied for cmd(0x%08x)",
-				    cmd);
+			AUTOFS_WARN(
+			  "path string terminator missing for cmd(0x%08x)",
+			  cmd);
 			goto out;
 		}
 
-		err = invalid_str(param->path,
-				 (void *) ((size_t) param + param->size));
+		err = check_name(param->path);
 		if (err) {
 			AUTOFS_WARN("invalid path supplied for cmd(0x%08x)",
 				    cmd);

