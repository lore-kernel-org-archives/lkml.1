Return-Path: <linux-kernel-owner+w=401wt.eu-S1758203AbYDQBK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203AbYDQBK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758173AbYDQBHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:07:08 -0400
Received: from sous-sol.org ([216.99.217.87]:58796 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226AbYDQBHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:07:04 -0400
Message-Id: <20080417010403.435495277@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:02:24 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Len Brown <lenb@kernel.org>
Subject: acpi: bus: check once more for an empty list after locking it
Content-Disposition: inline; filename=acpi-bus-check-once-more-for-an-empty-list-after-locking-it.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Chuck Ebbert <cebbert@redhat.com>

upstream commit: f0a37e008750ead1751b7d5e89d220a260a46147

List could have become empty after the unlocked check that was made earlier,
so check again inside the lock.

Should fix https://bugzilla.redhat.com/show_bug.cgi?id=427765

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Cc: <stable@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/acpi/bus.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -350,10 +350,11 @@ int acpi_bus_receive_event(struct acpi_b
 	}
 
 	spin_lock_irqsave(&acpi_bus_event_lock, flags);
-	entry =
-	    list_entry(acpi_bus_event_list.next, struct acpi_bus_event, node);
-	if (entry)
+	if (!list_empty(&acpi_bus_event_list)) {
+		entry = list_entry(acpi_bus_event_list.next,
+				   struct acpi_bus_event, node);
 		list_del(&entry->node);
+	}
 	spin_unlock_irqrestore(&acpi_bus_event_lock, flags);
 
 	if (!entry)

-- 
