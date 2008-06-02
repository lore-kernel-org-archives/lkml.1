Return-Path: <linux-kernel-owner+w=401wt.eu-S1762009AbYFBNwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762009AbYFBNwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757106AbYFBNv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:51:59 -0400
Received: from mail.suse.de ([195.135.220.2]:53252 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886AbYFBNv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:51:57 -0400
From: Olaf Dabrunz <od@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>, Olaf Dabrunz <od@suse.de>,
       Stefan Assmann <sassmann@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] Boot IRQ quirks and rerouting
Date: Mon,  2 Jun 2008 14:45:00 +0200
Message-Id: <12124107071847-git-send-email-od@suse.de>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are against linux-2.6-tip, auto-x86-next.

When IRQ lines on secondary or higher IO-APICs are masked (as done by
RT and others), many chipsets redirect IRQs on this line to the PIC, and
thereby regularly to the first IO-APIC in the system. This causes
spurious interrupts and can lead to disabled IRQ lines.

Disabling this "boot interrupt" (as it is mostly used to supply all
IRQs to the legacy PIC during boot) is chipset-specific, and not
possible for all chips. This patchset disables the boot interrupt on
chipsets where this is possible and where we know how to do it.

When disabling the boot interrupt is not possible, the patches tell the
IRQ code to always use the redirected interrupt line (on the first
IO-APIC) instead of the "original" line on the secondary (tertiary ...)
IO-APIC. The original line remains masked, and IRQs always appear on
the boot interrupt line on the first IO-APIC instead.

Two new boot parameters control the quirks and are explained in the
patches: nobootirqquirk,
bootirqquirk=0x<vendor>,0x<device>,<quirk_variant>. "noapic" also sets
nobootirqquirk.

All patches are co-authored by Stefan Assmann and Olaf Dabrunz. But
according to Documentation/SubmittingPatches, the patch submission format
allows only for one author.

 drivers/acpi/pci_irq.c     |   63 ++++++++
 drivers/pci/quirks.c       |  339 ++++++++++++++++++++++++++++++++++++++++++++-
 include/asm-x86/io_apic.h  |    4 
 include/linux/pci.h        |    2 
 include/linux/pci_ids.h    |    6 
 include/linux/pci_quirks.h |   29 +++
 6 files changed, 435 insertions(+), 8 deletions(-)

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

