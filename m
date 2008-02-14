Return-Path: <linux-kernel-owner+w=401wt.eu-S1765923AbYBNJkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765923AbYBNJkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 04:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbYBNJkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 04:40:39 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:38396 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbYBNJki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 04:40:38 -0500
Date: Thu, 14 Feb 2008 10:40:35 +0100
From: "Edgar E. Iglesias" <edgar.iglesias@axis.com>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: "Edgar E. Iglesias" <edgar.iglesias@axis.com>,
       linux-kernel@vger.kernel.org, mikael.starvik@axis.com,
       akpm@linux-foundation.org, ralf@linux-mips.org, jesper.nilsson@axis.com
Subject: Re: [PATCH] Use ELF_CORE_EFLAGS for kcore ELF header flags.
Message-ID: <20080214094035.GB13450@edgar.se.axis.com>
References: <20080212133423.GD16389@edgar.se.axis.com> <87skzwnwt7.wl%ysato@users.sourceforge.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87skzwnwt7.wl%ysato@users.sourceforge.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 08:36:36PM -0500, Yoshinori Sato wrote:
> At Tue, 12 Feb 2008 14:34:23 +0100,
> Edgar E. Iglesias wrote:
> > 
> > ELF_CORE_EFLAGS is already used by the binfmt_elf coredumper to set correct 
> > arch specific ELF header flags on coredumps. Use it for kcore aswell.
> > This corrects kcore files for the CRIS arch and I beleive it corrects 
> > ordinary coredumps for the H8/300.
>
> Hmm...
> I think more simple.
> 
> --- include/asm-h8300/elf.h~	2008-02-12 17:42:50.000000000 -0500
> +++ include/asm-h8300/elf.h	2008-02-13 20:26:58.000000000 -0500
> @@ -26,10 +26,10 @@
>  #define ELF_DATA	ELFDATA2MSB
>  #define ELF_ARCH	EM_H8_300
>  #if defined(__H8300H__)
> -#define ELF_FLAGS       0x810000
> +#define ELF_CORE_FLAGS  0x810000
>  #endif
>  #if defined(__H8300S__)
> -#define ELF_FLAGS       0x820000
> +#define ELF_CORE_FLAGS  0x820000
>  #endif

Thanks. In case you already applied this somewhere, please note that it should be ELF_CORE_EFLAGS and not ELF_CORE_FLAGS.

Here's a new patch.

Best regards
-- 
Edgar E. Iglesias
Axis Communications AB

[PATCH] Use ELF_CORE_EFLAGS for kcore dumps.

ELF_CORE_EFLAGS is already used by the binfmt_elf coredumper to set correct
arch specific ELF header flags on coredumps. Use it for kcore dumps aswell. At
the moment, this affects the CRIS and the H8300 arch.

Signed-off-by: Edgar E. Iglesias <edgar@axis.com>

---

diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index e78c81f..c2370c7 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -23,6 +23,10 @@
 
 #define CORE_STR "CORE"
 
+#ifndef ELF_CORE_EFLAGS
+#define ELF_CORE_EFLAGS	0
+#endif
+
 static int open_kcore(struct inode * inode, struct file * filp)
 {
 	return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
@@ -164,11 +168,7 @@ static void elf_kcore_store_hdr(char *bufp, int nphdr, int dataoff)
 	elf->e_entry	= 0;
 	elf->e_phoff	= sizeof(struct elfhdr);
 	elf->e_shoff	= 0;
-#if defined(CONFIG_H8300)
-	elf->e_flags	= ELF_FLAGS;
-#else
-	elf->e_flags	= 0;
-#endif
+	elf->e_flags	= ELF_CORE_EFLAGS;
 	elf->e_ehsize	= sizeof(struct elfhdr);
 	elf->e_phentsize= sizeof(struct elf_phdr);
 	elf->e_phnum	= nphdr;
diff --git a/include/asm-h8300/elf.h b/include/asm-h8300/elf.h
index 26bfc7e..a8b57d1 100644
--- a/include/asm-h8300/elf.h
+++ b/include/asm-h8300/elf.h
@@ -26,10 +26,10 @@ typedef unsigned long elf_fpregset_t;
 #define ELF_DATA	ELFDATA2MSB
 #define ELF_ARCH	EM_H8_300
 #if defined(__H8300H__)
-#define ELF_FLAGS       0x810000
+#define ELF_CORE_EFLAGS 0x810000
 #endif
 #if defined(__H8300S__)
-#define ELF_FLAGS       0x820000
+#define ELF_CORE_EFLAGS 0x820000
 #endif
 
 #define ELF_PLAT_INIT(_r)	_r->er1 = 0
