Return-Path: <linux-kernel-owner+w=401wt.eu-S1756282AbYIKVuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbYIKVuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 17:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbYIKVuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 17:50:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59068 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbYIKVuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 17:50:12 -0400
Subject: [PATCH] Audit: fix handling of 'strings' with NULL characters
From: Eric Paris <eparis@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, jdennis@redhat.com, mitr@redhat.com,
       akpm@linux-foundation.org, sgrubb@redhat.com
Content-Type: text/plain
Date: Thu, 11 Sep 2008 17:48:39 -0400
Message-Id: <1221169719.2952.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

currently audit_log_n_untrustedstring() uses
audit_string_contains_control() to check if the 'string' has any control
characters.  If the 'string' has an embedded NULL
audit_string_contains_control() will return that the data has no control
characters and will then pass the string to audit_log_n_string with the
total length, not the length up to the first NULL.  audit_log_n_string
does a memcpy of the entire length and so the actual audit record
emitted may then contain a NULL and then whatever random memory is after
the NULL.

Since we want to log the entire octet stream (if we can't trust the data
to be a string we can't trust that a NULL isn't actually a part of it)
we should just consider NULL as a control character.  If the caller is
certain they want to stop at the first NULL they should be using
audit_log_untrustedstring.

Signed-off-by: Eric Paris <eparis@redhat.com>

---

Miloslav, this is also going to take care of nulls in the TTY_AUDIT_USER
message from userspace.  Is it going to be common to have control
characters on that code path as well?  Do you want to change
audit_receive_msg() to also use the hex encoding directly instead of the
_n_untrustedstring interface?

 kernel/audit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 4414e93..ccb8d68 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1370,7 +1370,7 @@ void audit_log_n_string(struct audit_buffer *ab, const char *string,
 int audit_string_contains_control(const char *string, size_t len)
 {
 	const unsigned char *p;
-	for (p = string; p < (const unsigned char *)string + len && *p; p++) {
+	for (p = string; p < (const unsigned char *)string + len; p++) {
 		if (*p == '"' || *p < 0x21 || *p > 0x7e)
 			return 1;
 	}


