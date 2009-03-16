Return-Path: <linux-kernel-owner+w=401wt.eu-S1762227AbZCPW5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762227AbZCPW5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 18:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452AbZCPW5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 18:57:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754592AbZCPW5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 18:57:42 -0400
Message-ID: <49BED952.2050809@redhat.com>
Date: Mon, 16 Mar 2009 18:57:22 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: [BUGFIX][PATCH] prevent boosting kprobes on exception address
References: <497FC3B1.7050805@redhat.com> <497FE895.1080708@redhat.com> <20090128154824.GA6025@Krystal> <49808EEF.1020700@redhat.com> <20090128171331.GA9006@Krystal> <49809CCE.40409@redhat.com> <20090128181053.GC9908@Krystal>
In-Reply-To: <20090128181053.GC9908@Krystal>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't boost at the addresses which are listed on exception tables,
because major page fault will occur on those addresses. In that case,
kprobes can not ensure that when instruction buffer can be freed
since some processes will sleep on the buffer.
(kprobes-ia64 already has same check.)

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 arch/x86/kernel/kprobes.c |    3 +++
 1 file changed, 3 insertions(+)

Index: mmotm/arch/x86/kernel/kprobes.c
===================================================================
--- mmotm.orig/arch/x86/kernel/kprobes.c
+++ mmotm/arch/x86/kernel/kprobes.c
@@ -193,6 +193,9 @@ static int __kprobes can_boost(kprobe_op
 	kprobe_opcode_t opcode;
 	kprobe_opcode_t *orig_opcodes = opcodes;

+	if (search_exception_tables(opcodes))
+		return 0;	/* Page fault may occur on this address. */
+
 retry:
 	if (opcodes - orig_opcodes > MAX_INSN_SIZE - 1)
 		return 0;
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


