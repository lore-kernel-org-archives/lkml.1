Return-Path: <linux-kernel-owner+w=401wt.eu-S1760788AbYAKJOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760788AbYAKJOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 04:14:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758881AbYAKJNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 04:13:34 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:32220
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758369AbYAKJNc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 04:13:32 -0500
Message-Id: <4787415E.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Fri, 11 Jan 2008 09:13:50 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <paulus@samba.org>
Cc: <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH, ppc64] improve dedotify()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This completely untested patch is intended to be a suggestion only:
Code inspection for an entirely different purpose made me stumble
across this, and I think that modifying the string table of an ELF
object is a bad idea, since there's nothing disallowing a linker to
merge strings inside the table, which would result in this code
possibly, but unintentionally screwing up other symbol names.
Besides that, the presented alternative is both smaller and faster.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/powerpc/kernel/module_64.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- linux-2.6.24-rc7/arch/powerpc/kernel/module_64.c	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.24-rc7-ppc64-dedotify/arch/powerpc/kernel/module_64.c	2008-01-08 13:32:33.000000000 +0100
@@ -154,16 +154,14 @@ static void dedotify_versions(struct mod
 }
 
 /* Undefined symbols which refer to .funcname, hack to funcname */
-static void dedotify(Elf64_Sym *syms, unsigned int numsyms, char *strtab)
+static void dedotify(Elf64_Sym *syms, unsigned int numsyms, const char *strtab)
 {
 	unsigned int i;
 
 	for (i = 1; i < numsyms; i++) {
-		if (syms[i].st_shndx == SHN_UNDEF) {
-			char *name = strtab + syms[i].st_name;
-			if (name[0] == '.')
-				memmove(name, name+1, strlen(name));
-		}
+		if (syms[i].st_shndx == SHN_UNDEF
+		    && strtab[syms[i].st_name] == '.')
+			syms[i].st_name++;
 	}
 }
 



