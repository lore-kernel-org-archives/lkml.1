Return-Path: <linux-kernel-owner+w=401wt.eu-S1759053AbYFKOu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759053AbYFKOu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 10:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335AbYFKOuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 10:50:17 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:36732 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716AbYFKOuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 10:50:15 -0400
Date: Wed, 11 Jun 2008 16:50:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUILD-FAILURE] linux-next: Tree for June 11 - on ia64
Message-ID: <20080611145057.GA10487@uranus.ravnborg.org>
References: <20080611193840.08a35b14.sfr@canb.auug.org.au> <484FE1EE.9020201@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484FE1EE.9020201@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 08:02:14PM +0530, Kamalesh Babulal wrote:
> Hi Stephen,
> 
> The next-20080611 kernel build fails on ia64 machine
> 
>   AR      arch/ia64/lib/lib.a
>   LD      vmlinux.o
>   MODPOST vmlinux.o
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux
>   LD      vmlinux
> ld: .tmp_kallsyms.o: linking constant-gp files with non-constant-gp files
> ld: failed to merge target specific data of file .tmp_kallsyms.o
> make: *** [vmlinux] Error 1

A kbuild bug..
We do a local build of .tmp_kallsyms.o and we do not pass -mconstant-gp

Can you please try if the following patch fixes it.

	Sam

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index b9ecff5..b335700 100644
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -128,7 +128,7 @@ if [ "${CONFIG_KALLSYMS}" = "y" ]; then
 
 	# Do an extra pass to link in kallsyms data
 	${NM} -n .tmp_vmlinux | scripts/kallsyms > .tmp_kallsyms.S
-        ${CC} ${KBUILD_AFLAGS} ${KBUILD_CPPFLAGS} -c -o .tmp_kallsyms.o \
+        ${CC} ${KBUILD_AFLAGS} ${AFLAGS_KERNEL} ${KBUILD_CPPFLAGS} -c -o .tmp_kallsyms.o \
 	      .tmp_kallsyms.S
         # link in kalll symbols
 	tell LD vmlinux
