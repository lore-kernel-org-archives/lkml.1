Return-Path: <linux-kernel-owner+w=401wt.eu-S933308AbYB0BFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933308AbYB0BFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 20:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764389AbYB0BFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 20:05:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54598
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1764382AbYB0BF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 20:05:28 -0500
Date: Tue, 26 Feb 2008 17:06:13 -0800 (PST)
Message-Id: <20080226.170613.107688605.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: [BUG] 2.6.25-rc3 hangs in early boot on Sun Ultra5
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080226.164900.193701385.davem@davemloft.net>
References: <18371.10207.58819.188510@alkaid.it.uu.se>
	<18371.54294.748777.976300@harpo.it.uu.se>
	<20080226.164900.193701385.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 26 Feb 2008 16:49:00 -0800 (PST)

[ Thomas, forgot to CC: you earlier, changeset
  a0c1e9073ef7428a14309cba010633a6cd6719ea ("futex: runtime enable pi
  and robust functionality") broke sparc64. ]

> From: Mikael Pettersson <mikpe@it.uu.se>
> Date: Tue, 26 Feb 2008 09:55:50 +0100
> 
> > Minor update: rc2-git7 has the slow initial console behaviour,
> > but successfully switches to the framebuffer. rc2-git8 however
> > hangs in the console handover. So I'll bisect git7->git8 next.
> 
> Between the VT layer registering it's console and the atyfb
> driver initializing we get a crash, and it happens on all
> sparc64 systems.  It is caused by this commit and I am working
> on a fix:

The following patch will let things "work" but the trick being used
here by the FUTEX layer is borderline valid in my opinion.

Basically for 10+ years on sparc64 we've had this check here in the
fault path, which makes sure that if we're processing an exception
table entry we really, truly, are doing an access to userspace from
the kernel.  Otherwise we OOPS.

What the FUTEX checking code is doing now is doing a "user" access
with set_fs(KERNEL_DS) since it runs from the kernel bootup early init
sequence.  And this is illegal according to the existing checks.

When we do set_fs(KERNEL_DS) then pass a "user" pointer down
into a system call or something like that, we give it a pointer
that "cannot fault".  So if we get into the fault handling
path here for a case like that we really do want to scream and
print out an OOPS message in my opinion.

I realize that not many platforms other than sparc64 can check
for things this precisely, but it's something to consider.

Did this FUTEX change go into -stable too?

diff --git a/arch/sparc64/mm/fault.c b/arch/sparc64/mm/fault.c
index e2027f2..9183633 100644
--- a/arch/sparc64/mm/fault.c
+++ b/arch/sparc64/mm/fault.c
@@ -244,16 +244,8 @@ static void do_kernel_fault(struct pt_regs *regs, int si_code, int fault_code,
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
