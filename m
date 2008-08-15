Return-Path: <linux-kernel-owner+w=401wt.eu-S1760312AbYHOQYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760312AbYHOQYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 12:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbYHOQYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 12:24:21 -0400
Received: from smtp-out.google.com ([216.239.33.17]:58601 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbYHOQYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 12:24:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:mime-version:content-type:
	content-transfer-encoding:content-disposition;
	b=ODm7YPa7GWX4uSmWPxBmGCyRyGMbmF22251zPzaG8uGi4dBZ2T0WK0gyjW5M9EOT+
	8OQcEtcJVJ+j4+f6zwrTw==
Message-ID: <b040c32a0808150924h2b93529aj803e0b923e1f96f3@mail.gmail.com>
Date: Fri, 15 Aug 2008 09:24:15 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew G. Morgan" <morgan@kernel.org>
Subject: [patch] fix NPTL thread iterator construct in cap_set_pg()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of while_each_pid_task() construct in cap_set_pg() looks incorrect.
The macro is meant to form 'do ... while' loop instead of a simple while loop.
I think currently it will skip thread leader of a NPTL process.

Fix by convert to 'do ... while' style.

Signed-off-by: Ken Chen <kenchen@google.com>

diff --git a/kernel/capability.c b/kernel/capability.c
index 0101e84..26d8eda 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -167,7 +167,7 @@ static inline int cap_set_pg
 	pgrp = find_vpid(pgrp_nr);
 	do_each_pid_task(pgrp, PIDTYPE_PGID, g) {
 		target = g;
-		while_each_thread(g, target) {
+		do {
 			if (!security_capset_check(target, effective,
 						   inheritable, permitted)) {
 				security_capset_set(target, effective,
@@ -175,7 +175,7 @@ static inline int cap_set_pg
 				ret = 0;
 			}
 			found = 1;
-		}
+		} while_each_thread(g, target);
 	} while_each_pid_task(pgrp, PIDTYPE_PGID, g);

 	read_unlock(&tasklist_lock);
