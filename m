Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbZHIIEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbZHIIEp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 04:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbZHIIEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 04:04:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:21809 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbZHIIEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 04:04:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YdbgljIHdy+mTkARldf+uwobhgCz6v9MTcr0tQ/HGk8wTMQNlFXkxYH2qW9IRsCD6+
         S9l4hEOmwuyIAA76XfnR5nln1nj5XjTkzlslVUMXeUtuLFgIxlzAccA0XH80zIihsCl/
         8s4NBAUCPK3B9HVYLGa4Rp9VK4s1c5BTW83JA=
Date: Sun, 9 Aug 2009 17:03:52 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: [PATCH tip:x86/asm] x86: Introduce GDT_ENTRY_INIT(), initialize
	bad_bios_desc statically
Message-ID: <20090809080350.GA4765@localhost.localdomain>
References: <20090808094905.GA2954@localhost.localdomain> <4A7DE8B6.80801@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <4A7DE8B6.80801@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fully initialize bad_bios_desc statically instead of doing some
fields statically and some dynamically.

Suggested-by: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/kernel/apm_32.c        |   19 +++++++++----------
 drivers/pnp/pnpbios/bioscalls.c |    5 ++---
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index bfe0815..151ace6 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -403,7 +403,15 @@ static DECLARE_WAIT_QUEUE_HEAD(apm_waitqueue);
 static DECLARE_WAIT_QUEUE_HEAD(apm_suspend_waitqueue);
 static struct apm_user *user_list;
 static DEFINE_SPINLOCK(user_list_lock);
-static struct desc_struct bad_bios_desc = GDT_ENTRY_INIT(0x4092, 0, 0);
+
+/*
+ * Set up a segment that references the real mode segment 0x40
+ * that extends up to the end of page zero (that we have reserved).
+ * This is for buggy BIOS's that refer to (real mode) segment 0x40
+ * even though they are called in protected mode.
+ */
+static struct desc_struct bad_bios_desc = GDT_ENTRY_INIT(0x4092,
+			(unsigned long)__va(0x400UL), PAGE_SIZE - 0x400 - 1);
 
 static const char driver_version[] = "1.16ac";	/* no spaces */
 
@@ -2332,15 +2340,6 @@ static int __init apm_init(void)
 	pm_flags |= PM_APM;
 
 	/*
-	 * Set up a segment that references the real mode segment 0x40
-	 * that extends up to the end of page zero (that we have reserved).
-	 * This is for buggy BIOS's that refer to (real mode) segment 0x40
-	 * even though they are called in protected mode.
-	 */
-	set_desc_base(&bad_bios_desc, (unsigned long)__va(0x40UL << 4));
-	set_desc_limit(&bad_bios_desc, 4095 - (0x40 << 4));
-
-	/*
 	 * Set up the long jump entry point to the APM BIOS, which is called
 	 * from inline assembly.
 	 */
diff --git a/drivers/pnp/pnpbios/bioscalls.c b/drivers/pnp/pnpbios/bioscalls.c
index bd035e3..fc83783 100644
--- a/drivers/pnp/pnpbios/bioscalls.c
+++ b/drivers/pnp/pnpbios/bioscalls.c
@@ -60,7 +60,8 @@ do { \
 	set_desc_limit(&gdt[(selname) >> 3], (size) - 1); \
 } while(0)
 
-static struct desc_struct bad_bios_desc = GDT_ENTRY_INIT(0x4092, 0, 0);
+static struct desc_struct bad_bios_desc = GDT_ENTRY_INIT(0x4092,
+			(unsigned long)__va(0x400UL), PAGE_SIZE - 0x400 - 1);
 
 /*
  * At some point we want to use this stack frame pointer to unwind
@@ -476,8 +477,6 @@ void pnpbios_calls_init(union pnp_bios_install_struct *header)
 	pnp_bios_callpoint.offset = header->fields.pm16offset;
 	pnp_bios_callpoint.segment = PNP_CS16;
 
-	set_desc_base(&bad_bios_desc, (unsigned long)__va(0x40UL << 4));
-	set_desc_limit(&bad_bios_desc, 4095 - (0x40 << 4));
 	for_each_possible_cpu(i) {
 		struct desc_struct *gdt = get_cpu_gdt_table(i);
 		if (!gdt)
