Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbZDSLOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbZDSLOz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 07:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755594AbZDSLOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 07:14:44 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:37199 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536AbZDSLOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 07:14:44 -0400
Date: Sun, 19 Apr 2009 13:16:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, rakib.mullick@gmail.com,
       akpm@linux-foundation.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Fix false positive section mismatch warnings in the apic code
Message-ID: <20090419111650.GA19873@uranus.ravnborg.org>
References: <b9df5fa10904181941u4a73fc97i80dfa90a50b8daf5@mail.gmail.com> <tip-aa57a15ad17d284e62fbd24cf7e0eb628b2cb3f7@git.kernel.org> <49EAF31C.8020108@gmail.com> <20090419095759.GA4808@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090419095759.GA4808@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 19, 2009 at 11:57:59AM +0200, Ingo Molnar wrote:
> 
> * Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> 
> > tip-bot for Rakib Mullick pisze:
> > > Commit-ID:  aa57a15ad17d284e62fbd24cf7e0eb628b2cb3f7
> > > Gitweb:     http://git.kernel.org/tip/aa57a15ad17d284e62fbd24cf7e0eb628b2cb3f7
> > > Author:     Rakib Mullick <rakib.mullick@gmail.com>
> > > AuthorDate: Sun, 19 Apr 2009 08:41:17 +0600
> > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > CommitDate: Sun, 19 Apr 2009 11:28:18 +0200
> > > 
> > > x86: Fix false positive section mismatch warnings in the apic code
> > > 
> > > find_unisys_acpi_oem_table() and unmap_unisys_acpi_oem_table() 
> > > are non init functions, but these functions calls some init 
> > > functions. But we need these functions as non-init functions.
> > 
> > Why? This warning seems to be valid.
> 
> It's put into struct apic::acpi_madt_oem_check - which is a non-init 
> structure. That particular field is only used from init context - 
> but other fields are used all the time.
> 
> Sam, what's the preferred way to handle these? We could mark the 
> function pointer prototype there as __initdata, but i suspect we'll 
> still get the warning in that case.

If I understand it correct we have the following:

(data) struct apic apic_es7000.acpi_madt_oem_check =>
(function) es7000_acpi_madt_oem_check =>
(function) find_unisys_acpi_oem_table
(__init) early_acpi_os_unmap_memory

So the real fix is to:
1) annotate find_unisys_acpi_oem_table __init
2) annotate es7000_acpi_madt_oem_check __init
3) teach modpost that struct apic apic_es7000 may reference __init

Step 3 is done using __refdata

Based on the above analysis I would assume the best fix
would look like this the following.
[I only looked at the first warning]

Rabik/Marcin - if you agree in the analysis could you produce
a proper patch and send to Ingo - thanks.

You can add my:
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
if the patch is ok.

	Sam


diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 1c11b81..810d5ce 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -254,7 +254,7 @@ static int parse_unisys_oem(char *oemptr)
 }
 
 #ifdef CONFIG_ACPI
-static int find_unisys_acpi_oem_table(unsigned long *oem_addr)
+static int __init find_unisys_acpi_oem_table(unsigned long *oem_addr)
 {
 	struct acpi_table_header *header = NULL;
 	struct es7000_oem_table *table;
@@ -306,7 +306,7 @@ static int es7000_check_dsdt(void)
 static int es7000_acpi_ret;
 
 /* Hook from generic ACPI tables.c */
-static int es7000_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int __init es7000_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	unsigned long oem_addr = 0;
 	int check_dsdt;
@@ -717,7 +717,11 @@ struct apic apic_es7000_cluster = {
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 };
 
-struct apic apic_es7000 = {
+/*
+ * .acpi_madt_oem_check references an init function which is ok.
+ * Annotate with __refdata to silence section mismatch warning
+ */
+struct apic __refdata apic_es7000 = {
 
 	.name				= "es7000",
 	.probe				= probe_es7000,


