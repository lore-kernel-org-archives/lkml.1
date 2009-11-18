Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbZKRSoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbZKRSoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755671AbZKRSoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:44:18 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:41647 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700AbZKRSoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:44:17 -0500
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org
References: <m13a4pjjh9.fsf@fess.ebiederm.org>
	<200911082215.HGJ57827.SJOVFFOHMOLFQt@I-love.SAKURA.ne.jp>
	<m1bpjch9hy.fsf@fess.ebiederm.org>
	<200911090012.nA90CF2i016994@www262.sakura.ne.jp>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 18 Nov 2009 10:44:17 -0800
In-Reply-To: <200911090012.nA90CF2i016994@www262.sakura.ne.jp> (Tetsuo Handa's message of "Mon\, 09 Nov 2009 09\:12\:15 +0900")
Message-ID: <m1zl6j65by.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 00/23] Removal of binary sysctl support
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> writes:

> Eric W. Biederman wrote:
>> There has been a gradual transition from the assumption that the table ends with
>> !ctl_name to the assumption that procname == NULL.  There is no sysctl entry
>> with a valid ctl_name without a valid procname.
>
> I see. Then, please add below one to your patchset.

I have been looking at this and in the sysctl tree I am now going through
the vfs for all of the the operations on /proc/sys.  I believe that means
we can completely remove the sysctl special case in tomoyo.  Like I have
in the patch below.

Will that work?

Eric

diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
index 3f93bb9..8a00ade 100644
--- a/security/tomoyo/tomoyo.c
+++ b/security/tomoyo/tomoyo.c
@@ -85,75 +85,6 @@ static int tomoyo_bprm_check_security(struct linux_binprm *bprm)
 	return tomoyo_check_open_permission(domain, &bprm->file->f_path, 1);
 }
 
-#ifdef CONFIG_SYSCTL
-
-static int tomoyo_prepend(char **buffer, int *buflen, const char *str)
-{
-	int namelen = strlen(str);
-
-	if (*buflen < namelen)
-		return -ENOMEM;
-	*buflen -= namelen;
-	*buffer -= namelen;
-	memcpy(*buffer, str, namelen);
-	return 0;
-}
-
-/**
- * tomoyo_sysctl_path - return the realpath of a ctl_table.
- * @table: pointer to "struct ctl_table".
- *
- * Returns realpath(3) of the @table on success.
- * Returns NULL on failure.
- *
- * This function uses tomoyo_alloc(), so the caller must call tomoyo_free()
- * if this function didn't return NULL.
- */
-static char *tomoyo_sysctl_path(struct ctl_table *table)
-{
-	int buflen = TOMOYO_MAX_PATHNAME_LEN;
-	char *buf = tomoyo_alloc(buflen);
-	char *end = buf + buflen;
-	int error = -ENOMEM;
-
-	if (!buf)
-		return NULL;
-
-	*--end = '\0';
-	buflen--;
-	while (table) {
-		if (tomoyo_prepend(&end, &buflen, table->procname) ||
-		    tomoyo_prepend(&end, &buflen, "/"))
-			goto out;
-		table = table->parent;
-	}
-	if (tomoyo_prepend(&end, &buflen, "/proc/sys"))
-		goto out;
-	error = tomoyo_encode(buf, end - buf, end);
- out:
-	if (!error)
-		return buf;
-	tomoyo_free(buf);
-	return NULL;
-}
-
-static int tomoyo_sysctl(struct ctl_table *table, int op)
-{
-	int error;
-	char *name;
-
-	op &= MAY_READ | MAY_WRITE;
-	if (!op)
-		return 0;
-	name = tomoyo_sysctl_path(table);
-	if (!name)
-		return -ENOMEM;
-	error = tomoyo_check_file_perm(tomoyo_domain(), name, op);
-	tomoyo_free(name);
-	return error;
-}
-#endif
-
 static int tomoyo_path_truncate(struct path *path, loff_t length,
 				unsigned int time_attrs)
 {
@@ -274,9 +205,6 @@ static struct security_operations tomoyo_security_ops = {
 	.cred_transfer	     = tomoyo_cred_transfer,
 	.bprm_set_creds      = tomoyo_bprm_set_creds,
 	.bprm_check_security = tomoyo_bprm_check_security,
-#ifdef CONFIG_SYSCTL
-	.sysctl              = tomoyo_sysctl,
-#endif
 	.file_fcntl          = tomoyo_file_fcntl,
 	.dentry_open         = tomoyo_dentry_open,
 	.path_truncate       = tomoyo_path_truncate,
