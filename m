Return-Path: <linux-kernel-owner+w=401wt.eu-S1752001AbZGYQEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbZGYQEN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 12:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbZGYQEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 12:04:12 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:36348 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbZGYQEL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 12:04:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=uoI/P2mhM9qzksuT3CR3MZUEDlz8bPjyfio2qMfHjAvtlvGn4Q51QmS2SOsSwyB9/O
         jicU96DKPIp23sCEWRS6Y5HJiP7dYol/k5cyAIma1/A2GzksavDQfYv/2mT7eY2opPxl
         QgwpCkz1es1EE5K3cNCY9WkA1TJnZMpTKv6G8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH] acpi: fix NULL pointer dereference in acpi_ex_release_mutex()
Date: Sat, 25 Jul 2009 18:01:18 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4-next-20090723-04314-g011b7b2-dirty; KDE/4.2.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Dan Carpenter <error27@gmail.com>, corbet@lwn.net, eteo@redhat.com
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907251801.19482.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] acpi: fix NULL pointer dereference in acpi_ex_release_mutex()

>From Dan's list:

drivers/acpi/acpica/exmutex.c +397 acpi_ex_release_mutex(40) warning: variable derefenced before check 'walk_state->thread'

Reorder the code to make it check for walk_state->thread existence before
accessing walk_state->thread->thread_id and fix the comment while at it.

Reported-by: Dan Carpenter <error27@gmail.com>
Cc: corbet@lwn.net
Cc: eteo@redhat.com
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
2.6.31 material

 drivers/acpi/acpica/exmutex.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

Index: b/drivers/acpi/acpica/exmutex.c
===================================================================
--- a/drivers/acpi/acpica/exmutex.c
+++ b/drivers/acpi/acpica/exmutex.c
@@ -375,6 +375,14 @@ acpi_ex_release_mutex(union acpi_operand
 		return_ACPI_STATUS(AE_AML_MUTEX_NOT_ACQUIRED);
 	}
 
+	/* must have a valid thread */
+	if (!walk_state->thread) {
+		ACPI_ERROR((AE_INFO,
+			    "Cannot release Mutex [%4.4s], null thread info",
+			    acpi_ut_get_node_name(obj_desc->mutex.node)));
+		return_ACPI_STATUS(AE_AML_INTERNAL);
+	}
+
 	/*
 	 * The Mutex is owned, but this thread must be the owner.
 	 * Special case for Global Lock, any thread can release
@@ -392,15 +400,6 @@ acpi_ex_release_mutex(union acpi_operand
 		return_ACPI_STATUS(AE_AML_NOT_OWNER);
 	}
 
-	/* Must have a valid thread ID */
-
-	if (!walk_state->thread) {
-		ACPI_ERROR((AE_INFO,
-			    "Cannot release Mutex [%4.4s], null thread info",
-			    acpi_ut_get_node_name(obj_desc->mutex.node)));
-		return_ACPI_STATUS(AE_AML_INTERNAL);
-	}
-
 	/*
 	 * The sync level of the mutex must be equal to the current sync level. In
 	 * other words, the current level means that at least one mutex at that
