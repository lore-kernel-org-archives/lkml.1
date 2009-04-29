Return-Path: <linux-kernel-owner+w=401wt.eu-S1757759AbZD2Ms3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759AbZD2Ms3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757398AbZD2Mrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:47:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58543 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757400AbZD2Mrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:47:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] SELinux: Remove excessive interrupt disablement
To: linux-security-module@vger.kernel.org, jmorris@namei.org
Cc: dhowells@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 29 Apr 2009 13:47:19 +0100
Message-ID: <20090429124719.19278.51952.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to disable interrupts with spin_lock_irqsave() inside of
read_lock_irq().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/selinux/hooks.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)


diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index ba808ef..0702ba6 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2378,7 +2378,6 @@ static void selinux_bprm_committed_creds(struct linux_binprm *bprm)
 	struct sighand_struct *psig;
 	u32 osid, sid;
 	int rc, i;
-	unsigned long flags;
 
 	osid = tsec->osid;
 	sid = tsec->sid;
@@ -2410,9 +2409,9 @@ static void selinux_bprm_committed_creds(struct linux_binprm *bprm)
 	 * wait permission to the new task SID. */
 	read_lock_irq(&tasklist_lock);
 	psig = current->parent->sighand;
-	spin_lock_irqsave(&psig->siglock, flags);
+	spin_lock(&psig->siglock);
 	wake_up_interruptible(&current->parent->signal->wait_chldexit);
-	spin_unlock_irqrestore(&psig->siglock, flags);
+	spin_unlock(&psig->siglock);
 	read_unlock_irq(&tasklist_lock);
 }
 

