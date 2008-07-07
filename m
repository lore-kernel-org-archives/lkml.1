Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbYGGQv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbYGGQv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbYGGQuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:50:05 -0400
Received: from aa2005110791d2e6c28a.userreverse.dion.ne.jp ([210.230.194.138]:20574
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754104AbYGGQuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:50:04 -0400
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2008 12:49:54 EDT
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 15/20] selinux: change handling of invalid classes (Was: Re: 2.6.26-rc5-mm1 selinux whine)
Date: Tue,  8 Jul 2008 01:42:17 +0900
Message-Id: <1215448942-17581-16-git-send-email-jmorris@namei.org>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1215448942-17581-1-git-send-email-jmorris@namei.org>
References: <1215448942-17581-1-git-send-email-jmorris@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Smalley <sds@tycho.nsa.gov>

On Mon, 2008-06-09 at 01:24 -0700, Andrew Morton wrote:
> Getting a few of these with FC5:
>
> SELinux: context_struct_compute_av:  unrecognized class 69
> SELinux: context_struct_compute_av:  unrecognized class 69
>
> one came out when I logged in.
>
> No other symptoms, yet.

Change handling of invalid classes by SELinux, reporting class values
unknown to the kernel as errors (w/ ratelimit applied) and handling
class values unknown to policy as normal denials.

Signed-off-by:  Stephen Smalley <sds@tycho.nsa.gov>
Acked-by: Eric Paris <eparis@redhat.com>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/ss/services.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 543fd0f..04c0b70 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -407,9 +407,19 @@ static int context_struct_compute_av(struct context *scontext,
 	return 0;
 
 inval_class:
-	printk(KERN_ERR "SELinux: %s:  unrecognized class %d\n", __func__,
-		tclass);
-	return -EINVAL;
+	if (!tclass || tclass > kdefs->cts_len ||
+	    !kdefs->class_to_string[tclass]) {
+		if (printk_ratelimit())
+			printk(KERN_ERR "SELinux: %s:  unrecognized class %d\n",
+			       __func__, tclass);
+		return -EINVAL;
+	}
+
+	/*
+	 * Known to the kernel, but not to the policy.
+	 * Handle as a denial (allowed is 0).
+	 */
+	return 0;
 }
 
 /*
-- 
1.5.5.1

