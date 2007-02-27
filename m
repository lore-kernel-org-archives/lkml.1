Return-Path: <linux-kernel-owner+w=401wt.eu-S1751044AbXB0Tdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751044AbXB0Tdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 14:33:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbXB0Tdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 14:33:40 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39682 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbXB0Tdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 14:33:39 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-pci@atrey.karlin.mff.cuni.cz>,
       Michael Ellerman <michael@ellerman.id.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/3] msi: Support masking msi irqs without a mask bit
References: <m1tzx7l7z2.fsf@ebiederm.dsl.xmission.com>
	<m1ps7vl7rr.fsf@ebiederm.dsl.xmission.com>
	<m1lkijl7ms.fsf_-_@ebiederm.dsl.xmission.com>
Date: Tue, 27 Feb 2007 12:33:20 -0700
In-Reply-To: <m1lkijl7ms.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Tue, 27 Feb 2007 12:31:39 -0700")
Message-ID: <m1hct7l7jz.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


For devices that do not support msi-x we only support 1 interrupt.  Therefore
we can disable that one interrupt by disabling the msi capability itself.  If
we leave the intx interrupts disabled while we have the msi capability disabled
no interrupts should be delivered from that device.

Devices with just the minimal msi support (and thus hitting this code path)
include things like the intel e1000 nic, so it looks like is going to be
a fairly common case and thus important to get right.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/pci/msi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index c43e7d2..01869b1 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -85,6 +85,8 @@ static void msi_set_mask_bit(unsigned int irq, int flag)
 			mask_bits &= ~(1);
 			mask_bits |= flag;
 			pci_write_config_dword(entry->dev, pos, mask_bits);
+		} else {
+			msi_set_enable(entry->dev, !flag);
 		}
 		break;
 	case PCI_CAP_ID_MSIX:
-- 
1.5.0.g53756

