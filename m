Return-Path: <linux-kernel-owner+w=401wt.eu-S1760066AbZBTRiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066AbZBTRiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:38:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759695AbZBTRhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:37:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37990 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbZBTRhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:37:33 -0500
Date: Fri, 20 Feb 2009 12:37:31 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull v2] x86 page fault checker
In-Reply-To: <20090220155036.GA3225@elte.hu>
Message-ID: <alpine.DEB.2.00.0902201232510.13747@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0902201012220.29217@gandalf.stny.rr.com> <20090220155036.GA3225@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo,

I added your suggestion, and even tested it out. I cherry picked
a branch to remove your split_large fix, added this output, and then
added the changes that triggered the original bug. I got a very nasty 
warning, but the kernel resumed fine.

------------[ cut here ]------------
WARNING: at arch/x86/mm/fault.c:495 do_page_fault+0x2aa/0x890()
Hardware name: Precision WorkStation 470   
PMD has incorrect permission bits
[...]


Thanks,

-- Steve

Please pull the latest tip/x86/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/x86/urgent


Steven Rostedt (1):
      x86: check PMD in spurious_fault handler

----
 arch/x86/mm/fault.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)
---------------------------
commit 3c3e5694add02e665bbbd0fecfbbdcc0b903097a
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Thu Feb 19 11:46:36 2009 -0500

    x86: check PMD in spurious_fault handler
    
    Impact: fix to prevent hard lockup on bad PMD permissions
    
    If the PMD does not have the correct permissions for a page access,
    but the PTE does, the spurious fault handler will mistake the fault
    as a lazy TLB transaction. This will result in an infinite loop of:
    
     fault -> spurious_fault check (pass) -> return to code -> fault
    
    This patch adds a check and a warn on if the PTE passes the permissions
    but the PMD does not.
    
    [ Updated: Ingo Molnar suggested using WARN_ONCE with some text ]
    
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index c76ef1d..278d645 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -455,6 +455,7 @@ static int spurious_fault(unsigned long address,
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
+	int ret;
 
 	/* Reserved-bit violation or user access to kernel space? */
 	if (error_code & (PF_USER | PF_RSVD))
@@ -482,7 +483,17 @@ static int spurious_fault(unsigned long address,
 	if (!pte_present(*pte))
 		return 0;
 
-	return spurious_fault_check(error_code, pte);
+	ret = spurious_fault_check(error_code, pte);
+	if (!ret)
+		return 0;
+
+	/*
+	 * Make sure we have permissions in PMD
+	 * If not, then there's a bug in the page tables.
+	 */
+	ret = spurious_fault_check(error_code, (pte_t *) pmd);
+	WARN_ONCE(!ret, "PMD has incorrect permission bits\n");
+	return ret;
 }
 
 /*

