Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbZHTNoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbZHTNoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbZHTNoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:44:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754428AbZHTNox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:44:53 -0400
Date: Thu, 20 Aug 2009 15:47:34 +0200
From: Michal Schmidt <mschmidt@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2] bsdacct: switch credentials for writing to the
 accounting file
Message-ID: <20090820154734.3db7d7ae@leela>
In-Reply-To: <17328.1250762526@redhat.com>
References: <20090819163616.3716.18477.stgit@localhost.localdomain>
	<17328.1250762526@redhat.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When process accounting is enabled, every exiting process writes a log
to the account file. In addition, every once in a while one of the
exiting processes checks whether there's enough free space for the log.

SELinux policy may or may not allow the exiting process to stat the fs.
So unsuspecting processes start generating AVC denials just because
someone enabled process accounting.

For these filesystem operations, the exiting process's credentials
should be temporarily switched to that of the process which enabled
accounting, because it's really that process who wanted to have the
accounting information logged.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
---

Dne Thu, 20 Aug 2009 11:02:06 +0100 David Howells napsal:
> Do you really need to keep creds in acct?  Can you used
> acct->file->f_cred instead?  Those are the credentials of the process
> that opened the file, so acct->cred may be redundant.
> 
> Other than that, it looks reasonable.

You're right, I didn't realize that. That makes the patch much simpler.

 kernel/acct.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index 9f33910..9a4715a 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -491,13 +491,17 @@ static void do_acct_process(struct bsd_acct_struct *acct,
 	u64 run_time;
 	struct timespec uptime;
 	struct tty_struct *tty;
+	const struct cred *orig_cred;
+
+	/* Perform file operations on behalf of whoever enabled accounting */
+	orig_cred = override_creds(file->f_cred);
 
 	/*
 	 * First check to see if there is enough free_space to continue
 	 * the process accounting system.
 	 */
 	if (!check_free_space(acct, file))
-		return;
+		goto out;
 
 	/*
 	 * Fill the accounting struct with the needed info as recorded
@@ -578,6 +582,8 @@ static void do_acct_process(struct bsd_acct_struct *acct,
 			       sizeof(acct_t), &file->f_pos);
 	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = flim;
 	set_fs(fs);
+out:
+	revert_creds(orig_cred);
 }
 
 /**
-- 
1.6.2.5

