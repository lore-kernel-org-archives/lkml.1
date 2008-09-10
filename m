Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbYIJWav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbYIJWav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 18:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbYIJWan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 18:30:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47304 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbYIJWam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 18:30:42 -0400
Subject: [PATCH 2/2] audit: Handle embedded NUL in TTY input auditing
From: Miloslav =?UTF-8?Q?Trma=C4=8D?= <mitr@redhat.com>
To: viro@zeniv.linux.org.uk, Eric Paris <eparis@redhat.com>
Cc: linux-audit <linux-audit@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 00:29:33 +0200
Message-Id: <1221085773.2705.25.camel@amilo>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miloslav Trmac <mitr@redhat.com>

Data read from a TTY can contain an embedded NUL byte (e.g. after
pressing Ctrl-2, or sent to a PTY).  After the previous patch, the data
would be logged only up to the first NUL.

This patch modifies the AUDIT_TTY record to always use the hexadecimal
format, which does not terminate at the first NUL byte.  The vast
majority of recorded TTY input data will contain either ' ' or '\n', so
the hexadecimal format would have been used anyway.

Signed-off-by: Miloslav Trmac <mitr@redhat.com>
---
 tty_audit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
diff --git a/drivers/char/tty_audit.c b/drivers/char/tty_audit.c
index 3582f43..5787249 100644
--- a/drivers/char/tty_audit.c
+++ b/drivers/char/tty_audit.c
@@ -93,7 +93,7 @@ static void tty_audit_buf_push(struct task_struct *tsk, uid_t loginuid,
 		get_task_comm(name, tsk);
 		audit_log_untrustedstring(ab, name);
 		audit_log_format(ab, " data=");
-		audit_log_n_untrustedstring(ab, buf->data, buf->valid);
+		audit_log_n_hex(ab, buf->data, buf->valid);
 		audit_log_end(ab);
 	}
 	buf->valid = 0;


