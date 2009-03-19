Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbZCSNt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbZCSNt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 09:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbZCSNts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 09:49:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501AbZCSNtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:49:47 -0400
Date: Thu, 19 Mar 2009 09:48:27 -0400 (EDT)
From: Miloslav Trmac <mitr@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, Steve Grubb <sgrubb@redhat.com>,
       John Dennis <jdennis@redhat.com>, linux-kernel@vger.kernel.org,
       Eric Paris <eparis@redhat.com>
Message-ID: <692263700.1702781237470507796.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1542533951.1702681237470446245.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Subject: Fwd: [PATCH] Audit: fix handling of 'strings' with NULL characters
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_55533_1271358058.1237470507793"
X-Originating-IP: [10.5.5.72]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_55533_1271358058.1237470507793
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hello,
this appears to have been lost somewhere...
    Mirek
------=_Part_55533_1271358058.1237470507793
Content-Type: message/rfc822
Content-Disposition: attachment

Return-Path: eparis@redhat.com
Received: from zmta01.collab.prod.int.phx2.redhat.com (LHLO
 zmta01.collab.prod.int.phx2.redhat.com) (10.5.5.31) by
 mail02.corp.redhat.com with LMTP; Thu, 11 Sep 2008 17:48:42 -0400 (EDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zmta01.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id 3F86D9061D
	for <mitr@redhat.com>; Thu, 11 Sep 2008 17:48:42 -0400 (EDT)
Received: from zmta01.collab.prod.int.phx2.redhat.com ([127.0.0.1])
	by localhost (zmta01.collab.prod.int.phx2.redhat.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B6FTiTvWG892 for <mitr@redhat.com>;
	Thu, 11 Sep 2008 17:48:42 -0400 (EDT)
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by zmta01.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id 10CB49060A
	for <mitr@mail.corp.redhat.com>; Thu, 11 Sep 2008 17:48:42 -0400 (EDT)
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8BLmeNL013040;
	Thu, 11 Sep 2008 17:48:40 -0400
Received: from [10.11.13.208] (vpn-13-208.rdu.redhat.com [10.11.13.208])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id m8BLmdcD003426;
	Thu, 11 Sep 2008 17:48:39 -0400
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
X-Scanned-By: MIMEDefang 2.58 on 172.16.52.254

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



------=_Part_55533_1271358058.1237470507793--
