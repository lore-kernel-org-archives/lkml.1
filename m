Return-Path: <linux-kernel-owner+w=401wt.eu-S1758534AbYGDQkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534AbYGDQkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 12:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbYGDQj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:39:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:35468 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbYGDQj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:39:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Z89O6aELftPay/s8fLJxgjeATfwVL+MR8vPSbNG02Fc13vI9kD41fSKALtQKT3nOsy
         tirrPvYsJjPiUj0uhkP1vzQQDfCMJSTt+nmLqfwl+OcwUuQ1BPE3atzA4gBwK1TZrL8h
         nJgnQ1OSJuPNPU7K6vHvjgu8oo084pBGNaFuk=
Date: Sat, 5 Jul 2008 01:39:43 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org,
       andrew.vasquez@qlogic.com, linux-driver@qlogic.com,
       seokmann.ju@qlogic.com, linux-kernel@vger.kernel.org
Subject: [PATCH] move memory_read_from_buffer() from fs.h to string.h
Message-ID: <20080704163942.GA15214@localhost.localdomain>
References: <200807040647.m646lXpN017508@imap1.linux-foundation.org> <1215182555.5413.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <1215182555.5413.8.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2008 at 09:42:35AM -0500, James Bottomley wrote:
> For such a micro optimisation, this is a pretty big price to pay.
> 
> Inclusion of linux/fs.h in a low level driver was always a danger signal
> usually it meant the driver was trying to access files or something at
> the very least it was a warning of a potential layering violation.  Now
> you're trying to make it standard practice ... I really don't like that.
> Surely a function that does memory to memory copies belongs either in
> string.h with the rest of our memory copies ... or in another header
> that would be a usual include for the potential users.

OK, I'll move it to linux/string.h

From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] move memory_read_from_buffer() from fs.h to string.h

James Bottomley warns that inclusion of linux/fs.h in a low level driver
was always a danger signal. This patch moves memory_read_from_buffer()
from fs.h to string.h and fixes includes in existing memory_read_from_buffer()
users.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Bob Moore <robert.moore@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Len Brown <lenb@kernel.org>
---
 drivers/acpi/system.c       |    1 +
 drivers/zorro/zorro-sysfs.c |    1 -
 include/linux/fs.h          |    2 --
 include/linux/string.h      |    3 +++
 4 files changed, 4 insertions(+), 3 deletions(-)

Index: 2.6-mm/include/linux/fs.h
===================================================================
--- 2.6-mm.orig/include/linux/fs.h
+++ 2.6-mm/include/linux/fs.h
@@ -2026,8 +2026,6 @@ extern void simple_release_fs(struct vfs
 
 extern ssize_t simple_read_from_buffer(void __user *to, size_t count,
 			loff_t *ppos, const void *from, size_t available);
-extern ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
-			const void *from, size_t available);
 
 #ifdef CONFIG_MIGRATION
 extern int buffer_migrate_page(struct address_space *,
Index: 2.6-mm/include/linux/string.h
===================================================================
--- 2.6-mm.orig/include/linux/string.h
+++ 2.6-mm/include/linux/string.h
@@ -111,5 +111,8 @@ extern void argv_free(char **argv);
 
 extern bool sysfs_streq(const char *s1, const char *s2);
 
+extern ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
+			const void *from, size_t available);
+
 #endif
 #endif /* _LINUX_STRING_H_ */
Index: 2.6-mm/drivers/acpi/system.c
===================================================================
--- 2.6-mm.orig/drivers/acpi/system.c
+++ 2.6-mm/drivers/acpi/system.c
@@ -26,6 +26,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/init.h>
+#include <linux/string.h>
 #include <asm/uaccess.h>
 
 #include <acpi/acpi_drivers.h>
Index: 2.6-mm/drivers/zorro/zorro-sysfs.c
===================================================================
--- 2.6-mm.orig/drivers/zorro/zorro-sysfs.c
+++ 2.6-mm/drivers/zorro/zorro-sysfs.c
@@ -15,7 +15,6 @@
 #include <linux/zorro.h>
 #include <linux/stat.h>
 #include <linux/string.h>
-#include <linux/fs.h>
 
 #include "zorro.h"
 
