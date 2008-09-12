Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbYILUBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbYILUBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbYILUBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:01:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60147 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173AbYILUBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:01:06 -0400
Subject: [PATCH] Audit: Ignore terminating NUL in AUDIT_USER_TTY messages
From: Miloslav =?UTF-8?Q?Trma=C4=8D?= <mitr@redhat.com>
To: Eric Paris <eparis@redhat.com>, viro <viro@zeniv.linux.org.uk>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, jdennis@redhat.com,
       akpm@linux-foundation.org, sgrubb@redhat.com
In-Reply-To: <1221169719.2952.14.camel@localhost.localdomain>
References: <1221169719.2952.14.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 12 Sep 2008 21:59:04 +0200
Message-Id: <1221249545.2702.10.camel@amilo>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miloslav Trmac <mitr@redhat.com>

AUDIT_USER_TTY, like all other messages sent from user-space, is sent
NUL-terminated.  Unlike other user-space audit messages, which come only
from trusted sources, AUDIT_USER_TTY messages are processed using
audit_log_n_untrustedstring().

This patch modifies AUDIT_USER_TTY handling to ignore the trailing NUL
and use the "quoted_string" representation of the message if possible.

Signed-Off-By: Miloslav Trmac <mitr@redhat.com>
---
> Miloslav, this is also going to take care of nulls in the TTY_AUDIT_USER
> message from userspace.  Is it going to be common to have control
> characters on that code path as well?
AUDIT_USER_TTY will commonly contain spaces, but not always.  This patch
cleans the AUDIT_USER_TTY messages up a bit.

 kernel/audit.c |    3 +++
 1 file changed, 3 insertions(+)
diff --git a/kernel/audit.c b/kernel/audit.c
index ccb8d68..f3d88c4 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -763,6 +763,9 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 
 				audit_log_format(ab, " msg=");
 				size = nlmsg_len(nlh);
+				if (size > 0 &&
+				    ((unsigned char *)data)[size - 1] == '\0')
+					size--;
 				audit_log_n_untrustedstring(ab, data, size);
 			}
 			audit_set_pid(ab, pid);


