Return-Path: <linux-kernel-owner+w=401wt.eu-S1759216AbYAQVtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216AbYAQVtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755614AbYAQVnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:43:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51231 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758767AbYAQVnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:43:20 -0500
Date: Thu, 17 Jan 2008 22:42:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Andreas Herrmann3 <andreas.herrmann3@amd.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>, ak@muc.de,
       ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, arjan@infradead.org,
       jesse.barnes@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug
	fixes
Message-ID: <20080117214209.GA12811@elte.hu>
References: <20080116023955.597433000@intel.com> <20080116185748.GA11244@alberich.amd.com> <20080116203328.GA17869@linux-os.sc.intel.com> <20080117191211.GA12631@alberich.amd.com> <20080117203600.GB27778@elte.hu> <20080117210301.GC12631@alberich.amd.com> <20080117211308.GA7858@elte.hu> <20080117213131.GA25389@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117213131.GA25389@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:

> On Thu, Jan 17, 2008 at 10:13:08PM +0100, Ingo Molnar wrote:
> > but in general we must be robust enough in this case and just degrade 
> > any overlapping page to UC (and emit a warning perhaps) - instead of 
> > failing the ioremap and thus failing the driver (and the bootup).
> 
> But then, this will cause an attribute conflicit. Old one was 
> specifying WB in PAT (ioremap with noflags) and the new ioremap 
> specifies UC.

we could fix up all aliases of that page as well and degrade them to UC?

> As Linus mentioned, main problem is to figure out the correct 
> attribute for ioremap() which doesn't specify the actual attribute to 
> be used.

i think the problem is the proximity of some ACPI tables to actual 
device mmio areas - they share the same physical page. The ACPI tables 
will be mapped WB, the device mmio areas will be UC most of the time.

> One mechanism to fix the issue generically (somewhat atleast) is to 
> use MTRR's and figure out the default MTRR attribute for that physical 
> address and use it for ioremap().

how would this solve the problem at hand? I dont think it's possible to 
guarantee that all the BIOS data pages and mmio areas will have 
compatible attributes. BIOS data pages might be in plain RAM that we 
intend to map WB. Or they might be in reserved areas near the mmio 
addresses.

but if we fixed up aliases (only for that single conflicting page), so 
that all mappings are degraded to UC, we'd have uniform behavior all 
across and the least amount of surprise to drivers. Hm?

> > but i have not seen this message in your boot log. Could you boot 
> > with early_ioremap_debug and send us the dmesg - i'm curious which 
> > ACPI tables are actively mapped while those devices are initialized.
> 
> In this scenario, ACPI is using ioremap() leaving some dangling 
> references. Venki is looking to fix this code. Getting the attribute 
> for MTRR for ioremap noflags, might solve some of these issues aswell. 
> Will look into this.

ok. Resolving that would be nice anyway because the ACPI table might be 
in plain RAM which might be reused by the kernel later on, etc. FYI, 
there's also the patch from Yinghai Lu on lkml, for one such dangling 
reference problem in the SRAT table.

	Ingo

---------------->
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86: copy srat table and unmap in acpi_parse_table

[PATCH] x86: copy srat table and unmap in acpi_parse_table


the old acpi_numa_slit_init was saving old address in early stage acpi_slit
and acpi_parse_table can not unmap address that.
the patch copy the slit in the callback,
so we could unmap table in acpi_parse_table instead of outside track it.

need to revert
"
commit d8d28f25f33c6a035cdfb1d421c79293d16e5c58
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Jan 17 15:26:42 2008 +0100

    x86: ACPI: fix mapping leaks

    ioremap_early() is stateful, hence we cannot tolerate mapping leaks.
"

before appling this patch

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/mm/srat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat_64.c
+++ linux-2.6/arch/x86/mm/srat_64.c
@@ -23,7 +23,9 @@
 
 int acpi_numa __initdata;
 
-static struct acpi_table_slit *acpi_slit;
+static int slit_copied;
+static u64 slit_locality_count;
+static u8 slit_entry[MAX_NUMNODES * MAX_NUMNODES];
 
 static nodemask_t nodes_parsed __initdata;
 static struct bootnode nodes[MAX_NUMNODES] __initdata;
@@ -130,7 +132,16 @@ void __init acpi_numa_slit_init(struct a
 		printk(KERN_INFO "ACPI: SLIT table looks invalid. Not used.\n");
 		return;
 	}
-	acpi_slit = slit;
+
+	if (slit->locality_count > MAX_NUMNODES)
+		return;
+
+	slit_locality_count = slit->locality_count;
+
+	memcpy(slit_entry, slit->entry,
+	       slit_locality_count * slit_locality_count);
+
+	slit_copied = 1;
 }
 
 /* Callback for Proximity Domain -> LAPIC mapping */
@@ -502,11 +513,11 @@ int __node_distance(int a, int b)
 {
 	int index;
 
-	if (!acpi_slit)
+	if (!slit_copied)
 		return null_slit_node_compare(a, b) ? LOCAL_DISTANCE :
 						      REMOTE_DISTANCE;
-	index = acpi_slit->locality_count * node_to_pxm(a);
-	return acpi_slit->entry[index + node_to_pxm(b)];
+	index = slit_locality_count * node_to_pxm(a);
+	return slit_entry[index + node_to_pxm(b)];
 }
 
 EXPORT_SYMBOL(__node_distance);
Index: linux-2.6/drivers/acpi/tables.c
===================================================================
--- linux-2.6.orig/drivers/acpi/tables.c
+++ linux-2.6/drivers/acpi/tables.c
@@ -260,6 +260,7 @@ int __init acpi_table_parse(char *id, ac
 
 	if (table) {
 		handler(table);
+		acpi_os_unmap_memory(table, table->length);
 		return 0;
 	} else
 		return 1;
