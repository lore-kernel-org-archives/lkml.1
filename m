Return-Path: <linux-kernel-owner+w=401wt.eu-S1755107AbYCaCXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbYCaCXK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 22:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbYCaCW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 22:22:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:44193 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751286AbYCaCW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 22:22:57 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX19/mTcGKnJ/GVbp5CDLOC+BXSQBX+04fBI8moNA5m
	uLtK7JcpKF4jPu
Date: Mon, 31 Mar 2008 04:22:53 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bob Tracy <rct@frus.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix off-by-one errors in some pirq warnings
Message-ID: <20080331022253.GA24987@atjola.homenet>
Reply-To: 20080331020341.GB24702@atjola.homenet
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The conditions for the warnings simply ignored the fact that we later actually
use the original value minus 1, so the warning triggered even for valid values.

Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
---
> In pirq_ali_{get,set} there's probably the same problem, but I can't
> really tell for sure, because pirq isn't used to index the array
> directly, and the comment above that functions tells me not to guess
> anything.

OK, so I made a guess anyway, the new condition at least makes more
sense to me.

 arch/x86/pci/irq.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index a871586..579745c 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -200,7 +200,7 @@ static int pirq_ali_get(struct pci_dev *router, struct pci_dev *dev, int pirq)
 {
 	static const unsigned char irqmap[16] = { 0, 9, 3, 10, 4, 5, 7, 6, 1, 11, 0, 12, 0, 14, 0, 15 };
 
-	WARN_ON_ONCE(pirq >= 16);
+	WARN_ON_ONCE(pirq > 16);
 	return irqmap[read_config_nybble(router, 0x48, pirq-1)];
 }
 
@@ -209,7 +209,7 @@ static int pirq_ali_set(struct pci_dev *router, struct pci_dev *dev, int pirq, i
 	static const unsigned char irqmap[16] = { 0, 8, 0, 2, 4, 5, 7, 6, 0, 1, 3, 9, 11, 0, 13, 15 };
 	unsigned int val = irqmap[irq];
 
-	WARN_ON_ONCE(pirq >= 16);
+	WARN_ON_ONCE(pirq > 16);
 	if (val) {
 		write_config_nybble(router, 0x48, pirq-1, val);
 		return 1;
@@ -260,7 +260,7 @@ static int pirq_via586_get(struct pci_dev *router, struct pci_dev *dev, int pirq
 {
 	static const unsigned int pirqmap[5] = { 3, 2, 5, 1, 1 };
 
-	WARN_ON_ONCE(pirq >= 5);
+	WARN_ON_ONCE(pirq > 5);
 	return read_config_nybble(router, 0x55, pirqmap[pirq-1]);
 }
 
@@ -268,7 +268,7 @@ static int pirq_via586_set(struct pci_dev *router, struct pci_dev *dev, int pirq
 {
 	static const unsigned int pirqmap[5] = { 3, 2, 5, 1, 1 };
 
-	WARN_ON_ONCE(pirq >= 5);
+	WARN_ON_ONCE(pirq > 5);
 	write_config_nybble(router, 0x55, pirqmap[pirq-1], irq);
 	return 1;
 }
@@ -282,7 +282,7 @@ static int pirq_ite_get(struct pci_dev *router, struct pci_dev *dev, int pirq)
 {
 	static const unsigned char pirqmap[4] = { 1, 0, 2, 3 };
 
-	WARN_ON_ONCE(pirq >= 4);
+	WARN_ON_ONCE(pirq > 4);
 	return read_config_nybble(router,0x43, pirqmap[pirq-1]);
 }
 
@@ -290,7 +290,7 @@ static int pirq_ite_set(struct pci_dev *router, struct pci_dev *dev, int pirq, i
 {
 	static const unsigned char pirqmap[4] = { 1, 0, 2, 3 };
 
-	WARN_ON_ONCE(pirq >= 4);
+	WARN_ON_ONCE(pirq > 4);
 	write_config_nybble(router, 0x43, pirqmap[pirq-1], irq);
 	return 1;
 }
-- 
1.5.5.rc2
