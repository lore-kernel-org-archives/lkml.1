Return-Path: <linux-kernel-owner+w=401wt.eu-S965052AbXCSVka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965052AbXCSVka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965075AbXCSVkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:40:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:55555 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964815AbXCSVj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:39:58 -0400
Date: Mon, 19 Mar 2007 14:38:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Tony Luck <tony.luck@intel.com>
Subject: [patch 07/31] IA64: fix NULL pointer in ia64/irq_chip-mask/unmask function
Message-ID: <20070319213807.GI9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ia64-fix-null-pointer-in-ia64-irq_chip-mask-unmask-function.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

[IA64] fix NULL pointer in ia64/irq_chip-mask/unmask function

This patch fixes boot failure because irq_desc->mask() is NULL.

- Added mask/unmask functions to ia64's irq desc function table.
- rename hw_interrupt_type to irq_chip. hw_interrupt_type is old name.
- Tony: Added same change to arch/ia64/sn/kernel/irq.c as pointed out
  by Eric Biederman ... mask/unmask functions there can be no-op.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/ia64/kernel/iosapic.c |    8 ++++++--
 arch/ia64/sn/kernel/irq.c  |   14 +++++++++++++-
 2 files changed, 19 insertions(+), 3 deletions(-)

--- a/arch/ia64/kernel/iosapic.c
+++ b/arch/ia64/kernel/iosapic.c
@@ -446,7 +446,7 @@ iosapic_end_level_irq (unsigned int irq)
 #define iosapic_disable_level_irq	mask_irq
 #define iosapic_ack_level_irq		nop
 
-struct hw_interrupt_type irq_type_iosapic_level = {
+struct irq_chip irq_type_iosapic_level = {
 	.name =		"IO-SAPIC-level",
 	.startup =	iosapic_startup_level_irq,
 	.shutdown =	iosapic_shutdown_level_irq,
@@ -454,6 +454,8 @@ struct hw_interrupt_type irq_type_iosapi
 	.disable =	iosapic_disable_level_irq,
 	.ack =		iosapic_ack_level_irq,
 	.end =		iosapic_end_level_irq,
+	.mask =		mask_irq,
+	.unmask =	unmask_irq,
 	.set_affinity =	iosapic_set_affinity
 };
 
@@ -493,7 +495,7 @@ iosapic_ack_edge_irq (unsigned int irq)
 #define iosapic_disable_edge_irq	nop
 #define iosapic_end_edge_irq		nop
 
-struct hw_interrupt_type irq_type_iosapic_edge = {
+struct irq_chip irq_type_iosapic_edge = {
 	.name =		"IO-SAPIC-edge",
 	.startup =	iosapic_startup_edge_irq,
 	.shutdown =	iosapic_disable_edge_irq,
@@ -501,6 +503,8 @@ struct hw_interrupt_type irq_type_iosapi
 	.disable =	iosapic_disable_edge_irq,
 	.ack =		iosapic_ack_edge_irq,
 	.end =		iosapic_end_edge_irq,
+	.mask =		mask_irq,
+	.unmask =	unmask_irq,
 	.set_affinity =	iosapic_set_affinity
 };
 
--- a/arch/ia64/sn/kernel/irq.c
+++ b/arch/ia64/sn/kernel/irq.c
@@ -205,7 +205,17 @@ static void sn_set_affinity_irq(unsigned
 		(void)sn_retarget_vector(sn_irq_info, nasid, slice);
 }
 
-struct hw_interrupt_type irq_type_sn = {
+static void
+sn_mask_irq(unsigned int irq)
+{
+}
+
+static void
+sn_unmask_irq(unsigned int irq)
+{
+}
+
+struct irq_chip irq_type_sn = {
 	.name		= "SN hub",
 	.startup	= sn_startup_irq,
 	.shutdown	= sn_shutdown_irq,
@@ -213,6 +223,8 @@ struct hw_interrupt_type irq_type_sn = {
 	.disable	= sn_disable_irq,
 	.ack		= sn_ack_irq,
 	.end		= sn_end_irq,
+	.mask		= sn_mask_irq,
+	.unmask		= sn_unmask_irq,
 	.set_affinity	= sn_set_affinity_irq
 };
 

-- 
