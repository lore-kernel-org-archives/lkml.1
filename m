Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbYKGXfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbYKGXfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:35:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbYKGX05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:26:57 -0500
Received: from kroah.org ([198.145.64.141]:47610 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754510AbYKGX0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:26:55 -0500
Date: Fri, 7 Nov 2008 15:26:20 -0800
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
       alan@lxorguk.ukuu.org.uk, Andrea Shepard <andrea@persephoneslair.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 11/16] sparc64: Fix race in arch/sparc64/kernel/trampoline.S
Message-ID: <20081107232620.GL4282@kroah.com>
References: <20081107231848.995297975@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0001-sparc64-Fix-race-in-arch-sparc64-kernel-trampoline.patch"
In-Reply-To: <20081107232544.GA4282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrea Shepard <andrea@persephoneslair.org>

[ Upstream commit e0037df3852b4b60edbe01f70f4968e4a9fdb272 ]

Make arch/sparc64/kernel/trampoline.S in 2.6.27.1 lock prom_entry_lock
when calling the PROM.  This prevents a race condition that I observed
causing a hang on startup on a 12-CPU E4500.

I am not subscribed to this list, so please CC me on replies.

Signed-off-by: Andrea Shepard <andrea@persephoneslair.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/trampoline.S |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/arch/sparc64/kernel/trampoline.S
+++ b/arch/sparc64/kernel/trampoline.S
@@ -328,6 +328,12 @@ after_lock_tlb:
 
 	wrpr		%g0, 0, %wstate
 
+	sethi		%hi(prom_entry_lock), %g2
+1:	ldstub		[%g2 + %lo(prom_entry_lock)], %g1
+	membar		#StoreLoad | #StoreStore
+	brnz,pn		%g1, 1b
+	 nop
+
 	/* As a hack, put &init_thread_union into %g6.
 	 * prom_world() loads from here to restore the %asi
 	 * register.
@@ -337,7 +343,7 @@ after_lock_tlb:
 
 	sethi		%hi(is_sun4v), %o0
 	lduw		[%o0 + %lo(is_sun4v)], %o0
-	brz,pt		%o0, 1f
+	brz,pt		%o0, 2f
 	 nop
 
 	TRAP_LOAD_TRAP_BLOCK(%g2, %g3)
@@ -369,10 +375,10 @@ after_lock_tlb:
 	call		%o1
 	 add		%sp, (2047 + 128), %o0
 
-	ba,pt		%xcc, 2f
+	ba,pt		%xcc, 3f
 	 nop
 
-1:	sethi		%hi(sparc64_ttable_tl0), %o0
+2:	sethi		%hi(sparc64_ttable_tl0), %o0
 	set		prom_set_trap_table_name, %g2
 	stx		%g2, [%sp + 2047 + 128 + 0x00]
 	mov		1, %g2
@@ -386,7 +392,11 @@ after_lock_tlb:
 	call		%o1
 	 add		%sp, (2047 + 128), %o0
 
-2:	ldx		[%l0], %g6
+3:	sethi		%hi(prom_entry_lock), %g2
+	stb		%g0, [%g2 + %lo(prom_entry_lock)]
+	membar		#StoreStore | #StoreLoad
+
+	ldx		[%l0], %g6
 	ldx		[%g6 + TI_TASK], %g4
 
 	mov		1, %g5

-- 
