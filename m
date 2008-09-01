Return-Path: <linux-kernel-owner+w=401wt.eu-S1757904AbYIAJfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904AbYIAJfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 05:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756582AbYIAJf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 05:35:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:39617 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452AbYIAJfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 05:35:25 -0400
Subject: Re: [Bug #11355] Regression in 2.6.27-rc2 when cross-building the
	kernel
From: David Woodhouse <dwmw2@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <200808242334.05993.rjw@sisk.pl>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
	 <VSpL6AnBTS.A.jvH.vaGsIB@albercik>  <200808242334.05993.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 01 Sep 2008 10:35:20 +0100
Message-Id: <1220261720.2982.51.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-08-24 at 23:34 +0200, Rafael J. Wysocki wrote:
> On Saturday, 23 of August 2008, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11355
> > Subject		: Regression in 2.6.27-rc2 when cross-building the kernel
> > Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
> > Date		: 2008-08-16 2:38 (8 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121885432118368&w=4
> 
> As I wrote in the Bugzilla, I'm seeing a related problem.
> 
> Namely, I build kernels on one box, with 'make O=<target>', then I mount
> <target> on another one over NFS, 'cd' to it and try to install the kernel
> modules with 'make modules_install'.  This results in 'HOSTCC firmware/ihex2fw'
> and 'fatal error: ...: Read-only file system'.  It's readily reproducible.
> 
> Commenting out line 1130 of Makefile
> ("$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.fwinst obj=firmware __fw_modinst")
> obviously helps, so it looks like Makefile.fwinst needs fixing.

I don't like this much, but it should do the trick... please confirm.

diff --git a/firmware/Makefile b/firmware/Makefile
index aab12bf..e7130b5 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -166,15 +166,28 @@ $(patsubst %,$(obj)/%.gen.o, $(fw-external-y)): $(obj)/%.gen.o: $(fwdir)/%
 $(obj)/%: $(obj)/%.ihex | $(objtree)/$(obj)/$$(dir %)
 	$(call cmd,ihex)
 
+# Don't depend on ihex2fw if we're installing and it already exists.
+# Putting it after | in the dependencies doesn't seem sufficient when
+# we're installing after a cross-compile, because ihex2fw has dependencies
+# on stuff like /usr/lib/gcc/ppc64-redhat-linux/4.3.0/include/stddef.h and 
+# thus wants to be rebuilt. Which it can't be, if the prebuilt kernel tree
+# is exported read-only for someone to run 'make install'.
+ifeq ($(INSTALL):$(wildcard $(obj)/ihex2fw),install:$(obj)/ihex2fw)
+ihex2fw_dep :=
+else
+ihex2fw_dep := $(obj)/ihex2fw
+endif
+
+
 # .HEX is also Intel HEX, but where the offset and length in each record
 # is actually meaningful, because the firmware has to be loaded in a certain
 # order rather than as a single binary blob. Thus, we convert them into our
 # more compact binary representation of ihex records (<linux/ihex.h>)
-$(obj)/%.fw: $(obj)/%.HEX $(obj)/ihex2fw | $(objtree)/$(obj)/$$(dir %)
+$(obj)/%.fw: $(obj)/%.HEX $(ihex2fw_dep) | $(objtree)/$(obj)/$$(dir %)
 	$(call cmd,ihex2fw)
 
 # .H16 is our own modified form of Intel HEX, with 16-bit length for records.
-$(obj)/%.fw: $(obj)/%.H16 $(obj)/ihex2fw | $(objtree)/$(obj)/$$(dir %)
+$(obj)/%.fw: $(obj)/%.H16 $(ihex2fw_dep) | $(objtree)/$(obj)/$$(dir %)
 	$(call cmd,h16tofw)
 
 $(firmware-dirs):

-- 
dwmw2

