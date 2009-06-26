Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbZFZWaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbZFZWaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 18:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbZFZW3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 18:29:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55355 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392AbZFZW3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 18:29:43 -0400
Date: Fri, 26 Jun 2009 21:14:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, earl_chew@agilent.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       Roland McGrath <roland@redhat.com>
Subject: [PATCH 1/2] do_coredump: factor out put_cred() calls
Message-ID: <20090626191455.GB22603@redhat.com>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090625163050.d6a71a13.akpm@linux-foundation.org> <20090626180222.GD7337@hmsreliant.think-freely.org> <20090626165908.GB12063@redhat.com> <20090626202411.GH7337@hmsreliant.think-freely.org> <20090626191418.GA22603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626191418.GA22603@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given that do_coredump() calls put_cred() on exit path, it is a bit ugly
to do put_cred() + "goto fail" twice, just add the new "fail_creds" label.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- WAIT/fs/exec.c~CD_1_PUT_CRED	2009-06-15 12:48:28.000000000 +0200
+++ WAIT/fs/exec.c	2009-06-26 20:06:01.000000000 +0200
@@ -1732,13 +1732,11 @@ void do_coredump(long signr, int exit_co
 
 	binfmt = current->binfmt;
 	if (!binfmt || !binfmt->core_dump)
-		goto fail;
+		goto out;
 
 	cred = prepare_creds();
-	if (!cred) {
-		retval = -ENOMEM;
-		goto fail;
-	}
+	if (!cred)
+		goto out;
 
 	down_write(&mm->mmap_sem);
 	/*
@@ -1746,8 +1744,7 @@ void do_coredump(long signr, int exit_co
 	 */
 	if (mm->core_state || !get_dumpable(mm)) {
 		up_write(&mm->mmap_sem);
-		put_cred(cred);
-		goto fail;
+		goto fail_creds;
 	}
 
 	/*
@@ -1761,10 +1758,8 @@ void do_coredump(long signr, int exit_co
 	}
 
 	retval = coredump_wait(exit_code, &core_state);
-	if (retval < 0) {
-		put_cred(cred);
-		goto fail;
-	}
+	if (retval < 0)
+		goto fail_creds;
 
 	old_cred = override_creds(cred);
 
@@ -1862,9 +1857,10 @@ fail_unlock:
 	if (helper_argv)
 		argv_free(helper_argv);
 
+	coredump_finish(mm);
 	revert_creds(old_cred);
+fail_creds:
 	put_cred(cred);
-	coredump_finish(mm);
-fail:
+out:
 	return;
 }

