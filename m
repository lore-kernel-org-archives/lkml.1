Return-Path: <linux-kernel-owner+w=401wt.eu-S1763261AbZE2UV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763261AbZE2UV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 16:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763454AbZE2UUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 16:20:10 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41762 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763305AbZE2UTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 16:19:53 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Fri, 29 May 2009 13:19:14 -0700
Message-Id: <1243628376-22905-4-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
References: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0162]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 04/26] sysfs: sysfs_remove_dir stop checking for bogus cases.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

kobj->sd can not be NULL in sysfs_remove_dir.

sysfs_remove_dir is only called from kobject_add (to clean up after failure)
and from kobject_del at the end of a kobject's life.  In both cases kobject_add
has already called sysfs_create_dir successfully.  The only writers of
kobj->sd are sysfs_create_dir on sucess and sysfs_remove_dir when it clears
the kobj just before deleting the directory.

Which means at the time sysfs_remove_dir is called kobj->sd will be
valid.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/dir.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index b95cc07..a55e1d4 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -752,9 +752,6 @@ static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
 	struct sysfs_addrm_cxt acxt;
 	struct sysfs_dirent **pos;
 
-	if (!dir_sd)
-		return;
-
 	pr_debug("sysfs %s: removing dir\n", dir_sd->s_name);
 	sysfs_addrm_start(&acxt, dir_sd);
 	pos = &dir_sd->s_dir.children;
-- 
1.6.3.1.54.g99dd.dirty

