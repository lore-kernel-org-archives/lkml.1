Return-Path: <linux-kernel-owner+w=401wt.eu-S1758773AbYEAJik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbYEAJik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 05:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756539AbYEAJic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 05:38:32 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:35481 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756497AbYEAJib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 05:38:31 -0400
Date: Thu, 1 May 2008 11:39:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roland McGrath <roland@redhat.com>
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: arch/x86/kernel/acpi/realmode/Makefile
Message-ID: <20080501093905.GA2684@uranus.ravnborg.org>
References: <20080501010516.DD2FE26FA05@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501010516.DD2FE26FA05@magilla.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 06:05:16PM -0700, Roland McGrath wrote:
> I noticed that arch/x86/kernel/acpi/realmode/wakeup.lds was being remade on
> every make.

We have an additional bug where we always do a link of vmlinux.
Testing the following patch atm:

diff --git a/Makefile b/Makefile
index d3634cd..5cf8258 100644
--- a/Makefile
+++ b/Makefile
@@ -794,7 +794,7 @@ endif # ifdef CONFIG_KALLSYMS
 quiet_cmd_vmlinux-modpost = LD      $@
       cmd_vmlinux-modpost = $(LD) $(LDFLAGS) -r -o $@                          \
 	 $(vmlinux-init) --start-group $(vmlinux-main) --end-group             \
-	 $(filter-out $(vmlinux-init) $(vmlinux-main) $(vmlinux-lds) FORCE ,$^)
+	 $(filter-out $(vmlinux-init) $(vmlinux-main) FORCE ,$^)
 define rule_vmlinux-modpost
 	:
 	+$(call cmd,vmlinux-modpost)
@@ -818,7 +818,9 @@ endif
 ifdef CONFIG_KALLSYMS
 .tmp_vmlinux1: vmlinux.o
 endif
-vmlinux.o: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) FORCE
+
+modpost-init := $(filter-out init/built-in.o, $(vmlinux-init))
+vmlinux.o: $(modpost-init) $(vmlinux-main) FORCE
 	$(call if_changed_rule,vmlinux-modpost)
 
 # The actual objects are generated when descending, 
