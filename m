Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbZJAJ7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbZJAJ7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 05:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756123AbZJAJ7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 05:59:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:55824 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756088AbZJAJ7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 05:59:40 -0400
Date: Thu, 1 Oct 2009 09:58:41 GMT
From: tip-bot for Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, jason.wessel@windriver.com,
       hannes@cmpxchg.org, lenb@kernel.org, akpm@linux-foundation.org,
       gregkh@suse.de, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jason.wessel@windriver.com, torvalds@linux-foundation.org,
       hannes@cmpxchg.org, lenb@kernel.org, akpm@linux-foundation.org,
       gregkh@suse.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4ABB7D5E.6000301@windriver.com>
References: <4ABB7D5E.6000301@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: earlyprintk: Fix regression to handle serial,ttySn as 1 arg
Message-ID: <tip-ea3acb199a5d7e4da1de0a4288eba993b29f33b9@git.kernel.org>
Git-Commit-ID: ea3acb199a5d7e4da1de0a4288eba993b29f33b9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 09:58:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea3acb199a5d7e4da1de0a4288eba993b29f33b9
Gitweb:     http://git.kernel.org/tip/ea3acb199a5d7e4da1de0a4288eba993b29f33b9
Author:     Jason Wessel <jason.wessel@windriver.com>
AuthorDate: Thu, 24 Sep 2009 09:08:30 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 1 Oct 2009 10:34:16 +0200

x86: earlyprintk: Fix regression to handle serial,ttySn as 1 arg

Commit c953094 ("early_printk: Allow more than one early console")
introduced a regression in the parsing of the earlyprintk= kernel
arguments.

If you specify "earlyprintk=serial,ttyS0,115200" as a kernel
argument, the "serial,ttyS" should be parsed as a single argument
and not as "serial" and then "ttyS".

Also update the documentation to reflect you can specify the ttyS
directly without the "serial" argument.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
LKML-Reference: <4ABB7D5E.6000301@windriver.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/kernel-parameters.txt |    1 +
 arch/x86/kernel/early_printk.c      |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6fa7292..9107b38 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -671,6 +671,7 @@ and is between 256 and 4096 characters. It is defined in the file
 	earlyprintk=	[X86,SH,BLACKFIN]
 			earlyprintk=vga
 			earlyprintk=serial[,ttySn[,baudrate]]
+			earlyprintk=ttySn[,baudrate]
 			earlyprintk=dbgp[debugController#]
 
 			Append ",keep" to not disable it when the real console
diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 41fd965..b9c830c 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -206,8 +206,11 @@ static int __init setup_early_printk(char *buf)
 
 	while (*buf != '\0') {
 		if (!strncmp(buf, "serial", 6)) {
-			early_serial_init(buf + 6);
+			buf += 6;
+			early_serial_init(buf);
 			early_console_register(&early_serial_console, keep);
+			if (!strncmp(buf, ",ttyS", 5))
+				buf += 5;
 		}
 		if (!strncmp(buf, "ttyS", 4)) {
 			early_serial_init(buf + 4);
