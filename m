Return-Path: <linux-kernel-owner+w=401wt.eu-S1752454AbZILIlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbZILIlR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 04:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbZILIlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 04:41:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51618 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbZILIlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 04:41:16 -0400
Date: Sat, 12 Sep 2009 10:40:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Morris <jmorris@namei.org>, Thomas Liu <tliu@redhat.com>,
       Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] out-of-tree: Whack warning off in kernel/cred.c ...
Message-ID: <20090912084057.GA19659@elte.hu>
References: <a5388f3a349a38034ec677c64677afadd0541713.1252083485.git.zohar@linux.vnet.ibm.com> <alpine.LRH.2.00.0909071215530.3222@tundra.namei.org> <20090912072450.GA6767@elte.hu> <20090912075816.GA27306@elte.hu> <20090912081941.GA16903@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090912081941.GA16903@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > I'll try a blind (and manual) revert of:
> > 
> > ee18d64: KEYS: Add a keyctl to install a process's session keyring 
> > on its parent [try #6
> 
> that didnt do the trick, nor did this:
> 
>   1a51e09: Revert "KEYS: Add a keyctl to install a process's session keyring on its parent
> 
> These were the only two changes to cred.c.

Whacking off the BUG()s via the hack below gave me a booting system.

( Btw., WARN_ONCE() / WARN_ON_ONCE() constructs are in fashion these 
  days not BUG() - they are real time savers ;-) )

	Ingo

---------->
>From 2723334da705b2bb162bb6c7dabbbb4806278758 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 12 Sep 2009 10:21:33 +0200
Subject: [PATCH] out-of-tree: Whack warning off in kernel/cred.c ...

Prevent a crash with selinux=0.

NOT-Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/cred.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/cred.c b/kernel/cred.c
index 006fcab..782e362 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -817,10 +817,12 @@ static void dump_invalid_creds(const struct cred *cred, const char *label,
  */
 void __invalid_creds(const struct cred *cred, const char *file, unsigned line)
 {
+#if 0
 	printk(KERN_ERR "CRED: Invalid credentials\n");
 	printk(KERN_ERR "CRED: At %s:%u\n", file, line);
 	dump_invalid_creds(cred, "Specified", current);
 	BUG();
+#endif
 }
 EXPORT_SYMBOL(__invalid_creds);
 
@@ -844,6 +846,7 @@ void __validate_process_creds(struct task_struct *tsk,
 	return;
 
 invalid_creds:
+#if 0
 	printk(KERN_ERR "CRED: Invalid process credentials\n");
 	printk(KERN_ERR "CRED: At %s:%u\n", file, line);
 
@@ -853,6 +856,8 @@ invalid_creds:
 	else
 		printk(KERN_ERR "CRED: Effective creds == Real creds\n");
 	BUG();
+#endif
+	;
 }
 EXPORT_SYMBOL(__validate_process_creds);
 
