Return-Path: <linux-kernel-owner+w=401wt.eu-S1762929AbYHRTGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762929AbYHRTGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757561AbYHRTEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:04:14 -0400
Received: from ns2.suse.de ([195.135.220.15]:37194 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762585AbYHRTEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:04:12 -0400
Date: Mon, 18 Aug 2008 11:45:19 -0700
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
Subject: [patch 48/60] sparc64: Fix recursion in stack overflow detection
	handling.
Message-ID: <20080818184519.GW29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0002-sparc64-Fix-recursion-in-stack-overflow-detection-h.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
[ Upstream commit c7498081a6f5d96c9f3243b6b5e020352903bfd2 ]

The calls down into prom_printf() when we detect an overflowed stack
can recurse again since the overflow stack will be "below" the current
kernel stack limit.

Prevent this by just returning straight if we are on the stack
overflow safe stack already.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/lib/mcount.S |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/arch/sparc64/lib/mcount.S
+++ b/arch/sparc64/lib/mcount.S
@@ -45,12 +45,23 @@ _mcount:
 	sub		%g3, STACK_BIAS, %g3
 	cmp		%sp, %g3
 	bg,pt		%xcc, 1f
-	 sethi		%hi(panicstring), %g3
+	 nop
+	/* If we are already on ovstack, don't hop onto it
+	 * again, we are already trying to output the stack overflow
+	 * message.
+	 */
 	sethi		%hi(ovstack), %g7		! cant move to panic stack fast enough
 	 or		%g7, %lo(ovstack), %g7
-	add		%g7, OVSTACKSIZE, %g7
+	add		%g7, OVSTACKSIZE, %g3
+	sub		%g3, STACK_BIAS + 192, %g3
 	sub		%g7, STACK_BIAS, %g7
-	mov		%g7, %sp
+	cmp		%sp, %g7
+	blu,pn		%xcc, 2f
+	 cmp		%sp, %g3
+	bleu,pn		%xcc, 1f
+	 nop
+2:	mov		%g3, %sp
+	sethi		%hi(panicstring), %g3
 	call		prom_printf
 	 or		%g3, %lo(panicstring), %o0
 	call		prom_halt

-- 
