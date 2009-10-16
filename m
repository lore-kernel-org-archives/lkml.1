Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbZJPRUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbZJPRUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756171AbZJPRUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:20:05 -0400
Received: from kroah.org ([198.145.64.141]:48673 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630AbZJPRSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:44 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:12:08 2009
Message-Id: <20091016171207.830595302@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michal Schmidt <mschmidt@redhat.com>,
       David Howells <dhowells@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       James Morris <jmorris@namei.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [40/46] bsdacct: switch credentials for writing to the accounting file
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=bsdacct-switch-credentials-for-writing-to-the-accounting-file.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michal Schmidt <mschmidt@redhat.com>

commit d8e180dcd5bbbab9cd3ff2e779efcf70692ef541 upstream.

When process accounting is enabled, every exiting process writes a log to
the account file.  In addition, every once in a while one of the exiting
processes checks whether there's enough free space for the log.

SELinux policy may or may not allow the exiting process to stat the fs.
So unsuspecting processes start generating AVC denials just because
someone enabled process accounting.

For these filesystem operations, the exiting process's credentials should
be temporarily switched to that of the process which enabled accounting,
because it's really that process which wanted to have the accounting
information logged.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/acct.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -491,13 +491,17 @@ static void do_acct_process(struct bsd_a
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
@@ -578,6 +582,8 @@ static void do_acct_process(struct bsd_a
 			       sizeof(acct_t), &file->f_pos);
 	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = flim;
 	set_fs(fs);
+out:
+	revert_creds(orig_cred);
 }
 
 /**


