Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbZCNBVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbZCNBVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbZCNBTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:19:46 -0400
Received: from kroah.org ([198.145.64.141]:34745 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751835AbZCNBTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:19:45 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:31 2009
Message-Id: <20090314011031.814268622@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:09:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 004/114] sparc64: Fix DAX handling via userspace access from kernel.
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=sparc64-fix-dax-handling-via-userspace-access-from-kernel.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit fcd26f7ae2ea5889134e8b3d60a42ce8b993c95f ]

If we do a userspace access from kernel mode, and get a
data access exception, we need to check the exception
table just like a normal fault does.

The spitfire DAX handler was doing this, but such logic
was missing from the sun4v DAX code.

Reported-by: Dennis Gilmore <dgilmore@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/traps.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/arch/sparc64/kernel/traps.c
+++ b/arch/sparc64/kernel/traps.c
@@ -1,6 +1,6 @@
 /* arch/sparc64/kernel/traps.c
  *
- * Copyright (C) 1995,1997,2008 David S. Miller (davem@davemloft.net)
+ * Copyright (C) 1995,1997,2008,2009 David S. Miller (davem@davemloft.net)
  * Copyright (C) 1997,1999,2000 Jakub Jelinek (jakub@redhat.com)
  */
 
@@ -313,6 +313,21 @@ void sun4v_data_access_exception(struct 
 		return;
 
 	if (regs->tstate & TSTATE_PRIV) {
+		/* Test if this comes from uaccess places. */
+		const struct exception_table_entry *entry;
+
+		entry = search_exception_tables(regs->tpc);
+		if (entry) {
+			/* Ouch, somebody is trying VM hole tricks on us... */
+#ifdef DEBUG_EXCEPTIONS
+			printk("Exception: PC<%016lx> faddr<UNKNOWN>\n", regs->tpc);
+			printk("EX_TABLE: insn<%016lx> fixup<%016lx>\n",
+			       regs->tpc, entry->fixup);
+#endif
+			regs->tpc = entry->fixup;
+			regs->tnpc = regs->tpc + 4;
+			return;
+		}
 		printk("sun4v_data_access_exception: ADDR[%016lx] "
 		       "CTX[%04x] TYPE[%04x], going.\n",
 		       addr, ctx, type);


