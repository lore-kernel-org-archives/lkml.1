Return-Path: <linux-kernel-owner+w=401wt.eu-S1758082AbYFYNfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082AbYFYNfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 09:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756170AbYFYNfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 09:35:37 -0400
Received: from rn-out-0910.google.com ([64.233.170.188]:38481 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072AbYFYNfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 09:35:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=heYxO5wuJJWBSJ7IZoifIwu74ZOC4NbnFBXOevEEuGq6/8ldazujDlBjyBR1qNLjm2
         0W3FePiFXRgDWRMw8eE/yNquM1ohIGoK6UHMxQEtlIuYTT21VoZFjAzICx3V+skuT43Z
         Tv4oLyORUP/KCDWLsP6nwLfaiNw9bXb9ItDsc=
Message-ID: <386072610806250635u2a8a13i625a5fdebfc00fc2@mail.gmail.com>
Date: Wed, 25 Jun 2008 21:35:35 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel List" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Blackfin arch bug fixing for 2.6.26-rc8
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 0feb6c40d15a12c7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus

to receive the following updates:

 arch/blackfin/kernel/cplb-nompu/cplbinit.c |    6 ++++--
 arch/blackfin/kernel/irqchip.c             |    5 +++++
 2 files changed, 9 insertions(+), 2 deletions(-)

Bryan Wu (1):
      Blackfin arch: fix up section mismatch warning

Sonic Zhang (1):
      Blackfin arch: fix bug - kernel boot fails when Spinlock and
rw-lock debugging enabled

diff --git a/arch/blackfin/kernel/cplb-nompu/cplbinit.c
b/arch/blackfin/kernel/cplb-nompu/cplbinit.c
index 917325b..6be0c50 100644
--- a/arch/blackfin/kernel/cplb-nompu/cplbinit.c
+++ b/arch/blackfin/kernel/cplb-nompu/cplbinit.c
@@ -254,7 +254,8 @@ close_cplbtab(struct cplb_tab *table)
 }

 /* helper function */
-static void __fill_code_cplbtab(struct cplb_tab *t, int i, u32
a_start, u32 a_end)
+static void __init
+__fill_code_cplbtab(struct cplb_tab *t, int i, u32 a_start, u32 a_end)
 {
 	if (cplb_data[i].psize) {
 		fill_cplbtab(t,
@@ -291,7 +292,8 @@ static void __fill_code_cplbtab(struct cplb_tab
*t, int i, u32 a_start, u32 a_en
 	}
 }

-static void __fill_data_cplbtab(struct cplb_tab *t, int i, u32
a_start, u32 a_end)
+static void __init
+__fill_data_cplbtab(struct cplb_tab *t, int i, u32 a_start, u32 a_end)
 {
 	if (cplb_data[i].psize) {
 		fill_cplbtab(t,
diff --git a/arch/blackfin/kernel/irqchip.c b/arch/blackfin/kernel/irqchip.c
index 73647c1..07402f5 100644
--- a/arch/blackfin/kernel/irqchip.c
+++ b/arch/blackfin/kernel/irqchip.c
@@ -60,9 +60,14 @@ static struct irq_chip bad_chip = {
 };

 static struct irq_desc bad_irq_desc = {
+	.status = IRQ_DISABLED,
 	.chip = &bad_chip,
 	.handle_irq = handle_bad_irq,
 	.depth = 1,
+	.lock = __SPIN_LOCK_UNLOCKED(irq_desc->lock),
+#ifdef CONFIG_SMP
+	.affinity = CPU_MASK_ALL
+#endif
 };

 int show_interrupts(struct seq_file *p, void *v)
