Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbYHRTGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbYHRTGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762529AbYHRTDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:03:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37153 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757679AbYHRTDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:03:48 -0400
Date: Mon, 18 Aug 2008 11:45:17 -0700
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
Subject: [patch 47/60] sparc64: Fix end-of-stack checking in
	save_stack_trace().
Message-ID: <20080818184517.GV29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0001-sparc64-Fix-end-of-stack-checking-in-save_stack_tra.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit 433c5f706856689be25928a99636e724fb3ea7cf ]

Bug reported by Alexander Beregalov.

Before we dereference the stack frame or try to peek at the
pt_regs magic value, make sure the entire object is within
the kernel stack bounds.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/stacktrace.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/sparc64/kernel/stacktrace.c
+++ b/arch/sparc64/kernel/stacktrace.c
@@ -25,13 +25,15 @@ void save_stack_trace(struct stack_trace
 
 		/* Bogus frame pointer? */
 		if (fp < (thread_base + sizeof(struct thread_info)) ||
-		    fp >= (thread_base + THREAD_SIZE))
+		    fp > (thread_base + THREAD_SIZE - sizeof(struct sparc_stackf)))
 			break;
 
 		sf = (struct sparc_stackf *) fp;
 		regs = (struct pt_regs *) (sf + 1);
 
-		if ((regs->magic & ~0x1ff) == PT_REGS_MAGIC) {
+		if (((unsigned long)regs <=
+		     (thread_base + THREAD_SIZE - sizeof(*regs))) &&
+		    (regs->magic & ~0x1ff) == PT_REGS_MAGIC) {
 			if (!(regs->tstate & TSTATE_PRIV))
 				break;
 			pc = regs->tpc;

-- 
