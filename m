Return-Path: <linux-kernel-owner+w=401wt.eu-S1752900AbZIZS4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbZIZS4N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 14:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZIZSyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 14:54:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:36390 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbZIZSyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 14:54:19 -0400
Date: Sat, 26 Sep 2009 20:50:25 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       lenb@kernel.org
Subject: [PATCH 1/9] Fix bound checks for copy_from_user in the acpi /proc
 code
Message-ID: <20090926205025.3befecf6@infradead.org>
In-Reply-To: <20090926204951.424e567e@infradead.org>
References: <20090926204951.424e567e@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 1/9] Fix bound checks for copy_from_user in the acpi /proc code
CC: Len Brown <lenb@kernel.org>

The ACPI /proc write() code takes an unsigned length argument like any write()
function, but then assigned it to a *signed* integer called "len".
Only after this is a sanity check for len done to make it not larger than 4.

Due to the type change a len < 0 is in principle also possible; this patch
adds a check for this.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

diff --git a/drivers/acpi/proc.c b/drivers/acpi/proc.c
index d0d550d..f8b6f55 100644
--- a/drivers/acpi/proc.c
+++ b/drivers/acpi/proc.c
@@ -398,6 +398,8 @@ acpi_system_write_wakeup_device(struct file *file,
 
 	if (len > 4)
 		len = 4;
+	if (len < 0)
+		return -EFAULT;
 
 	if (copy_from_user(strbuf, buffer, len))
 		return -EFAULT;


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
