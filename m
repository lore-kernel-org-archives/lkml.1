Return-Path: <linux-kernel-owner+w=401wt.eu-S1765107AbXHAMdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765107AbXHAMdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 08:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761972AbXHAMdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 08:33:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:40912 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761963AbXHAMdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 08:33:14 -0400
From: Andi Kleen <ak@novell.com>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: linux-kernel@vger.kernel.org
Subject: [RFC] [PATCH] Deprecate a.out ELF interpreters
Date: Wed, 1 Aug 2007 14:33:09 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708011433.09433.ak@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[apologies for the empty mail earlier; wetware error]

RFC: Deprecate a.out ELF interpreter support

The Linux ELF loader is quite complicated and messy code (that could
probably need a rewrite, but that's a different chapter). One particular
messy part in it is the support for non ELF a.out ld.sos. This 
was originally added to make transition from a.out to ELF easier
because an a.out ELF ld.so could be still build using an older
a.out toolkit. But by now that should be fully obsolete and removing
it would clean up binfmt_elf.c up a bit.

I propose to deprecate this support and remove for 2.6.25.

Drawback is that someone still runs their system with a.out ld.so
they would need to update the ld.so when updating to a new kernel.

This patch just adds an entry to the deprecation file and a printk
warning users.

Comments?

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux-2.6.23-rc1-misc/Documentation/feature-removal-schedule.txt
===================================================================
--- linux-2.6.23-rc1-misc.orig/Documentation/feature-removal-schedule.txt
+++ linux-2.6.23-rc1-misc/Documentation/feature-removal-schedule.txt
@@ -306,3 +306,12 @@ Why:	All mthca hardware also supports MS
 Who:	Roland Dreier <rolandd@cisco.com>
 
 ---------------------------
+
+What:  a.out interpreter support for ELF executables
+When:  2.6.25
+Files: fs/binfmt_elf.c
+Why:   Using a.out interpreters for ELF executables was a feature for
+       transition from a.out to ELF. But now it is unlikely to be still
+       needed anymore and removing it would simplify the hairy ELF
+       loader code.
+Who:   Andi Kleen <ak@suse.de>
Index: linux-2.6.23-rc1-misc/fs/binfmt_elf.c
===================================================================
--- linux-2.6.23-rc1-misc.orig/fs/binfmt_elf.c
+++ linux-2.6.23-rc1-misc/fs/binfmt_elf.c
@@ -730,6 +730,7 @@ static int load_elf_binary(struct linux_
 
 	/* Some simple consistency checks for the interpreter */
 	if (elf_interpreter) {
+		static int warn;
 		interpreter_type = INTERPRETER_ELF | INTERPRETER_AOUT;
 
 		/* Now figure out which format our binary is */
@@ -741,6 +742,12 @@ static int load_elf_binary(struct linux_
 		if (memcmp(loc->interp_elf_ex.e_ident, ELFMAG, SELFMAG) != 0)
 			interpreter_type &= ~INTERPRETER_ELF;
 
+		if (interpreter_type == INTERPRETER_AOUT && warn < 10) {
+			printk(KERN_WARNING "a.out ELF interpreter %s is "
+	"deprecated and will not be supported anymore\n", elf_interpreter);
+			warn++;
+		}
+
 		retval = -ELIBBAD;
 		if (!interpreter_type)
 			goto out_free_dentry;


