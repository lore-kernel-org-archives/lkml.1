Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbYFSVeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbYFSVeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 17:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbYFSVcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 17:32:16 -0400
Received: from ns1.suse.de ([195.135.220.2]:38136 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137AbYFSVcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 17:32:13 -0400
Date: Thu, 19 Jun 2008 14:30:00 -0700
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
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-acpi@vger.kernel.org,
       Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: [patch 09/15] ACPICA: Ignore ACPI table signature for Load()
	operator
Message-ID: <20080619213000.GJ20267@suse.de>
References: <20080619211313.834170620@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpica-ignore-acpi-table-signature-for-load-operator.patch"
In-Reply-To: <20080619212621.GA20267@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Bob Moore <robert.moore@intel.com>

upstream bc45b1d39a925b56796bebf8a397a0491489d85c

Without this patch booting with acpi_osi="!Windows 2006" is required
for several machines to function properly with cpufreq
due to failure to load a Vista specific table with a bad signature.

Only "SSDT" is acceptable to the ACPI spec, but tables are
seen with OEMx and null sigs. Therefore, signature validation
is worthless.  Apparently MS ACPI accepts such signatures, ACPICA
must be compatible.

http://bugzilla.kernel.org/show_bug.cgi?id=9919
http://bugzilla.kernel.org/show_bug.cgi?id=10383
http://bugzilla.kernel.org/show_bug.cgi?id=10454
https://bugzilla.novell.com/show_bug.cgi?id=396311

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/tables/tbinstal.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

--- a/drivers/acpi/tables/tbinstal.c
+++ b/drivers/acpi/tables/tbinstal.c
@@ -123,17 +123,13 @@ acpi_tb_add_table(struct acpi_table_desc
 		}
 	}
 
-	/* The table must be either an SSDT or a PSDT or an OEMx */
-
-	if ((!ACPI_COMPARE_NAME(table_desc->pointer->signature, ACPI_SIG_PSDT))
-	    &&
-	    (!ACPI_COMPARE_NAME(table_desc->pointer->signature, ACPI_SIG_SSDT))
-	    && (strncmp(table_desc->pointer->signature, "OEM", 3))) {
-		ACPI_ERROR((AE_INFO,
-			    "Table has invalid signature [%4.4s], must be SSDT, PSDT or OEMx",
-			    table_desc->pointer->signature));
-		return_ACPI_STATUS(AE_BAD_SIGNATURE);
-	}
+	/*
+	 * Originally, we checked the table signature for "SSDT" or "PSDT" here.
+	 * Next, we added support for OEMx tables, signature "OEM".
+	 * Valid tables were encountered with a null signature, so we've just
+	 * given up on validating the signature, since it seems to be a waste
+	 * of code. The original code was removed (05/2008).
+	 */
 
 	(void)acpi_ut_acquire_mutex(ACPI_MTX_TABLES);
 

-- 
