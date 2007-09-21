Return-Path: <linux-kernel-owner+w=401wt.eu-S1764531AbXIUVId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764531AbXIUVId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbXIUVIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 17:08:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897AbXIUVIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 17:08:24 -0400
Date: Fri, 21 Sep 2007 17:08:20 -0400
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [12/45] i386: Fix arch/i386/kernel/nmi.c -
	'unknown_nmi_panic_callback' declared 'static' but never defined
	warning
Message-ID: <20070921210820.GB8127@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Andi Kleen <ak@suse.de>,
	patches@x86-64.org, linux-kernel@vger.kernel.org
References: <200709211044.901175000@suse.de> <20070921204453.A6E6D14F09@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921204453.A6E6D14F09@wotan.suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 10:44:53PM +0200, Andi Kleen wrote:
 > 
 > I get this warning when CONFIG_SYSCTL is not set :
 > 
 > ...
 > 
 > arch/i386/kernel/nmi.c:52: warning: 'unknown_nmi_panic_callback' declared 'static' but never defined

If you move the function call after the declaration, you can do without
both the prototype, and the ifdef.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/i386/kernel/nmi.c b/arch/i386/kernel/nmi.c
index c7227e2..9a8ff0b 100644
--- a/arch/i386/kernel/nmi.c
+++ b/arch/i386/kernel/nmi.c
@@ -48,9 +48,6 @@ static unsigned int nmi_hz = HZ;
 
 static DEFINE_PER_CPU(short, wd_enabled);
 
-/* local prototypes */
-static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu);
-
 static int endflag __initdata = 0;
 
 #ifdef CONFIG_SMP
@@ -389,15 +386,6 @@ __kprobes int nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
 	return rc;
 }
 
-int do_nmi_callback(struct pt_regs * regs, int cpu)
-{
-#ifdef CONFIG_SYSCTL
-	if (unknown_nmi_panic)
-		return unknown_nmi_panic_callback(regs, cpu);
-#endif
-	return 0;
-}
-
 #ifdef CONFIG_SYSCTL
 
 static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu)
@@ -451,6 +439,16 @@ int proc_nmi_enabled(struct ctl_table *table, int write, struct file *file,
 
 #endif
 
+int do_nmi_callback(struct pt_regs * regs, int cpu)
+{
+#ifdef CONFIG_SYSCTL
+	if (unknown_nmi_panic)
+		return unknown_nmi_panic_callback(regs, cpu);
+#endif
+	return 0;
+}
+
+
 void __trigger_all_cpu_backtrace(void)
 {
 	int i;

-- 
http://www.codemonkey.org.uk
