Return-Path: <linux-kernel-owner+w=401wt.eu-S1758630AbZAHLSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630AbZAHLSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 06:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbZAHLSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 06:18:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43696 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbZAHLSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 06:18:38 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] CRED: Fix commit_creds() on a process that has no mm
To: torvalds@osdl.org, jmorris@namei.org, akpm@linux-foundation.org,
       jirislaby@gmail.com
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Date: Thu, 08 Jan 2009 11:18:31 +0000
Message-ID: <20090108111831.27076.81306.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix commit_creds()'s handling of a process that has no mm (such as one that is
calling or has called daemonize()).  commit_creds() should check to see if
task->mm is not NULL before calling set_dumpable() on it.

Reported-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/cred.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/cred.c b/kernel/cred.c
index ff7bc07..480a61a 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -372,7 +372,8 @@ int commit_creds(struct cred *new)
 	    old->fsuid != new->fsuid ||
 	    old->fsgid != new->fsgid ||
 	    !cap_issubset(new->cap_permitted, old->cap_permitted)) {
-		set_dumpable(task->mm, suid_dumpable);
+		if (task->mm)
+			set_dumpable(task->mm, suid_dumpable);
 		task->pdeath_signal = 0;
 		smp_wmb();
 	}

