Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbZBJTP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbZBJTP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755884AbZBJTEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:04:04 -0500
Received: from kroah.org ([198.145.64.141]:53963 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755875AbZBJTEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:04:01 -0500
Date: Tue, 10 Feb 2009 11:00:52 -0800
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
       alan@lxorguk.ukuu.org.uk, Len Brown <len.brown@intel.com>
Subject: [patch 33/53] ACPI: disable ACPI cleanly when bad RSDP found
Message-ID: <20090210190052.GH14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-disable-acpi-cleanly-when-bad-rsdp-found.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Len Brown <len.brown@intel.com>

commit 9e3a9d1ed8cc8db93e5c53e9a5b09065bd95de8b upstream.

When ACPI is disabled in the BIOS of this VIA C3 box,
it invalidates the RSDP, which Linux notices:

ACPI Error (tbxfroot-0218): A valid RSDP was not found [20080926]

Bug Linux neglected to disable ACPI at that stage,
and later scribbled on smp_found_config:

ACPI: No APIC-table, disabling MPS

But this box doesn't run well in legacy PIC mode,
it needed IOAPIC mode to perform correctly:

http://lkml.org/lkml/2009/2/5/39

So exit ACPI mode cleanly when we first detect
that it is hopeless.

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/tables.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -293,7 +293,12 @@ static void __init check_multiple_madt(v
 
 int __init acpi_table_init(void)
 {
-	acpi_initialize_tables(initial_tables, ACPI_MAX_TABLES, 0);
+	acpi_status status;
+
+	status = acpi_initialize_tables(initial_tables, ACPI_MAX_TABLES, 0);
+	if (ACPI_FAILURE(status))
+		return 1;
+
 	check_multiple_madt();
 	return 0;
 }

