Return-Path: <linux-kernel-owner+w=401wt.eu-S1759982AbXHGMoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982AbXHGMoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 08:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761809AbXHGMnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 08:43:53 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58534 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756660AbXHGMnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 08:43:49 -0400
Date: Tue, 7 Aug 2007 12:45:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: borislav@users.sourceforge.net, hmh@hmh.eng.br,
       kernel list <linux-kernel@vger.kernel.org>
Subject: refcounting problems with ibm_acpi but acpi=off
Message-ID: <20070807104500.GA1684@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I get this nastyness in syslog if I compile ibm_acpi into kernel, then
boot with acpi=off.

floppy0: no floppy controllers found
loop: module loaded
WARNING: at lib/kref.c:33 kref_get()
 [<c025bd80>] kref_get+0x40/0x50
 [<c025aeff>] kobject_get+0xf/0x20
 [<c0325eee>] get_driver+0xe/0x20
 [<c0325f13>] driver_remove_file+0x13/0x40
 [<c0337812>] thinkpad_acpi_module_exit+0x92/0x100
 [<c083a192>] thinkpad_acpi_module_init+0x252/0x810
 [<c025a71a>] idr_get_new+0xa/0x30
 [<c01ad15d>] proc_register+0x8d/0x100
 [<c081e570>] kernel_init+0x140/0x320
 [<c01040ca>] ret_from_fork+0x6/0x1c
 [<c081e430>] kernel_init+0x0/0x320
 [<c081e430>] kernel_init+0x0/0x320
 [<c0104d8f>] kernel_thread_helper+0x7/0x18
 =======================
WARNING: at lib/kref.c:33 kref_get()
 [<c025bd80>] kref_get+0x40/0x50
 [<c025aeff>] kobject_get+0xf/0x20
 [<c0325eee>] get_driver+0xe/0x20
 [<c0325f13>] driver_remove_file+0x13/0x40
 [<c0337812>] thinkpad_acpi_module_exit+0x92/0x100
 [<c083a192>] thinkpad_acpi_module_init+0x252/0x810
 [<c025a71a>] idr_get_new+0xa/0x30
 [<c01ad15d>] proc_register+0x8d/0x100
 [<c081e570>] kernel_init+0x140/0x320
 [<c01040ca>] ret_from_fork+0x6/0x1c
 [<c081e430>] kernel_init+0x0/0x320
 [<c081e430>] kernel_init+0x0/0x320
 [<c0104d8f>] kernel_thread_helper+0x7/0x18
 =======================
WARNING: at lib/kref.c:33 kref_get()
 [<c025bd80>] kref_get+0x40/0x50
 [<c025aeff>] kobject_get+0xf/0x20
 [<c0325eee>] get_driver+0xe/0x20
 [<c0325f13>] driver_remove_file+0x13/0x40
 [<c0337812>] thinkpad_acpi_module_exit+0x92/0x100
 [<c083a192>] thinkpad_acpi_module_init+0x252/0x810
 [<c025a71a>] idr_get_new+0xa/0x30
 [<c01ad15d>] proc_register+0x8d/0x100
 [<c081e570>] kernel_init+0x140/0x320
 [<c01040ca>] ret_from_fork+0x6/0x1c
 [<c081e430>] kernel_init+0x0/0x320
 [<c081e430>] kernel_init+0x0/0x320
 [<c0104d8f>] kernel_thread_helper+0x7/0x18
 =======================
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
PCI: Found IRQ 11 for device 0000:02:00.0
PCI: Sharing IRQ 11 with 0000:00:1c.0

...

Perhaps this is needed?
								Pavel

diff --git a/drivers/acpi/ibm_acpi.c b/drivers/acpi/ibm_acpi.c
index a664f2b..654a124 100644
--- a/drivers/acpi/ibm_acpi.c
+++ b/drivers/acpi/ibm_acpi.c
@@ -2695,6 +2695,9 @@ static void acpi_ibm_exit(void)
 {
 	int i;
 
+	if (acpi_disabled)
+		return;
+
 	for (i = ARRAY_SIZE(ibms) - 1; i >= 0; i--)
 		ibm_exit(&ibms[i]);
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
