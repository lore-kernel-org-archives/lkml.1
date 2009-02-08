Return-Path: <linux-kernel-owner+w=401wt.eu-S1753090AbZBHGWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbZBHGWu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 01:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZBHGWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 01:22:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51807 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbZBHGWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 01:22:41 -0500
Date: Sun, 8 Feb 2009 01:22:40 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
cc: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Arnd Bergmann <arnd@arndb.de>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] ftrace, powerpc64: fix math to calculate offset in TOC
Message-ID: <alpine.DEB.1.10.0902080118480.30802@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Paul,

I found the bug that was causing large modules to fail in setting
up dynamic ftrace. It wound up being a simple math error. To calculate
the offset in the TOC, I had used an OR, but the bottom half was
a signed extended short, and it should have been an addition.
The fix is in my tree below, as well as posted here.

-- Steve


The following patch is in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: ppc/ftrace


Steven Rostedt (1):
      ftrace, powerpc64: fix math to calculate offset in TOC

----
 arch/powerpc/kernel/ftrace.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)
---------------------------
commit 60e611577d908119bb515ead908a46b025a4c9f9
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Sat Feb 7 22:00:26 2009 -0800

    ftrace, powerpc64: fix math to calculate offset in TOC
    
    Impact: fix dynamic ftrace with large modules in PPC64
    
    The math to calculate the offset into the TOC that is taken from reading
    the trampoline is incorrect. The bottom half of the offset is a signed
    extended short. The current code was using an OR to create the offset
    when it should have been using an addition.
    
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index 88c641d..4112175 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -191,8 +191,9 @@ __ftrace_make_nop(struct module *mod,
 		return -EINVAL;
 	}
 
-	offset = (unsigned)((unsigned short)jmp[0]) << 16 |
-		(unsigned)((unsigned short)jmp[1]);
+	/* The bottom half is signed extended */
+	offset = ((unsigned)((unsigned short)jmp[0]) << 16) +
+		(int)((short)jmp[1]);
 
 	pr_debug(" %x ", offset);
 

