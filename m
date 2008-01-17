Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbYAQA7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbYAQA7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 19:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbYAQA73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 19:59:29 -0500
Received: from lixom.net ([66.141.50.11]:52291 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876AbYAQA72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 19:59:28 -0500
Date: Wed, 16 Jan 2008 19:10:00 -0600
From: Olof Johansson <olof@lixom.net>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [patch 3/3]  Add bug/warn marker to generic report_bug()
Message-ID: <20080117011000.GC24766@lixom.net>
References: <20080117010130.GA24663@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117010130.GA24663@lixom.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Powerpc uses the generic report_bug() from lib/bug.c to report warnings,
and I'm guessing other arches do as well.

Add the module list as well as the end-of-trace marker to the output. This
required making print_oops_end_marker() nonstatic.


Signed-off-by: Olof Johansson <olof@lixom.net>


diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 94bc996..88d1aa3 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -133,6 +133,7 @@ NORET_TYPE void panic(const char * fmt, ...)
 extern void oops_enter(void);
 extern void oops_exit(void);
 extern int oops_may_print(void);
+extern void print_oops_end_marker(void);
 fastcall NORET_TYPE void do_exit(long error_code)
 	ATTRIB_NORET;
 NORET_TYPE void complete_and_exit(struct completion *, long)
diff --git a/kernel/panic.c b/kernel/panic.c
index d9e90cf..0269a7f 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -281,7 +281,7 @@ static int init_oops_id(void)
 }
 late_initcall(init_oops_id);
 
-static void print_oops_end_marker(void)
+void print_oops_end_marker(void)
 {
 	init_oops_id();
 	printk(KERN_WARNING "---[ end trace %016llx ]---\n",
diff --git a/lib/bug.c b/lib/bug.c
index 530f38f..3aa60a5 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -148,7 +148,9 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 			       "[verbose debug info unavailable]\n",
 			       (void *)bugaddr);
 
+		print_modules();
 		show_regs(regs);
+		print_oops_end_marker();
 		return BUG_TRAP_TYPE_WARN;
 	}
 
