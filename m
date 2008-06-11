Return-Path: <linux-kernel-owner+w=401wt.eu-S1762282AbYFKPsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762282AbYFKPsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 11:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759634AbYFKPs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 11:48:27 -0400
Received: from [198.99.130.12] ([198.99.130.12]:43916 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbYFKPs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 11:48:26 -0400
Date: Wed, 11 Jun 2008 11:48:16 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild breaks um - fails to find util when linking
Message-ID: <20080611154816.GA8167@c2.user-mode-linux.org>
References: <20080610190307.GA15983@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080610190307.GA15983@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch obviously isn't usable for anyone else, but UML needs a
hook or something to add libgcc and libc to the ld commands:

Index: linux-2.6-git/scripts/link-vmlinux.sh
===================================================================
--- linux-2.6-git.orig/scripts/link-vmlinux.sh	2008-06-11 11:26:07.000000000 -0400
+++ linux-2.6-git/scripts/link-vmlinux.sh	2008-06-11 11:41:04.000000000 -0400
@@ -122,7 +122,7 @@ fi
 # First stage of fully linked vmlinux
 tell LD ${VMLINUX}
 ${LD} ${LDFLAGS} ${LDFLAGS_vmlinux} -o ${VMLINUX} \
-      -T ${KBUILD_VMLINUX_LDS} vmlinux.o
+      -T ${KBUILD_VMLINUX_LDS} vmlinux.o `gcc -print-libgcc-file-name` -lc
 
 if [ "${CONFIG_KALLSYMS}" = "y" ]; then
 
@@ -133,7 +133,8 @@ if [ "${CONFIG_KALLSYMS}" = "y" ]; then
         # link in kalll symbols
 	tell LD vmlinux
         ${LD} ${LDFLAGS} ${LDFLAGS_vmlinux} -o vmlinux \
-         -T ${KBUILD_VMLINUX_LDS} vmlinux.o .tmp_kallsyms.o
+         -T ${KBUILD_VMLINUX_LDS} vmlinux.o .tmp_kallsyms.o \
+	    `gcc -print-libgcc-file-name` -lc
 fi
 
 tell SYSMAP System.map

This fixes the flood of undefined symbols, but I still get this on the
link:
    ld: warning: Cannot create .note.gnu.build-id section, --build-id ignored.
    ld: warning: cannot find entry symbol _start; defaulting to 08056320

And when I run the result, I get this, which I don't understand at
all:

    -bash: ./uml/linux: /usr/lib/libc.so.1: bad ELF interpreter: No
such file or directory

			Jeff

-- 
Work email - jdike at linux dot intel dot com
