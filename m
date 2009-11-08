Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbZKHVa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbZKHVa4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 16:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbZKHVaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 16:30:55 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:61216 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401AbZKHVaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 16:30:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vbNxYKG0QfEuN93JyxzMJ2sOeU9NZdqA9bUSw9mO2pE7YK6HS/1pMW2U37+e3DPXEV
         RvGW+n2cDEGv+9IhdtgGo3neLEVfNWomefvzAox9UvBXJp7/sMsg83IKzm3Zz33d/kCL
         HiHhkH/Gk0On3VqqPng5j6CaaoJhvchh0J73k=
Date: Mon, 9 Nov 2009 00:30:55 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: linux-next: tip tree build warning
Message-ID: <20091108213055.GA13555@lenovo>
References: <20091028181443.50a09dbb.sfr@canb.auug.org.au> <20091028073145.GD6353@elte.hu> <20091028184126.b5f52d1b.sfr@canb.auug.org.au> <20091028184851.504752ef.sfr@canb.auug.org.au> <20091028075012.GD19402@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028075012.GD19402@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Wed, Oct 28, 2009 at 08:50:12AM +0100]
| 
| * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
| 
| > Hi all,
| > 
| > On Wed, 28 Oct 2009 18:41:26 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
| > >
| > > static inline physid_mask_t default_apicid_to_cpu_present(int phys_apicid)
| > > {
| > >         return physid_mask_of_physid(phys_apicid);
| > > }
| > 
| > I just noticed that this function (default_apicid_to_cpu_present) is 
| > declared "static inline in a header" but looks like it is only used by 
| > assigning its address to a function pointer.  Its only use for x86_64 
| > is in arch/x86/kernel/apic/apic_noop.c ...
| 
| yes, that might be a real problem - returning the mask like that is 
| messy. Thanks, will check.
| 
| 	Ingo
|

ok, here is what I've just cooked. Please review, I've CC'ed a few
"knowing-apic-code-quite-well" persons just to be sure.

Note that we still have a few items in "struct apic" which
operate with physid_mask_t on stack.

I think perhaps it's a good idea to touch this data via pointers
povided by caller:

	physid_mask_t (*ioapic_phys_id_map)(physid_mask_t map);

I didn't manage to cover it today -- will do tomorrow if patch
approach would be approved.

Also, it's just warning (yet) since we don't use those routines
in x86-64 so it doesn't harm.

Anyway, please review, comment, complain and etc... would appreciate.

	-- Cyrill

p.s.: i don't have inet access in office so will be able to reply
at tomorrow evening only.
---
x86,apic: Do not use stack'ed physid_mask_t in apicid_to_cpu_present

Stephen Rothwell pointed out that apic-noop (when gets compiled
in x86-84 environment) potentially may consume too much stack space.

|
| Hi all,
|
| Today's linux-next build (x86_64 allmodconfig) produced this warning:
|
| In file included from arch/x86/include/asm/smp.h:13,
|                 from arch/x86/include/asm/mmzone_64.h:12,
|                 from arch/x86/include/asm/mmzone.h:4,
|                 from include/linux/mmzone.h:783,
|                 from include/linux/gfp.h:4,
|                 from include/linux/kmod.h:22,
|                 from include/linux/module.h:13,
|                 from arch/x86/kernel/apic/apic_noop.c:14:
| arch/x86/include/asm/apic.h: In function 'default_apicid_to_cpu_present':
| arch/x86/include/asm/apic.h:591: warning: the frame size of 8192 bytes is larger than 2048 bytes
|
| It may not have been caused by the tip tree, but I can't find what
| changed to cause this and a commit from the tip tree has exposed it
| (9844ab11c763bfed9f054c82366b19dcda66aca9 "x86, apic: Introduce the NOOP
| apic driver").
|

So I would say this is a bug in apic-noop (in fact we don't use
default_apicid_to_cpu_present if operate in 64bit mode but it's a sign
that something is wrong with code design). The key problem is that
physid_mask_t is an array with a size depending on MAX_APICS, which
in turn is big enough on x86-64 to trigger compiler warning.

So to prevent such a situation in future we should use physid_mask_t
pointer leaving apic driver with a task to operate over data but not
allocate it. Caller should instead.

This allow us throw out some code as well since physid_set_mask_of_physid
already implement the functionality we need.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/include/asm/apic.h      |    7 +------
 arch/x86/kernel/apic/apic_noop.c |    2 +-
 arch/x86/kernel/apic/bigsmp_32.c |    7 +------
 arch/x86/kernel/apic/es7000_32.c |    8 ++------
 arch/x86/kernel/apic/io_apic.c   |    4 ++--
 arch/x86/kernel/apic/numaq_32.c  |    4 ++--
 arch/x86/kernel/apic/probe_32.c  |    2 +-
 arch/x86/kernel/apic/summit_32.c |    4 ++--
 arch/x86/kernel/visws_quirks.c   |    2 +-
 9 files changed, 13 insertions(+), 27 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/apic.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/apic.h
+++ linux-2.6.git/arch/x86/include/asm/apic.h
@@ -310,7 +310,7 @@ struct apic {
 	int (*apicid_to_node)(int logical_apicid);
 	int (*cpu_to_logical_apicid)(int cpu);
 	int (*cpu_present_to_apicid)(int mps_cpu);
-	physid_mask_t (*apicid_to_cpu_present)(int phys_apicid);
+	void (*apicid_to_cpu_present)(int phys_apicid, physid_mask_t *map);
 	void (*setup_portio_remap)(void);
 	int (*check_phys_apicid_present)(int phys_apicid);
 	void (*enable_apic_mode)(void);
@@ -585,11 +585,6 @@ extern int default_cpu_present_to_apicid
 extern int default_check_phys_apicid_present(int phys_apicid);
 #endif
 
-static inline physid_mask_t default_apicid_to_cpu_present(int phys_apicid)
-{
-	return physid_mask_of_physid(phys_apicid);
-}
-
 #endif /* CONFIG_X86_LOCAL_APIC */
 
 #ifdef CONFIG_X86_32
Index: linux-2.6.git/arch/x86/kernel/apic/apic_noop.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/apic_noop.c
+++ linux-2.6.git/arch/x86/kernel/apic/apic_noop.c
@@ -162,7 +162,7 @@ struct apic apic_noop = {
 
 	.cpu_to_logical_apicid		= noop_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
-	.apicid_to_cpu_present		= default_apicid_to_cpu_present,
+	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
Index: linux-2.6.git/arch/x86/kernel/apic/bigsmp_32.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/bigsmp_32.c
+++ linux-2.6.git/arch/x86/kernel/apic/bigsmp_32.c
@@ -93,11 +93,6 @@ static int bigsmp_cpu_present_to_apicid(
 	return BAD_APICID;
 }
 
-static physid_mask_t bigsmp_apicid_to_cpu_present(int phys_apicid)
-{
-	return physid_mask_of_physid(phys_apicid);
-}
-
 /* Mapping from cpu number to logical apicid */
 static inline int bigsmp_cpu_to_logical_apicid(int cpu)
 {
@@ -230,7 +225,7 @@ struct apic apic_bigsmp = {
 	.apicid_to_node			= bigsmp_apicid_to_node,
 	.cpu_to_logical_apicid		= bigsmp_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= bigsmp_cpu_present_to_apicid,
-	.apicid_to_cpu_present		= bigsmp_apicid_to_cpu_present,
+	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= bigsmp_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
Index: linux-2.6.git/arch/x86/kernel/apic/es7000_32.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/es7000_32.c
+++ linux-2.6.git/arch/x86/kernel/apic/es7000_32.c
@@ -539,14 +539,10 @@ static int es7000_cpu_present_to_apicid(
 
 static int cpu_id;
 
-static physid_mask_t es7000_apicid_to_cpu_present(int phys_apicid)
+static void es7000_apicid_to_cpu_present(int phys_apicid, physid_mask_t *map)
 {
-	physid_mask_t mask;
-
-	mask = physid_mask_of_physid(cpu_id);
+	physid_set_mask_of_physid(cpu_id, map);
 	++cpu_id;
-
-	return mask;
 }
 
 /* Mapping from cpu number to logical apicid */
Index: linux-2.6.git/arch/x86/kernel/apic/io_apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/io_apic.c
@@ -2073,7 +2073,7 @@ void __init setup_ioapic_ids_from_mpc(vo
 			mp_ioapics[apic_id].apicid = i;
 		} else {
 			physid_mask_t tmp;
-			tmp = apic->apicid_to_cpu_present(mp_ioapics[apic_id].apicid);
+			apic->apicid_to_cpu_present(mp_ioapics[apic_id].apicid, &tmp);
 			apic_printk(APIC_VERBOSE, "Setting %d in the "
 					"phys_id_present_map\n",
 					mp_ioapics[apic_id].apicid);
@@ -3969,7 +3969,7 @@ int __init io_apic_get_unique_id(int ioa
 		apic_id = i;
 	}
 
-	tmp = apic->apicid_to_cpu_present(apic_id);
+	apic->apicid_to_cpu_present(apic_id, &tmp);
 	physids_or(apic_id_map, apic_id_map, tmp);
 
 	if (reg_00.bits.ID != apic_id) {
Index: linux-2.6.git/arch/x86/kernel/apic/numaq_32.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/numaq_32.c
+++ linux-2.6.git/arch/x86/kernel/apic/numaq_32.c
@@ -402,12 +402,12 @@ static inline int numaq_apicid_to_node(i
 	return logical_apicid >> 4;
 }
 
-static inline physid_mask_t numaq_apicid_to_cpu_present(int logical_apicid)
+static void numaq_apicid_to_cpu_present(int logical_apicid, physid_mask_t *map)
 {
 	int node = numaq_apicid_to_node(logical_apicid);
 	int cpu = __ffs(logical_apicid & 0xf);
 
-	return physid_mask_of_physid(cpu + 4*node);
+	physid_set_mask_of_physid(cpu + 4*node, map);
 }
 
 /* Where the IO area was mapped on multiquad, always 0 otherwise */
Index: linux-2.6.git/arch/x86/kernel/apic/probe_32.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/probe_32.c
+++ linux-2.6.git/arch/x86/kernel/apic/probe_32.c
@@ -108,7 +108,7 @@ struct apic apic_default = {
 	.apicid_to_node			= default_apicid_to_node,
 	.cpu_to_logical_apicid		= default_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
-	.apicid_to_cpu_present		= default_apicid_to_cpu_present,
+	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
Index: linux-2.6.git/arch/x86/kernel/apic/summit_32.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/summit_32.c
+++ linux-2.6.git/arch/x86/kernel/apic/summit_32.c
@@ -267,9 +267,9 @@ static physid_mask_t summit_ioapic_phys_
 	return physids_promote(0x0F);
 }
 
-static physid_mask_t summit_apicid_to_cpu_present(int apicid)
+static void summit_apicid_to_cpu_present(int apicid, physid_mask_t *map)
 {
-	return physid_mask_of_physid(0);
+	physid_set_mask_of_physid(0, map);
 }
 
 static int summit_check_phys_apicid_present(int physical_apicid)
Index: linux-2.6.git/arch/x86/kernel/visws_quirks.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/visws_quirks.c
+++ linux-2.6.git/arch/x86/kernel/visws_quirks.c
@@ -183,7 +183,7 @@ static void __init MP_processor_info(str
 		return;
 	}
 
-	apic_cpus = apic->apicid_to_cpu_present(m->apicid);
+	apic->apicid_to_cpu_present(m->apicid, &apic_cpus);
 	physids_or(phys_cpu_present_map, phys_cpu_present_map, apic_cpus);
 	/*
 	 * Validate version
