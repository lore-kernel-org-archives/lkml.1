Return-Path: <linux-kernel-owner+w=401wt.eu-S1764236AbYFHMOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764236AbYFHMOi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 08:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759832AbYFHMO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 08:14:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40937 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953AbYFHMO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 08:14:28 -0400
Subject: Re: [PATCH] Speed up "make headers_*"
From: David Woodhouse <dwmw2@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1212925623.32207.517.camel@pmac.infradead.org>
References: <20080608094730.GA30098@uranus.ravnborg.org>
	 <1212924004.32207.498.camel@pmac.infradead.org>
	 <20080608113028.GE10545@uranus.ravnborg.org>
	 <1212925623.32207.517.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Sun, 08 Jun 2008 13:14:25 +0100
Message-Id: <1212927265.32207.527.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-08 at 12:47 +0100, David Woodhouse wrote:
> On Sun, 2008-06-08 at 13:30 +0200, Sam Ravnborg wrote:
> > I will name it ASMDIR and set it to 'y' if we shall install to asm/
> 
> That works if we can't just make the top-level Makefile set $(dst) for
> itself. Which perhaps we could, if we stopped it running the whole
> recursive installation on include/ for each arch, and instead made it
> run only on include/asm-$(ARCH) for each arch.
> 
> And do a separate run for the other directories, of course -- probably
> with $(ARCH) and $(SRCARCH) set to empty or something.
> 
> That also might help shave a little more time off by not repeating the
> export 20 times for every non-asm subdirectory. (Not that we actually
> _do_ repeat it, but even the make invocation and the dependency checks
> take time).

Something like this takes the time for 'headers_install_all' from 30s to
20s on my machine, and from 9s to 1.5s when it doesn't actually have to
do anything. I have yet to actually remove $(BIARCH) and just override
$(dst), though.

diff --git a/Makefile b/Makefile
index eff8fee..4eae126 100644
--- a/Makefile
+++ b/Makefile
@@ -1017,6 +1017,14 @@ headers_install_all: __headers
 	         BIASMDIR=-bi-$$arch ;\
 	 done
 
+PHONY += headers_install_all_faster
+headers_install_all_faster: __headers
+	$(Q)$(MAKE) ARCH= SRCARCH= $(hdr-inst)=include
+	$(Q)set -e; for arch in $(hdr-archs); do \
+	 $(MAKE) ARCH=$$arch SRCARCH=$$arch $(hdr-inst)=include/asm-$$arch \
+	         BIASMDIR=-bi-$$arch ;\
+	 done
+
 PHONY += headers_install
 headers_install: __headers
 	$(Q)if [ ! -r $(srctree)/include/asm-$(SRCARCH)/Kbuild ]; then \
diff --git a/include/Kbuild b/include/Kbuild
index b522887..9393f7e 100644
--- a/include/Kbuild
+++ b/include/Kbuild
@@ -5,4 +5,6 @@ header-y += mtd/
 header-y += rdma/
 header-y += video/
 
+ifneq ($(ARCH),)
 header-y += asm-$(ARCH)/
+endif

-- 
dwmw2

