Return-Path: <linux-kernel-owner+w=401wt.eu-S1754190AbXJHVeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbXJHVeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 17:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbXJHVeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 17:34:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773AbXJHVeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 17:34:10 -0400
Subject: [PATCH 2/3] Audit: break a large single execve argument into
	smaller records
From: Eric Paris <eparis@redhat.com>
To: linux-audit@redhat.com
Cc: sgrubb@redhat.com, aviro@redhat.com, klaus@atsec.com,
       linux-kernel@vger.kernel.org, mchouque@free.fr
Content-Type: text/plain
Date: Mon, 08 Oct 2007 17:34:04 -0400
Message-Id: <1191879244.3132.42.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    support single arguments that are large, not just large lists of execve args.
    This also means we never have to get a kernel buffer larger than
    MAX_EXECVE_AUDIT_LEN no matter how large the argument is.  Before this patch
    we could need to allocate 32 consecutive pages to hold one argument which could
    pretty easily oom.
    
    a single argument larger than MAX_EXECVE_AUDIT_LEN is broken into multiple
    records and have a format like   a10[0] a10[1] a10[2] etc.
    
    Signed-off-by: Eric Paris <eparis@redhat.com>
---

example audit log (about 50k long) for the whole patch series can be
found at http://people.redhat.com/~eparis/audit/audit.log the execve in
question was something like:

program_name [about 50 arguments] [one argument which is about 17k long] [about 1000 arguments]

 kernel/auditsc.c |   42 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 4176db6..ffc8d4b 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -853,6 +853,48 @@ static void audit_log_execve_info(struct audit_context *context,
 			send_sig(SIGKILL, current, 0);
 		}
 
+		if (unlikely(len > MAX_EXECVE_AUDIT_LEN)) {
+			/* deal with single arugments > MAX_EXECVE_AUDIT_LEN */
+			int j;
+			const long tmplen = sizeof(char) * MAX_EXECVE_AUDIT_LEN;
+
+			buf = kmalloc(tmplen + 1, GFP_KERNEL);
+			if (!buf) {
+				audit_panic("out of memory for argv string\n");
+				return;
+			}
+			buf[tmplen] = '\0';
+			for (j = 0; len > 0; j++) {
+				if (len > tmplen) {
+					ret = copy_from_user(buf, p, tmplen);
+					p += tmplen;
+					len -= tmplen;
+				} else {
+					ret = copy_from_user(buf, p, len);
+					/* p is at the next arg */
+					p += len;
+					/* 27 is the max length of a%d[%d] */
+					len_sent = len + 27;
+					len  = 0;
+				}
+				if (ret) {
+					WARN_ON(1);
+					send_sig(SIGKILL, current, 0);
+				}
+				audit_log_end(*ab);
+				*ab = audit_log_start(context, GFP_KERNEL,
+						      AUDIT_EXECVE);
+				if (!*ab) {
+					kfree(buf);
+					return;
+				}
+				audit_log_format(*ab, "a%d[%d]=", i, j);
+				audit_log_untrustedstring(*ab, buf);
+				audit_log_format(*ab, "\n");
+			}
+			continue;
+		}
+
 		buf = kmalloc(len, GFP_KERNEL);
 		if (!buf) {
 			audit_panic("out of memory for argv string\n");


