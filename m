Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbYH1Qc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbYH1Qc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 12:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbYH1QcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 12:32:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:57881 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874AbYH1QcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 12:32:14 -0400
Message-ID: <48B6D2C6.4010703@kernel.org>
Date: Thu, 28 Aug 2008 18:31:02 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] uevent: handle duplicate uevent_var keys properly
References: <48B6D28E.10006@kernel.org>
In-Reply-To: <48B6D28E.10006@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 Aug 2008 16:32:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add_uevent_var() appends the specified variable whether the new entry
has duplicate key or not.  This patch makes add_uevent_var() to
override the existing entry if an entry with the same key is added
later.  This will be used by CUSE (character device in userland) to
fake hotplug events.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 lib/kobject_uevent.c |   33 ++++++++++++++++++++++-----------
 1 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index ca215bc..64b1aaf 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -281,27 +281,38 @@ EXPORT_SYMBOL_GPL(kobject_uevent);
  */
 int add_uevent_var(struct kobj_uevent_env *env, const char *format, ...)
 {
+	char *buf = &env->buf[env->buflen];
+	size_t avail = sizeof(env->buf) - env->buflen;
 	va_list args;
-	int len;
+	int i, len, key_len;
 
-	if (env->envp_idx >= ARRAY_SIZE(env->envp)) {
-		WARN(1, KERN_ERR "add_uevent_var: too many keys\n");
+	va_start(args, format);
+	len = vsnprintf(buf, avail, format, args);
+	va_end(args);
+
+	if (len >= avail) {
+		printk(KERN_ERR "add_uevent_var: buffer size too small\n");
+		WARN_ON(1);
 		return -ENOMEM;
 	}
 
-	va_start(args, format);
-	len = vsnprintf(&env->buf[env->buflen],
-			sizeof(env->buf) - env->buflen,
-			format, args);
-	va_end(args);
+	key_len = strchr(buf, '=') - buf;
+
+	for (i = 0; i < env->envp_idx; i++)
+		if (key_len == strchr(env->envp[i], '=') - env->envp[i] &&
+		    !strncmp(buf, env->envp[i], key_len))
+			break;
 
-	if (len >= (sizeof(env->buf) - env->buflen)) {
-		WARN(1, KERN_ERR "add_uevent_var: buffer size too small\n");
+	if (i >= ARRAY_SIZE(env->envp)) {
+		printk(KERN_ERR "add_uevent_var: too many keys\n");
+		WARN_ON(1);
 		return -ENOMEM;
 	}
 
-	env->envp[env->envp_idx++] = &env->buf[env->buflen];
+	env->envp[i] = &env->buf[env->buflen];
 	env->buflen += len + 1;
+	if (i == env->envp_idx)
+		env->envp_idx++;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(add_uevent_var);
-- 
1.5.4.5

