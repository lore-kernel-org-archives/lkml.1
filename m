Return-Path: <linux-kernel-owner+w=401wt.eu-S932500AbZDAPR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500AbZDAPR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 11:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759433AbZDAPRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 11:17:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:52845 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758081AbZDAPRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 11:17:17 -0400
Date: Wed, 1 Apr 2009 15:16:09 GMT
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, h-shimamoto@ct.jp.nec.com, hpa@zytor.com,
       mingo@redhat.com, oleg@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, h-shimamoto@ct.jp.nec.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, oleg@redhat.com,
       mingo@elte.hu
In-Reply-To: <49CBB54C.5080201@ct.jp.nec.com>
References: <49CBB54C.5080201@ct.jp.nec.com>
Subject: [tip:x86/urgent] x86: signal: check sas_ss_size instead of sas_ss_flags()
Message-ID: <tip-0f8f308925ebe0480bd9831d32963ee0b885e24b@git.kernel.org>
Git-Commit-ID: 0f8f308925ebe0480bd9831d32963ee0b885e24b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 15:16:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f8f308925ebe0480bd9831d32963ee0b885e24b
Gitweb:     http://git.kernel.org/tip/0f8f308925ebe0480bd9831d32963ee0b885e24b
Author:     Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
AuthorDate: Thu, 26 Mar 2009 10:03:08 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Apr 2009 17:13:17 +0200

x86: signal: check sas_ss_size instead of sas_ss_flags()

Impact: fix redundant and incorrect check

Oleg Nesterov noticed wrt commit:

  14fc9fb: x86: signal: check signal stack overflow properly

>> No need to check SA_ONSTACK if we're already using alternate signal stack.
>
> Yes, but this also mean that we don't need sas_ss_flags() under
> "if (!onsigstack)",

Checking on_sig_stack() in sas_ss_flags() at get_sigframe() is redundant
and not correct on 64 bit. To check sas_ss_size is enough.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: roland@redhat.com
LKML-Reference: <49CBB54C.5080201@ct.jp.nec.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/signal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index dfcc74a..1442516 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -221,7 +221,7 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 	if (!onsigstack) {
 		/* This is the X/Open sanctioned signal stack switching.  */
 		if (ka->sa.sa_flags & SA_ONSTACK) {
-			if (sas_ss_flags(sp) == 0)
+			if (current->sas_ss_size)
 				sp = current->sas_ss_sp + current->sas_ss_size;
 		} else {
 #ifdef CONFIG_X86_32
