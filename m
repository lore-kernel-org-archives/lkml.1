Return-Path: <linux-kernel-owner+w=401wt.eu-S1761559AbZEFUml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761559AbZEFUml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761108AbZEFUjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:39:14 -0400
Received: from kroah.org ([198.145.64.141]:33952 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761057AbZEFUjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:39:12 -0400
X-Mailbox-Line: From greg@blue.kroah.org Wed May  6 13:31:30 2009
Message-Id: <20090506203130.096743335@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 13:30:21 -0700
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
       alan@lxorguk.ukuu.org.uk, linux-acpi@vger.kernel.org, tmb@mandriva.org,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 11/18] ACPI: Revert conflicting workaround for BIOS w/ mangled PRT entries
References: <20090506203010.615363711@blue.kroah.org>
Content-Disposition: inline; filename=acpi-revert-conflicting-workaround-for-bios-w-mangled-prt-entries.patch
In-Reply-To: <20090506203353.GA14624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

upstream 82babbb3887e234c995626e4121d411ea9070ca5
backported to apply cleanly to 2.6.27.21
and apply with offset -1 to 2.6.28.9

2f894ef9c8b36a35d80709bedca276d2fc691941
in Linux-2.6.21 worked around BIOS with mangled _PRT entries:
http://bugzilla.kernel.org/show_bug.cgi?id=6859

d0e184abc5983281ef189db2c759d65d56eb1b80
worked around the same issue via ACPICA, and shipped in 2.6.27.

Unfortunately the two workarounds conflict:
http://bugzilla.kernel.org/show_bug.cgi?id=12270

So revert the Linux specific one.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/resources/rscreate.c |   27 ++-------------------------
 1 file changed, 2 insertions(+), 25 deletions(-)

--- a/drivers/acpi/resources/rscreate.c
+++ b/drivers/acpi/resources/rscreate.c
@@ -191,8 +191,6 @@ acpi_rs_create_pci_routing_table(union a
 	user_prt = ACPI_CAST_PTR(struct acpi_pci_routing_table, buffer);
 
 	for (index = 0; index < number_of_elements; index++) {
-		int source_name_index = 2;
-		int source_index_index = 3;
 
 		/*
 		 * Point user_prt past this current structure
@@ -261,27 +259,6 @@ acpi_rs_create_pci_routing_table(union a
 			return_ACPI_STATUS(AE_BAD_DATA);
 		}
 
-		/*
-		 * If BIOS erroneously reversed the _PRT source_name and source_index,
-		 * then reverse them back.
-		 */
-		if (ACPI_GET_OBJECT_TYPE(sub_object_list[3]) !=
-		    ACPI_TYPE_INTEGER) {
-			if (acpi_gbl_enable_interpreter_slack) {
-				source_name_index = 3;
-				source_index_index = 2;
-				printk(KERN_WARNING
-				       "ACPI: Handling Garbled _PRT entry\n");
-			} else {
-				ACPI_ERROR((AE_INFO,
-					    "(PRT[%X].source_index) Need Integer, found %s",
-					    index,
-					    acpi_ut_get_object_type_name
-					    (sub_object_list[3])));
-				return_ACPI_STATUS(AE_BAD_DATA);
-			}
-		}
-
 		user_prt->pin = (u32) obj_desc->integer.value;
 
 		/*
@@ -305,7 +282,7 @@ acpi_rs_create_pci_routing_table(union a
 		 * 3) Third subobject: Dereference the PRT.source_name
 		 * The name may be unresolved (slack mode), so allow a null object
 		 */
-		obj_desc = sub_object_list[source_name_index];
+		obj_desc = sub_object_list[2];
 		if (obj_desc) {
 			switch (ACPI_GET_OBJECT_TYPE(obj_desc)) {
 			case ACPI_TYPE_LOCAL_REFERENCE:
@@ -380,7 +357,7 @@ acpi_rs_create_pci_routing_table(union a
 
 		/* 4) Fourth subobject: Dereference the PRT.source_index */
 
-		obj_desc = sub_object_list[source_index_index];
+		obj_desc = sub_object_list[3];
 		if (ACPI_GET_OBJECT_TYPE(obj_desc) != ACPI_TYPE_INTEGER) {
 			ACPI_ERROR((AE_INFO,
 				    "(PRT[%X].SourceIndex) Need Integer, found %s",


