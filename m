Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbZJ0Rxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbZJ0Rxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 13:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756483AbZJ0Rxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 13:53:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47916 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480AbZJ0Rxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 13:53:48 -0400
Subject: [PATCH] [GIT PULL] tracing: allow to change permissions for text
 with dynamic ftrace enabled
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 27 Oct 2009 13:53:43 -0400
Message-Id: <1256666023.26028.411.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

The cause of the ftrace bug you saw in tip/master was caused by a change
in tip's x86/mm branch.

Please pull the latest tip/x86/mm tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/x86/mm


Steven Rostedt (1):
      tracing: allow to change permissions for text with dynamic ftrace enabled

----
 arch/x86/mm/pageattr.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)
---------------------------
commit 883242dd0e5faaba041528a9a99f483f2a656c83
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Tue Oct 27 13:15:11 2009 -0400

    tracing: allow to change permissions for text with dynamic ftrace enabled
    
    The commit 74e081797bd9d2a7d8005fe519e719df343a2ba8
    x86-64: align RODATA kernel section to 2MB with CONFIG_DEBUG_RODATA
    prevents text sections from becoming read/write using set_memory_rw.
    
    The dynamic ftrace changes all text pages to read/write just before
    converting the calls to tracing to nops, and vice versa.
    
    I orginally just added a flag to allow this transaction when ftrace
    did the change, but I also found that when the CPA testing was running
    it would remove the read/write as well, and ftrace does not do the text
    conversion on boot up, and the CPA changes caused the dynamic tracer
    to fail on self tests.
    
    The current solution I have is to simply not to prevent
    change_page_attr from setting the RW bit for kernel text pages.
    
    Reported-by: Ingo Molnar <mingo@elte.hu>
    Cc: Suresh Siddha <suresh.b.siddha@intel.com>
    Cc: H. Peter Anvin <hpa@zytor.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index b494fc4..78d3168 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -279,7 +279,8 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 		   __pa((unsigned long)__end_rodata) >> PAGE_SHIFT))
 		pgprot_val(forbidden) |= _PAGE_RW;
 
-#if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
+#if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA) && \
+	!defined(CONFIG_DYNAMIC_FTRACE)
 	/*
 	 * Kernel text mappings for the large page aligned .rodata section
 	 * will be read-only. For the kernel identity mappings covering


