Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbYFDNi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbYFDNi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 09:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbYFDNir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 09:38:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57884 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbYFDNir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 09:38:47 -0400
Subject: Re: [BUILD-FAILURE] linux-next: Tree for June 4 -
	firmware/keyspan/mpr.fw.gen.S
From: David Woodhouse <dwmw2@infradead.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
       sam@ravnborg.org
In-Reply-To: <48468091.5000102@linux.vnet.ibm.com>
References: <20080604180025.3ecd03ff.sfr@canb.auug.org.au>
	 <48468091.5000102@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 14:38:37 +0100
Message-Id: <1212586717.32207.71.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-04 at 17:16 +0530, Kamalesh Babulal wrote:
> Hi Stephen,
> 
> The next-20080604 kernel build fails on the x86_64 machine
> 
> make[1]: *** No rule to make target `/usr/local/autobench/autotest/tmp/build/linux/$(dir)', needed by `firmware/keyspan/mpr.fw.gen.S'.  Stop.
> make: *** [firmware] Error 2

Does this 'fix' it?

diff --git a/firmware/Makefile b/firmware/Makefile
index b4f758a..5244ea4 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -83,7 +83,20 @@ wordsize_deps := $(wildcard include/config/64bit.h include/config/32bit.h \
 		include/config/superh32.h include/config/superh64.h \
 		include/config/x86_32.h include/config/x86_64.h)
 
-# For the $$(dir %) trick, where we need % to be expanded first.
+# .SECONDEXPANSION for the $$(dir %) trick, where we need % to be expanded
+# first before we expand the $(dir ...). And a workaround for broken make.
+PHONY += make-warning
+make-warning:
+	@echo '*************'
+	@echo 'WARNING: Your version of make ($(MAKE_VERSION)) seems not to work'
+	@echo 'correctly with .SECONDEXPANSION: as used in firmware/Makefile.'
+	@echo 'Creating directories in advance instead of on-demand'
+	@echo '*************'
+
+PHONY += $(objtree)/$$(%) $(objtree)/$(obj)/$$(%)
+$(objtree)/$$(%) $(objtree)/$(obj)/$$(%): make-warning $(firmware-dirs)
+	@true
+
 .SECONDEXPANSION:
 
 $(patsubst %,$(obj)/%.gen.S, $(fw-shipped-y)): %: $(wordsize_deps) \

-- 
dwmw2

