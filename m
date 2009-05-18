Return-Path: <linux-kernel-owner+w=401wt.eu-S1754308AbZERUFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbZERUFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 16:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZERUE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 16:04:58 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:30135 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbZERUE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 16:04:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gKXzg7uxR31SBY2pLdlLaA9PL91HSQqFn5TgYFMScjpzd8Gsnf0kmBe8gggr7ffCW9
         4kU36OG5oVWHmRu3tfLkRZy3wXnPS9N5Ux+a0IJrxY4bS2HbL1v0JH9Jpii1xCkszWjy
         dZJi4ofC8uRa61f17b93G1Alvf3QkddORnjWM=
MIME-Version: 1.0
In-Reply-To: <20090518094745.GF15531@tpkurt2.garloff.de>
References: <20090518093352.GC15531@tpkurt2.garloff.de>
	 <20090518094745.GF15531@tpkurt2.garloff.de>
Date: Mon, 18 May 2009 13:04:58 -0700
Message-ID: <86802c440905181304m47b2a2afx264f970a29d06930@mail.gmail.com>
Subject: Re: [PATCH 2/3]: x86-64: Handle SRAT v1 and v2 consistently
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Kurt Garloff <garloff@suse.de>,
       Linux kernel list <linux-kernel@vger.kernel.org>,
       Norbert Eicker <N.Eicker@fz-juelich.de>,
       Greg Kroah-Hartman <GregKH@suse.de>,
       Alexey Starikovskiy <AStarikovskiy@suse.cz>,
       Len Brown <LenB@kernel.org>, xb <xavier.bru@bull.net>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18, 2009 at 2:47 AM, Kurt Garloff <garloff@suse.de> wrote:
> Hi,
>
> x86-64 was rather inconsistent prior to this patch; it used 8 bits
> for the pxm field in cpu_affinity, but 32 bits in mem_affinity.
> This patch makes it consistent: Either use 8 bits consistently (SRAT
> rev 1 or lower) or 32 bits (SRAT rev 2 or higher).
>
> This is patch 2/3.
> --
> Kurt Garloff, VP OPS Partner Engineering -- Novell Inc.
>
From: Kurt Garloff <garloff@suse.de>
Subject: Use SRAT table rev to use 8bit or 32bit PXM fields (x86-64)
References: bnc#503038

In SRAT v1, we had 8bit proximity domain (PXM) fields; SRAT v2 provides
32bits for these. The new fields were reserved before.
According to the ACPI spec, the OS must disregrard reserved fields.

x86-64 was rather inconsistent prior to this patch; it used 8 bits
for the pxm field in cpu_affinity, but 32 bits in mem_affinity.
This patch makes it consistent: Either use 8 bits consistently (SRAT
rev 1 or lower) or 32 bits (SRAT rev 2 or higher).

This is patch 2/3.

Signed-off-by: Kurt Garloff <garloff@suse.de>

---
 arch/x86/mm/srat_64.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/arch/x86/mm/srat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat_64.c
+++ linux-2.6/arch/x86/mm/srat_64.c
@@ -154,6 +154,8 @@ acpi_numa_processor_affinity_init(struct
 	if ((pa->flags & ACPI_SRAT_CPU_ENABLED) == 0)
 		return;
 	pxm = pa->proximity_domain_lo;
+	if (acpi_srat_revision >= 2)
+		pxm |= *((unsigned int*)pa->proximity_domain_hi) << 8;
 	node = setup_node(pxm);
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
@@ -255,6 +257,8 @@ acpi_numa_memory_affinity_init(struct ac
 	start = ma->base_address;
 	end = start + ma->length;
 	pxm = ma->proximity_domain;
+	if (acpi_srat_revision <= 1)
+		pxm &= 0xff;
 	node = setup_node(pxm);
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains.\n");


Acked-by: Yinghai Lu <yinghai@kernel.org>
