Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbYLKTZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbYLKTZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:25:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757545AbYLKTS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:26 -0500
Received: from kroah.org ([198.145.64.141]:55964 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757359AbYLKTSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:15 -0500
Date: Thu, 11 Dec 2008 11:14:13 -0800
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
       alan@lxorguk.ukuu.org.uk, Arnd Bergmann <arnd@arndb.de>,
       Paul Mackerras <paulus@samba.org>
Subject: [patch 20/83] powerpc/mpic: Dont reset affinity for secondary MPIC
	on boot
Message-ID: <20081211191413.GT5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="powerpc-mpic-don-t-reset-affinity-for-secondary-mpic-on-boot.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit cc353c30bbdb84f4317a6c149ebb11cde2232e40 upstream.

Kexec/kdump currently fails on the IBM QS2x blades when the kexec happens
on a CPU other than the initial boot CPU.  It turns out that this is the
result of mpic_init trying to set affinity of each interrupt vector to the
current boot CPU.

As far as I can tell,  the same problem is likely to exist on any
secondary MPIC, because they have to deliver interrupts to the first
output all the time. There are two potential solutions for this: either
not set up affinity at all for secondary MPICs, or assume that a single
CPU output is connected to the upstream interrupt controller and hardcode
affinity to that per architecture.

This patch implements the second approach, defaulting to the first output.
Currently, all known secondary MPICs are routed to their upstream port
using the first destination, so we hardcode that.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/sysdev/mpic.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -1271,6 +1271,7 @@ void __init mpic_set_default_senses(stru
 void __init mpic_init(struct mpic *mpic)
 {
 	int i;
+	int cpu;
 
 	BUG_ON(mpic->num_sources == 0);
 
@@ -1313,6 +1314,11 @@ void __init mpic_init(struct mpic *mpic)
 
 	mpic_pasemi_msi_init(mpic);
 
+	if (mpic->flags & MPIC_PRIMARY)
+		cpu = hard_smp_processor_id();
+	else
+		cpu = 0;
+
 	for (i = 0; i < mpic->num_sources; i++) {
 		/* start with vector = source number, and masked */
 		u32 vecpri = MPIC_VECPRI_MASK | i |
@@ -1323,8 +1329,7 @@ void __init mpic_init(struct mpic *mpic)
 			continue;
 		/* init hw */
 		mpic_irq_write(i, MPIC_INFO(IRQ_VECTOR_PRI), vecpri);
-		mpic_irq_write(i, MPIC_INFO(IRQ_DESTINATION),
-			       1 << hard_smp_processor_id());
+		mpic_irq_write(i, MPIC_INFO(IRQ_DESTINATION), 1 << cpu);
 	}
 	
 	/* Init spurious vector */

