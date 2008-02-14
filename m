Return-Path: <linux-kernel-owner+w=401wt.eu-S933939AbYBNVGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933939AbYBNVGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761133AbYBNVGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:06:25 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:53555 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759745AbYBNVGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:06:23 -0500
Date: Thu, 14 Feb 2008 22:06:30 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] samples: build fix
Message-ID: <20080214210630.GG21894@uranus.ravnborg.org>
References: <20080214034541.EF1BD270192@magilla.localdomain> <20080214132752.GA27478@Krystal> <20080214194633.GA21894@uranus.ravnborg.org> <20080214200404.GA11166@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214200404.GA11166@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 03:04:04PM -0500, Mathieu Desnoyers wrote:
> * Sam Ravnborg (sam@ravnborg.org) wrote:
> > On Thu, Feb 14, 2008 at 08:27:52AM -0500, Mathieu Desnoyers wrote:
> > > * Roland McGrath (roland@redhat.com) wrote:
> > > > 
> > > > The samples/ subdirectory contains only modules.
> > > > But the only make run done there is in commands for vmlinux.
> > > > I can't see why this was ever done in this nonstandard fashion.
> > > > As things stand, the modules don't get built by 'make modules'.
> > > > 
> > > > I didn't make the addition of the directory use core-$(CONFIG_SAMPLES)
> > > > because there is no other conditional like that in the top-level Makefile
> > > > and samples/Makefile already uses obj-$(CONFIG_SAMPLES) as if it expects
> > > > always to be included.
> > > > 
> > > 
> > > Sam, is this ok with the samples intent ? I think as long as we do not
> > > include them with the kernel image and have a "make samples" to build
> > > them, it's ok. Having them built upon make modules seems like a good
> > > idea to me.
> > 
> > The samples code are supposed to be what the name says 'samples'.
> > This is not code that are supposed to be part of the built-in kernel.
> > This is not modules that are supposed to be installes when 
> > installing modules.
> > 
> > Adding it to core-y as Roland does in the patch below is plain
> > wrong as it enabled both points above.
> > The fact that the present code in samples/ does not do this is
> > in this respect irellevant.
> > 
> > Do we have problems when to build the sampls - then lets
> > address this issue but not by trying to upgrade the samples
> > to first class citizen in the kernel - they are not that
> > and should not be handled like that.
> > 
> 
> Then is there some other way to have the samples built upon "make
> modules" that would not install them with other modules ?
The simple solution is like attached.
I do not care if they are build as part of vmlinux or modules build.
So if it is generally preferred we could move it like this.

Comments?

	Sam

diff --git a/Makefile b/Makefile
index c162370..c72afa9 100644
--- a/Makefile
+++ b/Makefile
@@ -802,9 +802,6 @@ vmlinux: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o $(kallsyms.o)
 ifdef CONFIG_HEADERS_CHECK
 	$(Q)$(MAKE) -f $(srctree)/Makefile headers_check
 endif
-ifdef CONFIG_SAMPLES
-	$(Q)$(MAKE) $(build)=samples
-endif
 	$(call vmlinux-modpost)
 	$(call if_changed_rule,vmlinux__)
 	$(Q)rm -f .old_version
@@ -1036,6 +1033,9 @@ all: modules
 PHONY += modules
 modules: $(vmlinux-dirs) $(if $(KBUILD_BUILTIN),vmlinux)
 	$(Q)$(AWK) '!x[$$0]++' $(vmlinux-dirs:%=$(objtree)/%/modules.order) > $(objtree)/modules.order
+ifdef CONFIG_SAMPLES
+	$(Q)$(MAKE) $(build)=samples
+endif
 	@echo '  Building modules, stage 2.';
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
 
