Return-Path: <linux-kernel-owner+w=401wt.eu-S1755091AbYIJWY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbYIJWY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 18:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbYIJWYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 18:24:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57732 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbYIJWYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 18:24:47 -0400
Subject: [PATCH 1/2] audit: fix NUL handling in untrusted strings
From: Miloslav =?UTF-8?Q?Trma=C4=8D?= <mitr@redhat.com>
To: viro@zeniv.linux.org.uk, Eric Paris <eparis@redhat.com>
Cc: linux-audit <linux-audit@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 00:23:38 +0200
Message-Id: <1221085418.2705.19.camel@amilo>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miloslav Trmac <mitr@redhat.com>

audit_string_contains_control() stops checking at the first NUL byte.
If audit_string_contains_control() returns FALSE,
audit_log_n_untrustedstring() submits the complete string - including
the NUL byte and all following bytes, up to the specified maximum length
- to audit_log_n_string(), which copies the data unchanged into the
audit record.

The audit record can thus contain a NUL byte (and some unchecked data
after that).  Because the user-space audit daemon treats audit records
as NUL-terminated strings, an untrusted string that is shorter than the
specified maximum length effectively terminates the audit record.

This patch modifies audit_log_n_untrustedstring() to only log the data
before the first NUL byte, if any.

Signed-off-by: Miloslav Trmac <mitr@redhat.com>
--- 
kernel/audit.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)
diff --git a/kernel/audit.c b/kernel/audit.c
index 4414e93..03b6397 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1362,6 +1362,12 @@ void audit_log_n_string(struct audit_buffer *ab, const char *string,
 	skb_put(skb, slen + 2);	/* don't include null terminator */
 }
 
+static inline int
+audit_is_control_character(unsigned char c)
+{
+	return c == '"' || c < 0x21 || c > 0x7E;
+}
+
 /**
  * audit_string_contains_control - does a string need to be logged in hex
  * @string: string to be checked
@@ -1371,7 +1377,7 @@ int audit_string_contains_control(const char *string, size_t len)
 {
 	const unsigned char *p;
 	for (p = string; p < (const unsigned char *)string + len && *p; p++) {
-		if (*p == '"' || *p < 0x21 || *p > 0x7e)
+		if (audit_is_control_character(*p))
 			return 1;
 	}
 	return 0;
@@ -1394,10 +1400,15 @@ int audit_string_contains_control(const char *string, size_t len)
 void audit_log_n_untrustedstring(struct audit_buffer *ab, const char *string,
 				 size_t len)
 {
-	if (audit_string_contains_control(string, len))
-		audit_log_n_hex(ab, string, len);
-	else
-		audit_log_n_string(ab, string, len);
+	const unsigned char *p;
+
+	for (p = string; p < (const unsigned char *)string + len && *p; p++) {
+		if (audit_is_control_character(*p)) {
+			audit_log_n_hex(ab, string, len);
+			return;
+		}
+	}
+	audit_log_n_string(ab, string, p - (const unsigned char *)string);
 }
 
 /**


