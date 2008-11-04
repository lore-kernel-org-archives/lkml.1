Return-Path: <linux-kernel-owner+w=401wt.eu-S1761051AbYKDX4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761051AbYKDX4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757930AbYKDXlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:41:03 -0500
Received: from mail.suse.de ([195.135.220.2]:47900 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757924AbYKDXlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:41:01 -0500
Date: Tue, 4 Nov 2008 15:33:25 -0800
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
       alan@lxorguk.ukuu.org.uk, Len Brown <len.brown@intel.com>,
       Zhao Yakui <yakui.zhao@intel.com>
Subject: [patch 51/57] ACPI: Ingore the RESET_REG_SUP bit when using ACPI
	reset mechanism
Message-ID: <20081104233325.GZ659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-ingore-the-reset_reg_sup-bit-when-using-acpi-reset-mechanism.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Zhao Yakui <yakui.zhao@intel.com>

Subject: [patch 51/57] ACPI: Ingore the RESET_REG_SUP bit when using ACPI reset mechanism

commit 8fd145917fb62368a9b80db59562c20576238f5a upstream

ACPI: Ingore the RESET_REG_SUP bit when using ACPI reset mechanism

According to ACPI 3.0, FADT.flags.RESET_REG_SUP indicates
whether the ACPI reboot mechanism is supported.

However, some boxes have this bit clear, have a valid
ACPI_RESET_REG & RESET_VALUE, and ACPI reboot is the only
mechanism that works for them after S3.

This suggests that other operating systems may not be checking
the RESET_REG_SUP bit, and are using other means to decide
whether to use the ACPI reboot mechanism or not.

Here we stop checking RESET_REG_SUP.
Instead, When acpi reboot is requested,
only the reset_register is checked. If the following
conditions are met, it indicates that the reset register is supported.
	a. reset_register is not zero
	b. the access width is eight
	c. the bit_offset is zero

http://bugzilla.kernel.org/show_bug.cgi?id=7299
http://bugzilla.kernel.org/show_bug.cgi?id=1148

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/reboot.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

--- a/drivers/acpi/reboot.c
+++ b/drivers/acpi/reboot.c
@@ -15,9 +15,28 @@ void acpi_reboot(void)
 
 	rr = &acpi_gbl_FADT.reset_register;
 
-	/* Is the reset register supported? */
-	if (!(acpi_gbl_FADT.flags & ACPI_FADT_RESET_REGISTER) ||
-	    rr->bit_width != 8 || rr->bit_offset != 0)
+	/*
+	 * Is the ACPI reset register supported?
+	 *
+	 * According to ACPI 3.0, FADT.flags.RESET_REG_SUP indicates
+	 * whether the ACPI reset mechanism is supported.
+	 *
+	 * However, some boxes have this bit clear, yet a valid
+	 * ACPI_RESET_REG & RESET_VALUE, and ACPI reboot is the only
+	 * mechanism that works for them after S3.
+	 *
+	 * This suggests that other operating systems may not be checking
+	 * the RESET_REG_SUP bit, and are using other means to decide
+	 * whether to use the ACPI reboot mechanism or not.
+	 *
+	 * So when acpi reboot is requested,
+	 * only the reset_register is checked. If the following
+	 * conditions are met, it indicates that the reset register is supported.
+	 * 	a. reset_register is not zero
+	 * 	b. the access width is eight
+	 * 	c. the bit_offset is zero
+	 */
+	if (!(rr->address) || rr->bit_width != 8 || rr->bit_offset != 0)
 		return;
 
 	reset_value = acpi_gbl_FADT.reset_value;

-- 
