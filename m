Return-Path: <linux-kernel-owner+w=401wt.eu-S1763191AbYCUWrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763191AbYCUWrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762648AbYCUWqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:46:10 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:34720 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762629AbYCUWqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:46:08 -0400
Message-Id: <20080321224329.852791195@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:42:52 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 02/76] SPARC64: Loosen checks in exception table handling.
Content-Disposition: inline; filename=sparc64-loosen-checks-in-exception-table-handling.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: David S. Miller <davem@davemloft.net>

Upstream commits: 622eaec613130e6ea78f2a5d5070e3278b21cd8f
                  be71716e464f4ea38f08034dc666f2feb55535d9

Some parts of the kernel now do things like do *_user() accesses while
set_fs(KERNEL_DS) that fault on purpose.

See, for example, the code added by changeset
a0c1e9073ef7428a14309cba010633a6cd6719ea ("futex: runtime enable pi
and robust functionality").

That trips up the ASI sanity checking we make in do_kernel_fault().

Just remove it for now.  Maybe we can add it back later with an added
conditional which looks at the current get_fs() value.

Also, because of the new futex validation init handler, we have
to accept faults in init section text as well as the normal
kernel text.

Thanks to Tom Callaway for the bug report.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 arch/sparc64/mm/fault.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

--- a/arch/sparc64/mm/fault.c
+++ b/arch/sparc64/mm/fault.c
@@ -244,16 +244,8 @@ static void do_kernel_fault(struct pt_re
 	if (regs->tstate & TSTATE_PRIV) {
 		const struct exception_table_entry *entry;
 
-		if (asi == ASI_P && (insn & 0xc0800000) == 0xc0800000) {
-			if (insn & 0x2000)
-				asi = (regs->tstate >> 24);
-			else
-				asi = (insn >> 5);
-		}
-	
-		/* Look in asi.h: All _S asis have LS bit set */
-		if ((asi & 0x1) &&
-		    (entry = search_exception_tables(regs->tpc))) {
+		entry = search_exception_tables(regs->tpc);
+		if (entry) {
 			regs->tpc = entry->fixup;
 			regs->tnpc = regs->tpc + 4;
 			return;
@@ -294,7 +286,7 @@ asmlinkage void __kprobes do_sparc64_fau
 		unsigned long tpc = regs->tpc;
 
 		/* Sanity check the PC. */
-		if ((tpc >= KERNBASE && tpc < (unsigned long) _etext) ||
+		if ((tpc >= KERNBASE && tpc < (unsigned long) __init_end) ||
 		    (tpc >= MODULES_VADDR && tpc < MODULES_END)) {
 			/* Valid, no problems... */
 		} else {

-- 
