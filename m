Return-Path: <linux-kernel-owner+w=401wt.eu-S1756940AbZBNERI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbZBNERI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 23:17:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbZBNEQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 23:16:55 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:34253 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbZBNEQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 23:16:55 -0500
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 13 Feb 2009 20:16:59 -0800
Message-ID: <m1vdrdveis.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: tglx@linutronix.de, hpa@zytor.com, mingo@elte.hu, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH] i386 pci: Handle mmaping 64bit bars.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While reading through pci_mmap_page_range I realized that if don't
properly handle 64bit bars in the 32bit kernel.

Without the added cast the shift will be done in 32bit despite being
assigned to a 64bit variable and if we are mmaping an address above
4G things will do the wrong thing.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 arch/x86/pci/i386.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 5ead808..e9d5636 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -283,7 +283,7 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 			enum pci_mmap_state mmap_state, int write_combine)
 {
 	unsigned long prot;
-	u64 addr = vma->vm_pgoff << PAGE_SHIFT;
+	u64 addr = ((u64)vma->vm_pgoff) << PAGE_SHIFT;
 	unsigned long len = vma->vm_end - vma->vm_start;
 	unsigned long flags;
 	unsigned long new_flags;
-- 
1.6.0.6

