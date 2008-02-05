Return-Path: <linux-kernel-owner+w=401wt.eu-S1757218AbYBEQVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbYBEQVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYBEQVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:21:45 -0500
Received: from mail.windriver.com ([147.11.1.11]:56044 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbYBEQVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:21:44 -0500
Message-ID: <47A88CE4.3070205@windriver.com>
Date: Tue, 05 Feb 2008 10:20:52 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, phil.el@wanadoo.fr
CC: oprofile-list@lists.sourceforge.net
Subject: [PATCH][RFC] x86: oprofile 32bit stack traces on 64bit kernel
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Feb 2008 16:20:34.0246 (UTC) FILETIME=[08DD7E60:01C86813]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are multiple ways to write the same code, hence the reason this
is listed as an RFC patch.  I wanted to provide a working fix to
account for the case of executing 32 bit and 64 bit user space code on
a 64 bit kernel.

-----CLIP HERE-------

Allow oprofile's backtrace to work on a 32bit user space thread when
running on a 64bit kernel.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 arch/x86/oprofile/backtrace.c |   40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -52,6 +52,39 @@ struct frame_head {
 	unsigned long ret;
 } __attribute__((packed));
 
+
+#if defined(CONFIG_X86_64) && defined(CONFIG_IA32_EMULATION)
+struct frame_head32 {
+	unsigned int ebp;
+	unsigned int ret;
+} __attribute__((packed));
+
+static struct frame_head *
+dump_user_backtrace32(struct frame_head * head)
+{
+	struct frame_head32 bufhead[2];
+
+	/* Also check accessibility of one struct frame_head beyond */
+	if (!access_ok(VERIFY_READ, head, sizeof(bufhead)))
+		return NULL;
+	if (__copy_from_user_inatomic(bufhead, head, sizeof(bufhead)))
+		return NULL;
+	/* In a 32bit user space on a 64bit kernel the frame pointer and
+	 * PC are not at the same place as in the 64 registers.  This
+	 * requires some casting and checks of the 32bit register values
+	 * back to 64 pit pointers.
+	 */
+	oprofile_add_trace(bufhead[0].ret);
+
+	/* frame pointers should strictly progress back up the stack
+	 * (towards higher addresses) */
+	if (head >= (struct frame_head *)((unsigned long)bufhead[0].ebp))
+		return NULL;
+
+	return (struct frame_head *)((unsigned long)bufhead[0].ebp);
+}
+#endif
+
 static struct frame_head *
 dump_user_backtrace(struct frame_head * head)
 {
@@ -85,7 +118,12 @@ x86_backtrace(struct pt_regs * const reg
 				   &backtrace_ops, &depth);
 		return;
 	}
-
+#if defined(CONFIG_X86_64) && defined(CONFIG_IA32_EMULATION)
+	if (test_thread_flag(TIF_32BIT))
+		while (depth-- && head)
+			head = dump_user_backtrace32(head);
+	else
+#endif
 	while (depth-- && head)
 		head = dump_user_backtrace(head);
 }
