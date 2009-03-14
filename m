Return-Path: <linux-kernel-owner+w=401wt.eu-S1762234AbZCNAqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762234AbZCNAqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753785AbZCNATy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:54 -0400
Received: from kroah.org ([198.145.64.141]:34991 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753642AbZCNATk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:40 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:51 2009
Message-Id: <20090314000751.065212331@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:06:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Len Brown <lenb@kernel.org>
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
       alan@lxorguk.ukuu.org.uk, linux-acpi@vger.kernel.org,
       Lin Ming <ming.m.lin@intel.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [patch 79/96] ACPI: fix broken usage of name.ascii
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=acpi-fix-broken-usage-of-name.ascii.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

This issue was fixed indirectly in mainline by commit
0175d562a29ad052c510782c7e76bc63d5155b9b.

acpi_namespace_node's name.ascii field is four chars, and not NULL-
terminated except by pure luck.  So, it cannot be used by sscanf() without
a length restriction.

This is the minimal fix for both stable 2.6.27 and 2.6.28.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/ec.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -759,9 +759,10 @@ acpi_ec_register_query_methods(acpi_hand
 	struct acpi_namespace_node *node = handle;
 	struct acpi_ec *ec = context;
 	int value = 0;
-	if (sscanf(node->name.ascii, "_Q%x", &value) == 1) {
+
+	if (sscanf(node->name.ascii, "_Q%2x", &value) == 1)
 		acpi_ec_add_query_handler(ec, value, handle, NULL, NULL);
-	}
+
 	return AE_OK;
 }
 


