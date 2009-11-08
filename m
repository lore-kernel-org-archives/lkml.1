Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbZKHSmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbZKHSmS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 13:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbZKHSmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 13:42:17 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:42355 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbZKHSmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 13:42:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rwUcNogeqqEz/Mj/Rsbx+pO9moYdG+66/mQQTh+kR8n6+/gIeCM155zyBAB/bZDlBo
         ha/NiDP64CzrDLF71c9tuM1mzKnfsS53BpcsQ1hE8iUncUdY9xW5HPCcty8j+ONoiTTk
         IxlEn382wT3kUjVVs5EH5hFJeGZTGXVPLe19w=
Date: Sun, 8 Nov 2009 21:42:18 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: tip tree build warning
Message-ID: <20091108184218.GG25940@lenovo>
References: <20091028181443.50a09dbb.sfr@canb.auug.org.au> <20091028073145.GD6353@elte.hu> <20091028184126.b5f52d1b.sfr@canb.auug.org.au> <20091028184851.504752ef.sfr@canb.auug.org.au> <20091028075012.GD19402@elte.hu> <20091108131645.GD5300@lenovo> <20091108133247.GA14807@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108133247.GA14807@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sun, Nov 08, 2009 at 02:32:47PM +0100]
| 
...
| > +
| > +#ifdef CONFIG_X86_32
| >  	.apicid_to_cpu_present		= default_apicid_to_cpu_present,
| > +#else
| > +	.apicid_to_cpu_present		= NULL,
| > +#endif
| 
| would be better to unify this instead ...
| 
| 	Ingo
| 

[not for inclusion]

Here is what I'm going to implement (it is not finished yet,
but just to show the idea -- ie to get rid of physid_mask_t
passed as an argument at all but use pointers instead since
callers already have bitmask allocated).

And physid_set_mask_of_physid already do the work for us.
Hmm?

(Ingo, I think you may apply the former patch just to
 have the issue fixed this way temporary)

	-- Cyrill
---
 arch/x86/include/asm/apic.h      |    7 +------
 arch/x86/kernel/apic/apic_noop.c |    2 +-
 arch/x86/kernel/apic/bigsmp_32.c |    7 +------
 arch/x86/kernel/apic/probe_32.c  |    2 +-
 4 files changed, 4 insertions(+), 14 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/apic.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/apic.h
+++ linux-2.6.git/arch/x86/include/asm/apic.h
@@ -310,7 +310,7 @@ struct apic {
 	int (*apicid_to_node)(int logical_apicid);
 	int (*cpu_to_logical_apicid)(int cpu);
 	int (*cpu_present_to_apicid)(int mps_cpu);
-	physid_mask_t (*apicid_to_cpu_present)(int phys_apicid);
+	void (*apicid_to_cpu_present)(int phys_apicid, physid_mask_t *bitmap);
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
