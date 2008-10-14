Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbYJNWJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbYJNWJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 18:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbYJNWIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 18:08:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:32921 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbYJNWIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 18:08:54 -0400
Date: Tue, 14 Oct 2008 18:08:48 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ftrace: do not enclose logic in WARN_ON
Message-ID: <alpine.DEB.1.10.0810141804550.24272@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In ftrace, logic is defined in the WARN_ON_ONCE, which can become a
nop with some configs. This patch fixes it.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/ftrace.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-tip.git/arch/x86/kernel/ftrace.c
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/ftrace.c	2008-10-14 17:55:40.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/ftrace.c	2008-10-14 17:56:29.000000000 -0400
@@ -62,6 +62,7 @@ ftrace_modify_code(unsigned long ip, uns
 		   unsigned char *new_code)
 {
 	unsigned char replaced[MCOUNT_INSN_SIZE];
+	int ret;
 
 	/*
 	 * Note: Due to modules and __init, code can
@@ -77,8 +78,9 @@ ftrace_modify_code(unsigned long ip, uns
 	if (memcmp(replaced, old_code, MCOUNT_INSN_SIZE) != 0)
 		return 2;
 
-	WARN_ON_ONCE(__copy_to_user_inatomic((char __user *)ip, new_code,
-				    MCOUNT_INSN_SIZE));
+	ret = __copy_to_user_inatomic((char __user *)ip, new_code,
+					MCOUNT_INSN_SIZE);
+	WARN_ON_ONCE(ret);
 
 	sync_core();
 

