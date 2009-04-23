Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbZDWHe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbZDWHe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbZDWH2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:28:31 -0400
Received: from sous-sol.org ([216.99.217.87]:48343 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755646AbZDWH20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:28:26 -0400
Message-Id: <20090423072223.406830766@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:34 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       alan@lxorguk.ukuu.org.uk, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, Dan Carpenter <error27@gmail.com>,
       Len Brown <len.brown@intel.com>
Subject: [patch 014/100] dock: fix dereference after kfree()
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=dock-fix-dereference-after-kfree.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Dan Carpenter <error27@gmail.com>

upstream commit: f240729832dff3785104d950dad2d3ced4387f6d

dock_remove() calls kfree() on dock_station so we should use
list_for_each_entry_safe() to avoid dereferencing freed memory.

Found by smatch (http://repo.or.cz/w/smatch.git/).  Compile tested.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/acpi/dock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -1146,9 +1146,10 @@ static int __init dock_init(void)
 static void __exit dock_exit(void)
 {
 	struct dock_station *dock_station;
+	struct dock_station *tmp;
 
 	unregister_acpi_bus_notifier(&dock_acpi_notifier);
-	list_for_each_entry(dock_station, &dock_stations, sibiling)
+	list_for_each_entry_safe(dock_station, tmp, &dock_stations, sibiling)
 		dock_remove(dock_station);
 }
 

