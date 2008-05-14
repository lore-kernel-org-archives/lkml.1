Return-Path: <linux-kernel-owner+w=401wt.eu-S1762860AbYENTgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762860AbYENTgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 15:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbYENTgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 15:36:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752993AbYENTgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 15:36:25 -0400
Date: Wed, 14 May 2008 12:35:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.26-rc2-mm1
Message-Id: <20080514123537.4df70e80.akpm@linux-foundation.org>
In-Reply-To: <64bb37e0805141212i7587a502vdff9af109b55c37b@mail.gmail.com>
References: <20080514010129.4f672378.akpm@linux-foundation.org>
	<64bb37e0805141212i7587a502vdff9af109b55c37b@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 21:12:13 +0200
"Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:

> On Wed, May 14, 2008 at 10:01 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> >  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc2/2.6.26-rc2-mm1/
> 
> Nice! This one works for me again.

Thanks.

> But somehow the NUMAness of my system is gone.
> 
> ...
>
> 
> The system is a dual socket Opteron system, each processor has 2 GB of RAM.
> 
> I will try to debug this more tomorrow, but except the kernel now
> thinks there is only one NUMA node the system works correct. It is
> detecting the full 4GB of RAM.
> 
> This line from 2.6.26-rc2-mm1 really looks like the source of this:
> [    0.000000] SRAT: PXMs only cover 0MB of your 4608MB e820 RAM. Not used.
> There is no more than 4GB of RAM (but part of it is remapped...)

I suspect that this might be caused by the below.

That patch no longer seems to be necessary so I'll drop it.  Perhaps
you could try reverting it, please?



From: Ingo Molnar <mingo@elte.hu>

x86.git testing found the following build error on latest -git:

 drivers/acpi/numa.c: In function 'acpi_numa_init':
 drivers/acpi/numa.c:226: error: 'NR_NODE_MEMBLKS' undeclared (first use in this function)
 drivers/acpi/numa.c:226: error: (Each undeclared identifier is reported only once
 drivers/acpi/numa.c:226: error: for each function it appears in.)

with this config:

 http://redhat.com/~mingo/misc/config-Wed_Apr_30_22_42_42_CEST_2008.bad

i suspect we dont want SRAT parsing when CONFIG_HAVE_ARCH_PARSE_SRAT
is unset - but the fix looks a bit ugly. Perhaps we should define
NR_NODE_MEMBLKS even in this case and just let the code fall back
to some sane behavior?

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/numa.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/acpi/numa.c~acpi-acpi_numa_init-build-fix drivers/acpi/numa.c
--- a/drivers/acpi/numa.c~acpi-acpi_numa_init-build-fix
+++ a/drivers/acpi/numa.c
@@ -176,6 +176,7 @@ acpi_parse_processor_affinity(struct acp
 	return 0;
 }
 
+#ifdef CONFIG_HAVE_ARCH_PARSE_SRAT
 static int __init
 acpi_parse_memory_affinity(struct acpi_subtable_header * header,
 			   const unsigned long end)
@@ -193,6 +194,7 @@ acpi_parse_memory_affinity(struct acpi_s
 
 	return 0;
 }
+#endif
 
 static int __init acpi_parse_srat(struct acpi_table_header *table)
 {
@@ -221,9 +223,11 @@ int __init acpi_numa_init(void)
 	if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
 				      acpi_parse_processor_affinity, NR_CPUS);
+#ifdef CONFIG_HAVE_ARCH_PARSE_SRAT
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
 				      acpi_parse_memory_affinity,
 				      NR_NODE_MEMBLKS);
+#endif
 	}
 
 	/* SLIT: System Locality Information Table */
_

