Return-Path: <linux-kernel-owner+w=401wt.eu-S1756435AbZGCJ0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435AbZGCJ0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbZGCJ0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:26:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45381 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbZGCJ0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:26:38 -0400
Date: Fri, 3 Jul 2009 11:23:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
       Roland McGrath <roland@redhat.com>
Subject: [PATCH] selinux_bprm_committed_creds: use __wake_up_parent()
Message-ID: <20090703092311.GA3712@redhat.com>
References: <200906301951.n5UJpUSY013305@imap1.linux-foundation.org> <11314.1246585948@turing-police.cc.vt.edu> <20090702192047.10b81ada.akpm@linux-foundation.org> <20090703081821.GA4051@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703081821.GA4051@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(depends on ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
 which exports __wake_up_parent)

Spotted by Valdis.Kletnieks@vt.edu.

selinux_bprm_committed_creds() should not play with ->wait_chldexit, now
that __wake_up_parent() is exported change the code to use this helper.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- WAIT/security/selinux/hooks.c~SEL_WAKE_PARENT	2009-06-16 17:01:42.000000000 +0200
+++ WAIT/security/selinux/hooks.c	2009-07-03 11:15:08.000000000 +0200
@@ -2404,7 +2404,7 @@ static void selinux_bprm_committed_creds
 	/* Wake up the parent if it is waiting so that it can recheck
 	 * wait permission to the new task SID. */
 	read_lock(&tasklist_lock);
-	wake_up_interruptible(&current->real_parent->signal->wait_chldexit);
+	__wake_up_parent(current, current->real_parent);
 	read_unlock(&tasklist_lock);
 }
 

