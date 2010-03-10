Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab0CJVQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 16:16:35 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:46838 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393Ab0CJVQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 16:16:31 -0500
Date: Wed, 10 Mar 2010 22:16:28 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/6] arch/x86/pci: Use kasprintf
Message-ID: <Pine.LNX.4.64.1003102215200.1672@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

kasprintf combines kmalloc and sprintf, and takes care of the size
calculation itself.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression a,flag;
expression list args;
statement S;
@@

  a =
-  \(kmalloc\|kzalloc\)(...,flag)
+  kasprintf(flag,args)
  <... when != a
  if (a == NULL || ...) S
  ...>
- sprintf(a,args);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/x86/pci/acpi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -198,10 +198,9 @@ get_current_resources(struct acpi_device
 	if (!info.res)
 		goto res_alloc_fail;
 
-	info.name = kmalloc(16, GFP_KERNEL);
+	info.name = kasprintf(GFP_KERNEL, "PCI Bus %04x:%02x", domain, busnum);
 	if (!info.name)
 		goto name_alloc_fail;
-	sprintf(info.name, "PCI Bus %04x:%02x", domain, busnum);
 
 	info.res_num = 0;
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, setup_resource,
