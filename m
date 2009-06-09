Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbZFIPSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbZFIPSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 11:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756461AbZFIPSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 11:18:42 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44655 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756299AbZFIPSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 11:18:41 -0400
Subject: Re: linux-next: voyager tree build failure
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090609194038.826289f3.sfr@canb.auug.org.au>
References: <20090609194038.826289f3.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Tue, 09 Jun 2009 10:18:38 -0500
Message-Id: <1244560718.4137.26.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-09 at 19:40 +1000, Stephen Rothwell wrote:
> Hi James,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> arch/x86/xen/smp.c:478: error: 'apic_safe_smp_processor_id' undeclared here (not in a function)
> arch/x86/kernel/smp.c:219: error: 'apic_safe_smp_processor_id' undeclared here (not in a function)
> 
> Caused by commit 6a6df48477c1959b1baa78ecabba72548d362f60 ("[VOYAGER]
> x86: add {safe,hard}_smp_processor_id to smp_ops").
> 
> I have dropped the voyager tree for today.

Thanks for finding this.  The fix looks to be a dummy definition of this
function for x86_64.  The final fix (which has been under discussion)
will be the elimination of safe_smp_processor_id() altogether.

I've merged this into the

[VOYAGER] x86: add {safe,hard}_smp_processor_id to smp_ops

patch and respun the tree (and built it with an x86-64 cross compiler),
so it should be safe to include next time around

Thanks,

James

---

diff -u b/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
--- b/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -177,6 +177,15 @@
 	ti->cpu;							\
 })
 #define safe_smp_processor_id()		smp_processor_id()
+/*
+ * dummy function for smp_ops.safe_smp_processor_id() which is unused
+ * on x86_64.  This will also break the build if the definition leaks
+ * outside of the guards in kernel/apic/ipi.c on x86_64
+ */
+static inline int apic_safe_smp_processor_id(void)
+{
+	return 0;
+}
 
 #endif
 


