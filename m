Return-Path: <linux-kernel-owner+w=401wt.eu-S1030664AbXCSVnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030664AbXCSVnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030658AbXCSVnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:43:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59495 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965088AbXCSVnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:43:05 -0400
Date: Mon, 19 Mar 2007 14:41:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 30/31] fix deadlock in audit_log_task_context()
Message-ID: <20070319214116.GF9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-deadlock-in-audit_log_task_context.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Al Viro <viro@ftp.linux.org.uk>

[PATCH] fix deadlock in audit_log_task_context()

GFP_KERNEL allocations in non-blocking context; fixed by killing
an idiotic use of security_getprocattr().

Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Acked-by: James Morris <jmorris@namei.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/auditsc.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -734,28 +734,26 @@ static inline void audit_free_context(st
 void audit_log_task_context(struct audit_buffer *ab)
 {
 	char *ctx = NULL;
-	ssize_t len = 0;
+	unsigned len;
+	int error;
+	u32 sid;
 
-	len = security_getprocattr(current, "current", NULL, 0);
-	if (len < 0) {
-		if (len != -EINVAL)
+	selinux_get_task_sid(current, &sid);
+	if (!sid)
+		return;
+
+	error = selinux_sid_to_string(sid, &ctx, &len);
+	if (error) {
+		if (error != -EINVAL)
 			goto error_path;
 		return;
 	}
 
-	ctx = kmalloc(len, GFP_KERNEL);
-	if (!ctx)
-		goto error_path;
-
-	len = security_getprocattr(current, "current", ctx, len);
-	if (len < 0 )
-		goto error_path;
-
 	audit_log_format(ab, " subj=%s", ctx);
+	kfree(ctx);
 	return;
 
 error_path:
-	kfree(ctx);
 	audit_panic("error in audit_log_task_context");
 	return;
 }

-- 
