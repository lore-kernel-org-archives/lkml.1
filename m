Return-Path: <linux-kernel-owner+w=401wt.eu-S933076AbZHDQ5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076AbZHDQ5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 12:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932940AbZHDQ5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 12:57:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42777 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932916AbZHDQ5R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 12:57:17 -0400
Date: Tue, 4 Aug 2009 19:57:02 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de, sheng@linux.intel.com,
       avi@redhat.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/apic] x86/apic: Enable x2APIC without interrupt
	remapping under KVM
Message-ID: <20090804165702.GF4764@redhat.com>
References: <20090720122417.GR5638@redhat.com> <tip-ee6a28296de295d62a3d8fad8bab58a8a48d006f@git.kernel.org> <20090804133715.GA29573@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=cp1255
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20090804133715.GA29573@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 03:37:15PM +0200, Ingo Molnar wrote:
> 
> * tip-bot for Gleb Natapov <gleb@redhat.com> wrote:
> 
> > Commit-ID:  ee6a28296de295d62a3d8fad8bab58a8a48d006f
> > Gitweb:     http://git.kernel.org/tip/ee6a28296de295d62a3d8fad8bab58a8a48d006f
> > Author:     Gleb Natapov <gleb@redhat.com>
> > AuthorDate: Mon, 20 Jul 2009 15:24:17 +0300
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Tue, 4 Aug 2009 14:44:10 +0200
> > 
> > x86/apic: Enable x2APIC without interrupt remapping under KVM
> 
> -tip testing found this build failure:
> 
> arch/x86/kernel/apic/apic.c: In function ‘enable_IR_x2apic’:
> arch/x86/kernel/apic/apic.c:1431: error: ‘x2apic_phys’ undeclared (first use in this function)
> arch/x86/kernel/apic/apic.c:1431: error: (Each undeclared identifier is reported only once
> arch/x86/kernel/apic/apic.c:1431: error: for each function it appears in.)
> 
> with the attached config. (Please send a delta fix)
> 
> 	Ingo

Signed-off-by: Gleb Natapov <gleb@redhat.com>
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index bb7d479..ebdbf54 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -183,6 +183,10 @@ static inline int x2apic_enabled(void)
 }
 
 #define x2apic_supported()	(cpu_has_x2apic)
+static inline void x2apic_force_phys(void)
+{
+	x2apic_phys = 1;
+}
 #else
 static inline void check_x2apic(void)
 {
@@ -194,6 +198,9 @@ static inline int x2apic_enabled(void)
 {
 	return 0;
 }
+static inline void x2apic_force_phys()
+{
+}
 
 #define	x2apic_preenabled 0
 #define	x2apic_supported()	0
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 1221f68..de039fc 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1428,7 +1428,7 @@ void __init enable_IR_x2apic(void)
 		 * without IR all CPUs can be addressed by IOAPIC/MSI
 		 * only in physical mode
 		 */
-		x2apic_phys = 1;
+		x2apic_force_phys();
 	}
 
 	x2apic_enabled = 1;
--
			Gleb.
