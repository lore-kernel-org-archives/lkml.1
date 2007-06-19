Return-Path: <linux-kernel-owner+w=401wt.eu-S1758957AbXFSKGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957AbXFSKGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 06:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756520AbXFSKGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 06:06:25 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:50606 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428AbXFSKGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 06:06:24 -0400
Date: Tue, 19 Jun 2007 15:36:44 +0530
From: "S. P. Prasanna" <prasanna@in.ibm.com>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, ananth@in.ibm.com,
       mathieu.desnoyers@polymtl.ca
Subject: Re: [patch 1/2] kprobes i386 quick fix mark-ro-data
Message-ID: <20070619100644.GA5478@in.ibm.com>
Reply-To: prasanna@in.ibm.com
References: <20070615202310.178466032@polymtl.ca> <4676D2A9.6090403@redhat.com> <20070618115632.7aca8c0f.akpm@linux-foundation.org> <200706182132.56559.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706182132.56559.ak@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 09:32:56PM +0200, Andi Kleen wrote:
> On Monday 18 June 2007 20:56:32 Andrew Morton wrote:
> > On Mon, 18 Jun 2007 14:44:57 -0400
> > Chuck Ebbert <cebbert@redhat.com> wrote:
> > 
> > > > I fancy it's done by the kprobe_page_fault handler, but I do not see
> > > > clearly how writing the breakpoint from arch_arm_kprobe() in
> > > > non-writeable memory is done.
> > > 
> > > Looks like it's not merged yet:
> > > 
> > > http://lkml.org/lkml/2007/6/7/2
> > > 
> > > This needs to go in before 2.6.22-final
> > 
> > Andi, I'll include the below two patches in the next batch, OK?
> 
> It won't work reliably unless some of the c_p_a() fixes get in first.
> 
> > 
> > 
> > 
> > +extern int kernel_text_is_ro;
> 
> No externs in .c files
Yes.
> 
> 
> I also don't like kernel_text_is_read_only() much, it would
> be better to just lookup_address() it and check the write flag.

Yes, I will look into this approach.
> 
> But for 2.6.22 as a quick fix it might be better to just
> make KPROBES dependent on !DEBUG_RODATA. That would be a one liner.
> 

Please find the quick fix as per your suggestion below.

Thanks
Prasanna

This patch is a quick fix to enable kprobes only if DEBUG_RODATA is
not configured. Since DEBUG_RODATA markes the kernel text pages as read-only.

Signed-off-by: Prasanna S P. <prasanna@in.ibm.com>


 arch/i386/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/i386/Kconfig~kprobes-quick-fix-mark-ro-data-i386 arch/i386/Kconfig
--- linux-2.6.22-rc5/arch/i386/Kconfig~kprobes-quick-fix-mark-ro-data-i386	2007-06-19 14:55:31.000000000 +0530
+++ linux-2.6.22-rc5-prasanna/arch/i386/Kconfig	2007-06-19 14:55:31.000000000 +0530
@@ -1212,6 +1212,8 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
+source "arch/i386/Kconfig.debug"
+
 menu "Instrumentation Support"
 	depends on EXPERIMENTAL
 
@@ -1219,7 +1221,7 @@ source "arch/i386/oprofile/Kconfig"
 
 config KPROBES
 	bool "Kprobes (EXPERIMENTAL)"
-	depends on KALLSYMS && EXPERIMENTAL && MODULES
+	depends on KALLSYMS && EXPERIMENTAL && MODULES && !DEBUG_RODATA
 	help
 	  Kprobes allows you to trap at almost any kernel address and
 	  execute a callback function.  register_kprobe() establishes
@@ -1228,8 +1230,6 @@ config KPROBES
 	  If in doubt, say "N".
 endmenu
 
-source "arch/i386/Kconfig.debug"
-
 source "security/Kconfig"
 
 source "crypto/Kconfig"

_
-- 
Prasanna S.P.
Linux Technology Center
India Software Labs, IBM Bangalore
Email: prasanna@in.ibm.com
Ph: 91-80-41776329
