Return-Path: <linux-kernel-owner+w=401wt.eu-S1946394AbXBCIOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946394AbXBCIOm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 03:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946395AbXBCIOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 03:14:42 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4767 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946394AbXBCIOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 03:14:41 -0500
Date: Sat, 3 Feb 2007 08:14:26 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Andrew Morton <akpm@osdl.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH/RFC] alternative aproach to: Ban module license tag string termination trick
Message-ID: <20070203081426.GA10520@flint.arm.linux.org.uk>
Mail-Followup-To: Bodo Eggert <7eggert@gmx.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Andrew Morton <akpm@osdl.org>,
	Jon Masters <jonathan@jonmasters.org>,
	Alexey Dobriyan <adobriyan@gmail.com>
References: <Pine.LNX.4.58.0702022216120.25199@be1.lrz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0702022216120.25199@be1.lrz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 03, 2007 at 03:08:14AM +0100, Bodo Eggert wrote:
> This patch changes the module license handling code to:
> - prevent the "GPL\0 for nothing"-trick

You can achieve this effect without changing the existing module
format, and it's far more difficult to bypass with build-with-
modified module.h tricks.

--- a/kernel/module.c	Mon Nov  7 19:58:31 2005
+++ b/kernel/module.c	Mon Dec  5 19:39:36 2005
@@ -286,6 +286,24 @@ static unsigned long find_local_symbol(E
  	return 0;
 }
 
+static int check_modinfo_objects(Elf_Shdr *sechdrs,
+				 unsigned int symindex,
+				 unsigned int infoindex)
+{
+	unsigned int i;
+	Elf_Sym *sym = (void *)sechdrs[symindex].sh_addr;
+	char *info = (char *)sechdrs[infoindex].sh_addr;
+
+	for (i = 1; i < sechdrs[symindex].sh_size/sizeof(*sym); i++) {
+		if (sym[i].st_shndx == infoindex &&
+		    ELF_ST_TYPE(sym[i].st_info) == STT_OBJECT) {
+			if (strlen(info + sym[i].st_value) + 1 != sym[i].st_size)
+				return -ENOEXEC;
+		}
+	}
+	return 0;
+}
+
 /* Search for module by name: must hold module_mutex. */
 static struct module *find_module(const char *name)
 {
@@ -1674,6 +1692,10 @@ static struct module *load_module(void _
 		goto free_hdr;
 	}
 
+	err = check_modinfo_objects(sechdrs, symindex, infoindex);
+	if (err)
+		goto free_hdr;
+
 	modmagic = get_modinfo(sechdrs, infoindex, "vermagic");
 	/* This is allowed: modprobe --force will invalidate it. */
 	if (!modmagic) {

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
