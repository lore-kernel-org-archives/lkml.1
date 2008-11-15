Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbYKOF31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbYKOF31 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 00:29:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbYKOFZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 00:25:16 -0500
Received: from kroah.org ([198.145.64.141]:50569 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753439AbYKOFZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 00:25:01 -0500
Date: Fri, 14 Nov 2008 21:23:20 -0800
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
       alan@lxorguk.ukuu.org.uk, Zhang Rui <rui.zhang@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: [patch 11/22] ACPI: avoid empty file name in sysfs
Message-ID: <20081115052320.GL3710@kroah.com>
References: <20081115051732.506914008@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-avoid-empty-file-name-in-sysfs.patch"
In-Reply-To: <20081115052220.GA3710@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Gruber <nokos@gmx.net>

commit 4feba70a2c1a1a0c96909f657f48b2e11e682370 upstream.

Since commit bc45b1d39a925b56796bebf8a397a0491489d85c acpi tables are
allowed to have an empty signature and /sys/firmware/acpi/tables uses the
signature as filename.  Applications using naive recursion through /sys
loop forever.  A possible solution would be: (replacing the zero length
filename with the string "NULL")

http://bugzilla.kernel.org/show_bug.cgi?id=11539

Acked-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/system.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--- a/drivers/acpi/system.c
+++ b/drivers/acpi/system.c
@@ -78,9 +78,15 @@ static ssize_t acpi_table_show(struct ko
 	    container_of(bin_attr, struct acpi_table_attr, attr);
 	struct acpi_table_header *table_header = NULL;
 	acpi_status status;
+	char name[ACPI_NAME_SIZE];
+
+	if (strncmp(table_attr->name, "NULL", 4))
+		memcpy(name, table_attr->name, ACPI_NAME_SIZE);
+	else
+		memcpy(name, "\0\0\0\0", 4);
 
 	status =
-	    acpi_get_table(table_attr->name, table_attr->instance,
+	    acpi_get_table(name, table_attr->instance,
 			   &table_header);
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
@@ -95,21 +101,24 @@ static void acpi_table_attr_init(struct 
 	struct acpi_table_header *header = NULL;
 	struct acpi_table_attr *attr = NULL;
 
-	memcpy(table_attr->name, table_header->signature, ACPI_NAME_SIZE);
+	if (table_header->signature[0] != '\0')
+		memcpy(table_attr->name, table_header->signature,
+			ACPI_NAME_SIZE);
+	else
+		memcpy(table_attr->name, "NULL", 4);
 
 	list_for_each_entry(attr, &acpi_table_attr_list, node) {
-		if (!memcmp(table_header->signature, attr->name,
-			    ACPI_NAME_SIZE))
+		if (!memcmp(table_attr->name, attr->name, ACPI_NAME_SIZE))
 			if (table_attr->instance < attr->instance)
 				table_attr->instance = attr->instance;
 	}
 	table_attr->instance++;
 
 	if (table_attr->instance > 1 || (table_attr->instance == 1 &&
-					 !acpi_get_table(table_header->
-							 signature, 2,
-							 &header)))
-		sprintf(table_attr->name + 4, "%d", table_attr->instance);
+					!acpi_get_table
+					(table_header->signature, 2, &header)))
+		sprintf(table_attr->name + ACPI_NAME_SIZE, "%d",
+			table_attr->instance);
 
 	table_attr->attr.size = 0;
 	table_attr->attr.read = acpi_table_show;

-- 
